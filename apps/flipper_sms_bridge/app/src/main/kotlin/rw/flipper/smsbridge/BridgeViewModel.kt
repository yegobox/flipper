package rw.flipper.smsbridge

import android.Manifest
import android.app.Application
import android.content.pm.PackageManager
import android.os.Build
import android.os.PowerManager
import androidx.core.content.ContextCompat
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.work.WorkManager
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import rw.flipper.smsbridge.core.BridgeStatus
import rw.flipper.smsbridge.core.InboxSweep
import rw.flipper.smsbridge.core.PairingPayload
import rw.flipper.smsbridge.ui.BridgeUi
import java.io.IOException

/**
 * Reads the bridge's stored state into a [BridgeUi] and runs pairing. The
 * screen re-reads on resume and whenever the upload worker changes state, so
 * the counts move while you watch.
 */
class BridgeViewModel(app: Application) : AndroidViewModel(app) {
    private val creds = CredentialStore(app)
    private val state = BridgeState(app)

    private val _ui = MutableStateFlow(
        BridgeUi(defaultServerUrl = DEFAULT_CONNECTOR_URL, versionName = BuildConfig.VERSION_NAME),
    )
    val ui: StateFlow<BridgeUi> = _ui.asStateFlow()

    init {
        refresh()
        viewModelScope.launch {
            WorkManager.getInstance(app).getWorkInfosForUniqueWorkFlow(UploadWorker.UNIQUE).collect { refresh() }
        }
        // Keeps "Last sent: 2 min ago" honest without a refresh.
        viewModelScope.launch {
            while (true) {
                delay(30_000)
                _ui.update { it.copy(nowMs = System.currentTimeMillis()) }
            }
        }
    }

    fun refresh() {
        viewModelScope.launch {
            val app = getApplication<Application>()
            // The credential store decrypts with the Keystore: off the main thread.
            val snapshot = withContext(Dispatchers.IO) {
                val c = creds.load()
                val hasSms = hasPermission(Manifest.permission.RECEIVE_SMS)
                Snapshot(
                    status = BridgeStatus.derive(c != null, state.needsPairing, hasSms, state.lastError),
                    branchName = c?.branchName ?: c?.branchId,
                    serverHost = c?.connectorUrl?.let(PairingPayload::hostOf),
                    lastError = state.lastError,
                    queued = SmsQueue.get(app).size(),
                    forwarded = state.forwardedCount,
                    lastUploadAtMs = state.lastUploadAtMs,
                    lastCaughtAtMs = state.lastCaughtAtMs,
                    lastSweptAtMs = state.lastSweptAtMs,
                    hasSms = hasSms,
                    batteryExempt = app.getSystemService(PowerManager::class.java)
                        .isIgnoringBatteryOptimizations(app.packageName),
                )
            }
            _ui.update {
                it.copy(
                    status = snapshot.status,
                    branchName = snapshot.branchName,
                    serverHost = snapshot.serverHost,
                    lastError = snapshot.lastError,
                    queued = snapshot.queued,
                    forwarded = snapshot.forwarded,
                    lastUploadAtMs = snapshot.lastUploadAtMs,
                    lastCaughtAtMs = snapshot.lastCaughtAtMs,
                    lastSweptAtMs = snapshot.lastSweptAtMs,
                    nowMs = System.currentTimeMillis(),
                    hasSmsPermission = snapshot.hasSms,
                    batteryExempt = snapshot.batteryExempt,
                )
            }
        }
    }

    /**
     * Opening the app sweeps the inbox: anything the phone failed to hand
     * the receiver goes up now rather than at the next periodic run.
     */
    fun onResume() {
        val app = getApplication<Application>()
        viewModelScope.launch {
            val paired = withContext(Dispatchers.IO) { creds.load() != null }
            if (paired) UploadWorker.enqueue(app)
            refresh()
        }
    }

    fun onSmsPermissionResult(granted: Boolean) {
        if (!granted) _ui.update { it.copy(smsDenied = true) }
        refresh()
    }

    fun setBackfill(days: Int) = _ui.update { it.copy(backfillDays = days) }

    fun clearPairError() = _ui.update { it.copy(pairError = null) }

    fun noticeShown() = _ui.update { it.copy(notice = null) }

    fun showError(message: String) = _ui.update { it.copy(pairError = message) }

    /** A pairing link arrived (deep link): ask before using it. */
    fun offerLink(payload: PairingPayload) = _ui.update { it.copy(pendingLink = payload, pairError = null) }

    fun dismissLink() = _ui.update { it.copy(pendingLink = null, pairError = null) }

    fun confirmLink() {
        val link = _ui.value.pendingLink ?: return
        pair(link)
    }

    fun pairWithCode(code: String, serverUrl: String) {
        val url = PairingPayload.normalizeUrl(serverUrl)
        val normalized = PairingPayload.normalizeCode(code)
        if (url == null || normalized.length != PairingPayload.CODE_LENGTH) {
            showError(getApplication<Application>().getString(R.string.pair_bad_qr))
        } else {
            pair(PairingPayload(url, normalized))
        }
    }

    fun pair(payload: PairingPayload) {
        if (_ui.value.pairing) return
        _ui.update { it.copy(pairing = true, pairError = null) }
        val days = _ui.value.backfillDays
        val app = getApplication<Application>()
        viewModelScope.launch {
            val result: Result<Int> = withContext(Dispatchers.IO) {
                try {
                    val grant = ConnectorApi.claim(payload.connectorUrl, payload.code, state.installId(), Build.MODEL)
                    val previous = creds.load()
                    // Queued SMS belong to the branch they were captured for.
                    if (previous != null && previous.branchId != grant.branchId) {
                        SmsQueue.get(app).clear()
                    }
                    creds.save(
                        Credentials(
                            connectorUrl = payload.connectorUrl,
                            deviceId = grant.deviceId,
                            businessId = grant.businessId.orEmpty(),
                            branchId = grant.branchId.orEmpty(),
                            branchName = grant.branchName,
                            refreshToken = grant.refreshToken,
                            accessToken = grant.accessToken,
                            accessExpiresAtMs = System.currentTimeMillis() + grant.expiresInSec * 1000,
                        ),
                    )
                    state.resetStatus()
                    UploadWorker.schedulePeriodic(app)
                    // "New only" still reaches back a little: an SMS that
                    // landed while pairing was dropped by the receiver.
                    val now = System.currentTimeMillis()
                    val queued = Backfill.run(app, InboxSweep.pairingSince(days, now)).queued
                    state.sweptThroughMs = now
                    UploadWorker.enqueue(app)
                    Result.success(queued)
                } catch (e: CancellationException) {
                    throw e
                } catch (e: Exception) {
                    // Not only IOException: a malformed claim response or a
                    // provider error in the backfill must still clear the
                    // spinner, not escape the coroutine and crash the app.
                    Result.failure(e)
                }
            }
            result.fold(
                onSuccess = { queued ->
                    val notice = if (queued > 0) {
                        app.resources.getQuantityString(R.plurals.paired_backfill, queued, queued)
                    } else {
                        app.getString(R.string.paired)
                    }
                    _ui.update { it.copy(pairing = false, pendingLink = null, notice = notice) }
                },
                onFailure = { e ->
                    _ui.update { it.copy(pairing = false, pairError = pairErrorMessage(e)) }
                },
            )
            refresh()
        }
    }

    fun sendNow() {
        val app = getApplication<Application>()
        UploadWorker.enqueue(app)
        _ui.update { it.copy(notice = app.getString(R.string.sending)) }
    }

    /** Re-reads the inbox, e.g. for an SMS that arrived before this version. */
    fun findMissed(days: Int) {
        val app = getApplication<Application>()
        viewModelScope.launch {
            val queued = withContext(Dispatchers.IO) {
                val since = System.currentTimeMillis() - days * 24L * 60 * 60 * 1000
                Backfill.run(app, since).queued
            }
            if (queued > 0) UploadWorker.enqueue(app)
            val notice = if (queued > 0) {
                app.resources.getQuantityString(R.plurals.missed_found, queued, queued)
            } else {
                app.getString(R.string.missed_none)
            }
            _ui.update { it.copy(notice = notice) }
            refresh()
        }
    }

    fun unpair() {
        val app = getApplication<Application>()
        UploadWorker.cancelAll(app)
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                SmsQueue.get(app).clear()
                creds.clear()
                state.resetStatus()
            }
            refresh()
        }
    }

    private fun pairErrorMessage(e: Throwable): String {
        val app = getApplication<Application>()
        return when {
            e is ApiException && (e.status == 401 || e.status == 404 || e.status == 410) ->
                app.getString(R.string.pair_error_code)
            e is ApiException && e.status == 429 -> app.getString(R.string.pair_error_throttled)
            e is ApiException -> app.getString(R.string.pair_failed, e.message ?: "HTTP ${e.status}")
            e is IOException -> app.getString(R.string.pair_error_offline)
            else -> app.getString(R.string.pair_failed, e.message ?: e.javaClass.simpleName)
        }
    }

    private fun hasPermission(permission: String): Boolean =
        ContextCompat.checkSelfPermission(getApplication(), permission) == PackageManager.PERMISSION_GRANTED

    private data class Snapshot(
        val status: BridgeStatus,
        val branchName: String?,
        val serverHost: String?,
        val lastError: String?,
        val queued: Int,
        val forwarded: Long,
        val lastUploadAtMs: Long,
        val lastCaughtAtMs: Long,
        val lastSweptAtMs: Long,
        val hasSms: Boolean,
        val batteryExempt: Boolean,
    )

    companion object {
        /** Production connector, the same default Flipper uses (`kDataConnectorFallbackBaseUrl`). */
        const val DEFAULT_CONNECTOR_URL = "https://prod.api.yegobox.com/"
    }
}
