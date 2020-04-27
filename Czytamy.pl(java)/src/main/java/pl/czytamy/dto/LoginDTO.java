package pl.czytamy.dto;

import org.springframework.beans.factory.annotation.Autowired;
import pl.czytamy.dao.UserDAO;
import pl.czytamy.models.User;

import java.util.List;

public class LoginDTO {

    private String email;
    private String password;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean checkLogin(List<User> users){
        for (User user: users){
            if (user.getEmail().equals(email) && user.getPassword().equals(password)){
                return true;
            }
        }
        return false;
    }
}
