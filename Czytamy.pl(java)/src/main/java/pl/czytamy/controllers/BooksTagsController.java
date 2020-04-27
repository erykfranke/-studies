package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.czytamy.dao.BooksTagsDAO;
import pl.czytamy.models.BooksTags;

import java.util.List;

@Controller
public class BooksTagsController {
    @Autowired
    BooksTagsDAO booksTagsDAO;

    @RequestMapping("/books_tags")
    public String viewBooksTags(Model m){
        List<BooksTags> list = booksTagsDAO.getBooksTags();
        m.addAttribute("list", list);
        return "viewAll/books_tags";
    }
}
