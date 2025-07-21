# 📦 Maven Central Publishing Setup

## For Library Users (No Credentials Required!)

🎉 **Good news!** Users can now add PedroJSON to their projects without any GitHub credentials:

```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

That's it! Maven Central is included by default in all Gradle/Maven projects.

## For Library Maintainers

### Dual Publishing Strategy

This library is configured to publish to **both** repositories:

1. **Maven Central** - Public, no authentication required for users
2. **GitHub Packages** - Private, requires authentication for users

### Maven Central Setup

To publish to Maven Central, you need:

#### 1. Sonatype OSSRH Account
1. Create account at: https://issues.sonatype.org/
2. Request a new project following: https://central.sonatype.org/publish/publish-guide/
3. Your group ID (`com.pedrojson`) must be verified

#### 2. GPG Signing Key
```bash
# Generate key
gpg --gen-key

# Export for CI/CD
gpg --export-secret-keys --armor KEY_ID > signing-key.asc
```

#### 3. Credentials Configuration

Add to `~/.gradle/gradle.properties`:
```properties
# Maven Central
ossrhUsername=your_sonatype_username
ossrhPassword=your_sonatype_password

# GPG Signing
signing.keyId=YOUR_KEY_ID
signing.password=your_key_passphrase
signing.secretKeyRingFile=/path/to/secring.gpg

# Or use ASCII armored key for CI/CD
signingKey=-----BEGIN PGP PRIVATE KEY BLOCK-----...
signingPassword=your_key_passphrase
```

#### 4. Environment Variables (for CI/CD)
```yaml
OSSRH_USERNAME: your_sonatype_username
OSSRH_PASSWORD: your_sonatype_password
SIGNING_KEY: |
  -----BEGIN PGP PRIVATE KEY BLOCK-----
  ...your full ASCII armored private key...
  -----END PGP PRIVATE KEY BLOCK-----
SIGNING_PASSWORD: your_key_passphrase
```

### Publishing Commands

```bash
# Publish to GitHub Packages only
./gradlew publishGprPublicationToGitHubPackagesRepository

# Publish to Maven Central only
./gradlew publishMavenPublicationToOSSRHRepository

# Publish to both repositories
./gradlew publish
```

### Release Process

1. **Create a release on GitHub** with a version tag (e.g., `v1.0.5`)
2. **GitHub Actions automatically publishes** to both repositories
3. **Maven Central sync** takes 15-30 minutes to appear in search
4. **Users can immediately use** the new version without any setup

### Verification

Check if your library is available:

- **Maven Central Search**: https://search.maven.org/search?q=com.pedrojson
- **GitHub Packages**: https://github.com/pedrojson/PedroJSON/packages

### Benefits

✅ **For Users:**
- No authentication required
- Works with any Gradle/Maven project
- Fast, reliable CDN
- Automatic dependency resolution

✅ **For Maintainers:**
- Dual publishing strategy
- Automated releases via GitHub Actions
- Professional distribution platform
- Better discoverability

### Troubleshooting

**Issue**: "Could not find com.pedrojson:pedrojson-loader"
**Solution**: Version might not be synced yet, or check version number

**Issue**: "Authentication failed" 
**Solution**: This shouldn't happen with Maven Central! Check if you're using GitHub Packages by mistake

**Issue**: Maven Central publishing fails
**Solution**: Verify Sonatype credentials and GPG signing setup
