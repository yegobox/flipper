package rw.flipper.smsbridge.core

/** The one-word health the status card leads with. */
enum class BridgeStatus {
    /** No credentials yet: show setup. */
    NOT_PAIRED,

    /** Revoked in Flipper (or the refresh token was refused): pair again. */
    NEEDS_PAIRING,

    /** Paired, but Android won't deliver SMS to the app, so nothing moves. */
    NO_PERMISSION,

    /** Paired and allowed, but the last upload failed; WorkManager retries. */
    RETRYING,

    /** Working. */
    LIVE,
    ;

    companion object {
        /** Worst problem first: a phone that must re-pair can't be fixed by a permission. */
        fun derive(
            paired: Boolean,
            needsPairing: Boolean,
            hasSmsPermission: Boolean,
            lastError: String?,
        ): BridgeStatus = when {
            !paired -> NOT_PAIRED
            needsPairing -> NEEDS_PAIRING
            !hasSmsPermission -> NO_PERMISSION
            lastError != null -> RETRYING
            else -> LIVE
        }
    }
}
