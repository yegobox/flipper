// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets(
//   "Not inputting a text and wanting to go to the display page shows "
//   "an error and prevents from going to the display page.",
//   (WidgetTester tester) async {
//     // Testing starts at the root widget in the widget tree
//     await tester.pumpWidget(MyApp());

//     await tester.tap(find.byType(FloatingActionButton));
//     // Wait for all the animations to finish
//     await tester.pumpAndSettle();

//     expect(find.byType(TypingPage), findsOneWidget);
//     expect(find.byType(DisplayPage), findsNothing);
//     // This is the text displayed by an error message on the TextFormField
//     expect(find.text('Input at least one character'), findsOneWidget);
//   },
// );
// }