package rw.flipper.smsbridge

import android.app.Application

class BridgeApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // Re-arm the safety-net sweep after an update or a reboot that
        // cleared it, and flush anything still queued.
        if (CredentialStore(this).load() != null) {
            UploadWorker.schedulePeriodic(this)
            if (SmsQueue.get(this).size() > 0) UploadWorker.enqueue(this)
        }
    }
}
