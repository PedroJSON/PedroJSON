package PedroJSON.main;

public class Callback {

    Runnable codeToRun;

    public Callback() {}

    public Runnable GetCallback(String identifier) {

        codeToRun = () -> {
            //Maybe add a default command idk
        };

        return codeToRun;
    }
}
