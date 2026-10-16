package rw.flipper.smsbridge

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.provider.Telephony
import androidx.core.content.ContextCompat
import rw.flipper.smsbridge.core.InboundSms
import rw.flipper.smsbridge.core.InboxSweep

/**
 * Queues bank and mobile-money SMS already in the inbox. Runs at pairing (the
 * backfill the user picked), on every upload run from a watermark (so an SMS
 * the receiver missed is still sent), and from "Find missed messages".
 *
 * Needs READ_SMS. Re-reading a message is harmless: the queue skips what it
 * already holds or already sent, and the connector dedupes by the provider's
 * reference.
 */
object Backfill {
    /** [queued] new rows; [newestMs] the latest inbox date read, or null when none. */
    data class Result(val queued: Int, val newestMs: Long?)

    fun canRead(context: Context): Boolean =
        ContextCompat.checkSelfPermission(context, Manifest.permission.READ_SMS) ==
            PackageManager.PERMISSION_GRANTED

    fun run(context: Context, sinceMs: Long): Result {
        if (!canRead(context)) return Result(0, null)
        val allowlist = BridgeState(context).allowlist()
        val queue = SmsQueue.get(context)
        var queued = 0
        var newest: Long? = null
        context.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
            "${Telephony.Sms.DATE} >= ?",
            arrayOf(sinceMs.toString()),
            "${Telephony.Sms.DATE} ASC",
        )?.use { c ->
            while (c.moveToNext()) {
                val date = c.getLong(2)
                newest = maxOf(newest ?: date, date)
                val sender = c.getString(0) ?: continue
                val body = c.getString(1) ?: continue
                if (!allowlist.allows(sender)) continue
                if (queue.add(InboundSms(sender, body, date))) queued++
            }
        }
        return Result(queued, newest)
    }

    /**
     * The upload run's catch-up: reads from the watermark and moves it on.
     * Returns how many messages it queued.
     */
    fun sweep(context: Context, nowMs: Long = System.currentTimeMillis()): Int {
        val state = BridgeState(context)
        if (!canRead(context)) return 0
        val result = run(context, InboxSweep.since(state.sweptThroughMs, nowMs))
        state.sweptThroughMs = maxOf(state.sweptThroughMs ?: 0, result.newestMs ?: nowMs)
        return result.queued
    }
}
