package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import pl.czytamy.dao.AuthorDAO;
import pl.czytamy.dao.BookElementListDAO;
import pl.czytamy.dto.PublisherListDTO;
import pl.czytamy.models.*;
import pl.czytamy.models.helpModels.BookListElement;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.util.*;

@Controller
public class AuthorController {
    @Autowired
    AuthorDAO authorDAO;
    @Autowired
    BookElementListDAO bookElementListDAO;

    @RequestMapping("/author/{id}")
    public String viewAuthors(@PathVariable int id, Model m){
        Author author = authorDAO.getAuthorById(id);
        m.addAttribute("author", author);

        List<BookListElement> books = bookElementListDAO.getBookByFilters(
                null,
                null,
                Collections.singletonList(id),
                null,
                null,
                null
        );
        books.sort(new BookListElement.DatePublishedSorter());
        m.addAttribute("books", books);

        return "author/author";
    }

    @RequestMapping("/authors")
    public String viewAuthors(HttpServletRequest request, @ModelAttribute("form") @Valid PublisherListDTO form, BindingResult result, Model m){
        List<Author> list = new ArrayList<>();
        try {
            if (form.getSort().equals("bookASC")) {
                if(form.getCategory() == null) {
                    list = authorDAO.getAuthorsOrderByBookASC();
                } else {
                    list = authorDAO.getAuthorsOrderByBookASC(form.getCategory());
                }
            } else if (form.getSort().equals("bookDESC")) {
                if(form.getCategory() == null) {
                    list = authorDAO.getAuthorsOrderByBookDESC();
                } else {
                    list = authorDAO.getAuthorsOrderByBookDESC(form.getCategory());
                }
            } else {
                if(form.getCategory() == null) {
                    list = authorDAO.getAuthors();
                } else {
                    list = authorDAO.getAuthors(form.getCategory());
                }
            }
            if(form.getStartLetter() != null){
                List<Author> temp = new ArrayList<>();
                for (Author x : list){
                    if(x.getSurname().startsWith(form.getStartLetter())){
                        temp.add(x);
                    }
                }
                list = temp;
            }
            if (form.getSort().equals("ASC")) {
                Collections.sort(list);
            } else if (form.getSort().equals("DESC")) {
                Collections.reverse(list);
            }
        } catch (java.lang.NullPointerException ignored){}
        m.addAttribute("list", list);
        return "author/author_list";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  ADD AUTHOR
    @RequestMapping("authors/addAuthor")
    public String addAuthor(HttpServletRequest request, Model m){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("author", new Author());
                return "author/author_add";
            }
        }
        return "redirect:/authors?sort=DESC";
    }
    @RequestMapping(value = "authors/addAuthor", method = RequestMethod.POST)
    public String checkAddAuthor(Model m, @ModelAttribute("form") @Valid Author newAuthor){
        Map<String, String> errors = newAuthor.checkAddAuthor(newAuthor);
        if(!errors.isEmpty()){
            for ( Map.Entry<String, String> error : errors.entrySet()){
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("author", new Author());
            return "author/author_add";
        } else {
            if(newAuthor.getBirth_date().isEmpty()){
                authorDAO.addWithOutDate(newAuthor);
            } else {
                authorDAO.add(newAuthor);
            }
            return "redirect:/authors?sort=DESC";
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  EDIT AUTHOR
    @RequestMapping("author/{id}/editAuthor")
    public String editAuthor(HttpServletRequest request, Model m, @PathVariable int id){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("author", authorDAO.getAuthorById(id));
                return "author/author_edit";
            }
        }
        return "redirect:/author/"+id;
    }
    @RequestMapping(value = "author/{id}/editAuthor", method = RequestMethod.POST)
    public String checkEditAuthor(Model m, @ModelAttribute("form") @Valid Author newAuthor, @PathVariable int id){
        Map<String, String> errors = newAuthor.checkAddAuthor(newAuthor);
        if(!errors.isEmpty()){
            for ( Map.Entry<String, String> error : errors.entrySet()){
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("author", authorDAO.getAuthorById(id));
            return "author/author_edit";
        } else {
            if(newAuthor.getBirth_date().isEmpty()){
                authorDAO.edit(newAuthor);
            } else {
                authorDAO.editWithOutDate(newAuthor);
            }
            return "redirect:/author/"+id;
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  UPLOAD AVATAR
    //
    @RequestMapping("/authors/{id}/uploadPhoto")
    public String uploadAvatar(HttpServletRequest request, @PathVariable int id, Model m){
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("author", authorDAO.getAuthorById(id));
                return "author/author_uploadPhoto";
            }
        }
        return "redirect:/author/"+id;
    }
    @RequestMapping(value="/authors/{id}/uploadPhoto", method= RequestMethod.POST)
    public String checkUploadAvatar(@PathVariable int id, @RequestParam CommonsMultipartFile file){
        String path = "C:/Users/erykf/OneDrive/repo/Java/czytamy.pl/src/main/webapp/resources/images/authors";
        String fileName = id+".jpg";
        try{
            byte[] barr =file.getBytes();

            BufferedOutputStream bout=new BufferedOutputStream(
                    new FileOutputStream(path+"/"+fileName));
            bout.write(barr);
            bout.flush();
            bout.close();

        }catch(Exception e){System.out.println(e);}
        authorDAO.updatePhoto(id, "resources/images/authors/"+fileName);
        return "redirect:/author/"+id;
    }
}
