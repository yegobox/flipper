import 'package:analyzer/dart/element/element.dart';

/// The class an annotation instantiates, such as `Supabase` for
/// `@Supabase(ignore: true)`.
///
/// Don't compare `element.displayName`: analyzer 14 names an unnamed
/// constructor `Supabase.new`, so a `displayName == 'Supabase'` check stops
/// matching without any error, and every `@Supabase(ignore: true)` field
/// starts syncing to Ditto.
String? annotationClassName(ElementAnnotation annotation) {
  final element = annotation.element;
  if (element is ConstructorElement) return element.enclosingElement.name;
  return element?.name;
}
