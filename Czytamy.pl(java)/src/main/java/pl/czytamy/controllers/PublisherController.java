package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import pl.czytamy.dao.BookElementListDAO;
import pl.czytamy.dao.PublisherDAO;
import pl.czytamy.dto.PublisherListDTO;
import pl.czytamy.models.*;
import pl.czytamy.models.helpModels.BookListElement;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.util.*;

@Controller
public class PublisherController {
    @Autowired
    PublisherDAO publisherDAO;
    @Autowired
    BookElementListDAO bookElementListDAO;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  VIEW PUBLISHER
    @RequestMapping("/publisher/{id}")
    public String viewAuthors(@PathVariable int id, Model m){
        Publisher publisher = publisherDAO.getPublisherById(id);
        m.addAttribute("publisher", publisher);

        List<BookListElement> books = bookElementListDAO.getBookByFilters(
                null,
                null,
                null,
                Collections.singletonList(id),
                null,
                null
        );
        books.sort(new BookListElement.DatePublishedSorter());
        m.addAttribute("books", books);

        return "publisher/publisher";
    }
    @RequestMapping("/publishers")
    public String viewPublishers(HttpServletRequest request, @ModelAttribute("form") @Valid PublisherListDTO form, BindingResult result, Model m) {
        List<Publisher> list = new ArrayList<>();
        try {
            if (form.getSort().equals("bookASC")) {
                if(form.getCategory() == null) {
                    list = publisherDAO.getPublishersOrderByBookASC();
                } else {
                    list = publisherDAO.getPublishersOrderByBookASC(form.getCategory());
                }
            } else if (form.getSort().equals("bookDESC")) {
                if(form.getCategory() == null) {
                    list = publisherDAO.getPublishersOrderByBookDESC();
                } else {
                    list = publisherDAO.getPublishersOrderByBookDESC(form.getCategory());
                }
            } else {
                if(form.getCategory() == null) {
                    list = publisherDAO.getPublishers();
                } else {
                    list = publisherDAO.getPublishers(form.getCategory());
                }
            }
            if(form.getStartLetter() != null){
                List<Publisher> temp = new ArrayList<>();
                for (Publisher x : list){
                    if(x.getName().startsWith(form.getStartLetter())){
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
        return "publisher/publisher_list";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  ADD PUBLISHER
    @RequestMapping("publishers/addPublisher")
    public String addPublisher(HttpServletRequest request, Model m){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("publisher", new Publisher());
                return "publisher/publisher_add";
            }
        }
        return "redirect:/publishers?sort=bookDESC";
    }
    @RequestMapping(value = "publishers/addPublisher", method = RequestMethod.POST)
    public String checkAddPublisher(HttpServletRequest request, Model m, @ModelAttribute("form") @Valid Publisher publisher){
        Map<String, String> errors = publisher.checkRegistration(publisher, publisherDAO.getPublishers());
        if(!errors.isEmpty()){
            for ( Map.Entry<String, String> error : errors.entrySet()){
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("publisher", new Publisher());
            return "publisher/publisher_add";
        } else {
            publisherDAO.add(publisher);
            return "redirect:/publishers?sort=bookDESC";
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  EDIT PUBLISHER
    @RequestMapping("publisher/{id}/editPublisher")
    public String editPublisher(HttpServletRequest request, Model m, @PathVariable int id){
        if (request.getSession().getAttribute("user") != null){
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("publisher", publisherDAO.getPublisherById(id));
                return "publisher/publisher_edit";
            }
        }
        return "redirect:/publisher/"+id;
    }
    @RequestMapping(value = "publisher/{id}/editPublisher", method = RequestMethod.POST)
    public String checkEditPublisher(HttpServletRequest request, Model m, @ModelAttribute("form") @Valid Publisher publisher, @PathVariable int id){
        Map<String, String> errors = publisher.checkRegistration(publisher, publisherDAO.getPublishers());
        if(!errors.isEmpty()){
            for ( Map.Entry<String, String> error : errors.entrySet()){
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("publisher", publisherDAO.getPublisherById(id));
            return "publisher/publisher_edit";
        } else {
            publisherDAO.edit(publisher);
            return "redirect:/publisher/"+id;
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  UPLOAD AVATAR
    //
    @RequestMapping("/publisher/{id}/uploadLogo")
    public String uploadAvatar(HttpServletRequest request, @PathVariable int id, Model m){
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("publisher", publisherDAO.getPublisherById(id));
                return "publisher/publisher_uploadPhoto";
            }
        }
        return "redirect:/publisher/"+id;
    }
    @RequestMapping(value="/publisher/{id}/uploadLogo", method= RequestMethod.POST)
    public String checkUploadAvatar(@PathVariable int id, @RequestParam CommonsMultipartFile file){
        String path = "C:/Users/erykf/OneDrive/repo/Java/czytamy.pl/src/main/webapp/resources/images/publishers";
        String fileName = id+".jpg";
        try{
            byte[] barr =file.getBytes();

            BufferedOutputStream bout=new BufferedOutputStream(
                    new FileOutputStream(path+"/"+fileName));
            bout.write(barr);
            bout.flush();
            bout.close();

        }catch(Exception e){System.out.println(e);}
        publisherDAO.updatePhoto(id, "resources/images/publishers/"+fileName);
        return "redirect:/publisher/"+id;
    }
}
