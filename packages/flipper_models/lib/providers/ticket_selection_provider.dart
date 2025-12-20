import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ticket_selection_provider.g.dart';

@riverpod
class TicketSelection extends _$TicketSelection {
  @override
  Set<String> build() {
    return {};
  }

  void toggleSelection(String ticketId) {
    if (state.contains(ticketId)) {
      state = {...state}..remove(ticketId);
    } else {
      state = {...state, ticketId};
    }
  }

  void selectAll(List<ITransaction> tickets) {
    state = tickets.map((t) => t.id).toSet();
  }

  void clearSelection() {
    state = {};
  }

  bool isSelected(String ticketId) => state.contains(ticketId);

  bool get hasSelection => state.isNotEmpty;

  int get selectedCount => state.length;
}
