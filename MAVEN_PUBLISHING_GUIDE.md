# Maven Central Publishing Issues & Solutions

## Summary of Problems Found

Your Maven Central publishing workflow was failing due to several GPG signing and configuration issues. Here's what I found and fixed:

## 🔍 **Issues Identified**

### 1. **GPG Key Format Detection Problem**
- **Issue**: The original code checked for base64 encoding with `signingKeyAscii.startsWith('LS0t')`, but this is incorrect
- **Problem**: `LS0t` is only the base64 encoding of `---`, not the full GPG key header
- **Fix**: Implemented proper base64 detection using regex pattern and content validation

### 2. **Missing Error Handling**
- **Issue**: GPG signing failures were silent, making debugging difficult
- **Fix**: Added comprehensive error handling and debugging output

### 3. **Bundle Upload Verification**
- **Issue**: No verification that required files (signatures, artifacts) were present in the bundle
- **Fix**: Added validation to ensure all required files and signatures are present before upload

### 4. **Build Configuration Issues**
- **Issue**: Plugin block placement was incorrect
- **Fix**: Converted to modern Gradle plugins block syntax

## 🛠️ **Fixes Applied**

### 1. **Updated GPG Signing Configuration** (`loader/build.gradle`)

```gradle
signing {
    required { gradle.taskGraph.hasTask("publishToCentralPortal") || 
               gradle.taskGraph.hasTask("publishMavenPublicationToCentralPortalRepository") }
    
    if (signingKeyAscii && signingPasswordEnv) {
        // Proper base64 detection and decoding
        if (signingKeyAscii.matches("^[A-Za-z0-9+/]*={0,2}\$") && signingKeyAscii.length() > 100) {
            def decodedKey = new String(Base64.getDecoder().decode(signingKeyAscii))
            if (decodedKey.contains("BEGIN PGP PRIVATE KEY BLOCK")) {
                useInMemoryPgpKeys(decodedKey, signingPasswordEnv)
            }
        } else if (signingKeyAscii.contains("BEGIN PGP PRIVATE KEY BLOCK")) {
            useInMemoryPgpKeys(signingKeyAscii, signingPasswordEnv)
        }
    }
}
```

### 2. **Enhanced Bundle Creation & Upload**

- Added bundle content verification
- Added required file checks (`.pom`, `.jar`, `.aar` and their `.asc` signatures)
- Improved error reporting and debugging output
- Better HTTP request handling

### 3. **Improved GitHub Actions Workflow**

- Added GPG key format verification
- Enhanced debugging output
- Added key content preview for troubleshooting

## 🔧 **Required GitHub Secrets**

Make sure these secrets are set in your repository:

| Secret Name | Description | Format |
|-------------|-------------|---------|
| `SIGNING_KEY` | GPG private key | ASCII armored or base64 encoded |
| `SIGNING_PASSWORD` | GPG key passphrase | Plain text |
| `CENTRAL_PORTAL_USERNAME` | Sonatype Central Portal username | Plain text |
| `CENTRAL_PORTAL_PASSWORD` | Sonatype Central Portal password | Plain text |

## 📋 **Testing Your Setup**

### Local Testing (Windows)
```powershell
# Set environment variables for testing
$env:SIGNING_KEY = "your-gpg-key-here"
$env:SIGNING_PASSWORD = "your-gpg-passphrase"
$env:CENTRAL_PORTAL_USERNAME = "your-username"
$env:CENTRAL_PORTAL_PASSWORD = "your-password"

# Run the test script
.\test-gpg-setup.ps1

# Test Gradle publishing locally
.\gradlew :loader:publishMavenPublicationToMavenLocal --info
```

### GitHub Actions Testing
1. Trigger the workflow manually with `workflow_dispatch`
2. Check the enhanced debug output in the logs
3. Look for the GPG key format verification messages

## 🔑 **GPG Key Setup Instructions**

### If you need to create a new GPG key:

1. **Generate a key**:
   ```bash
   gpg --full-generate-key
   ```

2. **Export the private key**:
   ```bash
   # Get your key ID
   gpg --list-secret-keys --keyid-format=short
   
   # Export ASCII armored
   gpg --armor --export-secret-keys YOUR_KEY_ID
   
   # Or export and base64 encode
   gpg --armor --export-secret-keys YOUR_KEY_ID | base64 -w 0
   ```

3. **Upload public key to keyservers**:
   ```bash
   gpg --send-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
   gpg --send-keys YOUR_KEY_ID --keyserver keys.openpgp.org
   ```

## 🚀 **Next Steps**

1. **Verify your GPG key is properly formatted** using the test script
2. **Update your GitHub repository secrets** with the correct values
3. **Test the workflow** by creating a new release or triggering manually
4. **Monitor the enhanced debug output** to identify any remaining issues

## ❓ **Troubleshooting Common Issues**

### "GPG key format not recognized"
- Ensure your `SIGNING_KEY` starts with `-----BEGIN PGP PRIVATE KEY BLOCK-----`
- If base64 encoded, verify it decodes to a valid GPG key

### "Missing required signatures"
- This means GPG signing failed silently
- Check your `SIGNING_PASSWORD` is correct
- Verify the GPG key format

### "Central Portal upload failed"
- Verify your `CENTRAL_PORTAL_USERNAME` and `CENTRAL_PORTAL_PASSWORD`
- Check if your Sonatype account has the necessary permissions
- Ensure your group ID (`io.github.andersans11`) matches your verified namespace

### "Bundle directory is empty"
- This indicates the publishing step failed before creating artifacts
- Check the Gradle build logs for compilation errors
- Verify all dependencies can be resolved

The fixes should resolve the silent failures and provide clear feedback about what's going wrong in your publishing process.