# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the Book Finder App Flutter project.

## Available Workflows

### 1. `flutter-build.yml` - Main Build & Deploy
**Triggers:** Push to main/master, Pull requests, Releases
**Purpose:** Complete build pipeline with testing, building, and deployment

**Features:**
- ✅ Run tests and code analysis
- ✅ Build Android APK and App Bundle
- ✅ Build Web version
- ✅ Deploy to GitHub Pages
- ✅ Create releases with artifacts

### 2. `ci.yml` - Continuous Integration
**Triggers:** Push to main/master/develop, Pull requests
**Purpose:** Quick CI checks for every commit

**Features:**
- ✅ Lint and format checking
- ✅ Run tests with coverage
- ✅ Build verification for Android and Web
- ✅ Fast feedback for developers

### 3. `deploy-android.yml` - Android Play Store Deployment
**Triggers:** Releases, Manual dispatch
**Purpose:** Deploy Android app to Google Play Store

**Features:**
- ✅ Build release App Bundle
- ✅ Deploy to Google Play Console
- ✅ Support for staging and production environments

### 4. `deploy-firebase.yml` - Firebase Hosting Deployment
**Triggers:** Push to main/master, Manual dispatch
**Purpose:** Deploy web version to Firebase Hosting

**Features:**
- ✅ Build Flutter web app
- ✅ Deploy to Firebase Hosting
- ✅ Alternative to GitHub Pages

### 5. `code-quality.yml` - Code Quality Checks
**Triggers:** Push to main/master/develop, Pull requests
**Purpose:** Comprehensive code quality analysis

**Features:**
- ✅ Format checking
- ✅ Static analysis
- ✅ Test coverage reporting
- ✅ PR coverage comments

## Setup Instructions

### 1. Enable GitHub Pages (for web deployment)
1. Go to your repository Settings
2. Navigate to Pages section
3. Set source to "GitHub Actions"
4. The workflow will automatically deploy to `https://yourusername.github.io/book_finder_app`

### 2. Configure Secrets (Optional)

#### For Google Play Store Deployment:
```bash
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON
```
- Create a service account in Google Play Console
- Download the JSON key file
- Add the entire JSON content as a repository secret

#### For Firebase Hosting:
```bash
FIREBASE_SERVICE_ACCOUNT_BOOK_FINDER_APP
```
- Create a Firebase project
- Generate a service account key
- Add the JSON content as a repository secret

### 3. Repository Settings
- Enable GitHub Actions in repository settings
- Set branch protection rules for main/master branch
- Require status checks to pass before merging

## Workflow Triggers

| Workflow | Push | PR | Release | Manual |
|----------|------|----|---------| -------|
| flutter-build.yml | ✅ | ✅ | ✅ | ❌ |
| ci.yml | ✅ | ✅ | ❌ | ❌ |
| deploy-android.yml | ❌ | ❌ | ✅ | ✅ |
| deploy-firebase.yml | ✅ | ❌ | ❌ | ✅ |
| code-quality.yml | ✅ | ✅ | ❌ | ❌ |

## Artifacts Generated

### Android Builds
- `app-release-apk`: Android APK file
- `app-release-bundle`: Android App Bundle (AAB)

### Web Builds
- `web-build`: Flutter web build files

## Environment Variables

The workflows use the following environment variables:
- `FLUTTER_VERSION`: 3.35.4
- `JAVA_VERSION`: 17
- `NODE_VERSION`: 18

## Customization

### Changing Flutter Version
Update the `flutter-version` in all workflow files:
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.35.4'  # Change this
```

### Adding New Platforms
To add iOS builds, add a new job:
```yaml
build-ios:
  name: Build iOS
  runs-on: macos-latest
  steps:
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
    - name: Build iOS
      run: flutter build ios --release --no-codesign
```

### Custom Build Arguments
Modify build commands to include custom arguments:
```yaml
- name: Build APK
  run: flutter build apk --release --build-name=1.0.0 --build-number=1
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Flutter version compatibility
   - Verify all dependencies are properly declared
   - Check for platform-specific issues

2. **Deployment Failures**
   - Verify secrets are properly configured
   - Check repository permissions
   - Ensure target platforms are properly set up

3. **Test Failures**
   - Run tests locally first
   - Check for environment-specific test issues
   - Verify test coverage requirements

### Debugging
- Check workflow logs in the Actions tab
- Use `flutter doctor` in workflows to diagnose issues
- Enable debug logging with `--verbose` flags

## Best Practices

1. **Keep workflows fast**: Use caching and parallel jobs
2. **Fail fast**: Run quick checks first (lint, format)
3. **Security**: Use secrets for sensitive data
4. **Documentation**: Keep this README updated
5. **Testing**: Test workflows on feature branches first

## Support

For issues with GitHub Actions:
- Check the [GitHub Actions documentation](https://docs.github.com/en/actions)
- Review [Flutter CI/CD guide](https://docs.flutter.dev/deployment/ci)
- Open an issue in this repository
