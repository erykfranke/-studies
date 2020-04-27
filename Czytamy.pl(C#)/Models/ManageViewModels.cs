using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;

namespace Czytamy.pl.Models
{
    public class IndexViewModel
    {
        public bool HasPassword { get; set; }
        public IList<UserLoginInfo> Logins { get; set; }
        public string PhoneNumber { get; set; }
        public bool TwoFactor { get; set; }
        public bool BrowserRemembered { get; set; }
    }

    public class ManageLoginsViewModel
    {
        public IList<UserLoginInfo> CurrentLogins { get; set; }
        public IList<AuthenticationDescription> OtherLogins { get; set; }
    }

    public class FactorViewModel
    {
        public string Purpose { get; set; }
    }

    public class SetPasswordViewModel
    {
        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "New password")]
        public string NewPassword { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm new password")]
        [Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }

    public class ChangePasswordViewModel
    {
        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Obecne hasło")]
        public string OldPassword { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Nowe hasło")]
        public string NewPassword { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Potwierdz nowe hasło")]
        [Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
    }

    public class AddPhoneNumberViewModel
    {
        [Required]
        [Phone]
        [Display(Name = "Phone Number")]
        public string Number { get; set; }
    }

    public class VerifyPhoneNumberViewModel
    {
        [Required]
        [Display(Name = "Code")]
        public string Code { get; set; }

        [Required]
        [Phone]
        [Display(Name = "Phone Number")]
        public string PhoneNumber { get; set; }
    }

    public class ConfigureTwoFactorViewModel
    {
        public string SelectedProvider { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Providers { get; set; }
    }

    public class CreateEdit_BookViewModel : IValidatableObject
    {
        [Required]
        [MinLength(3), MaxLength(25)]
        [Display(Name = "Imię autora")]
        public string AuthorName { get; set; }

        [Required]
        [MinLength(3), MaxLength(25)]
        [Display(Name = "Nazwisko autora")]
        public string AuthorSurname { get; set; }

        [Required]
        [MinLength(3), MaxLength(50)]
        [Display(Name = "Nazwa wydanictwa")]
        public string PublisherName { get; set; }

        public Book Book { get; set; }

        IEnumerable<ValidationResult> IValidatableObject.Validate(ValidationContext validationContext)
        {
            ApplicationDbContext db = new ApplicationDbContext();
            List<ValidationResult> validationResults = new List<ValidationResult>();

            var authorValidate = db.Author.SingleOrDefault(x => x.Name.Equals(AuthorName) && x.Surname.Equals(AuthorSurname));
            if (authorValidate == null)
            {
                ValidationResult errorMessage = new ValidationResult
                    ("Autor o podanym imieniu i nazwisku nie istnieje w bazie danych.");
                validationResults.Add(errorMessage);
            }

            var publisherValidate = db.Publisher.SingleOrDefault(x => x.Name.Equals(PublisherName));
            if (authorValidate == null)
            {
                ValidationResult errorMessage = new ValidationResult
                    ("Wydawnictwo o podanej nazwie nie istnieje w bazie danych.");
                validationResults.Add(errorMessage);
            }

            return validationResults;
        }
    }

    public class BooksTagViewModel
    {
        [Required]
        [MinLength(2), MaxLength(40)]
        [Display(Name = "Tytuł")]
        public string BookTitle { get; set; }

        [Required]
        [MinLength(3), MaxLength(40)]
        [Display(Name = "Tag")]
        public string TagName { get; set; }
    }

    public class AuthorDeteilsViewModel
    {
        public Author Author { get; set; }
        public IEnumerable<Book> Books { get; set; }
    }

    public class BookDetailsViewModel
    {
        public ApplicationUser User { get; set; }
        public Opinion UserOpinion { get; set; }
        public Book Book { get; set;}
    }

    public class AdvenceFilterViewModel
    {
        public ICollection<Tag> Tags { get; set; }
        public ICollection<Author> Authors { get; set; }
        public ICollection<Publisher> Publishers { get; set; }
        public IList<Book> Books { get; set; }
    }
}