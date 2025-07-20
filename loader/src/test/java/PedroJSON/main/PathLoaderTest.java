package PedroJSON.main;

import org.junit.Test;
import org.mockito.Mockito;
import static org.junit.Assert.*;

import com.pedropathing.follower.Follower;
import com.qualcomm.robotcore.eventloop.opmode.OpMode;
import java.io.File;

/**
 * Basic unit tests for PathLoader
 */
public class PathLoaderTest {

    @Test
    public void testPathLoaderCreationWithFile() {
        // Create mock objects
        OpMode mockOpMode = Mockito.mock(OpMode.class);
        Follower mockFollower = Mockito.mock(Follower.class);
        File testFile = new File("test.json");
        
        PathLoader loader = new PathLoader(testFile, mockFollower, mockOpMode);
        assertNotNull("PathLoader should be created successfully", loader);
    }

    @Test
    public void testPathLoaderCreationWithString() {
        // Create mock objects
        OpMode mockOpMode = Mockito.mock(OpMode.class);
        Follower mockFollower = Mockito.mock(Follower.class);
        String testPath = "test.json";
        
        PathLoader loader = new PathLoader(testPath, mockFollower, mockOpMode);
        assertNotNull("PathLoader should be created successfully", loader);
    }

    @Test
    public void testCallbacksCreation() {
        OpMode mockOpMode = Mockito.mock(OpMode.class);
        
        Callbacks callbacks = new Callbacks(mockOpMode);
        assertNotNull("Callbacks should be created successfully", callbacks);
    }
}
