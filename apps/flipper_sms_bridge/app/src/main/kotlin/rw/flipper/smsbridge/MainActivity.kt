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
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.runtime.getValue
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import rw.flipper.smsbridge.core.PairingPayload
import rw.flipper.smsbridge.ui.BridgeActions
import rw.flipper.smsbridge.ui.BridgeRoot
import rw.flipper.smsbridge.ui.BridgeTheme

/**
 * One screen: a setup checklist until the phone is paired (scan Flipper's
 * QR, type the code, or accept a `flipper-sms-bridge://pair` link from
 * Flipper on this phone), then a status dashboard with the switches Android
 * hides away (SMS permission, battery optimisation).
 */
class MainActivity : ComponentActivity() {
    private val vm: BridgeViewModel by viewModels()

    private val requestPermissions =
        registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { result ->
            vm.onSmsPermissionResult(result[Manifest.permission.RECEIVE_SMS] == true)
        }

    private val scan = registerForActivityResult(ScanContract()) { result ->
        val raw = result.contents ?: return@registerForActivityResult
        val payload = PairingPayload.parse(raw)
        if (payload == null) vm.showError(getString(R.string.pair_bad_qr)) else vm.pair(payload)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)

        val actions = BridgeActions(
            allowSms = ::askForPermissions,
            openAppInfo = {
                startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName")))
            },
            allowBackground = ::askToIgnoreBatteryOptimisation,
            setBackfill = vm::setBackfill,
            scan = {
                scan.launch(
                    ScanOptions()
                        .setDesiredBarcodeFormats(ScanOptions.QR_CODE)
                        .setPrompt(getString(R.string.pair_scan_prompt))
                        .setBeepEnabled(false)
                        .setOrientationLocked(false),
                )
            },
            pairWithCode = vm::pairWithCode,
            clearPairError = vm::clearPairError,
            confirmLink = vm::confirmLink,
            dismissLink = vm::dismissLink,
            sendNow = vm::sendNow,
            unpair = vm::unpair,
            noticeShown = vm::noticeShown,
        )
        setContent {
            val ui by vm.ui.collectAsStateWithLifecycle()
            BridgeTheme { BridgeRoot(ui, actions) }
        }

        // A fresh launch from a link; a rotation must not offer it again.
        if (savedInstanceState == null) handleLink(intent)
        if (!hasSmsPermission()) askForPermissions()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleLink(intent)
    }

    override fun onResume() {
        super.onResume()
        vm.refresh()
    }

    private fun handleLink(intent: Intent?) {
        if (intent?.action != Intent.ACTION_VIEW) return
        val payload = intent.dataString?.let(PairingPayload::parse)
        if (payload == null) vm.showError(getString(R.string.pair_bad_qr)) else vm.offerLink(payload)
    }

    private fun hasSmsPermission(): Boolean =
        checkSelfPermission(Manifest.permission.RECEIVE_SMS) == PackageManager.PERMISSION_GRANTED

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
}
