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
    public class PublishersController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: Publishers
        public ActionResult Index(string _sort, string _category, string _start_letter)
        {
            IEnumerable<Publisher> publishers_ = db.Publisher.ToList();
            if (_category != null)
            {
                publishers_ = db.Book.Where(x => x.Category.Equals(_category.Replace("_", " "))).Select(x => x.Publisher).ToList();
            }
            if (_start_letter != null)
            {
                publishers_ = publishers_.Where(x => x.Name.StartsWith(_start_letter));
            }

            switch (_sort)
            {
                case "s_asc":
                    publishers_ = publishers_.OrderBy(x => x.Name);
                    break;

                case "s_desc":
                    publishers_ = publishers_.OrderByDescending(x => x.Name);
                    break;

                case "b_asc":
                    publishers_ = publishers_.OrderBy(x => x.Books.Count);
                    break;

                case "b_desc":
                    publishers_ = publishers_.OrderByDescending(x => x.Books.Count);
                    break;

                default:
                    break;
            }
            return View(publishers_);
        }

        // GET: Publishers/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Publisher publisher = db.Publisher.Find(id);
            if (publisher == null)
            {
                return HttpNotFound();
            }
            return View(publisher);
        }

        // GET: Publishers/Create
        [Authorize(Roles = "Admin")]
        public ActionResult Create()
        {
            return View();
        }

        // POST: Publishers/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Create(Publisher publisher)
        {
            if (ModelState.IsValid)
            {
                Publisher addedPublisher = db.Publisher.Add(publisher);
                db.SaveChanges();

                if (publisher.ImageFile != null)
                {
                    string _fileName = publisher.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Publisher_logos"), _fileName);
                    addedPublisher.ImageFile.SaveAs(_path);

                    addedPublisher.LogoPath = "/Resources/Images/Publisher_logos/" + _fileName;
                    db.Entry(addedPublisher).State = EntityState.Modified;
                    db.SaveChanges();
                }
                return RedirectToAction("Index");
            }
            return View(publisher);
        }

        // GET: Publishers/Edit/5
        [Authorize(Roles = "Admin")]
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Publisher publisher = db.Publisher.Find(id);
            if (publisher == null)
            {
                return HttpNotFound();
            }
            return View(publisher);
        }

        // POST: Publishers/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Publisher publisher)
        {
            if (ModelState.IsValid)
            {
                if (publisher.ImageFile != null)
                {
                    string _fileName = publisher.ID.ToString() + ".jpg";
                    string _path = Path.Combine(Server.MapPath("/Resources/Images/Publisher_logos"), _fileName);
                    publisher.ImageFile.SaveAs(_path);

                    publisher.LogoPath = "/Resources/Images/Publisher_logos/" + _fileName;
                }

                db.Entry(publisher).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Details", new { id = publisher.ID });
            }
            return View(publisher);
        }

        // GET: Publishers/Delete/5
        [Authorize(Roles = "Admin")]
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Publisher publisher = db.Publisher.Find(id);
            if (publisher == null)
            {
                return HttpNotFound();
            }
            return View(publisher);
        }

        // POST: Publishers/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Publisher publisher = db.Publisher.Find(id);

            IList<Book> books = publisher.Books.ToList();
            int booksSize = books.Count();
            for (int i = 0; i < booksSize; i++)
            {
                IList<Opinion> opinions = books[i].Opinions.ToList();
                int opinionsSize = opinions.Count();
                for (int j = 0; j < opinionsSize; j++)
                {
                    db.Opinion.Remove(opinions[j]);
                }
                System.IO.File.Delete(Server.MapPath(books[i].CoverPath));
                db.Book.Remove(books[i]);
            }
            deleteFile(publisher);
            db.Publisher.Remove(publisher);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public void deleteFile(Publisher publisher)
        {
            string filePath = Server.MapPath(publisher.LogoPath);
            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }
        }
    }
}
