package app;

/**
 * Hello world!
 */

public class App {

    private static final String MESSAGE = "Hello World!";
    private static final String INFO = "World";    

    public App() {}

    public static void main(String[] args) {
        System.out.println(MESSAGE);
    }

    public String getMessage() {
        return MESSAGE;
    }
}
