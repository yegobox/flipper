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

[![Crowdin](https://badges.crowdin.net/flipper/localized.svg)](https://crowdin.com/project/flipper)

</div>

<div align="center">
  [WhatsApp]()
</div>

-
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

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yegobox/flipper.git
    cd flipper
    ```

2.  **Activate Melos**:
    ```bash
    dart pub global activate melos 6.3.2
    ```

3.  **Bootstrap the project**:
    This command links all local packages and installs dependencies.
    ```bash
    melos bootstrap
    ```

4.  **Enable repo git hooks** (one-time):
    ```bash
    git config core.hooksPath hooks
    ```
    This also installs `post-checkout`/`post-merge` hooks that **automatically
    sync submodules** to the commit each branch pins on every `git switch` and
    `git pull` — so you never build against a stale submodule.

### Manual Configuration

For security reasons, some configuration files containing sensitive information are not included in the repository. You will need to create them manually.

1.  **Secret Files**:
    -   `packages/flipper_models/lib/secrets.dart`: Contains the `AppSecrets` class with API keys and endpoints.
    -   `apps/flipper/lib/firebase_options.dart`: Contains the `DefaultFirebaseOptions` class with Firebase configuration.

2.  **API Keys**:
    You'll need to obtain and configure your own API keys for services like Payment gateways (PayStack), Cloud storage, Analytics, Firebase, Sentry, and Supabase.

For templates and detailed setup instructions, please contact us at `info@yegobox.com`.

Additional implementation guides:

- [Flipper Sync Framework](docs/ditto_sync.md)

### 🪟 Running on Windows (local)

CI builds the Windows app on GitHub's `windows-latest` runners, which come
pre-provisioned and run elevated. A local machine needs a few extra steps that
CI gets for free:

1.  **Submodules** are kept in sync automatically by the git hooks (setup step 4)
    on every branch switch and pull. If one ever gets stuck at the wrong commit
    (e.g. it has local changes the hook won't overwrite), force-reset them:
    ```bash
    git submodule update --init --force --recursive
    ```

2.  **Install the Rust toolchain**. `turso_dart` builds a Rust native library via
    a `hook/build.dart` and requires `rustup`/`cargo` on `PATH` (GitHub runners
    ship with Rust pre-installed). After installing, open a fresh terminal:
    ```powershell
    winget install Rustlang.Rustup
    rustup default stable
    ```

3.  **Run via the helper script**, which bundles every local workaround (Rust on
    PATH, per-source PDBs, and turso DLL recovery) so you don't have to remember
    them:
    ```powershell
    pwsh scripts/run-windows.ps1
    ```
    It runs `flutter run -d windows`; extra args are forwarded.

#### Why the workarounds are needed (and the real fix)

On-access antivirus (e.g. **Bitdefender**, IPA's managed endpoint AV) interferes
with the build directory in two ways:

- It locks freshly written `.pdb`/`.ilk`/`.tlog` files mid-link → scattered
  `C1041` / `LNK1104` / `MSB6003 "used by another process"` errors. The script
  sets `UseMultiToolTask=true` (one PDB per source) to sidestep this.
- It grabs `turso_dart_native.dll` as cargo links it from `release\deps\` to the
  `release\` root, so Flutter's `install_code_assets` can't find it. The script
  restores the DLL and retries.

**The durable fix is an antivirus exclusion** for the repo's `build\` and
`.dart_tool\` folders, after which the script's workarounds become unnecessary.
On a managed device you usually can't set this yourself — request it from IT.
At IPA: email `support@poverty-action.org` asking for an on-access scanning
exclusion for your local clone path (e.g. `C:\...\flipper\`).

Note: don't run two Windows builds against the same checkout at once — concurrent
builds write the same PDBs and fail with `C1041`.

## 🤝 Contributing

We welcome contributions from the community! If you're interested in helping improve Flipper, please follow these steps:

1.  **Contact Us First**: Before starting any work, please email us at `info@yegobox.com` with your proposal or idea. This helps us coordinate efforts and prevent duplicate work.
2.  **Fork & Pull Request**: Use the standard GitHub workflow. Fork the repository, create a new branch for your feature or fix, and submit a pull request.
3.  **Follow Code Style**: Adhere to the existing code style and patterns within the project to maintain consistency.
4.  **Write Tests**: Ensure your changes include appropriate tests and that all existing tests pass.
5.  **Help Translate**: Join the [Flipper Crowdin project](https://crowdin.com/project/flipper) to improve translations for the community.

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
