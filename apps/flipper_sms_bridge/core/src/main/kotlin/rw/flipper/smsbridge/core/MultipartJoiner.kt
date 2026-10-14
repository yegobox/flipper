package rw.flipper.smsbridge.core

/** One PDU's worth of an SMS, as Android hands it to a receiver. */
data class SmsPart(
    val sender: String?,
    val body: String?,
    val timestampMs: Long,
)

/** A whole message, parts joined. */
data class InboundSms(
    val sender: String,
    val body: String,
    val receivedAtMs: Long,
)

/**
 * Joins the parts of concatenated SMS.
 *
 * A long bank message (BK's transfer notice is ~300 characters) arrives as
 * several PDUs in one `SMS_RECEIVED` broadcast. Android delivers them in
 * order, so parts from the same sender are concatenated as they come. One
 * broadcast can in principle carry messages from two senders; they are kept
 * apart.
 */
object MultipartJoiner {
    fun join(parts: List<SmsPart>): List<InboundSms> {
        val bySender = LinkedHashMap<String, MutableList<SmsPart>>()
        for (part in parts) {
            val sender = part.sender?.trim().orEmpty()
            if (sender.isEmpty()) continue
            bySender.getOrPut(sender) { mutableListOf() }.add(part)
        }
        return bySender.mapNotNull { (sender, group) ->
            val body = group.joinToString("") { it.body.orEmpty() }
            if (body.isBlank()) {
                null
            } else {
                InboundSms(sender, body, group.minOf { it.timestampMs })
            }
        }
    }
}
