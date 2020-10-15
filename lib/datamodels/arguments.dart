class Arguments {
  final Map<dynamic, dynamic> values;
  // ignore: sort_constructors_first
  Arguments(this.values);
}

// EXAMPLE
  // final Arguments firstMap = Arguments({1: {'a': { 'b': 'I am B'}, 'c': 'I am C' }});
  // final Arguments secondMap = Arguments({"2":Duration(seconds: 4)});

  // final Arguments thirdMap = Arguments({
  //   ...firstMap.values,
  //   ...secondMap.values,
  //     ...Arguments({'3': '3rd object added'}).values
  // });
  // print(thirdMap.values);
  // print((thirdMap.values ?? const {})[1]);

  // RESULT
  // {1: {a: {b: I am B}, c: I am C}, 2: 0:00:04.000000, 3: 3rd object added}
  // {a: {b: I am B}, c: I am C}