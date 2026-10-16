package rw.flipper.smsbridge.core

import java.security.MessageDigest

/**
 * Re-reading the SMS inbox, so a message the live receiver missed is still
 * forwarded.
 *
 * The receiver drops everything until the phone is paired, and some phones
 * never wake it at all (battery savers). Every upload run therefore reads the
 * inbox from a watermark; the queue's [dedupeKey] keeps a message the
 * receiver already caught from going up twice.
 */
object InboxSweep {
    /** First sweep after pairing or after updating the app: two days back. */
    const val FIRST_SWEEP_MS = 48 * 60 * 60 * 1000L

    /** Re-read a little before the watermark: the SMS app writes the inbox late. */
    const val OVERLAP_MS = 10 * 60 * 1000L

    /** "New only" at pairing still covers messages that arrived while pairing. */
    const val PAIRING_GRACE_MS = 2 * 60 * 60 * 1000L

    private const val DAY_MS = 24 * 60 * 60 * 1000L

    /** Where an upload run starts reading the inbox. */
    fun since(watermarkMs: Long?, nowMs: Long): Long =
        if (watermarkMs == null || watermarkMs <= 0) nowMs - FIRST_SWEEP_MS else watermarkMs - OVERLAP_MS

    /** Where pairing starts reading the inbox, for the backfill the user picked. */
    fun pairingSince(days: Int, nowMs: Long): Long =
        nowMs - maxOf(days.coerceAtLeast(0) * DAY_MS, PAIRING_GRACE_MS)

    /**
     * Identifies one SMS whichever path saw it. Not the time: the receiver
     * reads the network's timestamp, the inbox the phone's.
     */
    fun dedupeKey(sender: String, body: String): String {
        val text = body.trim().split(WHITESPACE).joinToString(" ")
        val digest = MessageDigest.getInstance("SHA-256").digest(text.toByteArray(Charsets.UTF_8))
        return SenderAllowlist.normalize(sender) + ":" + digest.joinToString("") { "%02x".format(it) }
    }

    private val WHITESPACE = Regex("\\s+")
}
