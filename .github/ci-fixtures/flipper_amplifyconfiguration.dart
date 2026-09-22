// CI FIXTURE — NOT REAL CREDENTIALS. Safe to read; safe to commit.
//
// `apps/flipper/lib/amplifyconfiguration.dart` is gitignored and written from
// an Actions secret in release.yml. PR-time jobs must not do that: they run
// PR-authored code, and fork pull requests are denied secrets entirely.
//
// Without this file, `dart analyze` on packages/flipper_models reports
// URI_DOES_NOT_EXIST for `package:flipper_rw/amplifyconfiguration.dart` and
// UNDEFINED_IDENTIFIER for `amplifyconfig`, because flipper_models reaches
// into the flipper_rw APP for it. (That import is itself one of the layering
// violations scripts/ci/architecture_ratchet.sh records.)
//
// The committed source references exactly one symbol — `amplifyconfig` — so
// that is all this provides. It is valid Amplify JSON in shape only; every
// value is a placeholder and no plugin is configured, so nothing here can
// reach a real AWS account.
//
// Named flipper_amplifyconfiguration.dart, not amplifyconfiguration.dart,
// because apps/flipper/.gitignore line 103 ignores that filename anywhere
// beneath it — and a fixture that is silently untracked fixes nothing. Same
// trap as flipper_firebase_options.dart.
//
// See .github/ci-fixtures/README.md.

const amplifyconfig = '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0"
}''';
