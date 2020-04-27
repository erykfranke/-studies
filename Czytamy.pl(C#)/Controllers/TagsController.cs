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
    public class TagsController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: Tags
        public ActionResult Index()
        {
            return View(db.Tag.ToList());
        }

        // GET: Tags/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tag tag = db.Tag.Find(id);
            if (tag == null)
            {
                return HttpNotFound();
            }
            return View(tag);
        }

        //GET: Tags/Create/id
        public ActionResult Create(int? id)
        {
           ViewBag.BookTitle = db.Book.Find(id).Title;
           return View();
        }

        // POST: Tags/Create/id
        [HttpPost]
        public ActionResult Create(int? id, Tag tag)
        {
            Book book = db.Book.Find(id);
            if (db.Tag.SingleOrDefault(x => x.Name.Equals(tag.Name)) != null)
            {
                tag = db.Tag.Single(x => x.Name.Equals(tag.Name));
            }
            else
            {
                db.Tag.Add(tag);
            }
            book.Tags.Add(tag);
            db.SaveChanges();

            return RedirectToAction("Details", "Books", new { id = book.ID });
        }

        // GET: Tags/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tag tag = db.Tag.Find(id);
            if (tag == null)
            {
                return HttpNotFound();
            }
            return View(tag);
        }

        // POST: Tags/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,name")] Tag tag)
        {
            if (ModelState.IsValid)
            {
                db.Entry(tag).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(tag);
        }

        // GET: Tags/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Tag tag = db.Tag.Find(id);
            if (tag == null)
            {
                return HttpNotFound();
            }
            return View(tag);
        }

        // POST: Tags/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id, int bookID)
        {
            Tag tag = db.Tag.Find(id);
            Book book = db.Book.Find(bookID);
            book.Tags.Remove(tag);
            db.SaveChanges();
            if (tag.Books.Count() == 0)
            {
                db.Tag.Remove(tag);
            }
            db.SaveChanges();
            return RedirectToAction("Details", "Books", new { id = bookID });
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
