using Czytamy.pl.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Czytamy.pl.Startup))]
namespace Czytamy.pl
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            CreateRoles();
        }

        private void CreateRoles()
        {
            ApplicationDbContext db = new ApplicationDbContext();

            var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(db));
            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(db));

            if(!roleManager.RoleExists("Admin"))
            {
                var role = new IdentityRole();
                role.Name = "Admin";
                roleManager.Create(role);

                var admin = new ApplicationUser();
                admin.UserName = "Czytamy.pl";
                admin.Email = "admin@czytamy.pl";
                string password = "Admin.123";

                var check = UserManager.Create(admin, password);
                if (check.Succeeded)
                {
                    UserManager.AddToRole(admin.Id, "Admin");
                }
            }

            if(!roleManager.RoleExists("User"))
            {
                var role = new IdentityRole();
                role.Name = "User";
                roleManager.Create(role);
            }
        }
    }
}
