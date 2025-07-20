# Maven Central Publishing Setup Guide

This guide will help you publish your PedroJSON library to Maven Central.

## Prerequisites

### 1. Create Sonatype OSSRH Account
1. Go to https://issues.sonatype.org/
2. Create a Jira account
3. Create a new issue with the following details:
   - Project: Community Support - Open Source Project Repository Hosting (OSSRH)
   - Issue Type: New Project
   - Group Id: com.pedrojson
   - Project URL: https://github.com/pedrojson/PedroJSON
   - SCM URL: https://github.com/pedrojson/PedroJSON.git

### 2. Generate GPG Key for Signing
1. Install GPG if you haven't already
2. Generate a new key:
   ```bash
   gpg --gen-key
   ```
3. List your keys and note the key ID:
   ```bash
   gpg --list-secret-keys --keyid-format LONG
   ```
4. Export your public key:
   ```bash
   gpg --armor --export YOUR_KEY_ID
   ```
5. Upload your public key to a keyserver:
   ```bash
   gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID
   ```

### 3. Configure Local Properties
Create or update your `local.properties` file with your credentials:

```properties
# Android SDK location
sdk.dir=C:\\Users\\YourUsername\\AppData\\Local\\Android\\Sdk

# Maven Central (OSSRH) credentials
ossrhUsername=your_sonatype_username
ossrhPassword=your_sonatype_password

# GitHub Packages credentials (optional)
gpr.user=your_github_username
gpr.key=your_github_personal_access_token

# GPG signing configuration
signing.keyId=YOUR_KEY_ID
signing.password=your_gpg_key_password
signing.secretKeyRingFile=C:\\Users\\YourUsername\\.gnupg\\secring.gpg
```

## Publishing Commands

### 1. Test Build
```bash
./gradlew :loader:assembleRelease
```

### 2. Publish to Local Maven Repository (for testing)
```bash
./gradlew :loader:publishToMavenLocal
```

### 3. Publish to Maven Central Staging
```bash
./gradlew :loader:publishMavenPublicationToOSSRHRepository
```

### 4. Publish to GitHub Packages
```bash
./gradlew :loader:publishGprPublicationToGitHubPackagesRepository
```

## GitHub Actions Setup

The repository includes a GitHub Actions workflow for automated publishing. To use it:

1. Go to your GitHub repository settings
2. Navigate to Secrets and variables > Actions
3. Add the following secrets:
   - `OSSRH_USERNAME`: Your Sonatype username
   - `OSSRH_PASSWORD`: Your Sonatype password
   - `SIGNING_KEY_ID`: Your GPG key ID
   - `SIGNING_PASSWORD`: Your GPG key password
   - `SIGNING_SECRET_KEY_RING_FILE`: Base64 encoded content of your secring.gpg file

To get the base64 encoded key file:
```bash
base64 -w 0 ~/.gnupg/secring.gpg
```

## Release Process

1. Update the version in `build.gradle`
2. Commit and push changes
3. Create a new release on GitHub
4. The GitHub Actions workflow will automatically publish to Maven Central

## Verification

After publishing, verify your library:

1. Check staging repository at https://s01.oss.sonatype.org/
2. Search for your artifact at https://search.maven.org/
3. Test importing the library in a new project

## Troubleshooting

### Common Issues

1. **"Repository not found"**: Make sure your Sonatype ticket is approved and your group ID is verified
2. **Signing errors**: Verify your GPG key is properly configured and uploaded to keyservers
3. **Build failures**: Check that all dependencies are available and Android SDK is properly configured

### Testing Locally

You can test your library locally before publishing:

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

After running `publishToMavenLocal`, this dependency should resolve from your local Maven repository.
