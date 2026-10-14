package rw.flipper.smsbridge

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.text.format.DateUtils
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import rw.flipper.smsbridge.core.PairingPayload
import rw.flipper.smsbridge.databinding.ActivityMainBinding
import java.io.IOException

/**
 * One screen: pair (scan Flipper's QR, or type the code), then a status view
 * with the queue, the last upload, and the switches Android hides away
 * (SMS permission, battery optimisation).
 */
class MainActivity : AppCompatActivity() {
    private lateinit var ui: ActivityMainBinding
    private lateinit var creds: CredentialStore
    private lateinit var state: BridgeState

    private val requestPermissions =
        registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { render() }

    private val scan = registerForActivityResult(ScanContract()) { result ->
        val raw = result.contents ?: return@registerForActivityResult
        val payload = PairingPayload.parse(raw)
        if (payload == null) {
            ui.message.text = getString(R.string.pair_bad_qr)
        } else {
            pair(payload)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ui = ActivityMainBinding.inflate(layoutInflater)
        setContentView(ui.root)
        creds = CredentialStore(this)
        state = BridgeState(this)

        ui.urlInput.setText(DEFAULT_CONNECTOR_URL)
        ui.grantButton.setOnClickListener { askForPermissions() }
        ui.appInfoButton.setOnClickListener {
            startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName")))
        }
        ui.scanButton.setOnClickListener {
            scan.launch(
                ScanOptions()
                    .setDesiredBarcodeFormats(ScanOptions.QR_CODE)
                    .setPrompt(getString(R.string.pair_how))
                    .setBeepEnabled(false)
                    .setOrientationLocked(false),
            )
        }
        ui.manualToggle.setOnClickListener {
            ui.manualSection.visibility =
                if (ui.manualSection.visibility == View.VISIBLE) View.GONE else View.VISIBLE
        }
        ui.manualSubmit.setOnClickListener {
            val url = PairingPayload.normalizeUrl(ui.urlInput.text.toString())
            val code = PairingPayload.normalizeCode(ui.codeInput.text.toString())
            if (url == null || code.length != PairingPayload.CODE_LENGTH) {
                ui.message.text = getString(R.string.pair_bad_qr)
            } else {
                pair(PairingPayload(url, code))
            }
        }
        ui.sendNow.setOnClickListener {
            UploadWorker.enqueue(this)
            ui.message.text = ""
        }
        ui.batteryButton.setOnClickListener { askToIgnoreBatteryOptimisation() }
        ui.unpairButton.setOnClickListener { confirmUnpair() }

        if (!hasSmsPermission()) askForPermissions()
    }

    override fun onResume() {
        super.onResume()
        render()
    }

    private fun hasSmsPermission(): Boolean =
        ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS) ==
            PackageManager.PERMISSION_GRANTED

    private fun askForPermissions() {
        val wanted = mutableListOf(Manifest.permission.RECEIVE_SMS, Manifest.permission.READ_SMS)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            wanted += Manifest.permission.POST_NOTIFICATIONS
        }
        requestPermissions.launch(wanted.toTypedArray())
    }

    @SuppressLint("BatteryLife")
    private fun askToIgnoreBatteryOptimisation() {
        val power = getSystemService(PowerManager::class.java)
        if (power.isIgnoringBatteryOptimizations(packageName)) {
            startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
        } else {
            // A sideloaded utility whose whole job is background delivery: the
            // direct request is the honest ask, and there is no Play policy here.
            startActivity(
                Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Uri.parse("package:$packageName")),
            )
        }
    }

    private fun backfillDays(): Int = when (ui.backfillGroup.checkedRadioButtonId) {
        R.id.backfill7 -> 7
        R.id.backfill30 -> 30
        else -> 0
    }

    private fun pair(payload: PairingPayload) {
        ui.message.text = getString(R.string.pairing)
        setPairingEnabled(false)
        val days = backfillDays()
        lifecycleScope.launch {
            val message = withContext(Dispatchers.IO) {
                try {
                    val grant = ConnectorApi.claim(
                        payload.connectorUrl,
                        payload.code,
                        state.installId(),
                        Build.MODEL,
                    )
                    val previous = creds.load()
                    // Queued SMS belong to the branch they were captured for.
                    if (previous != null && previous.branchId != grant.branchId) {
                        SmsQueue.get(this@MainActivity).clear()
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
                    UploadWorker.schedulePeriodic(this@MainActivity)
                    val canReadInbox = ContextCompat.checkSelfPermission(
                        this@MainActivity, Manifest.permission.READ_SMS,
                    ) == PackageManager.PERMISSION_GRANTED
                    val queued = if (canReadInbox) Backfill.run(this@MainActivity, days) else 0
                    UploadWorker.enqueue(this@MainActivity)
                    getString(R.string.paired_backfill, queued)
                } catch (e: IOException) {
                    getString(R.string.pair_failed, e.message ?: e.javaClass.simpleName)
                }
            }
            ui.message.text = message
            setPairingEnabled(true)
            render()
        }
    }

    private fun setPairingEnabled(enabled: Boolean) {
        ui.scanButton.isEnabled = enabled
        ui.manualSubmit.isEnabled = enabled
    }

    private fun confirmUnpair() {
        AlertDialog.Builder(this)
            .setMessage(R.string.unpair_confirm)
            .setNegativeButton(R.string.cancel, null)
            .setPositiveButton(R.string.unpair) { _, _ ->
                UploadWorker.cancelAll(this)
                SmsQueue.get(this).clear()
                creds.clear()
                state.resetStatus()
                render()
            }
            .show()
    }

    private fun render() {
        ui.permissionSection.visibility = if (hasSmsPermission()) View.GONE else View.VISIBLE
        val c = creds.load()
        val paired = c != null && !state.needsPairing
        ui.pairSection.visibility = if (paired) View.GONE else View.VISIBLE
        ui.statusSection.visibility = if (c != null) View.VISIBLE else View.GONE
        if (c == null) return

        ui.postingTo.text = getString(R.string.status_posting_to, c.branchName ?: c.branchId)
        ui.health.text = when {
            state.needsPairing -> getString(R.string.status_needs_pairing)
            state.lastError != null -> state.lastError
            else -> getString(R.string.status_ok)
        }
        ui.health.setTextColor(
            ContextCompat.getColor(
                this,
                when {
                    state.needsPairing -> R.color.danger
                    state.lastError != null -> R.color.warn
                    else -> R.color.ok
                },
            ),
        )
        ui.queueCount.text = getString(R.string.status_queue, SmsQueue.get(this).size())
        ui.forwardedCount.text = getString(R.string.status_forwarded, state.forwardedCount.toInt())
        val last = state.lastUploadAtMs
        ui.lastUpload.text = getString(
            R.string.status_last_upload,
            if (last == 0L) getString(R.string.status_never) else DateUtils.getRelativeTimeSpanString(last),
        )
    }

    private companion object {
        /** Production connector, the same default Flipper uses (`kDataConnectorFallbackBaseUrl`). */
        const val DEFAULT_CONNECTOR_URL = "https://prod.api.yegobox.com/"
    }
}
