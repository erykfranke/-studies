package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import pl.czytamy.dao.BookDAO;
import pl.czytamy.dao.BooksTagsDAO;
import pl.czytamy.dao.TagDAO;
import pl.czytamy.models.Book;
import pl.czytamy.models.BooksTags;
import pl.czytamy.models.Tag;
import pl.czytamy.models.User;
import pl.czytamy.models.helpModels.TagsCount;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;

@Controller
public class TagController {
    @Autowired
    TagDAO tagDAO;
    @Autowired
    BookDAO bookDAO;
    @Autowired
    BooksTagsDAO booksTagsDAO;

    @RequestMapping("/tags")
    public String viewTags(Model m){
        List<TagsCount> list = tagDAO.getTagsCount();
        m.addAttribute("list", list);
        return "tag/tags_cloud";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  ADD TAG
    @RequestMapping("book/{book_id}/addTag")
    public String addTagToBook(HttpServletRequest request, Model m, @PathVariable int book_id, @ModelAttribute("form") @Valid Tag tag){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                Book book = bookDAO.getBookById(book_id);
                m.addAttribute("book", book);
                return "tag/add_tag";
            }
        }
        return "redirect:/book/"+book_id;
    }
    @RequestMapping(value = "book/{book_id}/addTag", method = RequestMethod.POST)
    public String checkAddTagToBook(Model m, @PathVariable int book_id,  @ModelAttribute("form") @Valid Tag tag){
        List<BooksTags> booksTags = booksTagsDAO.getBooksTagsByBookId(book_id);
        int tag_id = 0;
        if (tagDAO.getTagByName(tag.getName()) != null){
             tag_id = tagDAO.getTagByName(tag.getName()).getId();
        }
        if (booksTagsDAO.getByTagIDAndBookID(tag_id, book_id) != null) {
            Book book = bookDAO.getBookById(book_id);
            m.addAttribute("book", book);
            m.addAttribute("error", "książka już posiada wpisany tag");
            return "tag/add_tag";
        }
        if (tagDAO.getTagByName(tag.getName()) == null){
            tagDAO.add(tag);
        }
        booksTagsDAO.add(tagDAO.getTagByName(tag.getName()).getId(), book_id);
        return "redirect:/book/"+book_id;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  REMOVE TAG
    @RequestMapping("/removeTag")
    public String removeTag(HttpServletRequest request, @ModelAttribute("form") @Valid Tag tag){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                return "tag/remove_tag";
            }
        }
        return "redirect:/tags";
    }
    @RequestMapping(value = "/removeTag", method = RequestMethod.POST)
    public String checkRemoveTag(Model m,  @ModelAttribute("form") @Valid Tag tag){
        Tag tag1 = tagDAO.getTagByName(tag.getName());
        if(tag1 == null){
            m.addAttribute("error", "wpisany tag nie istnieje");
            return "tag/remove_tag";
        } else {
            List<BooksTags> booksTags = booksTagsDAO.getBooksTagsByTagId(tag1.getId());
            for (BooksTags x: booksTags){
                booksTagsDAO.delete(x.getId());
            }
            tagDAO.delete(tag1.getId());
            return "redirect:/tags";
        }
    }
}
