using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace Czytamy.pl.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit https://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        [Display(Name = "Opis")]
        public string Description { get; set; }

        [Display(Name = "Płeć")]
        public string Gender { get; set; }

        [Display(Name = "Miejscowość")]
        public string Place { get; set; }

        public string PhotoPath { get; set; } = "/Resources/Images/User_photos/default.jpg";

        [NotMapped]
        [Display(Name = "Avatar")]
        public HttpPostedFileBase ImageFile { get; set; }

        public virtual ICollection<Opinion> Opinions { get; set; }


        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
            return userIdentity;
        }
    }

    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
        }

        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

        public DbSet<Author> Author { get; set; }
        public DbSet<Book> Book { get; set; }
        public DbSet<Opinion> Opinion { get; set; }
        public DbSet<Publisher> Publisher { get; set; }
        public DbSet<Tag> Tag { get; set; }
    }
}