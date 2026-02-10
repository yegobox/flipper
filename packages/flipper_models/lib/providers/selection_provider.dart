import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_provider.g.dart';

@riverpod
class Selection extends _$Selection {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void selectAll(List<String> ids) {
    state = {...state, ...ids};
  }

  void deselectAll() {
    state = {};
  }
}
