package rw.flipper.smsbridge.core

/**
 * What to do with each queued message after an upload attempt.
 *
 * The connector answers per message (`data-connector/src/api/sms_bridge.rs`,
 * `IngestResult.status`): `stored`, `duplicate` and `ignored` are final, so
 * the row is deleted; `error` means the server could not store it and the
 * row stays for the next attempt. A message missing from the response is
 * treated as an error, never as delivered.
 */
object UploadPolicy {
    const val MAX_BATCH = 50

    /** Give up on one message after this many failed attempts (~ a week at the backoff cap). */
    const val MAX_ATTEMPTS = 200

    private val FINAL = setOf("stored", "duplicate", "ignored")

    /**
     * [stored] is the subset of [delivered] the connector kept as new: what
     * the "sent" count shows. A `duplicate` (the inbox sweep re-reading a
     * message) or an `ignored` sender is delivered but not counted.
     */
    data class Outcome(val delivered: Set<Long>, val failed: Set<Long>, val stored: Set<Long> = emptySet())

    fun classify(sentIds: Collection<Long>, statuses: Map<String, String>): Outcome {
        val delivered = mutableSetOf<Long>()
        val failed = mutableSetOf<Long>()
        val stored = mutableSetOf<Long>()
        for (id in sentIds) {
            val status = statuses[id.toString()]
            if (status in FINAL) delivered += id else failed += id
            if (status == "stored") stored += id
        }
        return Outcome(delivered, failed, stored)
    }
}
