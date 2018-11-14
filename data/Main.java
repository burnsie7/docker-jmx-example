import java.lang.Thread;

public class Main {

    public static void main(String[] args) {
    while (true){

        // Prints "Hello, World" to the terminal window.
        System.out.println("Hello, World");
    try {
            Thread.sleep(1000);
        } catch(InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
    }
}
}
