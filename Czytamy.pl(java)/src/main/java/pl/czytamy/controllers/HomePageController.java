package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import pl.czytamy.dao.BookPhotoListDAO;
import pl.czytamy.models.helpModels.BookPhotoList;

import javax.servlet.http.HttpSession;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.util.List;

@Controller
public class HomePageController {
    @Autowired
    BookPhotoListDAO bookPhotoListDAO;

    @RequestMapping("/")
    public String viewHomePage(Model m){
        List<BookPhotoList> booksCovers = bookPhotoListDAO.getBooks();
        m.addAttribute("boos", booksCovers);
        return "HomePage";
    }

}
