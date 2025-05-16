<div align="center">

<img src=".github/assets/flipper_logo.png" width="200"/>

# Flipper
### Enterprise-Grade Business Software with Military-Level Encryption

&ensp;
&ensp;

![Github Mockup Flipper2](https://github.com/user-attachments/assets/548911d7-96d9-43e1-9b2c-830865e78eb5)

</div>

## Our Mission

Flipper delivers a comprehensive business software suite with integrated data encryption for both enterprise and personal use. Our all-in-one platform streamlines operations while safeguarding your data with military-grade security protocols.

This monorepo contains our complete ecosystem:
- Client applications for all major platforms (iOS, Android, Web, Linux, macOS, Windows)
- Backend infrastructure powering our enterprise suite
- Core encryption technology ensures data protection

**Experience the revolution at [flipper.rw](https://flipper.rw) or [yegobox.com](https://yegobox.com)**

## Available Across All Platforms

<div align="center">
  <a href="https://apps.apple.com/app/id1542026904"><img height="42" src=".github/assets/flipper_logo.png" alt="App Store"></a>
  <a href="https://play.google.com/store/apps/details?id=io.Flipper.photos"><img height="42" src=".github/assets/play-store-badge.png" alt="Google Play"></a>
  <a href="https://f-droid.org/packages/io.Flipper.photos.fdroid/"><img height="42" src=".github/assets/f-droid-badge.png" alt="F-Droid"></a>
  <a href="https://yegobox.com"><img height="42" src=".github/assets/desktop-badge.png" alt="Desktop"></a>
  <a href="https://web.yegobox.com"><img height="42" src=".github/assets/web-badge.svg" alt="Web"></a>
</div>

<div align="center">
  <a href="https://apps.apple.com/app/id6444121398"><img height="42" src=".github/assets/app-store-badge.svg" alt="App Store"></a>
  <a href="https://play.google.com/store/apps/details?id=io.Flipper.auth"><img height="42" src=".github/assets/play-store-badge.png" alt="Google Play"></a>
  <a href="https://f-droid.org/packages/io.Flipper.auth/"><img height="42" src=".github/assets/f-droid-badge.png" alt="F-Droid"></a>
  <a href="https://github.com/Flipper-io/Flipper/releases?q=tag%3Aauth-v3"><img height="42" src=".github/assets/desktop-badge.png" alt="Desktop"></a>
  <a href="https://auth.yegobox.com"><img height="42" src=".github/assets/web-badge.svg" alt="Web"></a>
</div>

## Why Invest in Flipper?

Flipper presents a strategic opportunity for investors targeting high-growth potential in the B2B SaaS and data security markets. Our competitive advantages include:

- **Unified Enterprise Platform**: Seamlessly integrates comprehensive business tools with advanced encryption technology
- **True Cross-Platform Compatibility**: Consistent experience across all major operating systems and devices
- **Open-Source Foundation**: Builds trust through transparency while maintaining proprietary competitive advantages
- **Global Infrastructure**: Architecture designed for worldwide scalability with robust localization capabilities
- **Sustainable Revenue Model**: Subscription-based services delivering predictable, growing revenue streams

## Market Position & Growth Trajectory

The business software market is projected to reach $650B by 2028, driven by the growing demand for integrated and scalable solutions. Flipper is at the forefront, helping businesses automate operations, optimize workflows, and gain real-time insights across industries like finance, and professional services.

Our next funding round will accelerate:
- Enterprise user acquisition
- Better UI/UX and R&D
- Expansion of AI-powered business intelligence tools
- Global compliance and certification programs

## Join Our Community

<div align="center">
  <img src=".github/assets/flipper_logo.png" width="200" alt="Flipper's Mascot, Ducky" />
</div>

Connect with our growing community of developers, users, and partners:

[![Discord](https://img.shields.io/discord/948937918347608085?style=for-the-badge&logo=Discord&logoColor=white&label=Discord)](https://discord.gg/z2YVKkycX3) [![Flipper's Blog RSS](https://img.shields.io/badge/blog-rss-F88900?style=for-the-badge&logo=rss&logoColor=white)](https://yegobox.com/blog/rss.xml)

[![Twitter](.github/assets/twitter.svg)](https://twitter.com/Flipperio) &nbsp; [![Mastodon](.github/assets/mastodon.svg)](https://fosstodon.org/@Flipper)


Visit our community hub: [yegobox.com/community](https://yegobox.com/community)

## Contributing to Flipper

We welcome contributions from the community! Here's how you can get involved:

1. **Contact Us First**: Before starting work on a contribution, please email us at info@yegobox.com with your proposal or idea.

2. **Fork & Pull Request**: Standard GitHub workflow - fork the repository, make your changes, and submit a pull request.

3. **Code Style**: Follow the existing code style and patterns in the project.

4. **Testing**: Ensure your changes include appropriate tests and don't break existing functionality.

## Repository Setup

### Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yegobox/flipper.git
   cd flipper
   ```

2. **Setup Melos** (required for monorepo management):
   ```bash
   dart pub global activate melos 6.3.2
   melos bootstrap
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

### Manual Configuration

Some files need to be manually created or copied due to security or configuration reasons:

1. **Secret Files**: The following files contain sensitive information and need to be manually copied or created:
   - `packages/flipper_models/lib/secrets.dart` (contains `AppSecrets` class with API keys and endpoints)
   - `apps/flipper/lib/firebase_options.dart` (contains `DefaultFirebaseOptions` class with Firebase configuration)

2. **API Keys**: You'll need to obtain and configure your own API keys for services like:
   - Payment gateways (PayStack)
   - Cloud storage
   - Analytics
   - Firebase
   - Sentry
   - Supabase

3. **Local Database**: Initial database configuration files may need to be manually set up.

These files are not included in the repository for security reasons. For templates and detailed setup instructions, please contact info@yegobox.com.

---

## Security Commitment

Security is fundamental to our mission. We encourage responsible disclosure of potential vulnerabilities:
- Email: yegobox@gmail.com
- [Submit advisory](https://github.com/yegobox/flipper/security/advisories/new)

For complete details, please review our [security policy](SECURITY.md).
