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
using Microsoft.AspNet.Identity;

namespace Czytamy.pl.Controllers
{
    public class BooksController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();


        //-------------------------------------------------------------------------------------------------------------
        //  INDEX
        //-------------------------------------------------------------------------------------------------------------

        // GET: Books
        public ActionResult Index(
            string sort,
            string category,
            string tagsID,
            string datePublishedFrom,
            string datePublishedTo,
            string authorsID,
            string publishersID,
            string page
        )
        {
            AdvenceFilterViewModel viewModel = new AdvenceFilterViewModel();
            viewModel.Tags = db.Tag.ToList();
            viewModel.Authors = db.Author.ToList();
            viewModel.Publishers = db.Publisher.ToList();

            IList<Book> books = db.Book.ToList();
            if (category != null)
            {
                books = books.Where(x => x.Category.Equals(category.Replace("_", " "))).ToList();
            }
            if (tagsID != null)
            {
                var temp = db.Tag.Where(x => tagsID.Contains(x.ID.ToString())).SelectMany(x => x.Books).Distinct();
                books = books.Intersect(temp).ToList();
            }
            if (datePublishedFrom != null)
            {
                books = books.Where(x => x.Date_published.Year >= Int32.Parse(datePublishedFrom)).ToList();
            }
            if (datePublishedTo != null)
            {
                books = books.Where(x => x.Date_published.Year <= Int32.Parse(datePublishedTo)).ToList();
            }
            if (authorsID != null)
            {
                var temp = db.Author.Where(x => authorsID.Contains(x.ID.ToString())).SelectMany(x => x.Books).Distinct();
                books = books.Intersect(temp).ToList();
            }
            if (publishersID != null)
            {
                var temp = db.Publisher.Where(x => publishersID.Contains(x.ID.ToString())).SelectMany(x => x.Books).Distinct();
                books = books.Intersect(temp).ToList();
            }

            switch (sort)
            {
                case "t_asc":
                    books = books.OrderBy(x => x.Title).ToList();
                    break;

                case "t_desc":
                    books = books.OrderByDescending(x => x.Title).ToList();
                    break;

                case "dp_asc":
                    books = books.OrderBy(x => x.Date_published).ToList();
                    break;

                case "dp_desc":
                    books = books.OrderByDescending(x => x.Date_published).ToList();
                    break;

                case "noo_asc":
                    books = books.OrderBy(x => x.Opinions.Count()).ToList();
                    break;

                case "noo_desc":
                    books = books.OrderByDescending(x => x.Opinions.Count()).ToList();
                    break;

                case "r_asc":
                    books = books.OrderBy(x => x.Opinions.Average(y=>y.Rating)).ToList();
                    break;

                case "r_desc":
                    books = books.OrderByDescending(x => x.Opinions.Average(y => y.Rating)).ToList();
                    break;
            }

            const int bookOnPage = 10;
            IList<Book> booksOnPage = new List<Book>();
            for (int i = (Int32.Parse(page) * bookOnPage) - bookOnPage; i < (Int32.Parse(page) * bookOnPage) && i < books.Count(); i++)
            {
                booksOnPage.Add(books.ElementAt(i));
            }
            viewModel.Books = booksOnPage;
            ViewBag.numberOfBooks = books.Count();
            ViewBag.numberOfPages = (int)Math.Ceiling((double)books.Count() / bookOnPage);
            return View(viewModel);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  DETAILS
        //-------------------------------------------------------------------------------------------------------------

        // GET: Books/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            BookDetailsViewModel viewModel = new BookDetailsViewModel();
            string userID = User.Identity.GetUserId();
            viewModel.Book = db.Book.Find(id);
            if (userID != null)
            {
                viewModel.User = db.Users.FirstOrDefault(x => x.Id == userID);
                viewModel.UserOpinion = viewModel.Book.Opinions.SingleOrDefault(x=>x.User.Id == userID);
            }
            if (viewModel.Book == null)
            {
                return HttpNotFound();
            }
            IEnumerable<Opinion> opinions = db.Opinion.ToList();
            return View(viewModel);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  CREATE
        //-------------------------------------------------------------------------------------------------------------

        // GET: Books/Create
        [Authorize(Roles = "Admin")]
        public ActionResult Create()
        {
            return View();
        }

        // POST: Books/Create
        [HttpPost]
        public ActionResult Create(CreateEdit_BookViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                viewModel.Book.Author = db.Author.Single(
                        x => x.Surname.Equals(viewModel.AuthorSurname) && x.Name.Equals(viewModel.AuthorName)
                    );

                viewModel.Book.Publisher = db.Publisher.Single(
                        x => x.Name.Equals(viewModel.PublisherName)
                    );

                Book addedBook = db.Book.Add(viewModel.Book);
                db.SaveChanges();

                if (viewModel.Book.ImageFile != null)
                {
                    string _fileName = addedBook.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Book_covers"), _fileName);
                    addedBook.ImageFile.SaveAs(_path);

                    addedBook.CoverPath = "/Resources/Images/Book_covers/" + _fileName;
                    //db.Entry(addedBook).State = EntityState.Modified;
                }
                db.SaveChanges();

                return RedirectToAction("Index", new { page = "1" });
            }
            return View(viewModel);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  EDIT
        //-------------------------------------------------------------------------------------------------------------

        // GET: Books/Edit/5
        [Authorize(Roles = "Admin")]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            CreateEdit_BookViewModel viewModel = new CreateEdit_BookViewModel();
            viewModel.Book = db.Book.Find(id);
            viewModel.AuthorName = viewModel.Book.Author.Name;
            viewModel.AuthorSurname = viewModel.Book.Author.Surname;
            viewModel.PublisherName = viewModel.Book.Publisher.Name;

            if (viewModel.Book == null)
            {
                return HttpNotFound();
            }
            return View(viewModel);
        }

        // POST: Books/Edit/5
        [HttpPost]
        public ActionResult Edit(CreateEdit_BookViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                viewModel.Book.Author = db.Author.Single(
                        x => x.Surname.Equals(viewModel.AuthorSurname) && x.Name.Equals(viewModel.AuthorName)
                    );

                viewModel.Book.Publisher = db.Publisher.Single(
                        x => x.Name.Equals(viewModel.PublisherName)
                    );

                if (viewModel.Book.ImageFile != null)
                {
                    string _fileName = viewModel.Book.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Book_covers"), _fileName);
                    viewModel.Book.ImageFile.SaveAs(_path);

                    viewModel.Book.CoverPath = "/Resources/Images/Book_covers/" + _fileName;
                }

                db.Entry(viewModel.Book).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index", new { page = "1" });
            }
            return View(viewModel);
        }



        //-------------------------------------------------------------------------------------------------------------
        //  DELETEE
        //-------------------------------------------------------------------------------------------------------------

        // GET: Books/Delete/5
        [Authorize(Roles = "Admin")]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Book book = db.Book.Find(id);
            if (book == null)
            {
                return HttpNotFound();
            }
            return View(book);
        }

        // POST: Books/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Book book = db.Book.Find(id);

            IList<Opinion> opinions = book.Opinions.ToList();
            for (int i = 0; i < opinions.Count(); i++)
            {
                db.Opinion.Remove(opinions[i]);
            }
            deleteFile(book);
            db.Book.Remove(book);
            db.SaveChanges();
            return RedirectToAction("Index");
        }



        //.............................................................................................................
        //  UTILITY

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public void addFile(Book book)
        {

        }

        public void deleteFile(Book book)
        {
            string filePath = Server.MapPath(book.CoverPath);
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }
        }
    }
}
