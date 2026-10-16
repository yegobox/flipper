package rw.flipper.smsbridge.core

/**
 * The SMS senders this phone forwards. Everything else stays on the phone.
 *
 * The data-connector owns the list (`GET /api/sms-bridge/config`, from
 * `data-connector/src/sms/senders.rs`) and the bridge refreshes it every few
 * hours, so a new bank sender needs no app update. [BUILT_IN] is only the
 * starting point before the first refresh.
 */
class SenderAllowlist(senders: Collection<String>) {
    private val normalized: Set<String> = senders.map(::normalize).filter { it.isNotEmpty() }.toSet()

    val size: Int get() = normalized.size

    fun allows(sender: String?): Boolean {
        if (sender == null) return false
        val key = normalize(sender)
        return key.isNotEmpty() && key in normalized
    }

    fun senders(): Set<String> = normalized

    companion object {
        /**
         * Uppercase, keep only letters, digits and `&`: `"M-Money"` → `"MMONEY"`.
         * Must match `normalize_sender` in the connector.
         */
        fun normalize(raw: String): String =
            raw.filter { it.isLetterOrDigit() && it.code < 128 || it == '&' }.uppercase()

        /** Mirrors the connector's built-in list. */
        val BUILT_IN: List<String> = listOf(
            "BK", "BKBANK", "BANKOFKIGALI", "BKGROUP", "BKeBANK", "BK Cards",
            "M-Money", "MTN MoMo", "MoMo", "MTNMOMO",
            "AirtelMoney", "Airtel Money",
            "Equity Bank", "EquityBank",
            "I&M Bank", "I&M", "IMBANK",
            "BPR Bank",
        )

        val DEFAULT = SenderAllowlist(BUILT_IN)
    }
}
