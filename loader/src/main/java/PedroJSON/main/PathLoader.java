package PedroJSON.main;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.pedropathing.follower.Follower;
import com.pedropathing.localization.Pose;
import com.pedropathing.pathgen.BezierCurve;
import com.pedropathing.pathgen.BezierLine;
import com.pedropathing.pathgen.Path;
import com.pedropathing.pathgen.PathBuilder;
import com.pedropathing.pathgen.PathChain;
import com.pedropathing.pathgen.Point;
import com.pedropathing.util.Timer;
import com.qualcomm.robotcore.eventloop.opmode.OpMode;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class PathLoader {

    InputStream inputStream;
    Point start;
    Point end;
    Point control1;
    Point control2;
    ArrayList<PathChain> pathDir = new ArrayList<>();

    Follower follower;
    PathBuilder builder;
    Callback callbacks;
    OpMode opmode;
    int pathState = 0;
    boolean isComplete = false;
    private Timer pathTimer;
    double defaultMaxPower;

    public PathLoader(InputStream inputStream, Follower follower, OpMode opMode, Callback callbacks, double defaultMaxPower) {
        this.inputStream = inputStream;
        this.follower = follower;
        this.opmode = opMode;
        this.callbacks = callbacks;
        this.defaultMaxPower = defaultMaxPower;
    }

    public void Parse() {
        
        if (inputStream == null) {
            return;
        }
        
        BufferedReader reader = null;
        try {
            // Use UTF-8 encoding explicitly for consistent behavior
            reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            
            // Read the entire file as text with proper line handling
            StringBuilder jsonText = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonText.append(line).append('\n');
            }
            
            // Validate that we read something
            String jsonString = jsonText.toString().trim();
            if (jsonString.isEmpty()) {
                return;
            }
            
            // Parse with Android's native JSON parser
            // This is done in the same try block to catch parsing errors early
            JSONObject rootNode = new JSONObject(jsonString);
            
            if (!rootNode.has("pathChains")) {
                return;
            }
            
            JSONArray pathChains = rootNode.getJSONArray("pathChains");

            for (int chainNumber = 0; chainNumber < pathChains.length(); chainNumber++) {
                
                builder = follower.pathBuilder();

                JSONObject pathChainNode = pathChains.getJSONObject(chainNumber);
                JSONArray paths = pathChainNode.getJSONArray("paths");

                for (int pathNumber = 0; pathNumber < paths.length(); pathNumber++) {

                    Path path = null;

                    JSONObject pathNode = paths.getJSONObject(pathNumber);

                    if (chainNumber == 0 && pathNumber == 0) {
                        JSONObject startNode = pathNode.getJSONObject("start");
                        JSONObject interpolationNode = pathNode.getJSONObject("interpolation");
                        follower.setStartingPose(new Pose(startNode.getDouble("x"), startNode.getDouble("y"), interpolationNode.getDouble("heading1")));
                    }

                    JSONObject startNode = pathNode.getJSONObject("start");
                    start = new Point(startNode.getDouble("x"), startNode.getDouble("y"), Point.CARTESIAN);

                    JSONObject endNode = pathNode.getJSONObject("end");
                    end = new Point(endNode.getDouble("x"), endNode.getDouble("y"), Point.CARTESIAN);

                    String pathType = pathNode.optString("type", "LINEAR");
                    switch (pathType) {
                        case "QUADRATIC":
                            JSONObject control1Node = pathNode.getJSONObject("control1");
                            control1 = new Point(control1Node.getDouble("x"), control1Node.getDouble("y"), Point.CARTESIAN);
                            path = new Path(new BezierCurve(start, control1, end));
                            break;
                        case "CUBIC":
                            JSONObject control1NodeCubic = pathNode.getJSONObject("control1");
                            control1 = new Point(control1NodeCubic.getDouble("x"), control1NodeCubic.getDouble("y"), Point.CARTESIAN);
                            JSONObject control2Node = pathNode.getJSONObject("control2");
                            control2 = new Point(control2Node.getDouble("x"), control2Node.getDouble("y"), Point.CARTESIAN);
                            path = new Path(new BezierCurve(start, control1, control2, end));
                            break;
                        default:
                            path = new Path(new BezierLine(start, end));
                            break;
                    }

                    JSONObject interpolationNode = pathNode.getJSONObject("interpolation");
                    String interpolationType = interpolationNode.optString("type", "TANGENT");
                    switch (interpolationType) {
                        case "CONSTANT":
                            path.setConstantHeadingInterpolation(Math.toRadians(interpolationNode.getDouble("heading1")));
                            break;
                        case "LINEAR":
                            path.setLinearHeadingInterpolation(Math.toRadians(interpolationNode.getDouble("heading2")), Math.toRadians(interpolationNode.getDouble("heading1")));
                            break;
                        case "TANGENT":
                            break;
                    }

                    double zpam = pathNode.optDouble("zpam", 0);
                    if (zpam != 0) path.setZeroPowerAccelerationMultiplier(zpam);

                    builder.addPath(path);

                    if (pathNode.has("callbacks")) {
                        JSONArray callbacksArray = pathNode.getJSONArray("callbacks");
                        for (int callbackNumber = 0; callbackNumber < callbacksArray.length(); callbackNumber++) {

                            JSONObject callbackNode = callbacksArray.getJSONObject(callbackNumber);
                            String callbackType = callbackNode.getString("type");

                            switch (callbackType) {
                                case "PARAMETRIC":
                                    builder.addParametricCallback(callbackNode.getDouble("t"), callbacks.GetCallback(callbackNode.getString("runnable")));
                                    break;
                                case "TEMPORAL":
                                    builder.addTemporalCallback(callbackNode.getDouble("t"), callbacks.GetCallback(callbackNode.getString("runnable")));
                                    break;
                            }
                        }
                    }

                    double maxPower = pathNode.optDouble("maxPower", 0);
                    if (maxPower != 0) {
                        final double power = maxPower;
                        builder.addParametricCallback(0, () -> follower.setMaxPower(power));
                    } else {
                        builder.addParametricCallback(0, () -> follower.setMaxPower(defaultMaxPower));
                    }
                }
                pathDir.add(builder.build());
            }
            
            opmode.telemetry.addLine("Routine loaded successfully.");
            opmode.telemetry.addData("PathChains", pathDir.size());
            
        } catch (IOException e) {
            opmode.telemetry.addLine("ERROR: Failed to read file");
            opmode.telemetry.addData("IOException", e.getMessage());
            e.printStackTrace();
        } catch (JSONException e) {
            opmode.telemetry.addLine("ERROR: Invalid JSON format");
            opmode.telemetry.addData("JSONException", e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            opmode.telemetry.addLine("ERROR: Unexpected error during parsing");
            opmode.telemetry.addData("Exception", e.getClass().getSimpleName() + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Ensure resources are properly closed
            try {
                if (reader != null) {
                    reader.close();
                }
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException e) {
                // Ignore close exceptions
            }
        }

        if (pathDir == null || pathDir.size() == 0) {
            opmode.telemetry.addLine("WARNING: No paths loaded");
        }
    }

    public void Write() {
        System.out.println("Number of PathChains: " + pathDir.size());
        for (int chainNumber = 1; chainNumber <= pathDir.size(); chainNumber++) {
            PathChain currentChain = pathDir.get(chainNumber - 1);
            System.out.println("  PathChain " + chainNumber + ":");
            System.out.println("    Number of Paths: " + currentChain.size());
        }
    }
    public void Reset() {
        pathState = 0;
        pathTimer = new Timer();
        isComplete = false;
    }

    public void Update() {
        if(!follower.isBusy() && !isComplete) {
            follower.followPath(pathDir.get(pathState));
            pathTimer.resetTimer();
            pathState++;
            if (pathState > pathDir.size()) {
                isComplete = true;
            }
        }
    }

    public boolean isComplete() {
        return isComplete;
    }
}