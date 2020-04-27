using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Czytamy.pl.Models;

namespace Czytamy.pl.Controllers
{
    public class AuthorsController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();


        //-------------------------------------------------------------------------------------------------------------
        //  INDEX
        //-------------------------------------------------------------------------------------------------------------

        // GET: Authors
        public ActionResult Index(string _sort, string _category, string _start_letter)
        {
            IEnumerable<Author> authors_ = db.Author.ToList();
            if (_category != null)
            {
                authors_ = db.Book.Where(
                        x => x.Category.Equals(_category.Replace("_"," "))
                    ).Select(x => x.Author).ToList();
            }
            if (_start_letter != null)
            {
                authors_ = authors_.Where(x => x.Surname.StartsWith(_start_letter));
            }

            switch (_sort)
            {
                case "s_asc":
                    authors_ = authors_.OrderBy(x => x.Surname);
                    break;

                case "s_desc":
                    authors_ = authors_.OrderByDescending(x => x.Surname);
                    break;

                case "b_asc":
                    authors_ = authors_.OrderBy(x => x.Books.Count);
                    break;

                case "b_desc":
                    authors_ = authors_.OrderByDescending(x => x.Books.Count);
                    break;

                default:
                    break;
            }
            return View(authors_);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  DETAILS
        //-------------------------------------------------------------------------------------------------------------

        // GET: Authors/Details/5
        public ActionResult Details(int? id)
        {
            AuthorDeteilsViewModel viewModel = new AuthorDeteilsViewModel();

            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            viewModel.Author = db.Author.Find(id);
            if (viewModel.Author == null)
            {
                return HttpNotFound();
            }
            viewModel.Books = db.Book.Where(x => x.Author.ID == id).OrderBy(x => x.Date_published).ToList();
            HashSet<string> set = new HashSet<string>();
            foreach (var item in viewModel.Books)
            {
                set.Add(item.Category);
            }
            ViewBag.Categories = set;
            return View(viewModel);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  CREATE
        //-------------------------------------------------------------------------------------------------------------

        // GET: Authors/Create
        [Authorize(Roles = "Admin")]
        public ActionResult Create()
        {
            return View();
        }


        // POST: Authors/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Author author)
        {
            if (ModelState.IsValid)
            {
                Author addedAuthor = db.Author.Add(author);
                db.SaveChanges();

                if (author.ImageFile != null)
                {
                    string _fileName = author.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Author_photos"), _fileName);
                    author.ImageFile.SaveAs(_path);

                    addedAuthor.PhotoPath = "/Resources/Images/Author_photos/" + _fileName;
                    db.Entry(addedAuthor).State = EntityState.Modified;
                    db.SaveChanges();
                }

                return RedirectToAction("Index");
            }
            return View(author);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  EDIT
        //-------------------------------------------------------------------------------------------------------------

        // GET: Authors/Edit/5
        [Authorize(Roles = "Admin")]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Author author = db.Author.Find(id);
            if (author == null)
            {
                return HttpNotFound();
            }
            return View(author);
        }
        

        // POST: Authors/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Author author)
        {
            if (ModelState.IsValid)
            {
                if (author.ImageFile != null)
                {
                    string _fileName = author.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Author_photos"), _fileName);
                    author.ImageFile.SaveAs(_path);

                    author.PhotoPath = "/Resources/Images/Author_photos/" + _fileName;
                }
                db.Entry(author).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Details", new { id = author.ID });
            }
            return View(author);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  DELETE
        //-------------------------------------------------------------------------------------------------------------

        // GET: Authors/Delete/5
        [Authorize(Roles = "Admin")]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Author author = db.Author.Find(id);
            if (author == null)
            {
                return HttpNotFound();
            }
            return View(author);
        }


        // POST: Authors/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Author author = db.Author.Find(id);

            IList<Book> books = author.Books.ToList();
            int booksSize = books.Count();
            for(int i = 0; i < booksSize; i++)
            {
                IList<Opinion> opinions = books[i].Opinions.ToList();
                int opinionsSize = opinions.Count();
                for(int j = 0; j < opinionsSize; j++)
                {
                    db.Opinion.Remove(opinions[j]);
                }
                System.IO.File.Delete(Server.MapPath(books[i].CoverPath));
                db.Book.Remove(books[i]);
            }
            deleteFile(author);
            db.Author.Remove(author);
            db.SaveChanges();
            return RedirectToAction("Index");
        }



        //-------------------------------------------------------------------------------------------------------------

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public void deleteFile(Author author)
        {
            string filePath = Server.MapPath(author.PhotoPath);
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }
        }
    }
}
