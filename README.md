# PedroJSON

A JSON-based path loading library for Pedro Pathing, allowing you to define and load robot paths from JSON files.

## 🚀 Quick Start (No Authentication Required!)

Add to your `build.dependencies.gradle`:

```gradle
dependencies {
    implementation 'io.github.andersans11:pedrojson-loader:1.0.4-alpha'
}
```

That's it! Start using PedroJSON immediately.

## Features

- Load Pedro Pathing paths from JSON files
- Support for BezierLine and BezierCurve path segments
- Easy integration with FTC robot projects
- Callback system for path execution events
- **Zero setup required** - works with any Gradle project

## Installation

### Maven Central (Recommended - No Authentication Required)

Simply add the dependency to your `build.gradle` file:

```gradle
dependencies {
    implementation 'io.github.andersans11:pedrojson-loader:1.0.4-alpha'
    // Or use the latest release version - check GitHub releases
}
```

**That's it!** No special repositories or authentication needed. Maven Central is included by default in all Gradle projects.

**Latest Versions:**
Check the [Releases page](https://github.com/pedrojson/PedroJSON/releases) for the latest version numbers.

### GitHub Packages (Alternative - Requires Authentication)

If you prefer to use GitHub Packages, add the repository and dependency to your `build.gradle` file:

```gradle
repositories {
    maven {
        name = "GitHubPackages"
        url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
        credentials {
            username = "your_github_username"
            password = "your_github_token" // Personal Access Token with read:packages permission
        }
    }
}

dependencies {
    implementation 'io.github.andersans11:pedrojson-loader:1.0.4-alpha'
    // Or use the latest release version - check GitHub releases
}
```

**Getting a GitHub Token:**
1. Go to [GitHub Settings > Personal Access Tokens](https://github.com/settings/tokens)
2. Create a token with `read:packages` permission
3. Use your GitHub username and the token as credentials

### Local Development

If you've cloned and built the project locally:

```bash
./gradlew :loader:publishToMavenLocal
```

Then use in your project:
```gradle
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
import PedroJSON.main.Callback;

PathLoader loader = new PathLoader();
Callbacks callback = new Callbacks() {
    @Override
    public void onPathStart() {
        // Called when path execution starts
    }
    
    @Override
    public void onPathComplete() {
        // Called when path execution completes
    }
};

PathChain pathChain = loader.loadPathWithCallbacks("path/to/your/path.json", callback);
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
