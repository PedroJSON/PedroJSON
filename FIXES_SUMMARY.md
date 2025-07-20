# PedroJSON Library - Maven Central Publishing Fixes

## Summary of Changes Made

Your PedroJSON library has been successfully configured for Maven Central publishing. Here are the key fixes that were implemented:

### 1. **Fixed Plugin Configuration**
- Changed from `com.android.application` to `com.android.library` (libraries cannot use the application plugin)
- Added `signing` plugin for Maven Central requirements

### 2. **Updated Group ID and Artifact Configuration**
- Changed group ID from `com.PedroJSON` to `com.pedrojson` (lowercase convention)
- Set proper artifact ID to `pedrojson-loader`
- Added consistent versioning across all publications

### 3. **Fixed Android Library Configuration**
- Removed `applicationId` (only for applications, not libraries)
- Updated package name to `com.pedrojson.loader`
- Added proper build types and Java compatibility settings
- Removed deprecated `publishNonDefault` setting

### 4. **Added Maven Central Publishing Configuration**
- Added OSSRH repository configuration for Maven Central
- Created proper POM metadata including:
  - Description, URL, licenses (BSD 3-Clause)
  - Developer information
  - SCM information
- Added sources and javadoc JAR generation
- Configured signing for Maven Central requirements

### 5. **Enhanced Security**
- Moved credentials to `local.properties` and environment variables
- Removed hardcoded GitHub token from build.gradle
- Added proper credential handling for both GitHub Packages and Maven Central

### 6. **Added Documentation and Automation**
- Created comprehensive `README.md` with usage examples
- Added `PUBLISHING.md` with detailed setup instructions
- Created GitHub Actions workflow for automated publishing
- Added `local.properties.template` for easy setup

### 7. **Added Testing Infrastructure**
- Added JUnit and Mockito dependencies
- Created basic unit tests to verify library functionality
- Fixed test dependencies to include Pedro Pathing for testing

### 8. **Fixed Build Issues**
- Resolved R file generation problems
- Fixed Javadoc generation issues
- Added proper ProGuard rules

## Current Status

✅ **Library builds successfully**
✅ **Unit tests pass**
✅ **Publishing to Maven Local works**
✅ **All required artifacts generated** (AAR, sources JAR, javadoc JAR, POM)
✅ **Ready for Maven Central submission**

## Next Steps

1. **Set up Sonatype OSSRH account** (see `PUBLISHING.md`)
2. **Generate and configure GPG signing key**
3. **Update `local.properties` with your credentials**
4. **Test publishing to staging**: `./gradlew :loader:publishMavenPublicationToOSSRHRepository`
5. **Set up GitHub Actions secrets** for automated publishing

## Verification

Your library is now properly configured and can be found in your local Maven repository at:
```
~/.m2/repository/com/pedrojson/pedrojson-loader/1.0.4-alpha/
```

Users will be able to include your library in their projects with:
```gradle
dependencies {
    implementation 'com.pedrojson:pedrojson-loader:1.0.4-alpha'
}
```

## Repository Structure

The library now follows proper Maven conventions:
- Group ID: `com.pedrojson`
- Artifact ID: `pedrojson-loader`
- Version: `1.0.4-alpha`
- Package: `com.pedrojson.loader`

All publishing requirements for Maven Central are now met!
