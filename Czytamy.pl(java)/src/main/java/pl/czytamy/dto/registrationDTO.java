package pl.czytamy.dto;

import org.springframework.security.core.parameters.P;
import pl.czytamy.models.User;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class registrationDTO {
    private String nick;
    private String email;
    private String password;
    private String check_password;

    //------------------------------------------------------------------------------------------------------------------

    public Map<String, String> checkRegistration(registrationDTO newUser, List<User> users){
        Map<String, String> errors = new TreeMap<>();

        if (newUser.getNick().length() < 4){
            errors.put("nick_error", "nick musi posiadać przynajmniej 4 znaki");
        } else {
            for (User user : users) {
                if (user.getNick().equals(newUser.getNick())) {
                    errors.put("nick_error", "ten nick jest już zajęty");
                    break;
                }
            }
        }

        String regex = "^(.+)@(.+)$";
        Pattern pattern = Pattern.compile(regex);
        if(!pattern.matcher(newUser.getEmail()).matches()){
            errors.put("email_error", "nieporawny adress e-mail");
        } else {
            for (User user : users) {
                if (user.getEmail().equals(newUser.getEmail())) {
                    errors.put("email_error", "ten email został już użyty do rejestracji");
                    break;
                }
            }
        }

        if(newUser.getPassword().length() < 6){
            errors.put("password_error", "haslo musi posiadać przynajmniej 6 znaków");
        }
        if(!newUser.getPassword().equals(newUser.getCheck_password())){
            errors.put("checkPassword_error", "hasła nie są identyczne");
        }
        return errors;
    }

    //------------------------------------------------------------------------------------------------------------------

    public String getNick() {
        return nick;
    }

    public void setNick(String nick) {
        this.nick = nick;
    }

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

    public String getCheck_password() {
        return check_password;
    }

    public void setCheck_password(String check_password) {
        this.check_password = check_password;
    }
}
