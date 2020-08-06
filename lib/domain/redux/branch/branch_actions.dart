import 'package:flipper/model/branch.dart';
import 'package:flipper/model/hint.dart';
import 'package:flutter/material.dart';

@immutable
class OnSetBranchHint {
  final Branch branch;

  const OnSetBranchHint({@required this.branch});
}

@immutable
class OnCurrentBranchAction {
  final Branch branch;

  const OnCurrentBranchAction({@required this.branch});
}

@immutable
class OnBranchLoaded {
  final List<Branch> branches;

  const OnBranchLoaded({@required this.branches});

  @override
  String toString() {
    return 'OnBranchLoaded{OnBranchLoaded: $branches}';
  }
}

@immutable
class OnHintLoaded {
  final Hint hint;

  const OnHintLoaded({@required this.hint});

  @override
  String toString() {
    return 'OnBranchLoaded{OnHintLoaded: $hint}';
  }
}
