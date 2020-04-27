using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Czytamy.pl.Models
{
    public class Author : IValidatableObject
    {
        // ----------------------------------------------------------------------------------------
        //  Columns
        // ----------------------------------------------------------------------------------------
        [Key]
        public int ID { get; set; }

        [Required]
        [MinLength(3), MaxLength(25)]
        [Display(Name = "Imię")]
        public string Name { get; set; }

        [Required]
        [MinLength(3), MaxLength(25)]
        [Display(Name = "Nazwisko")]
        public string Surname { get; set; }

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [Display(Name = "Urodzony")]
        public DateTime? Birth_date { get; set; }

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [Display(Name = "Zmarły")]
        public DateTime? Death_date { get; set; }

        [Url]
        [Display(Name = "Strona Internetowa")]
        public string Web_site { get; set; }

        [Display(Name = "Opis")]
        public string Description { get; set; }

        public string PhotoPath { get; set; } = "/Resources/Images/Author_photos/default.jpg";



        // ----------------------------------------------------------------------------------------
        // Relation Ship
        // ----------------------------------------------------------------------------------------
        public virtual ICollection<Book> Books { get; set; }



        // ----------------------------------------------------------------------------------------
        // Not Mapped
        // ----------------------------------------------------------------------------------------
        [NotMapped]
        [Display(Name = "Zdjęcie autora")]
        public HttpPostedFileBase ImageFile { get; set; }



        // ----------------------------------------------------------------------------------------
        //  Validation
        // ----------------------------------------------------------------------------------------
        IEnumerable<ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            ApplicationDbContext db = new ApplicationDbContext();
            List<ValidationResult> validationResults = new List<ValidationResult>();
            var validateName = db.Author.SingleOrDefault(x => x.Name.Equals(Name) && x.Surname.Equals(Surname) && x.ID != ID);
            if (validateName != null)
            {
                ValidationResult errorMessage = new ValidationResult
                    ("Autor o podanym imieniu i nazwisku istnieje już w bazie danych.");
                validationResults.Add(errorMessage);
            }
            return validationResults;
        }
    }
}
