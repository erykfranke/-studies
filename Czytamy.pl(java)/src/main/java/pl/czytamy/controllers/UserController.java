package pl.czytamy.controllers;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import pl.czytamy.dao.OpinionDAO;
import pl.czytamy.dto.LoginDTO;
import pl.czytamy.dto.registrationDTO;
import pl.czytamy.models.User;
import pl.czytamy.dao.UserDAO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
public class UserController {
    @Autowired
    UserDAO userDAO;
    @Autowired
    OpinionDAO opinionDAO;

    @RequestMapping("/user/{id}")
    public String viewUsers(@PathVariable int id, Model m){
        User user = userDAO.getUserByID(id);
        m.addAttribute("user", user);

        int opinionCount = opinionDAO.getOpinionCountByUserID(user.getId());
        m.addAttribute("opinionCount", opinionCount);

        return "user/user";
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  REGISTRATION
    //
    @RequestMapping("/registration")
    public String registerUser(Model m){
        m.addAttribute("user", new registrationDTO());
        return "user/registration";
    }
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String save(@ModelAttribute("form") @Valid registrationDTO user,  Model m){
        Map<String, String> errors = user.checkRegistration(user, userDAO.getUsers());
        if (!errors.isEmpty()){
            for ( Map.Entry<String, String> error : errors.entrySet()){
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("user", new registrationDTO());
            return "user/registration";
        } else {
            userDAO.save(user.getNick(), user.getEmail(), user.getPassword());
            return "redirect:/";
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  LOGIN
    //
    @RequestMapping("/login")
    public String login(Model m){
        m.addAttribute("user", new LoginDTO());
        return "user/login";
    }
    @RequestMapping(value = "/checkLogin", method = RequestMethod.POST)
    public String checkLogin(HttpServletRequest request, @ModelAttribute("form") LoginDTO user, BindingResult result, Model m){
        List<User> users = userDAO.getUsers();
        for (User x: users){
            if (x.getEmail().equals(user.getEmail()) && x.getPassword().equals(user.getPassword())){
                request.getSession().setAttribute("user", x);
                return "redirect:/";
            }
        }
        m.addAttribute("error", "niepoprawny e-mail lub hasło");
        m.addAttribute("user", new LoginDTO());
        return "user/login";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  LOGOUT
    //
    @RequestMapping("/logout")
    public String logout(HttpServletRequest request){
        request.getSession().removeAttribute("user");
        return "redirect:/";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  EDIT USER
    //
    @RequestMapping("/user/{user_id}/edit")
    public String editUser(HttpServletRequest request, @PathVariable int user_id, Model m){
        User user = userDAO.getUserByID(user_id);
        m.addAttribute("user", user);
        if (request.getSession().getAttribute("user") != null){
            User sessionUser = (User) request.getSession().getAttribute("user");
            if (user_id == sessionUser.getId()){
                return "user/user_edit";
            }
        }
        return "redirect:/";
    }
    @RequestMapping(value = "/user/{user_id}/edit", method = RequestMethod.POST)
    public String checkEditUser(@PathVariable int user_id, @ModelAttribute("form") @Valid User newUser, Model m){
        if (newUser.getNick().length() < 4){
            m.addAttribute("nick_error", "nick musi posiadać przynajmniej 4 znaki");
            User user = userDAO.getUserByID(user_id);
            m.addAttribute("user", user);
            return "user/user_edit";
        } else {
            List<User> users = userDAO.getUsers();
            for (User x : users) {
                if (x.getNick().equals(newUser.getNick()) && x.getId() != user_id) {
                    m.addAttribute("nick_error", "ten nick jest już zajęty");
                    User user = userDAO.getUserByID(user_id);
                    user.setNick(x.getNick());
                    m.addAttribute("user", user);
                    return "user/user_edit";
                }
            }
            userDAO.update(newUser);
            return "redirect:/user/"+user_id;
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  UPLOAD AVATAR
    //
    @RequestMapping("/user/{user_id}/uploadAvatar")
    public String uploadAvatar(HttpServletRequest request, @PathVariable int user_id, Model m){
        User user = userDAO.getUserByID(user_id);
        m.addAttribute("user", user);
        if (request.getSession().getAttribute("user") != null){
            User sessionUser = (User) request.getSession().getAttribute("user");
            if (user_id == sessionUser.getId()){
                return "user/user_uploadPhoto";
            }
        }
        return "redirect:/";
    }
    @RequestMapping(value="/user/{user_id}/uploadAvatar",method= RequestMethod.POST)
    public String checkUploadAvatar(@PathVariable int user_id, @ModelAttribute("form") @Valid User user, @RequestParam CommonsMultipartFile file){
        String path = "C:/Users/erykf/OneDrive/repo/Java/czytamy.pl/src/main/webapp/resources/images/users";
        String fileName = user_id+".jpg";
        try{
            byte[] barr =file.getBytes();

            BufferedOutputStream bout=new BufferedOutputStream(
                    new FileOutputStream(path+"/"+fileName));
            bout.write(barr);
            bout.flush();
            bout.close();

        }catch(Exception e){System.out.println(e);}
        userDAO.updatePhoto(user_id, "resources/images/users/"+fileName);
        return "redirect:/user/"+user_id;
    }
}
