//Get Credentials
// var credentials = await storage.getCredentials();
// if (credentials == null) {
// }
//  else {
//   await refreshToken();
//   // log.i(credentials["expiry"]);
//   // log.i(credentials["data"]);
//   // log.i(credentials["type"]);
//   return authenticatedClient(
//     http.Client(),
//     AccessCredentials(
//       AccessToken(
//         credentials["type"],
//         credentials["data"],
//         DateTime.tryParse(credentials["expiry"])!,
//       ),
//       // credentials["refreshToken"],
//       // refreshToken can be null as it was not returned when logging in
//       null,
//       _scopes,
//     ),
//   );
// }
