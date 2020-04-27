package pl.czytamy.models.helpModels;

import pl.czytamy.models.Opinion;
import pl.czytamy.models.User;

public class UserOpinion {
   private User user;
   private Opinion opinion;

    public UserOpinion() {
        this.user = null;
        this.opinion = null;
    }

    public UserOpinion(User user, Opinion opinion) {
        this.user = user;
        this.opinion = opinion;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Opinion getOpinion() {
        return opinion;
    }

    public void setOpinion(Opinion opinion) {
        this.opinion = opinion;
    }
}
