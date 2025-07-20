# GitHub Packages Publishing Guide

## Quick Setup (5 minutes)

Your library is already configured for GitHub Packages! You just need to set up credentials.

### 1. Create GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name like "PedroJSON Publishing"
4. Select scopes:
   - ✅ `write:packages` (to publish packages)
   - ✅ `read:packages` (to download packages)
   - ✅ `repo` (if the repository is private)
5. Click "Generate token"
6. **Copy the token** (you won't see it again!)

### 2. Update Local Credentials

Edit `local.properties` and add your credentials:

```properties
gpr.user=your_github_username
gpr.key=ghp_your_personal_access_token_here
```

### 3. Publish to GitHub Packages

```bash
./gradlew :loader:publishGprPublicationToGitHubPackagesRepository
```

That's it! Your library is now published to GitHub Packages.

## Using the Published Library

### For Library Users

Add this to your `build.gradle`:

```gradle
repositories {
    maven {
        name = "GitHubPackages"
        url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
        credentials {
            username = "your_github_username"
            password = "your_github_token" // needs read:packages permission
        }
    }
}

dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

### Automated Publishing

GitHub Actions is already set up! Publishing happens automatically when you:

1. **Create a release** on GitHub, or
2. **Manually trigger** the workflow from the Actions tab

No additional secrets needed - it uses the built-in `GITHUB_TOKEN`.

## Version Management

The library automatically uses the **release version** as the artifact version:

### Automatic Versioning (Recommended)

1. **Create a GitHub Release** with version tag (e.g., `v1.0.5` or `1.0.5`)
2. **GitHub Actions automatically publishes** with that version
3. **Users get the exact release version**

### Manual Versioning

For local publishing with a specific version:

```bash
# Windows
set RELEASE_VERSION=1.0.5-alpha
./gradlew :loader:publishGprPublicationToGitHubPackagesRepository

# Or use the helper script:
publish-version.bat 1.0.5-alpha
```

```bash
# Linux/Mac
export RELEASE_VERSION=1.0.5-alpha
./gradlew :loader:publishGprPublicationToGitHubPackagesRepository
```

### Version Detection Priority

1. **RELEASE_VERSION environment variable** (highest priority)
2. **Git tag on current commit** (if available)
3. **Default fallback version** `1.0.4-alpha` (lowest priority)

### Creating Releases

1. Go to your GitHub repository
2. Click "Releases" → "Create a new release"
3. Set tag version (e.g., `v1.0.5`, `1.0.5-alpha`, `2.0.0-beta`)
4. Publish release
5. GitHub Actions automatically publishes with that version!

## Verification

After publishing, you can verify your package at:
https://github.com/pedrojson/PedroJSON/packages

## Benefits of GitHub Packages

✅ **No approval process** - publish immediately  
✅ **No external accounts** - uses your existing GitHub account  
✅ **No signing required** - simpler setup  
✅ **Integrated with GitHub** - automatic CI/CD  
✅ **Private packages** - can publish private packages  

## Troubleshooting

### "Could not find artifact" error
- Make sure the user has a GitHub token with `read:packages` permission
- Verify the repository URL is correct
- Check that the package was published successfully

### "401 Unauthorized" when publishing
- Verify your GitHub username and token in `local.properties`
- Make sure your token has `write:packages` permission
- Check that you have push access to the repository

### Publishing from different machines
- Each developer needs their own GitHub token in their `local.properties`
- Or use environment variables: `GITHUB_ACTOR` and `GITHUB_TOKEN`

## Current Library Details

**Group ID:** `com.pedrojson`  
**Artifact ID:** `pedrojson-loader`  
**Current Version:** `1.0.4-alpha`  
**Repository:** https://github.com/pedrojson/PedroJSON  
**Packages:** https://github.com/pedrojson/PedroJSON/packages
