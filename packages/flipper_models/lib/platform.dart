import 'dart:io';

String? url;
String? password;

void getEnvVariables() {
  if (Platform.environment.containsKey('DB_URL')) {
    url = Platform.environment['DB_URL'];
  }
  if (Platform.environment.containsKey('DB_PASSWORD')) {
    password = Platform.environment['DB_PASSWORD'];
  }
}

// For testing purpose@NOTE: please add this in your operating system environment variable for testing.
// void main() {
//   getEnvVariables();
//   print("DB_URL: $url");
//   print("DB_PASSWORD: $password");
// }
