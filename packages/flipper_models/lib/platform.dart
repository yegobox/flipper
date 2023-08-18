class getEnvVariables {
  static String url() {
    return String.fromEnvironment('DB_URL');
  }

  static String password() {
    return String.fromEnvironment('DB_PASSWORD');
  }
}

// For testing purpose@NOTE: please add this in your operating system environment variable for testing.
// void main() {
//   getEnvVariables();
//   print("DB_URL: $url");
//   print("DB_PASSWORD: $password");
// }
