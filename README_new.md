# PedroJSON

A JSON-based path loading library for Pedro Pathing, allowing you to define and load robot paths from JSON files.

## Features

- Load Pedro Pathing paths from JSON files
- Support for BezierLine and BezierCurve path segments
- Easy integration with FTC robot projects
- Callback system for path execution events

## Installation

### Maven Central

Add this dependency to your `build.gradle` file:

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

### GitHub Packages

Add the repository and dependency to your `build.gradle` file:

```gradle
repositories {
    maven {
        name = "GitHubPackages"
        url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
        credentials {
            username = "your_github_username"
            password = "your_github_token"
        }
    }
}

dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

## Usage

### Basic Path Loading

```java
import PedroJSON.main.PathLoader;
import com.pedropathing.pathgen.PathChain;

// Load a path from JSON file
PathLoader loader = new PathLoader();
PathChain pathChain = loader.loadPath("path/to/your/path.json");
```

### With Callbacks

```java
import PedroJSON.main.PathLoader;
import PedroJSON.main.Callbacks;

PathLoader loader = new PathLoader();
Callbacks callbacks = new Callbacks() {
    @Override
    public void onPathStart() {
        // Called when path execution starts
    }
    
    @Override
    public void onPathComplete() {
        // Called when path execution completes
    }
};

PathChain pathChain = loader.loadPathWithCallbacks("path/to/your/path.json", callbacks);
```

## JSON Path Format

Define your paths in JSON format with the following structure:

```json
{
    "paths": [
        {
            "type": "BezierLine",
            "startPoint": {"x": 0, "y": 0},
            "endPoint": {"x": 24, "y": 24}
        },
        {
            "type": "BezierCurve",
            "startPoint": {"x": 24, "y": 24},
            "controlPoint1": {"x": 36, "y": 24},
            "controlPoint2": {"x": 36, "y": 48},
            "endPoint": {"x": 48, "y": 48}
        }
    ]
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
