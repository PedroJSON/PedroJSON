# 🎯 COMPLETE WALKTHROUGH: Maven Central Setup

## 📋 Overview

Here's the complete step-by-step process to set up Maven Central publishing so users don't need GitHub credentials.

---

## 🌐 STEP 1: Sonatype OSSRH Account (5-10 minutes)

### What You Need To Do:

1. **Go to:** https://issues.sonatype.org/
2. **Create an account** (free)
3. **Click "Create" → "Create Issue"**
4. **Fill out the form:**

```
Project: Community Support - Open Source Project Repository Hosting (OSSRH)
Issue Type: New Project
Summary: Request publishing rights for io.github.pedrojson
Group Id: io.github.pedrojson
Project URL: https://github.com/pedrojson/PedroJSON
SCM URL: https://github.com/pedrojson/PedroJSON.git
Username(s): [your sonatype username]
Already Synced to Central: No
```

### Why `io.github.pedrojson`?
- Automatically verified since you own the GitHub repo
- No domain verification needed
- Faster approval process

### What Happens Next:
- Sonatype reviews your request (1-2 business days)
- They may ask questions in the ticket
- Once approved, you can publish to Maven Central

---

## 🔐 STEP 2: GPG Signing Keys (10-15 minutes)

### 2.1 Install GPG

**Windows:**
- Download from: https://www.gnupg.org/download/
- Or with Chocolatey: `choco install gnupg`

### 2.2 Generate Your Key

```bash
gpg --full-generate-key
```

**Choose these options:**
- Key type: `RSA and RSA` (default)
- Key size: `4096` bits (recommended)
- Expiration: `0` (never expires) or set your preference
- Real name: `PedroJSON Team` (or your name)
- Email: `aksandvick@icloud.com` (must match build.gradle)
- Passphrase: **Choose a strong one - you'll need it later!**

### 2.3 Find Your Key ID

```bash
gpg --list-secret-keys --keyid-format LONG
```

Look for output like:
```
sec   rsa4096/ABCD1234EFGH5678 2025-07-20
```
Your Key ID is: `ABCD1234EFGH5678`

### 2.4 Upload Public Key

```bash
gpg --keyserver hkp://keyserver.ubuntu.com --send-keys ABCD1234EFGH5678
```

### 2.5 Export Private Key for GitHub

```bash
gpg --export-secret-keys --armor ABCD1234EFGH5678 > signing-key.asc
```

**⚠️ IMPORTANT:** Keep `signing-key.asc` secure - it's your private key!

---

## 🏠 STEP 3: Local Development Setup (2 minutes)

### Create/Edit `~/.gradle/gradle.properties`

**Location:** `C:\Users\[your-username]\.gradle\gradle.properties`

**Add this content:**
```properties
# Maven Central Publishing
ossrhUsername=your_sonatype_username
ossrhPassword=your_sonatype_password

# GPG Signing
signing.keyId=ABCD1234EFGH5678
signing.password=your_gpg_key_passphrase
signing.secretKeyRingFile=C:/Users/[username]/.gnupg/secring.gpg

# GitHub Packages (existing)
gpr.user=your_github_username
gpr.key=your_github_token
```

**Replace:**
- `your_sonatype_username` → Your Sonatype username
- `your_sonatype_password` → Your Sonatype password  
- `ABCD1234EFGH5678` → Your actual GPG Key ID
- `your_gpg_key_passphrase` → Your GPG key passphrase

**Quick Setup Script:** Run `.\setup-local-gradle.bat` for guided setup.

---

## 🔐 STEP 4: GitHub Secrets (5 minutes)

### Navigate to Secrets:
1. Go to: https://github.com/pedrojson/PedroJSON
2. Click **Settings** tab
3. **Secrets and variables** → **Actions**
4. **New repository secret**

### Add These 4 Secrets:

#### Secret 1: OSSRH_USERNAME
- **Name:** `OSSRH_USERNAME`
- **Value:** Your Sonatype username

#### Secret 2: OSSRH_PASSWORD
- **Name:** `OSSRH_PASSWORD`
- **Value:** Your Sonatype password

#### Secret 3: SIGNING_KEY
- **Name:** `SIGNING_KEY`
- **Value:** Complete contents of `signing-key.asc` file
- **Format:** Include the full header and footer:
```
-----BEGIN PGP PRIVATE KEY BLOCK-----

[lots of characters here]

-----END PGP PRIVATE KEY BLOCK-----
```

#### Secret 4: SIGNING_PASSWORD
- **Name:** `SIGNING_PASSWORD`
- **Value:** Your GPG key passphrase

---

## 🧪 STEP 5: Test Your Setup (5 minutes)

### Test Local Publishing

```bash
# Test GitHub Packages (should work)
.\gradlew.bat :loader:publishGprPublicationToGitHubPackagesRepository --dry-run

# Test Maven Central (requires Sonatype approval)
.\gradlew.bat :loader:publishMavenPublicationToOSSRHRepository --dry-run
```

### Test Build
```bash
.\gradlew.bat :loader:assembleRelease
```

**Expected Output:**
- ✅ Build successful
- ✅ GitHub Packages ready
- ⚠️ Maven Central pending (until Sonatype approval)

---

## 🚀 STEP 6: First Release (After Approval)

### Once Sonatype Approves:

1. **Create a GitHub release:**
   - Tag: `v1.0.5`
   - Title: `Release 1.0.5`
   - Description: Your release notes

2. **GitHub Actions automatically:**
   - Builds the library
   - Signs with your GPG key
   - Publishes to GitHub Packages
   - Publishes to Maven Central

3. **Within 15-30 minutes:**
   - Library appears on Maven Central
   - Users can add it without credentials!

---

## 🎉 SUCCESS! User Experience

### Before (Required Credentials):
```gradle
repositories {
    maven {
        url = uri("https://maven.pkg.github.com/pedrojson/PedroJSON")
        credentials {
            username = "user_github_username"    // ❌ Required
            password = "user_github_token"       // ❌ Required
        }
    }
}
dependencies {
    implementation 'io.github.pedrojson:pedrojson-loader:1.0.5'
}
```

### After (Zero Setup):
```gradle
dependencies {
    implementation 'io.github.pedrojson:pedrojson-loader:1.0.5'
}
```

**That's it!** No repositories, no credentials, no setup required for users! 🚀

---

## 📋 Checklist

### Setup Checklist:
- [ ] Sonatype OSSRH account created
- [ ] New Project ticket submitted
- [ ] GPG key generated and uploaded
- [ ] Local gradle.properties configured
- [ ] GitHub Secrets added (4 secrets)
- [ ] Test builds pass locally

### Ready to Publish:
- [ ] Sonatype ticket approved
- [ ] All tests pass
- [ ] Create GitHub release
- [ ] Verify automatic publishing works

### User Experience Achieved:
- [ ] Users can add dependency without credentials
- [ ] Library available on Maven Central
- [ ] Simple one-line installation
- [ ] Professional distribution platform

---

## 🆘 Getting Help

**Sonatype Issues:** Check your OSSRH ticket for updates
**GPG Problems:** Run `gpg --help` or check GPG documentation
**GitHub Actions:** Check the Actions tab for build logs
**General Questions:** See SETUP_MAVEN_CENTRAL.md for detailed guides

---

## 🎯 Expected Timeline

- **Immediate:** Local setup complete
- **1-2 days:** Sonatype approval
- **First release:** Maven Central publishing active
- **Forever:** Users enjoy zero-setup installation! 🎉
