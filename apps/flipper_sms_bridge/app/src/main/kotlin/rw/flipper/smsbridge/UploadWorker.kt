package rw.flipper.smsbridge

import android.content.Context
import androidx.work.BackoffPolicy
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
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

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val creds = CredentialStore(applicationContext)
        val state = BridgeState(applicationContext)
        val queue = SmsQueue.get(applicationContext)
        var current = creds.load() ?: return@withContext Result.success()

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
                state.forwardedCount = state.forwardedCount + outcome.delivered.size
                state.lastUploadAtMs = System.currentTimeMillis()
                if (outcome.failed.isNotEmpty()) {
                    queue.recordFailure(outcome.failed, UploadPolicy.MAX_ATTEMPTS)
                    state.lastError = "The server could not store ${outcome.failed.size} message(s); retrying."
                    return@withContext Result.retry()
                }
            }
            state.lastError = null
            Result.success()
        } catch (e: ApiException) {
            if (e.status == 401 || e.status == 403) {
                // Revoked in Flipper, or the refresh token was refused. Retrying
                // cannot fix that; keep the queue and ask for a new pairing.
                state.needsPairing = true
                state.lastError = "This phone was unpaired. Pair it again from Flipper."
                Result.failure()
            } else {
                state.lastError = e.message
                Result.retry()
            }
        } catch (e: IOException) {
            state.lastError = "No connection to Flipper (${e.javaClass.simpleName}); will retry."
            Result.retry()
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

        private val network = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        /**
         * Upload now (or as soon as there is a network). Appends behind a
         * running upload rather than replacing it, so a message that arrives
         * mid-upload is picked up right after.
         */
        fun enqueue(context: Context) {
            val request = OneTimeWorkRequestBuilder<UploadWorker>()
                .setConstraints(network)
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 30, TimeUnit.SECONDS)
                .build()
            WorkManager.getInstance(context)
                .enqueueUniqueWork(UNIQUE, ExistingWorkPolicy.APPEND_OR_REPLACE, request)
        }

        /** Safety net: a sweep every few hours, in case a trigger was missed. */
        fun schedulePeriodic(context: Context) {
            val request = PeriodicWorkRequestBuilder<UploadWorker>(3, TimeUnit.HOURS)
                .setConstraints(network)
                .build()
            WorkManager.getInstance(context)
                .enqueueUniquePeriodicWork(PERIODIC, ExistingPeriodicWorkPolicy.KEEP, request)
        }

        fun cancelAll(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(UNIQUE)
            WorkManager.getInstance(context).cancelUniqueWork(PERIODIC)
        }
    }
}
