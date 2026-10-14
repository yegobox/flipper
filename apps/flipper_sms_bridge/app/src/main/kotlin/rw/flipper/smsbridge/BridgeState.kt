package rw.flipper.smsbridge

import android.content.Context
import rw.flipper.smsbridge.core.SenderAllowlist
import java.util.UUID

/**
 * Non-secret state: the sender allowlist the connector last sent, and what
 * the status screen shows. Credentials live in [CredentialStore].
 */
class BridgeState(context: Context) {
    private val prefs = context.getSharedPreferences("bridge_state", Context.MODE_PRIVATE)

    /** The connector's list once fetched, the built-ins before that. */
    fun allowlist(): SenderAllowlist {
        val saved = prefs.getStringSet(KEY_SENDERS, null)
        return if (saved.isNullOrEmpty()) SenderAllowlist.DEFAULT else SenderAllowlist(saved)
    }

    fun saveSenders(senders: Collection<String>) {
        if (senders.isEmpty()) return
        prefs.edit()
            .putStringSet(KEY_SENDERS, senders.toSet())
            .putLong(KEY_SENDERS_AT, System.currentTimeMillis())
            .apply()
    }

    fun sendersFetchedAtMs(): Long = prefs.getLong(KEY_SENDERS_AT, 0)

    /** Random per install, sent at pairing. Survives unpairing. */
    fun installId(): String =
        prefs.getString(KEY_INSTALL, null) ?: UUID.randomUUID().toString().also {
            prefs.edit().putString(KEY_INSTALL, it).apply()
        }

    var lastUploadAtMs: Long
        get() = prefs.getLong(KEY_LAST_UPLOAD, 0)
        set(v) = prefs.edit().putLong(KEY_LAST_UPLOAD, v).apply()

    var lastError: String?
        get() = prefs.getString(KEY_LAST_ERROR, null)
        set(v) = prefs.edit().putString(KEY_LAST_ERROR, v).apply()

    var forwardedCount: Long
        get() = prefs.getLong(KEY_FORWARDED, 0)
        set(v) = prefs.edit().putLong(KEY_FORWARDED, v).apply()

    /** Set when the connector refused our credentials: the phone must pair again. */
    var needsPairing: Boolean
        get() = prefs.getBoolean(KEY_NEEDS_PAIRING, false)
        set(v) = prefs.edit().putBoolean(KEY_NEEDS_PAIRING, v).apply()

    fun resetStatus() {
        prefs.edit()
            .remove(KEY_LAST_UPLOAD)
            .remove(KEY_LAST_ERROR)
            .remove(KEY_FORWARDED)
            .remove(KEY_NEEDS_PAIRING)
            .apply()
    }

    private companion object {
        const val KEY_SENDERS = "senders"
        const val KEY_SENDERS_AT = "senders_at"
        const val KEY_INSTALL = "install_id"
        const val KEY_LAST_UPLOAD = "last_upload"
        const val KEY_LAST_ERROR = "last_error"
        const val KEY_FORWARDED = "forwarded"
        const val KEY_NEEDS_PAIRING = "needs_pairing"
    }
}
