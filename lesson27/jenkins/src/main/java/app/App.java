package app;

/**
 * Hello Jenkins!!!
 */

public class App {

    private static final String MESSAGE = "Hello Jenkins!!!";
    private static final String INFO = "Jenkins";    

    public App() {}

    public static void main(String[] args) {
        System.out.println(MESSAGE);
    }

    public String getMessage() {
        return MESSAGE;
    }
}
