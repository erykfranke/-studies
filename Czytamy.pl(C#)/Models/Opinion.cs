using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Czytamy.pl.Models
{
    public class Opinion
    {
        // ----------------------------------------------------------------------------------------
        //  Columns
        // ----------------------------------------------------------------------------------------
        [Key]
        public int ID { get; set; }

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime Date_published { get; set; } = DateTime.Now;

        [Display(Name = "Komentarz")]
        public string Comment { get; set; }

        [Required]
        [Display(Name = "Ocena")]
        public short Rating { get; set; } = 0;



        // ----------------------------------------------------------------------------------------
        //  Relation Ship
        // ----------------------------------------------------------------------------------------
        public virtual ApplicationUser User { get; set; }

        public virtual ICollection<Book> Books { get; set; }
    }
}