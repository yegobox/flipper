import 'package:flipper_services/constants.dart';

/// Thrown when a ticket is resumed while another till already has it open.
class TicketOpenElsewhereException implements Exception {
  const TicketOpenElsewhereException(this.transactionId);

  final String transactionId;

  @override
  String toString() =>
      'Ticket $transactionId is already open on another device.';
}

/// Whether resuming a ticket on [deviceId] would take it from another till.
///
/// A tickets list that has not synced yet still shows a ticket as parked after
/// another device resumed it. Resuming it again rewrote `deviceId`/`agentId`,
/// so both tills held it as their open sale. A PENDING row stamped with a
/// different device is that case; a row this device already holds, or one with
/// no device, may be resumed.
bool ticketOpenOnAnotherDevice({
  required String? status,
  required String? ticketDeviceId,
  required String deviceId,
}) {
  if ((status ?? '').toLowerCase() != PENDING.toLowerCase()) return false;
  final holder = ticketDeviceId?.trim() ?? '';
  if (holder.isEmpty || deviceId.isEmpty) return false;
  return holder != deviceId;
}
