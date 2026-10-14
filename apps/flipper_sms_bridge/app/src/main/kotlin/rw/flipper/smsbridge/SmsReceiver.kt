package rw.flipper.smsbridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import rw.flipper.smsbridge.core.MultipartJoiner
import rw.flipper.smsbridge.core.SmsPart

/**
 * Catches every incoming SMS, keeps the bank and mobile-money ones, and
 * queues them for upload. Personal messages are dropped here, on the phone.
 *
 * Only queues: the network call happens in [UploadWorker], so a slow or
 * missing connection never makes the system kill the receiver mid-message.
 */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        if (CredentialStore(context).load() == null) return

        val parts = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            ?.filterNotNull()
            ?.map { SmsPart(it.displayOriginatingAddress, it.displayMessageBody, it.timestampMillis) }
            ?: return

        val allowlist = BridgeState(context).allowlist()
        val queue = SmsQueue.get(context)
        var queued = 0
        for (sms in MultipartJoiner.join(parts)) {
            if (allowlist.allows(sms.sender) && queue.add(sms)) queued++
        }
        if (queued > 0) UploadWorker.enqueue(context)
    }
}
