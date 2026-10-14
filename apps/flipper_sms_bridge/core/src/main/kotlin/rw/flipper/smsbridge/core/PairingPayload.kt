package rw.flipper.smsbridge.core

import java.net.URI
import java.net.URLDecoder

/**
 * What Flipper's pairing QR carries:
 *
 * ```
 * flipper-sms-bridge://pair?v=1&url=https%3A%2F%2Fprod.api.yegobox.com%2F&code=7K3QMZ9TXA
 * ```
 *
 * `url` is the data-connector this Flipper install talks to; the bridge uses
 * the same one, so a staging Flipper pairs a phone with staging.
 */
data class PairingPayload(val connectorUrl: String, val code: String) {
    companion object {
        const val SCHEME = "flipper-sms-bridge"

        /** Null for anything that is not a well-formed pairing QR. */
        fun parse(raw: String): PairingPayload? {
            val uri = try {
                URI(raw.trim())
            } catch (_: Exception) {
                return null
            }
            if (!uri.scheme.equals(SCHEME, ignoreCase = true) || uri.host != "pair") return null
            val query = uri.rawQuery ?: return null
            val params = query.split('&').mapNotNull { pair ->
                val i = pair.indexOf('=')
                if (i <= 0) {
                    null
                } else {
                    pair.substring(0, i) to URLDecoder.decode(pair.substring(i + 1), "UTF-8")
                }
            }.toMap()
            val url = params["url"]?.let(::normalizeUrl) ?: return null
            val code = params["code"]?.let(::normalizeCode)?.takeIf { it.length == CODE_LENGTH }
                ?: return null
            return PairingPayload(url, code)
        }

        const val CODE_LENGTH = 10

        /**
         * Same rule as the connector's `normalize_code`: uppercase, drop
         * separators, read O as 0 and I/L as 1.
         */
        fun normalizeCode(raw: String): String =
            raw.filter { it.isLetterOrDigit() && it.code < 128 }
                .uppercase()
                .map {
                    when (it) {
                        'O' -> '0'
                        'I', 'L' -> '1'
                        else -> it
                    }
                }
                .joinToString("")

        /**
         * HTTPS only, with a trailing slash. Plain HTTP is accepted for a
         * loopback/emulator host so the bridge can be tested against a local
         * connector, never for a real one: the bridge sends bank SMS.
         */
        fun normalizeUrl(raw: String): String? {
            val uri = try {
                URI(raw.trim())
            } catch (_: Exception) {
                return null
            }
            val host = uri.host ?: return null
            val local = host == "10.0.2.2" || host == "localhost" || host == "127.0.0.1"
            val ok = uri.scheme == "https" || (uri.scheme == "http" && local)
            if (!ok) return null
            val text = uri.toString()
            return if (text.endsWith("/")) text else "$text/"
        }
    }
}
