package rw.flipper.smsbridge

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager

class BridgeApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // Shown only while an expedited upload runs on Android 11 and older.
        getSystemService(NotificationManager::class.java).createNotificationChannel(
            NotificationChannel(CHANNEL_SENDING, getString(R.string.notify_channel), NotificationManager.IMPORTANCE_LOW),
        )
        // Re-arm the safety-net sweep after an update or a reboot that
        // cleared it, and flush anything still queued.
        if (CredentialStore(this).load() != null) {
            UploadWorker.schedulePeriodic(this)
            if (SmsQueue.get(this).size() > 0) UploadWorker.enqueue(this)
        }
    }

    companion object {
        const val CHANNEL_SENDING = "sending"
    }
}
