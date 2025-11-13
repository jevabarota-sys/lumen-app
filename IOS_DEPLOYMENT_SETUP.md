# iOS Automated Deployment Setup Guide

This guide will help you set up automated iOS builds and TestFlight uploads using GitHub Actions. No Mac required!

## Overview

The automated system uses:
- **GitHub Actions**: Free macOS runners for building iOS apps
- **Fastlane**: Automates code signing and App Store Connect uploads
- **Fastlane Match**: Manages certificates and provisioning profiles in a private GitHub repo
- **App Store Connect API**: Uploads builds without manual intervention

## Prerequisites

- ✅ Apple Developer Account (you have this)
- ✅ App created in App Store Connect (you have this)
- ✅ GitHub account with access to lumen-app repository (you have this)
- ⏳ App Store Connect API Key (we'll create this)
- ⏳ Private GitHub repository for certificates (we'll create this)

## Step 1: Create App Store Connect API Key

1. **Go to App Store Connect**
   - Visit: https://appstoreconnect.apple.com
   - Sign in with: jevabarota@gmail.com

2. **Navigate to API Keys**
   - Click your name in the top right
   - Select "Users and Access"
   - Click the "Keys" tab (under "Integrations")

3. **Generate New API Key**
   - Click the "+" button to create a new key
   - **Name**: "GitHub Actions iOS Deploy"
   - **Access**: Select "App Manager" role
   - Click "Generate"

4. **Download the API Key**
   - Click "Download API Key" (you can only download once!)
   - Save the file (it will be named something like `AuthKey_XXXXXXXXXX.p8`)
   - **IMPORTANT**: Keep this file safe! You'll need it for GitHub secrets

5. **Note the Key Information**
   Write down these three values (you'll need them later):
   - **Key ID**: 10-character string (shown in the table)
   - **Issuer ID**: UUID shown at the top of the Keys page
   - **Key File**: The .p8 file you downloaded

## Step 2: Create Private Repository for Certificates

Fastlane Match stores your certificates and provisioning profiles in a private Git repository.

1. **Create New Private Repository**
   - Go to: https://github.com/new
   - **Repository name**: `lumen-certificates`
   - **Description**: "iOS certificates and provisioning profiles for Lumen app"
   - **Visibility**: ⚠️ **PRIVATE** (very important!)
   - **Initialize**: Leave all checkboxes unchecked
   - Click "Create repository"

2. **Generate Personal Access Token**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - **Note**: "Fastlane Match Access"
   - **Expiration**: 90 days (or longer)
   - **Scopes**: Check only "repo" (full control of private repositories)
   - Click "Generate token"
   - **COPY THE TOKEN** - you won't see it again!

## Step 3: Initialize Fastlane Match

This step creates your certificates and provisioning profiles. You'll need to do this **once** from a Mac, or we can use a cloud Mac service.

### Option A: Using a Mac (Recommended)

If you can access a Mac temporarily (friend, library, etc.):

```bash
# Clone the repository
git clone https://github.com/jevabarota-sys/lumen-app.git
cd lumen-app/ios

# Install dependencies
gem install bundler
bundle install

# Initialize Match (this creates certificates)
bundle exec fastlane match appstore

# When prompted:
# - Git URL: https://github.com/jevabarota-sys/lumen-certificates
# - Username: jevabarota@gmail.com
# - Password: [Your GitHub Personal Access Token from Step 2]
# - Passphrase: Create a strong password (you'll need this for GitHub secrets)
```

### Option B: Using GitHub Codespaces (Alternative)

If you don't have Mac access, you can use GitHub Codespaces:

1. Go to: https://github.com/jevabarota-sys/lumen-app
2. Click "Code" → "Codespaces" → "Create codespace on main"
3. Wait for the environment to load
4. Run the same commands as Option A above

**Note**: Codespaces runs on Linux, so you'll need to use `fastlane match init` first, then manually create certificates in Apple Developer portal.

### Option C: Manual Certificate Creation (Most Complex)

If neither option works, you can manually create certificates in Apple Developer portal and add them to the Match repository. This is more complex and not recommended for first-time users.

## Step 4: Add Secrets to GitHub

Now we'll add all the necessary secrets to your GitHub repository.

1. **Go to Repository Settings**
   - Visit: https://github.com/jevabarota-sys/lumen-app/settings/secrets/actions
   - Click "New repository secret" for each secret below

2. **Add App Store Connect API Key Secrets**

   **Secret 1: APP_STORE_CONNECT_KEY_ID**
   - Value: The 10-character Key ID from Step 1
   - Example: `ABCD123456`

   **Secret 2: APP_STORE_CONNECT_ISSUER_ID**
   - Value: The Issuer ID (UUID) from Step 1
   - Example: `12345678-1234-1234-1234-123456789012`

   **Secret 3: APP_STORE_CONNECT_API_KEY**
   - Value: Base64-encoded contents of your .p8 file
   - To encode on Mac/Linux:
     ```bash
     base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
     ```
   - On Windows (PowerShell):
     ```powershell
     [Convert]::ToBase64String([IO.File]::ReadAllBytes("AuthKey_XXXXXXXXXX.p8")) | clip
     ```
   - Paste the base64 string as the secret value

3. **Add Match Secrets**

   **Secret 4: MATCH_PASSWORD**
   - Value: The passphrase you created when running `fastlane match` in Step 3
   - This encrypts your certificates in the Git repository

   **Secret 5: MATCH_GIT_BASIC_AUTHORIZATION**
   - Value: Base64-encoded GitHub credentials for Match repository access
   - Format: `base64("username:personal_access_token")`
   - To encode on Mac/Linux:
     ```bash
     echo -n "jevabarota@gmail.com:YOUR_GITHUB_TOKEN" | base64 | pbcopy
     ```
   - On Windows (PowerShell):
     ```powershell
     [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("jevabarota@gmail.com:YOUR_GITHUB_TOKEN")) | clip
     ```

4. **Add Supabase Secrets** (if not already added)

   **Secret 6: SUPABASE_URL**
   - Value: `https://slvwtiicaxkpvupbmbki.supabase.co`

   **Secret 7: SUPABASE_ANON_KEY**
   - Value: Your Supabase anon key

## Step 5: Trigger the Build

Once all secrets are added, you can trigger an iOS build:

### Manual Trigger (Recommended for First Build)

1. Go to: https://github.com/jevabarota-sys/lumen-app/actions
2. Click "iOS Deploy to TestFlight" workflow
3. Click "Run workflow" button
4. Select the branch (main or devin/1762372665-native-iap-implementation)
5. Click "Run workflow"

### Automatic Trigger

The workflow will automatically run when you push changes to:
- `main` or `master` branch
- Any files in `lib/`, `ios/`, or `pubspec.yaml`

## Step 6: Monitor the Build

1. **Watch the Build Progress**
   - Go to: https://github.com/jevabarota-sys/lumen-app/actions
   - Click on the running workflow
   - Watch each step complete (takes ~15-20 minutes)

2. **Check for Errors**
   - If any step fails, click on it to see the error details
   - Common issues:
     - **Certificate errors**: Check MATCH_PASSWORD and MATCH_GIT_BASIC_AUTHORIZATION
     - **API key errors**: Check APP_STORE_CONNECT_* secrets
     - **Build errors**: Check your code for iOS-specific issues

3. **Verify Upload to TestFlight**
   - After the build succeeds, go to: https://appstoreconnect.apple.com
   - Click on your app "Lumen: Personalized Growth"
   - Go to "TestFlight" tab
   - You should see a new build processing (takes 5-10 minutes)

## Step 7: Submit for Review

Once the build appears in TestFlight:

1. **Wait for Processing**
   - Apple processes the build (5-10 minutes)
   - You'll receive an email when it's ready

2. **Add Build to App Version**
   - Go to App Store Connect
   - Click "App Store" tab
   - Click on version "1.0"
   - Scroll to "Build" section
   - Click the "+" button and select your build

3. **Complete Remaining Sections**
   - Review all sections (should be mostly complete)
   - Add any missing information
   - Answer export compliance questions:
     - Uses encryption? **Yes** (HTTPS)
     - Exempt? **Yes** (standard HTTPS only)

4. **Submit for Review**
   - Click "Add for Review" button
   - Review the submission
   - Click "Submit to App Review"

## Troubleshooting

### Build Fails: "No matching provisioning profiles found"

**Solution**: Re-run `fastlane match appstore` to regenerate provisioning profiles.

### Build Fails: "Invalid API Key"

**Solution**: Check that APP_STORE_CONNECT_KEY_ID, ISSUER_ID, and API_KEY are correct. Make sure the API key is base64-encoded.

### Build Fails: "Authentication failed"

**Solution**: Check MATCH_GIT_BASIC_AUTHORIZATION is correctly base64-encoded with your GitHub username and personal access token.

### Build Succeeds but No Upload

**Solution**: Check App Store Connect for the build. It may take 5-10 minutes to appear. Check your email for any issues from Apple.

### "Certificate has expired"

**Solution**: Run `fastlane match appstore --force` to regenerate certificates.

## Next Steps After First Successful Build

1. **Test on TestFlight**
   - Add yourself as an internal tester
   - Install the app on your iPhone
   - Test the subscription flow
   - Verify all features work

2. **Replace Placeholder Screenshots**
   - Take real screenshots from the TestFlight build
   - Update them in App Store Connect
   - Make sure they accurately represent the app

3. **Monitor Review Status**
   - Apple typically reviews apps in 1-2 days
   - Respond quickly to any feedback
   - Be prepared to make changes if requested

4. **Plan for Updates**
   - Every time you push to main, a new build will be created
   - Increment the version number in pubspec.yaml for major updates
   - Build numbers are automatically incremented

## Support

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Review the Fastlane documentation: https://docs.fastlane.tools
3. Check Apple Developer forums: https://developer.apple.com/forums

## Security Notes

- ⚠️ **Never commit certificates or .p8 files to Git**
- ⚠️ **Keep your Match password secure**
- ⚠️ **The lumen-certificates repository must remain private**
- ⚠️ **Rotate your App Store Connect API key if compromised**
- ⚠️ **GitHub secrets are encrypted and only accessible to workflows**

---

**Congratulations!** Once you complete these steps, you'll have a fully automated iOS deployment pipeline that builds and uploads your app to TestFlight without requiring a Mac!
