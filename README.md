<div align="center">

<img src=".github/assets/flipper_logo.png" width="200" alt="Flipper Logo"/>

# Flipper

### Enterprise-Grade Business Software with Military-Level Encryption

</div>

<div align="center">
  <a href="https://apps.apple.com/app/id1542026904"><img height="42" src=".github/assets/app-store-badge.svg" alt="App Store"></a>
  <a href="https://play.google.com/store/apps/details?id=io.Flipper.photos"><img height="42" src=".github/assets/play-store-badge.png" alt="Google Play"></a>
  <a href="https://f-droid.org/packages/io.Flipper.photos.fdroid/"><img height="42" src=".github/assets/f-droid-badge.png" alt="F-Droid"></a>
  <a href="https://yegobox.com"><img height="42" src=".github/assets/desktop-badge.png" alt="Desktop"></a>
  <a href="https://web.yegobox.com"><img height="42" src=".github/assets/web-badge.svg" alt="Web"></a>
  <br/>
</div>

<div align="center">
  [WhatsApp]()
</div>


<div align="center">

&ensp;

![Github Mockup Flipper2](https://github.com/user-attachments/assets/548911d7-96d9-43e1-9b2c-830865e78eb5)

</div>

## 🚀 Our Mission

Flipper delivers a comprehensive business software suite with integrated data encryption for both enterprise and personal use. Our all-in-one platform streamlines operations while safeguarding your data with military-grade security protocols.

This monorepo contains our complete ecosystem, including:
-   Client applications for all major platforms (iOS, Android, Web, Linux, macOS, Windows)
-   Backend infrastructure powering our enterprise suite
-   Core encryption technology to ensure data protection

**Experience the revolution at [flipper.rw](https://flipper.rw) or [yegobox.com](https://yegobox.com)**

## ✨ Key Features

-   **Unified Enterprise Platform**: Seamlessly integrates comprehensive business tools with advanced encryption technology.
-   **True Cross-Platform Compatibility**: A consistent and reliable experience across all major operating systems and devices.
-   **Source-Available Foundation**: Builds trust through transparency while maintaining proprietary competitive advantages.
-   **Global Infrastructure**: Architecture designed for worldwide scalability with robust localization capabilities.
-   **Sustainable Revenue Model**: Subscription-based services delivering predictable, growing revenue streams.

## 🛠️ Getting Started: Repository Setup

This repository is a monorepo managed with [Melos](https://melos.invertase.dev/).

This section aligns local development with our CI/CD (`release.yml`). **If you cloned the repository before these steps, please repeat them.**

### 1. Prerequisites & Toolchain Versions

| Tool               | Required Version        | Notes                                                                |
| ------------------ | ----------------------- | -------------------------------------------------------------------- |
| Flutter            | **3.32.6** (stable)     | Match CI to avoid build/test drift. (Update here *first* before CI.) |
| Dart               | Bundled with Flutter    | Ensure `dart --version` matches Flutter SDK.                         |
| Java JDK           | **17** (Zulu / Temurin) | Required for Android and some tooling.                               |
| Ruby               | **3.0.x**               | For Fastlane (Android release lanes).                                |
| Node.js            | **20.x LTS**            | Used for Firebase Hosting deploy and scripts.                        |
| Melos              | **6.3.2**               | Monorepo orchestration (pinned version).                             |
| Git                | >= 2.40                 | Needed for submodules and hooks.                                     |
| Android SDK / NDK  | Latest stable           | Required for Android builds.                                         |
| PowerShell 7 (Win) | Optional                | For advanced scripting.                                              |

> **Why pin versions?** Divergent build artifacts and flaky tests occur when contributors use unverified toolchains. Always upgrade deliberately.

### 2. Clone With Submodules

```bash
git clone --recurse-submodules https://github.com/yegobox/flipper.git
cd flipper

# If already cloned without submodules
git submodule update --init --recursive
```

### 3. Activate Melos (Pinned Version)

```bash
dart pub global activate melos 6.3.2
```

### 4. Bootstrap the Monorepo

```bash
melos bootstrap
```

If dependencies fail to resolve:

```bash
melos clean
melos bootstrap
```

### 5. Git Hooks

```bash
git config core.hooksPath hooks
```

### 6. Code Generation

```bash
melos run build
# Or:
melos exec -- "dart run build_runner build --delete-conflicting-outputs"
```

### 7. Configure Local Secrets & Config

For security reasons, some configuration files containing sensitive information are not included in the repository. You will need to create them manually.

1.  **Secret Files**:
    -   `packages/flipper_models/lib/secrets.dart`: Contains the `AppSecrets` class with API keys and endpoints.
    -   `apps/flipper/lib/firebase_options.dart`: Contains the `DefaultFirebaseOptions` class with Firebase configuration.
    -   `apps/flipper/lib/config.dart`: Stores local configuration variables and environment-specific settings.
    -   `apps/flipper/lib/amplifyconfiguration.dart`: Holds AWS Amplify configuration for authentication and cloud services.
    -   `apps/flipper/lib/team-provider-info.json`: Tracks team environment settings for Amplify deployments.
    -   `apps/flipper/web/index.html`: May require embedded secrets or environment variables for web builds.

2.  **API Keys**:
    You'll need to obtain and configure your own API keys for services like Payment gateways (PayStack), Cloud storage, Analytics, Firebase, Sentry, and Supabase.

For templates and detailed setup instructions, please contact us at `info@yegobox.com`.

## 🤝 Contributing

We welcome contributions from the community! If you're interested in helping improve Flipper, please follow these steps:

1.  **Contact Us First**: Before starting any work, please email us at `info@yegobox.com` with your proposal or idea. This helps us coordinate efforts and prevent duplicate work.
2.  **Fork & Pull Request**: Use the standard GitHub workflow. Fork the repository, create a new branch for your feature or fix, and submit a pull request.
3.  **Follow Code Style**: Adhere to the existing code style and patterns within the project to maintain consistency.
4.  **Write Tests**: Ensure your changes include appropriate tests and that all existing tests pass.

## 🛡️ Security

Security is fundamental to our mission. We encourage responsible disclosure of potential vulnerabilities.
-   **Email**: `yegobox@gmail.com`
-   **Submit an Advisory**: [Create a new security advisory](https://github.com/yegobox/flipper/security/advisories/new)

For complete details, please review our [security policy](SECURITY.md).

## 📈 For Investors

Flipper presents a strategic opportunity for investors targeting high-growth potential in the B2B SaaS and data security markets. The business software market is projected to reach $650B by 2028, driven by the growing demand for integrated and scalable solutions. Flipper is at the forefront, helping businesses automate operations, optimize workflows, and gain real-time insights.

Our next funding round will accelerate:
-   Enterprise user acquisition
-   UI/UX improvements and R&D
-   Expansion of AI-powered business intelligence tools
-   Global compliance and certification programs

## 📜 License & Terms of Use

This project is source-available. The source code is public on GitHub to promote transparency and build trust with our users and partners. However, it is not "open source" in the conventional sense.

Usage of this source code is subject to specific terms. You may use, modify, and distribute the code only if you have a valid agreement with YEGOBOX LTD, or if you are an acknowledged investor, contributor, or partner. Unauthorized use is strictly prohibited. For licensing inquiries, please contact `info@yegobox.com`.

## 🧪 UI / UX Test Report *(Current Observations)*

### VERIFIED ASPECT
1. **Very Responsive**: According to screen resolution

### Key Issues & Recommendations

1. **Navigation & Controls**: Add *Back* and *Cancel* buttons in multi-step flows.
2. **Transaction Feedback**: Introduce optimistic UI states and server idempotency keys.
3. **Irreversible Actions**: Implement confirmation steps and undo options.
4. **API Performance**: Reduce coupling, batch requests, and add caching.

### Roadmap Priorities

1. Implement reversal and escape controls.
2. Optimize transaction latency and feedback.
3. Standardize API error handling and timeouts.
4. Add instrumentation and performance metrics.
5. Improve accessibility and UX consistency.


## Missing Steps (Gap Analysis)

Below are key setup and workflow steps present in `release.yml` but missing or incomplete in the current README:

- **Git Submodules:**  
  All jobs use `submodules: recursive` and run `git submodule update --init`. The README only shows a plain `git clone` and does not mention using `--recurse-submodules` or updating submodules after cloning.

- **Toolchain Versions:**  
  The workflow specifies Flutter `3.32.6`, Java JDK `17`, Node `20` (for Firebase deploy), and Ruby `3.0` (for Fastlane). The README does not provide version guidance, which can lead to local version mismatch issues.

- **Melos Bootstrap Sequence:**  
  The workflow always runs `dart pub global activate melos 6.3.2` followed by `melos bootstrap`. The README shows activation but does not stress the required version or the need to repeat this per clean build.

- **Secrets / Generated Config Files:**  
  The workflow configures missing files by echoing secrets into multiple paths: `config.dart`, `secrets.dart`, `firebase_options.dart`, `amplifyconfiguration.dart`, `team-provider-info.json`, and `web/index.html`. The README only mentions two files (`secrets.dart`, `firebase_options.dart`), with others missing and no placeholder instructions.

- **Amplify Support Files:**  
  Files like `amplify/team-provider-info.json` and `amplifyconfiguration.dart` are handled in the workflow but not mentioned in the README.

- **Web Index Injection:**  
  The workflow creates `apps/flipper/web/index.html` from a secret `$INDEX`, which is not documented in the README.

- **Code Generation:**  
  Packages use tools like `build_runner`, `freezed`, and `dart_mappable` for code generation before tests/builds. The README does not show the code generation command.

- **Running Tests:**  
  The workflow runs tests with `flutter test --dart-define=FLUTTER_TEST_ENV=true` for dashboard and integration tests. The README lacks a section on running tests or using the `--dart-define` flag.

- **Integration Tests (Windows):**  
  The workflow uses `integration_test/smoke_windows_test.dart` on the Windows runner, which is not documented in the README.

- **Windows Packaging:**  
  The workflow runs `dart run msix:create` (for debug and store), extracts version info, and installs certificates. The README does not include instructions for building Windows MSIX packages or installing certificates.

- **Fastlane / Android Release Lanes:**  
  The workflow supports lane choices like `beta`, `promote_to_production`, and `production`, with `internal` as default elsewhere. The README does not provide guidance on lanes or required keystore/service JSON placeholders.

- **Firebase Hosting Deploy:**  
  The workflow uses the Firebase action after building the web app, requiring Node and a service account secret. The README does not mention web deployment requirements.

- **Environment Variables / Secrets Naming:**  
  The workflow uses variables such as INDEX, CONFIGDART, SECRETS, FIREBASEOPTIONS, AMPLIFY_CONFIG, AMPLIFY_TEAM_PROVIDER, POSTHOG_API_KEY, DB_URL, DB_PASSWORD, etc. The README only lists “API keys” in general terms.

- **Branch Naming Conventions:**  
  Workflow triggers on branches named `feature-*`, `hotfix-*`, `bugfix-*`, `request-enhancment`, `shifts`, as well as `dev` and `main`. This is not documented in the README and would be helpful for contributors