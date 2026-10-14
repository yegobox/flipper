package rw.flipper.smsbridge

import android.content.Context
import android.provider.Telephony
import rw.flipper.smsbridge.core.InboundSms

/**
 * One-time catch-up at pairing: queues bank and mobile-money SMS already in
 * the inbox from the last [days] days. Needs READ_SMS; everything after
 * pairing arrives through [SmsReceiver] instead.
 *
 * Re-sending an SMS the connector already has is harmless: it dedupes by the
 * provider's reference.
 */
object Backfill {
    fun run(context: Context, days: Int): Int {
        if (days <= 0) return 0
        val since = System.currentTimeMillis() - days * 24L * 60 * 60 * 1000
        val allowlist = BridgeState(context).allowlist()
        val queue = SmsQueue.get(context)
        var queued = 0
        context.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
            "${Telephony.Sms.DATE} >= ?",
            arrayOf(since.toString()),
            "${Telephony.Sms.DATE} ASC",
        )?.use { c ->
            while (c.moveToNext()) {
                val sender = c.getString(0) ?: continue
                val body = c.getString(1) ?: continue
                if (!allowlist.allows(sender)) continue
                if (queue.add(InboundSms(sender, body, c.getLong(2)))) queued++
            }
        }
        if (queued > 0) UploadWorker.enqueue(context)
        return queued
    }
}
