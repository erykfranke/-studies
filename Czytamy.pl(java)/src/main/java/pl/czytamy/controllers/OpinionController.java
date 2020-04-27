package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import pl.czytamy.dao.OpinionDAO;
import pl.czytamy.models.Opinion;

import javax.validation.Valid;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
public class OpinionController {
    @Autowired
    OpinionDAO opinionDAO;

    @RequestMapping(value = "book/addComment", method = RequestMethod.POST)
    public String addComment(@ModelAttribute("form") @Valid Opinion opinion, BindingResult result){
        if (result.hasErrors()) {
            return "redirect:/book/"+opinion.getBook_id();
        } else {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            opinion.setDate_published(formatter.format(new Date()));
            opinionDAO.save(opinion);
            return "redirect:/book/"+opinion.getBook_id();
        }
    }

    @RequestMapping(value = "book/editComment", method = RequestMethod.POST)
    public String editComment(@ModelAttribute("form") @Valid Opinion opinion, BindingResult result){
        if (result.hasErrors()) {
            return "redirect:/book/"+opinion.getBook_id();
        } else {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            opinion.setDate_published(formatter.format(new Date()));
            opinionDAO.update(opinion);
            return "redirect:/book/"+opinion.getBook_id();
        }
    }

    @RequestMapping(value = "book/deleteComment", method = RequestMethod.POST)
    public String deleteComment(@ModelAttribute("form") @Valid Opinion opinion, BindingResult result){
        if (result.hasErrors()) {
            return "redirect:/book/"+opinion.getBook_id();
        } else {
            opinionDAO.delete(opinion.getId());
            return "redirect:/book/"+opinion.getBook_id();
        }
    }
}
