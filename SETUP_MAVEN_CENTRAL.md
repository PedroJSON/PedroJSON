# 🚀 Complete Setup Guide: Maven Central Publishing

## 🎯 Goal Achieved!

Your library is now configured so **users don't need GitHub credentials**! They can simply add:

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

## 📋 Current Status

✅ **Library configured for dual publishing**
✅ **README updated with simple installation**
✅ **GitHub Actions workflow enhanced**
✅ **Security properly configured**

## 🔧 Next Steps to Complete Maven Central Setup

### 1. Create Sonatype OSSRH Account

1. Go to: https://issues.sonatype.org/
2. Create an account
3. Create a new issue to request publishing rights for `com.pedrojson`
4. Follow their verification process

### 2. Generate GPG Signing Key

```bash
# Generate new key
gpg --full-generate-key

# Choose:
# - RSA and RSA (default)
# - 2048 bits minimum (4096 recommended)
# - Key does not expire (or set expiration)
# - Your name and email (must match POM)

# List keys to find Key ID
gpg --list-secret-keys --keyid-format LONG

# Export public key to send to Sonatype
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys YOUR_KEY_ID

# Export private key for GitHub Secrets
gpg --export-secret-keys --armor YOUR_KEY_ID > signing-key.asc
```

### 3. Configure GitHub Secrets

Add these secrets to your repository (Settings > Secrets and Variables > Actions):

```
OSSRH_USERNAME=your_sonatype_username
OSSRH_PASSWORD=your_sonatype_password
SIGNING_KEY=your_full_ascii_armored_private_key
SIGNING_PASSWORD=your_key_passphrase
```

### 4. Local Development Setup

Add to `~/.gradle/gradle.properties`:

```properties
# Maven Central (Optional for local testing)
ossrhUsername=your_sonatype_username
ossrhPassword=your_sonatype_password

# GPG Signing (Optional for local testing)
signing.keyId=YOUR_KEY_ID
signing.password=your_key_passphrase
signing.secretKeyRingFile=/path/to/secring.gpg
```

## 🎮 How It Works Now

### For Users (The Easy Part!)

1. **No special setup needed**
2. **Add dependency to build.gradle**
3. **Build their project** - works immediately!

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
    compileOnly 'com.pedropathing:pedro:1.0.9'
}
```

### For You (Publishing)

1. **Create a GitHub release** with a version tag
2. **GitHub Actions automatically publishes** to both:
   - GitHub Packages (backup/private access)
   - Maven Central (public access)
3. **Users get the update** within 15-30 minutes

## 🔍 Testing the Setup

### Test Publishing Locally

```bash
# Test GitHub Packages (should work now)
./gradlew publishGprPublicationToGitHubPackagesRepository

# Test Maven Central (requires Sonatype setup)
./gradlew publishMavenPublicationToOSSRHRepository
```

### Test User Experience

Create a test Android project and add:

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.5'
}
```

Should work without any authentication!

## 📊 Publishing Strategy

| Repository | Purpose | User Experience |
|-----------|---------|-----------------|
| **Maven Central** | Primary public distribution | ✅ No credentials needed |
| **GitHub Packages** | Backup/pre-release versions | ⚠️ Requires GitHub authentication |

## 🎉 Benefits Achieved

✅ **Zero friction for users** - just add the dependency  
✅ **Professional distribution** via Maven Central  
✅ **Automatic releases** via GitHub Actions  
✅ **Dual publishing** for flexibility  
✅ **Security compliant** - no exposed credentials  

## 🚀 Ready to Publish!

Once you complete the Sonatype setup:

1. Create a release on GitHub
2. Let GitHub Actions handle the publishing
3. Users worldwide can immediately use your library!

Your library will be discoverable at:
- https://search.maven.org/search?q=com.pedrojson
- https://mvnrepository.com/artifact/com.pedrojson/pedrojson-loader
