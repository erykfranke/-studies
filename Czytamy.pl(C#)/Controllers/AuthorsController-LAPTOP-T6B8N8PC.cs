using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
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

        // GET: Authors
        public ActionResult Index(string _sort, string _category, string _start_letter)
        {
            IEnumerable<Author> authors_ = db.Author.ToList();
            if (_category != null)
            {
                authors_ = authors_.Where(x => x.Books.Where(y => y.Category.Equals(_category)));
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

        // GET: Authors/Details/5
        public ActionResult Details(int? id)
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

        // GET: Authors/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Authors/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "name,surname,birth_date,death_date,description")] Author author)
        {
            if (ModelState.IsValid)
            {
                db.Author.Add(author);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(author);
        }

        // GET: Authors/Edit/5
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
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,name,surname,birth_date,death_date,description,photo")] Author author)
        {
            if (ModelState.IsValid)
            {
                db.Entry(author).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(author);
        }

        // GET: Authors/Delete/5
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
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Author author = db.Author.Find(id);
            db.Author.Remove(author);
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
    }
}
