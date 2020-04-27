using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Czytamy.pl.Models;
using Microsoft.AspNet.Identity;

namespace Czytamy.pl.Controllers
{
    public class OpinionsController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        //-------------------------------------------------------------------------------------------------------------
        //  INDEX
        //-------------------------------------------------------------------------------------------------------------

        // GET: Opinions
        public ActionResult Index()
        {
            return View(db.Opinion.ToList());
        }

        // GET: Opinions/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Opinion opinion = db.Opinion.Find(id);
            if (opinion == null)
            {
                return HttpNotFound();
            }
            return View(opinion);
        }

        // GET: Opinions/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Opinions/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Create(BookDetailsViewModel viewModel)
        {
            ApplicationUser user = db.Users.Find(viewModel.User.Id);
            Book book = db.Book.Find(viewModel.Book.ID);
            Opinion opinion = viewModel.UserOpinion;
            opinion.User = user;

            db.Opinion.Add(opinion);
            book.Opinions.Add(opinion);
            db.SaveChanges();

            viewModel.Book = book;
            viewModel.User = user;
            return RedirectToAction("Details", "Books" , new {id = viewModel.Book.ID, viewModel });
        }

        // GET: Opinions/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Opinion opinion = db.Opinion.Find(id);
            if (opinion == null)
            {
                return HttpNotFound();
            }
            return View(opinion);
        }

        // POST: Opinions/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Edit(BookDetailsViewModel viewModel)
        {
            //if (ModelState.IsValid)
            //{
            Opinion opinion = db.Opinion.Find(viewModel.UserOpinion.ID);
            opinion.Rating = viewModel.UserOpinion.Rating;
            opinion.Comment = viewModel.UserOpinion.Comment;
                
            db.Entry(opinion).State = EntityState.Modified;
            db.SaveChanges();
           // }
            return RedirectToAction("Details", "Books", new { id = viewModel.Book.ID, viewModel });
        }

        // GET: Opinions/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Opinion opinion = db.Opinion.Find(id);
            if (opinion == null)
            {
                return HttpNotFound();
            }
            return View(opinion);
        }

        // POST: Opinions/Delete/5
        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id, int bookID)
        {
            Opinion opinion = db.Opinion.Find(id);
            db.Opinion.Remove(opinion);
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
