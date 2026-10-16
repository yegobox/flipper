package rw.flipper.smsbridge

import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.ForegroundInfo
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import rw.flipper.smsbridge.core.UploadPolicy
import java.io.IOException
import java.util.concurrent.TimeUnit

/**
 * Drains the queue to the connector, refreshing the access token as needed.
 *
 * Runs as unique work, so only one upload (and therefore one refresh-token
 * rotation) is ever in flight: two concurrent refreshes would present a used
 * token, which the connector treats as theft and answers by revoking the
 * phone.
 */
class UploadWorker(context: Context, params: WorkerParameters) : CoroutineWorker(context, params) {

    // A fresh SMS REPLACEs the unique work (see [enqueue]), and the body is
    // blocking, so a cancelled run keeps going until it returns. The lock
    // keeps it and its replacement from rotating the refresh token at once.
    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        synchronized(RUN_LOCK) { runOnce() }
    }

    private fun runOnce(): Result {
        val creds = CredentialStore(applicationContext)
        val state = BridgeState(applicationContext)
        val queue = SmsQueue.get(applicationContext)
        var current = creds.load() ?: return Result.success()
        // SMS the receiver missed (it arrived while pairing, or the phone
        // never woke the receiver) are still in the inbox.
        Backfill.sweep(applicationContext)

        try {
            current = ensureAccess(current, creds)
            refreshSendersIfStale(current, state)

            while (true) {
                val batch = queue.next(UploadPolicy.MAX_BATCH)
                if (batch.isEmpty()) break
                val statuses = try {
                    ConnectorApi.upload(current.connectorUrl, current.accessToken!!, batch)
                } catch (e: ApiException) {
                    if (e.status != 401) throw e
                    // The access token may have been refused early (clock skew,
                    // server restart). Refresh once; if the refresh is refused
                    // too, the phone really was unpaired.
                    current = ensureAccess(current.copy(accessToken = null), creds)
                    ConnectorApi.upload(current.connectorUrl, current.accessToken!!, batch)
                }
                val outcome = UploadPolicy.classify(batch.map { it.id }, statuses)
                queue.delete(outcome.delivered)
                state.forwardedCount = state.forwardedCount + outcome.stored.size
                state.lastUploadAtMs = System.currentTimeMillis()
                if (outcome.failed.isNotEmpty()) {
                    queue.recordFailure(outcome.failed, UploadPolicy.MAX_ATTEMPTS)
                    state.lastError = "The server could not store ${outcome.failed.size} message(s); retrying."
                    return Result.retry()
                }
            }
            state.lastError = null
            return Result.success()
        } catch (e: ApiException) {
            if (e.status == 401 || e.status == 403) {
                // Revoked in Flipper, or the refresh token was refused. Retrying
                // cannot fix that; keep the queue and ask for a new pairing.
                state.needsPairing = true
                state.lastError = "This phone was unpaired. Pair it again from Flipper."
                return Result.failure()
            }
            state.lastError = e.message
            return Result.retry()
        } catch (e: IOException) {
            state.lastError = "No connection to Flipper (${e.javaClass.simpleName}); will retry."
            return Result.retry()
        }
    }

    /**
     * Expedited runs need this on Android 11 and older, where WorkManager
     * shows them as a short foreground service. Newer versions never call it.
     */
    override suspend fun getForegroundInfo(): ForegroundInfo {
        val notification = NotificationCompat.Builder(applicationContext, BridgeApp.CHANNEL_SENDING)
            .setSmallIcon(android.R.drawable.stat_notify_sync)
            .setContentTitle(applicationContext.getString(R.string.notify_sending))
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .build()
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ForegroundInfo(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            ForegroundInfo(NOTIFICATION_ID, notification)
        }
    }

    /** Returns credentials with a usable access token, rotating the refresh token if needed. */
    private fun ensureAccess(c: Credentials, store: CredentialStore): Credentials {
        val fresh = c.accessToken != null && c.accessExpiresAtMs - SKEW_MS > System.currentTimeMillis()
        if (fresh) return c
        val grant = ConnectorApi.refresh(c.connectorUrl, c.refreshToken)
        val next = c.copy(
            refreshToken = grant.refreshToken,
            accessToken = grant.accessToken,
            accessExpiresAtMs = System.currentTimeMillis() + grant.expiresInSec * 1000,
        )
        // Persist before use: the old refresh token is already dead.
        store.save(next)
        return next
    }

    private fun refreshSendersIfStale(c: Credentials, state: BridgeState) {
        if (System.currentTimeMillis() - state.sendersFetchedAtMs() < SENDERS_TTL_MS) return
        try {
            state.saveSenders(ConnectorApi.senders(c.connectorUrl, c.accessToken!!))
        } catch (_: IOException) {
            // Keep the cached list; uploads matter more than the refresh.
        }
    }

    companion object {
        /** Unique name of the upload chain; the status screen watches it. */
        const val UNIQUE = "sms-upload"
        private const val PERIODIC = "sms-upload-periodic"
        private const val SKEW_MS = 2 * 60 * 1000L
        private const val SENDERS_TTL_MS = 6 * 60 * 60 * 1000L
        private const val NOTIFICATION_ID = 7101
        private val RUN_LOCK = Any()

        private val network = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        /**
         * Upload now (or as soon as there is a network). Appends behind a
         * running upload rather than replacing it, so a message that arrives
         * mid-upload is picked up right after.
         *
         * [expedited] for a fresh SMS: it runs at once even when Android has
         * put a rarely opened app in a restricted standby bucket, where plain
         * work can wait for hours. Out of quota, it falls back to plain work.
         * It REPLACEs rather than appends, so it never waits behind a plain
         * upload that is itself being held back; every run drains the whole
         * queue, so nothing the replaced run would have sent is lost.
         */
        fun enqueue(context: Context, expedited: Boolean = false) {
            val request = OneTimeWorkRequestBuilder<UploadWorker>()
                .setConstraints(network)
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 30, TimeUnit.SECONDS)
                .apply { if (expedited) setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST) }
                .build()
            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    UNIQUE,
                    if (expedited) ExistingWorkPolicy.REPLACE else ExistingWorkPolicy.APPEND_OR_REPLACE,
                    request,
                )
        }

        /**
         * Safety net: every run sweeps the inbox, so an SMS whose broadcast
         * never arrived (some phones block it for sideloaded apps) still goes
         * up within about 15 minutes, the shortest period Android allows.
         * UPDATE, so phones paired with the old 3-hour period move to this.
         */
        fun schedulePeriodic(context: Context) {
            val request = PeriodicWorkRequestBuilder<UploadWorker>(15, TimeUnit.MINUTES)
                .setConstraints(network)
                .build()
            WorkManager.getInstance(context)
                .enqueueUniquePeriodicWork(PERIODIC, ExistingPeriodicWorkPolicy.UPDATE, request)
        }

        fun cancelAll(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(UNIQUE)
            WorkManager.getInstance(context).cancelUniqueWork(PERIODIC)
        }
    }
}
