using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Czytamy.pl.Models
{
    public class Tag
    {
        // ----------------------------------------------------------------------------------------
        //  Columns
        // ----------------------------------------------------------------------------------------
        [Key]
        public int ID { get; set; }

        [Required]
        [MinLength(3), MaxLength(40)]
        public string Name { get; set; }


        // ----------------------------------------------------------------------------------------
        //  Relation Ship
        // ----------------------------------------------------------------------------------------
        public virtual ICollection<Book> Books { get; set; }
    }
}