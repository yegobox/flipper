// CI FIXTURE — NOT REAL CREDENTIALS. Safe to read; safe to commit.
//
// web_ci.yml copies this over the gitignored secrets file so pull requests can
// compile and boot without real credentials entering a job that runs
// PR-authored code. It also lets fork pull requests build at all, which they
// cannot when the file is written from Actions secrets.
//
// This file is NOT generated from the real secrets. It is derived from the
// members the committed source actually references (`AppSecrets.<member>`), so
// no real value can leak into it by construction.
//
// Every endpoint points at the reserved .invalid TLD, which is guaranteed
// never to resolve, so nothing here can accidentally reach a live service.
//
// If CI fails with "no member named X on AppSecrets", the app started using a
// new secret: add it here. See .github/ci-fixtures/README.md.

class AppSecrets {
  /// Gates `POST /auth/enroll` on the data-connector.
  ///
  /// Not a secret in any strong sense: it ships inside this app, so anyone
  /// with a build can read it. It raises the cost of drive-by scanning; the
  /// real proof of identity is the Firebase ID token sent alongside it, which
  /// the connector verifies against Google's signing keys.
  static const String dataConnectorEnrollKey = "ci-fixture.invalid";
  static bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  static const String AccessCollection = 'ci-fixture-AccessCollection';
  static const String apihubDevDomain =
      'https://ci-fixture.invalid/apihubDevDomain';
  static const String apihubProd = 'ci-fixture-apihubProd';
  static const String apihubProdDomain =
      'https://ci-fixture.invalid/apihubProdDomain';
  static const String apikey = 'ci-fixture-apikey';
  static const String appId = 'ci-fixture-appId';
  static const String appIdDebug = 'ci-fixture-appIdDebug';
  static const String baseUrl = 'https://ci-fixture.invalid/baseUrl';
  static const String bearerToken = 'ci-fixture-bearerToken';
  static const String bucketId = 'ci-fixture-bucketId';
  static const String capelaHost = 'https://ci-fixture.invalid/capelaHost';
  static const String capelaPassword = 'ci-fixture-capelaPassword';
  static const String capelaUsername = 'ci-fixture-capelaUsername';
  static const String clusterId = 'ci-fixture-clusterId';
  static const String coreApi = 'https://ci-fixture.invalid/coreApi';
  static const String dataSource = 'ci-fixture-dataSource';
  static const String database = 'ci-fixture-database';
  static const String flipperCompaignCollection =
      'ci-fixture-flipperCompaignCollection';
  static const String googleAiUrl = 'https://ci-fixture.invalid/googleAiUrl';
  static const String googleKey = 'ci-fixture-googleKey';
  static const String huggingFaceToken = 'ci-fixture-huggingFaceToken';
  static const String ippisSecretKey = 'ci-fixture-ippisSecretKey';
  static const String ippisUser = 'ci-fixture-ippisUser';
  static const String localSupabaseAnonKey = 'ci-fixture-localSupabaseAnonKey';
  static const String localSuperbaseUrl =
      'https://ci-fixture.invalid/localSuperbaseUrl';
  static const String mongoBaseUrl = 'https://ci-fixture.invalid/mongoBaseUrl';
  static const String newApiEndPoints =
      'https://ci-fixture.invalid/newApiEndPoints';
  static const String organizationId = 'ci-fixture-organizationId';
  static const String password = 'ci-fixture-password';
  static const String payStackApiKey = 'ci-fixture-payStackApiKey';
  static const String postHogProjectToken = 'ci-fixture-postHogProjectToken';
  static const String powersyncUrl = 'https://ci-fixture.invalid/powersyncUrl';
  static const String projectId = 'ci-fixture-projectId';
  static const String publicPassword = 'ci-fixture-publicPassword';
  static const String publicUsername = 'ci-fixture-publicUsername';
  static const String socialIntegrationUrl =
      'https://ci-fixture.invalid/socialIntegrationUrl';
  static const String supabaseAnonKey = 'ci-fixture-supabaseAnonKey';
  static const String supabaseAnonKeyPublishable =
      'ci-fixture-supabaseAnonKeyPublishable';
  static const String supabaseUrl = 'https://ci-fixture.invalid/supabaseUrl';
  static const String superbaseurl = 'https://ci-fixture.invalid/superbaseurl';
  static const bool tursoCloudSyncEnabled = false;
  static const String tursoDatabaseAuthToken =
      'ci-fixture-tursoDatabaseAuthToken';
  static const String tursoDatabaseUrl =
      'https://ci-fixture.invalid/tursoDatabaseUrl';
  static const String username = 'ci-fixture-username';
  static const String whatsAppToken = 'ci-fixture-whatsAppToken';
}
