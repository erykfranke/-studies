using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Czytamy.pl.Models
{
    public class Publisher : IValidatableObject
    {
        // ----------------------------------------------------------------------------------------
        //  Columns
        // ----------------------------------------------------------------------------------------
        [Key]
        public int ID { get; set; }

        [Required]
        [MinLength(3), MaxLength(50)]
        [Index(IsUnique = true)]
        [Display(Name = "Nazwa")]
        public string Name { get; set; }

        [Url]
        [Display(Name = "Strona Internetowa")]
        public string Web_site { get; set; }

        [Display(Name = "Opis")]
        public string Description { get; set; }

        public string LogoPath { get; set; } = "/Resources/Images/Publisher_logos/default.jpg";



        // ----------------------------------------------------------------------------------------
        //  Relation Ship
        // ----------------------------------------------------------------------------------------
        public virtual ICollection<Book> Books { get; set; }



        // ----------------------------------------------------------------------------------------
        //  Not Mapped
        // ----------------------------------------------------------------------------------------
        [NotMapped]
        [Display(Name = "Logo wydawnictwa")]
        public HttpPostedFileBase ImageFile { get; set; }



        // ----------------------------------------------------------------------------------------
        //  Validation
        // ----------------------------------------------------------------------------------------
        IEnumerable<ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            ApplicationDbContext db = new ApplicationDbContext();
            List<ValidationResult> validationResults = new List<ValidationResult>();
            var validateName = db.Publisher.SingleOrDefault(x => x.Name.Equals(Name) && x.ID != ID);
            if (validateName != null)
            {
                ValidationResult errorMessage = new ValidationResult
                    ("Wpisane wydawnictwo istnieję już w bazie danych.", new[] { "Name" });
                validationResults.Add(errorMessage);
            }
            return validationResults;
        }
    }
}