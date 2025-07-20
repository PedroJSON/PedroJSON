# Maven Central Publishing - Step by Step Guide

## Current Status ✅
Your library is **ready for Maven Central publishing**! All technical requirements are met:
- ✅ Proper library configuration
- ✅ Required metadata (POM with description, licenses, developers, SCM)
- ✅ Sources JAR generation
- ✅ Javadoc JAR generation
- ✅ Signing configuration (when credentials are provided)
- ✅ Correct group ID and artifact naming

## What You Need to Do

### 1. Create Sonatype OSSRH Account (5-10 minutes)

1. Go to https://issues.sonatype.org/
2. Click "Sign up" and create an account
3. Create a new issue:
   - Project: **Community Support - Open Source Project Repository Hosting (OSSRH)**
   - Issue Type: **New Project**
   - Group Id: **com.pedrojson**
   - Project URL: **https://github.com/pedrojson/PedroJSON**
   - SCM URL: **https://github.com/pedrojson/PedroJSON.git**
   - Username: **your_username**

4. Wait for approval (usually 1-2 business days)

### 2. Set Up GPG Signing (10 minutes)

Run the included setup script:
```batch
setup-gpg.bat
```

Or manually:
```bash
# Install GPG for Windows
# Download from: https://www.gnupg.org/download/

# Generate key
gpg --gen-key

# List keys to get ID
gpg --list-secret-keys --keyid-format LONG

# Upload to keyserver
gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID
```

### 3. Update Credentials (2 minutes)

Edit `local.properties` and uncomment/fill in:
```properties
ossrhUsername=your_sonatype_username
ossrhPassword=your_sonatype_password
signing.keyId=your_gpg_key_id
signing.password=your_gpg_key_password
signing.secretKeyRingFile=C:\\Users\\aksan\\.gnupg\\secring.gpg
```

### 4. Publish to Maven Central (1 command)

```bash
./gradlew :loader:publishMavenPublicationToOSSRHRepository
```

### 5. Release on Sonatype (2 minutes)

1. Go to https://s01.oss.sonatype.org/
2. Log in with your OSSRH credentials
3. Go to "Staging Repositories"
4. Find your repository and click "Close"
5. After validation, click "Release"

## Alternative: GitHub Packages (Immediate)

If you want to publish immediately while waiting for Maven Central approval:

1. Update `local.properties`:
```properties
gpr.user=your_github_username
gpr.key=your_github_personal_access_token
```

2. Publish:
```bash
./gradlew :loader:publishGprPublicationToGitHubPackagesRepository
```

Users can then access it with:
```gradle
repositories {
    maven {
        url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
        credentials {
            username = "github_username"
            password = "github_token"
        }
    }
}

dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

## Automated Publishing

GitHub Actions workflow is already set up! Just add these secrets to your repo:
- `OSSRH_USERNAME`
- `OSSRH_PASSWORD` 
- `SIGNING_KEY_ID`
- `SIGNING_PASSWORD`
- `SIGNING_SECRET_KEY_RING_FILE`

Then publishing happens automatically on releases.

## Your Library Info

**Group ID:** `com.pedrojson`  
**Artifact ID:** `pedrojson-loader`  
**Version:** `1.0.4-alpha`

**Usage after publishing:**
```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```
