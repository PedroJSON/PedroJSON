#!/bin/bash

# Test script to verify GPG setup for Maven Central publishing
# Run this script to test your GPG configuration locally

echo "🔍 Testing GPG setup for Maven Central publishing..."
echo

# Check if GPG is installed
if command -v gpg >/dev/null 2>&1; then
    echo "✅ GPG is installed: $(gpg --version | head -1)"
else
    echo "❌ GPG is not installed"
    exit 1
fi

# Check environment variables
echo
echo "🔑 Environment variables:"
if [ -n "$SIGNING_KEY" ]; then
    echo "  SIGNING_KEY: SET (${#SIGNING_KEY} characters)"
    
    # Test if it's base64 encoded
    if echo "$SIGNING_KEY" | base64 -d >/dev/null 2>&1; then
        echo "    Format: Likely base64 encoded"
        if echo "$SIGNING_KEY" | base64 -d | grep -q "BEGIN PGP PRIVATE KEY BLOCK"; then
            echo "    Content: ✅ Contains GPG private key block"
        else
            echo "    Content: ❌ Does not contain GPG private key block"
        fi
    elif echo "$SIGNING_KEY" | grep -q "BEGIN PGP PRIVATE KEY BLOCK"; then
        echo "    Format: ✅ ASCII armored"
    else
        echo "    Format: ❌ Unknown format"
    fi
else
    echo "  SIGNING_KEY: ❌ NOT SET"
fi

if [ -n "$SIGNING_PASSWORD" ]; then
    echo "  SIGNING_PASSWORD: ✅ SET"
else
    echo "  SIGNING_PASSWORD: ❌ NOT SET"
fi

if [ -n "$CENTRAL_PORTAL_USERNAME" ]; then
    echo "  CENTRAL_PORTAL_USERNAME: ✅ SET ($CENTRAL_PORTAL_USERNAME)"
else
    echo "  CENTRAL_PORTAL_USERNAME: ❌ NOT SET"
fi

if [ -n "$CENTRAL_PORTAL_PASSWORD" ]; then
    echo "  CENTRAL_PORTAL_PASSWORD: ✅ SET"
else
    echo "  CENTRAL_PORTAL_PASSWORD: ❌ NOT SET"
fi

# Test GPG import (if key is provided)
if [ -n "$SIGNING_KEY" ] && [ -n "$SIGNING_PASSWORD" ]; then
    echo
    echo "🧪 Testing GPG key import..."
    
    # Create a temporary GPG home
    TEMP_GPG_HOME=$(mktemp -d)
    export GNUPGHOME="$TEMP_GPG_HOME"
    
    # Try to import the key
    if echo "$SIGNING_KEY" | grep -q "BEGIN PGP PRIVATE KEY BLOCK"; then
        # ASCII armored
        echo "$SIGNING_KEY" | gpg --batch --import
    else
        # Assume base64 encoded
        echo "$SIGNING_KEY" | base64 -d | gpg --batch --import
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ GPG key imported successfully"
        
        # List imported keys
        echo "📋 Imported keys:"
        gpg --list-secret-keys --keyid-format=short
        
        # Test signing
        echo "🧪 Testing signing capability..."
        echo "test" | gpg --batch --yes --passphrase="$SIGNING_PASSWORD" --pinentry-mode loopback --armor --detach-sign
        
        if [ $? -eq 0 ]; then
            echo "✅ GPG signing test successful"
        else
            echo "❌ GPG signing test failed"
        fi
    else
        echo "❌ GPG key import failed"
    fi
    
    # Cleanup
    rm -rf "$TEMP_GPG_HOME"
fi

echo
echo "📝 To fix GPG issues:"
echo "1. Make sure your SIGNING_KEY is either:"
echo "   - ASCII armored (starts with -----BEGIN PGP PRIVATE KEY BLOCK-----)"
echo "   - Base64 encoded ASCII armored key"
echo "2. Set SIGNING_PASSWORD to your GPG key passphrase"
echo "3. Set CENTRAL_PORTAL_USERNAME to your Sonatype Central Portal username"
echo "4. Set CENTRAL_PORTAL_PASSWORD to your Sonatype Central Portal password"
echo
echo "To export your GPG key:"
echo "  gpg --armor --export-secret-keys YOUR_KEY_ID"
echo "To base64 encode it:"
echo "  gpg --armor --export-secret-keys YOUR_KEY_ID | base64 -w 0"