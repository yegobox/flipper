package rw.flipper.smsbridge.ui

import rw.flipper.smsbridge.core.BridgeStatus
import rw.flipper.smsbridge.core.PairingPayload

/**
 * Everything the screen shows, in one value. The screens are pure functions
 * of it, so screenshot tests can render any state without a phone.
 */
data class BridgeUi(
    val status: BridgeStatus = BridgeStatus.NOT_PAIRED,
    val branchName: String? = null,
    val serverHost: String? = null,
    val lastError: String? = null,
    val queued: Int = 0,
    val forwarded: Long = 0,
    val lastUploadAtMs: Long = 0,
    /** When the receiver last caught a bank SMS; 0 = never. */
    val lastCaughtAtMs: Long = 0,
    /** When an upload run last read the inbox; 0 = never. */
    val lastSweptAtMs: Long = 0,
    val nowMs: Long = 0,
    val hasSmsPermission: Boolean = false,
    /** Android refused at least once: show the "restricted settings" help. */
    val smsDenied: Boolean = false,
    val batteryExempt: Boolean = false,
    val backfillDays: Int = 0,
    val pairing: Boolean = false,
    val pairError: String? = null,
    /** One-off message for the snackbar ("Paired…"). */
    val notice: String? = null,
    /** A `flipper-sms-bridge://pair` link waiting for the user to confirm. */
    val pendingLink: PairingPayload? = null,
    val defaultServerUrl: String = "https://prod.api.yegobox.com/",
    val versionName: String = "",
)

/** What the screens can ask for. The activity owns the Android side of each. */
class BridgeActions(
    val allowSms: () -> Unit = {},
    val openAppInfo: () -> Unit = {},
    val allowBackground: () -> Unit = {},
    val setBackfill: (Int) -> Unit = {},
    val scan: () -> Unit = {},
    val pairWithCode: (code: String, serverUrl: String) -> Unit = { _, _ -> },
    val clearPairError: () -> Unit = {},
    val confirmLink: () -> Unit = {},
    val dismissLink: () -> Unit = {},
    val sendNow: () -> Unit = {},
    /** Re-read the inbox for the last N days and send what was missed. */
    val findMissed: (days: Int) -> Unit = {},
    val unpair: () -> Unit = {},
    val noticeShown: () -> Unit = {},
)
