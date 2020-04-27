package pl.czytamy.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import pl.czytamy.dao.*;
import pl.czytamy.dao.BookElementListDAO;
import pl.czytamy.dto.bookDTO;
import pl.czytamy.dto.booksFiltersDTO;
import pl.czytamy.models.helpModels.BookListElement;
import pl.czytamy.models.helpModels.UserOpinion;
import pl.czytamy.models.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class BookController {
    @Autowired
    BookDAO bookDAO;
    @Autowired
    AuthorDAO authorDAO;
    @Autowired
    PublisherDAO publisherDAO;
    @Autowired
    BooksTagsDAO booksTagsDAO;
    @Autowired
    TagDAO tagDAO;
    @Autowired
    OpinionDAO opinionDAO;
    @Autowired
    UserDAO userDAO;
    @Autowired
    BookElementListDAO bookElementListDAO;

    @RequestMapping("/book/{id}")
    public String bookDetail(HttpServletRequest request, @PathVariable int id, Model m) {
        Book book = bookDAO.getBookById(id);
        m.addAttribute("book", book);

        Author author = authorDAO.getAuthorById(book.getAuthor_id());
        m.addAttribute("author", author);

        Publisher publisher = publisherDAO.getPublisherById(book.getPublisher_id());
        m.addAttribute("publisher", publisher);

        List<BooksTags> booksTags = booksTagsDAO.getBooksTagsByBookId(id);
        List<Tag> tags = new ArrayList<>();
        for (BooksTags x : booksTags) {
            assert false;
            tags.add(tagDAO.getTagById(x.getTag_id()));
        }
        m.addAttribute("tags", tags);

        List<Opinion> opinions = opinionDAO.getOpinionByBookID(id);
        m.addAttribute("opinions", opinions);

        List<UserOpinion> usersOpinions = new ArrayList<>();
        for (Opinion x : opinions) {
            User user = userDAO.getUserByID(x.getUser_id());
            usersOpinions.add(new UserOpinion(user, x));
        }
        m.addAttribute("usersOpinions", usersOpinions);

        OptionalDouble average = opinions.stream().mapToInt(Opinion::getRating).average();
        m.addAttribute("averageOpinion", average.toString().substring(15, 18));

        if (request.getSession().getAttribute("user") != null) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            User user = (User) request.getSession().getAttribute("user");
            Opinion opinion = new Opinion();
            opinion.setUser_id(user.getId());
            opinion.setBook_id(id);

            boolean find = false;
            UserOpinion toDelete = new UserOpinion();
            for (UserOpinion x : usersOpinions) {
                if (x.getUser().getId() == opinion.getUser_id()) {
                    find = true;
                    opinion = x.getOpinion();
                    toDelete = x;
                }
            }
            usersOpinions.remove(toDelete);

            if (find) {
                m.addAttribute("haveOpinion", true);
            } else {
                m.addAttribute("haveOpinion", false);
            }
            m.addAttribute("userOpinion", opinion);
        }
        return "book/book";
    }


    @RequestMapping("/books")
    public String viewBooks(HttpServletRequest request, @ModelAttribute("form") @Valid booksFiltersDTO form, BindingResult result, Model m) {
        List<BookListElement> list = bookElementListDAO.getBookByFilters(
                form.getCategory(),
                form.getTags_id(),
                form.getAuthors_id(),
                form.getPublishers_id(),
                form.getDate_published_from(),
                form.getDate_published_to()
        );

        switch (form.getSort()) {
            case "datePublishedASC":
                list.sort(new BookListElement.DatePublishedSorter());
                break;
            case "datePublishedDESC":
                list.sort(new BookListElement.DatePublishedSorter().reversed());
                break;
            case "ratingASC":
                list.sort(new BookListElement.RatingSorter());
                break;
            case "ratingDESC":
                list.sort(new BookListElement.RatingSorter().reversed());
                break;
            case "numberOfOpinionsASC":
                list.sort(new BookListElement.NumberOfOpinionsSorter());
                break;
            case "numberOfOpinionsDESC":
                list.sort(new BookListElement.NumberOfOpinionsSorter().reversed());
                break;
        }
        m.addAttribute("list", list);

        List<Tag> tags = tagDAO.getTags();
        m.addAttribute("tags", tags);

        List<Author> authors = authorDAO.getAuthors();
        m.addAttribute("authors", authors);

        List<Publisher> publishers = publisherDAO.getPublishers();
        m.addAttribute("publishers", publishers);

        return "book/book_list";
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  ADD Book
    @RequestMapping("books/addBook")
    public String addAuthor(HttpServletRequest request, Model m) {
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("book", new bookDTO());
                return "book/book_add";
            }
        }
        return "redirect:/books?sort=numberOfOpinionsDESC";
    }

    @RequestMapping(value = "books/addBook", method = RequestMethod.POST)
    public String checkAddAuthor(Model m, @ModelAttribute("form") @Valid bookDTO newBook) {
        Author author = authorDAO.getAuthorByNameAndSurname(newBook.getAuthor_name(), newBook.getAuthor_surname());
        Publisher publisher = publisherDAO.getPublisherByName(newBook.getPublisher_name());
        Map<String, String> errors = newBook.checkAddBook(bookDAO.getAll(), author, publisher);
        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> error : errors.entrySet()) {
                m.addAttribute(error.getKey(), error.getValue());
            }
            m.addAttribute("book", new bookDTO());
            return "book/book_add";
        } else {
            Book book = newBook.getBook();
            book.setAuthor_id(author.getId());
            book.setPublisher_id(publisher.getId());
            if (newBook.getBook().getPolish_date_published().isEmpty()) {
                bookDAO.addWithOutDate(book);
            } else {
                bookDAO.add(book);
            }
            return "redirect:/book/" + bookDAO.getBookByISBN(book.getIsbn()).getId();
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  EDIT BOOK
    @RequestMapping("book/{id}/editBook")
    public String editAuthor(HttpServletRequest request, Model m, @PathVariable int id) {
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                bookDTO bookdto = new bookDTO();

                Book book = bookDAO.getBookById(id);
                Author author = authorDAO.getAuthorById(book.getAuthor_id());
                Publisher publisher = publisherDAO.getPublisherById(book.getPublisher_id());

                bookdto.setBook(book);
                bookdto.setAuthor_name(author.getName());
                bookdto.setAuthor_surname(author.getSurname());
                bookdto.setPublisher_name(publisher.getName());

                m.addAttribute("book", bookdto);
                return "book/book_edit";
            }
        }
        return "redirect:/book/" + id;
    }

    @RequestMapping(value = "book/{id}/editBook", method = RequestMethod.POST)
    public String checkEditAuthor(Model m, @ModelAttribute("form") @Valid bookDTO newBook, @PathVariable int id) {
        Author author = authorDAO.getAuthorByNameAndSurname(newBook.getAuthor_name(), newBook.getAuthor_surname());
        Publisher publisher = publisherDAO.getPublisherByName(newBook.getPublisher_name());
        Map<String, String> errors = newBook.checkAddBook(bookDAO.getAll(), author, publisher);
        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> error : errors.entrySet()) {
                m.addAttribute(error.getKey(), error.getValue());
            }
            bookDTO bookdto = new bookDTO();

            Book book = bookDAO.getBookById(id);
            Author author__ = authorDAO.getAuthorById(book.getAuthor_id());
            Publisher publisher__ = publisherDAO.getPublisherById(book.getPublisher_id());

            bookdto.setBook(book);
            bookdto.setAuthor_name(author__.getName());
            bookdto.setAuthor_surname(author__.getSurname());
            bookdto.setPublisher_name(publisher__.getName());

            m.addAttribute("book", bookdto);
            return "book/book_edit";
        } else {
            Book book = newBook.getBook();
            book.setAuthor_id(author.getId());
            book.setPublisher_id(publisher.getId());
            if (newBook.getBook().getPolish_date_published().isEmpty()) {
                bookDAO.editWithOutDate(book);
            } else {
                bookDAO.edit(book);
            }
            return "redirect:/book/" + id;
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  UPLOAD AVATAR
    //
    @RequestMapping("/book/{id}/uploadCover")
    public String uploadAvatar(HttpServletRequest request, @PathVariable int id, Model m) {
        if (request.getSession().getAttribute("user") != null) {
            User user = (User) request.getSession().getAttribute("user");
            if (user.getRole() == 2) {
                m.addAttribute("book", bookDAO.getBookById(id));
                return "book/book_uploadPhoto";
            }
        }
        return "redirect:/book/" + id;
    }

    @RequestMapping(value = "/book/{id}/uploadCover", method = RequestMethod.POST)
    public String checkUploadAvatar(@PathVariable int id, @RequestParam CommonsMultipartFile file) {
        String path = "C:/Users/erykf/OneDrive/repo/Java/czytamy.pl/src/main/webapp/resources/images/covers";
        String fileName = id + ".jpg";
        try {
            byte[] barr = file.getBytes();

            BufferedOutputStream bout = new BufferedOutputStream(
                    new FileOutputStream(path + "/" + fileName));
            bout.write(barr);
            bout.flush();
            bout.close();

        } catch (Exception e) {
            System.out.println(e);
        }
        bookDAO.updatePhoto(id, "resources/images/covers/" + fileName);
        return "redirect:/book/" + id;
    }
}

