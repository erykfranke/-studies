using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Czytamy.pl.Models
{
    public class Book : IValidatableObject
    {
        // ----------------------------------------------------------------------------------------
        //  Columns
        // ----------------------------------------------------------------------------------------
        [Key]
        public int ID { get; set; }

        [Required]
        [MinLength(2), MaxLength(40)]
        [Display(Name = "Tytuł")]
        public string Title { get; set; }

        [MinLength(2), MaxLength(40)]
        [Display(Name = "Oryginalny tytuł")]
        public string Oryginal_title { get; set; }

        [Required]
        [Display(Name = "Kategoria")]
        public string Category { get; set; }

        [Required]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [Display(Name = "Data wydania")]
        public DateTime Date_published { get; set; }

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [Display(Name = "Polska data wydania")]
        public DateTime? Polish_date_published { get; set; }

        [Required]
        [Display(Name = "Liczba stron")]
        public int Number_of_pages { get; set; }

        [Required]
        [MinLength(6), MaxLength(20)]
        [Display(Name = "Język")]
        public string Language { get; set; }

        [Required]
        [StringLength(13)]
        [Index(IsUnique = true)]
        [Display(Name = "ISBN")]
        public string ISBN { get; set; }

        [Display(Name = "Opis")]
        public string Description { get; set; }

        public string CoverPath { get; set; } = "/Resources/Images/Book_covers/default.jpg";



        // ----------------------------------------------------------------------------------------
        //  Relation Ship
        // ----------------------------------------------------------------------------------------
        public virtual Author Author { get; set; }

        public virtual Publisher Publisher { get; set; }

        public virtual ICollection<Opinion> Opinions { get; set; }

        public virtual ICollection<Tag> Tags { get; set; }



        // ----------------------------------------------------------------------------------------
        //  Not Mapped
        // ----------------------------------------------------------------------------------------
        [NotMapped]
        [Display(Name = "Okładka książki")]
        public HttpPostedFileBase ImageFile { get; set; }



        // ----------------------------------------------------------------------------------------
        //  Validation
        // ----------------------------------------------------------------------------------------
        IEnumerable<ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            ApplicationDbContext db = new ApplicationDbContext();
            List<ValidationResult> validationResults = new List<ValidationResult>();
            var validateName = db.Book.SingleOrDefault(x => x.ISBN.Equals(ISBN) && x.ID != ID);
            if (validateName != null)
            {
                ValidationResult errorMessage = new ValidationResult
                    ("Wpisny ISBN widnieje już w bazie danych", new[] { "ISBN" });
                validationResults.Add(errorMessage);
            }
            return validationResults;
        }
    }
}
