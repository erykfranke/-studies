package pl.czytamy.dto;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import pl.czytamy.models.User;

public class editUserDTO {
    private User user;
    private CommonsMultipartFile file;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public CommonsMultipartFile getFile() {
        return file;
    }

    public void setFile(CommonsMultipartFile file) {
        this.file = file;
    }
}
