# 🔐 GitHub Secrets Setup Guide

## Navigate to GitHub Secrets

1. Go to your repository: https://github.com/pedrojson/PedroJSON
2. Click **Settings** (tab at the top)
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret** for each secret below

## Required Secrets

### 1. OSSRH_USERNAME
- **Name:** `OSSRH_USERNAME`
- **Value:** Your Sonatype username (from Step 1)

### 2. OSSRH_PASSWORD
- **Name:** `OSSRH_PASSWORD`  
- **Value:** Your Sonatype password (from Step 1)

### 3. SIGNING_KEY
- **Name:** `SIGNING_KEY`
- **Value:** The complete contents of your `signing-key.asc` file (from Step 2)
- **Important:** Copy the ENTIRE file including the header and footer:
```
-----BEGIN PGP PRIVATE KEY BLOCK-----

lQdGBGF... (lots of characters)
...XYZ
-----END PGP PRIVATE KEY BLOCK-----
```

### 4. SIGNING_PASSWORD
- **Name:** `SIGNING_PASSWORD`
- **Value:** The passphrase you used when creating your GPG key

## Verification Commands

After setting up secrets, test them locally:

```bash
# Test if environment variables work
$env:OSSRH_USERNAME="your_username"
$env:OSSRH_PASSWORD="your_password"
$env:SIGNING_KEY="your_key_content"
$env:SIGNING_PASSWORD="your_passphrase"

# Test Maven Central publishing (dry run)
.\gradlew.bat :loader:publishMavenPublicationToOSSRHRepository --dry-run
```

## Security Best Practices

✅ **Do:**
- Use repository secrets (not environment secrets)
- Keep your signing-key.asc file secure locally
- Use a strong passphrase for your GPG key
- Regularly rotate your Sonatype password

❌ **Don't:**
- Commit signing keys to Git
- Share your GPG private key
- Use weak passphrases
- Store secrets in plain text files

## Troubleshooting

**Issue:** "GPG signing failed"
**Solution:** Verify SIGNING_KEY includes complete header/footer

**Issue:** "Authentication failed to OSSRH"
**Solution:** Double-check OSSRH_USERNAME and OSSRH_PASSWORD

**Issue:** "Repository not found"
**Solution:** Make sure Sonatype has approved your group ID request
