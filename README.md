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
  [Discord](https://discord.gg/z2YVKkycX3)
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

4.  **Enable repo git hooks**:
    ```bash
    git config core.hooksPath hooks
    ```

### Manual Configuration

For security reasons, some configuration files containing sensitive information are not included in the repository. You will need to create them manually.

1.  **Secret Files**:
    -   `packages/flipper_models/lib/secrets.dart`: Contains the `AppSecrets` class with API keys and endpoints.
    -   `apps/flipper/lib/firebase_options.dart`: Contains the `DefaultFirebaseOptions` class with Firebase configuration.

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

