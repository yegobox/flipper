package rw.flipper.smsbridge.ui

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsEnabled
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import com.github.takahirom.roborazzi.captureRoboImage
import com.github.takahirom.roborazzi.captureScreenRoboImage
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config
import org.robolectric.annotation.GraphicsMode
import rw.flipper.smsbridge.core.BridgeStatus
import rw.flipper.smsbridge.core.PairingPayload

/**
 * Renders every screen state on the JVM. Run with
 * `-Proborazzi.test.record=true` to write PNGs to
 * `app/build/outputs/roborazzi/` for review; without it the captures are
 * no-ops and only the behaviour checks run.
 */
@RunWith(RobolectricTestRunner::class)
@GraphicsMode(GraphicsMode.Mode.NATIVE)
@Config(sdk = [35], qualifiers = "w400dp-h1500dp-xxhdpi")
class BridgeScreensTest {
    @get:Rule
    val compose = createComposeRule()

    private val now = 1_760_000_000_000L
    private val paired = BridgeUi(
        status = BridgeStatus.LIVE,
        branchName = "Kigali Main",
        serverHost = "prod.api.yegobox.com",
        queued = 0,
        forwarded = 128,
        lastUploadAtMs = now - 2 * 60_000,
        lastCaughtAtMs = now - 3 * 60_000,
        lastSweptAtMs = now - 60_000,
        nowMs = now,
        hasSmsPermission = true,
        batteryExempt = true,
        versionName = "1.1.0",
    )

    private fun show(ui: BridgeUi, actions: BridgeActions = BridgeActions()) {
        compose.setContent { BridgeTheme { BridgeRoot(ui, actions) } }
    }

    private fun shot(name: String) = compose.onRoot().captureRoboImage("build/outputs/roborazzi/$name.png")

    @Test
    fun freshInstall() {
        show(BridgeUi(versionName = "1.1.0"))
        compose.onNodeWithText("Connect this phone to Flipper").assertIsDisplayed()
        compose.onNodeWithText("Allow SMS access").assertIsDisplayed()
        shot("setup_fresh")
    }

    @Test
    fun deniedPermissionExplainsRestrictedSettings() {
        show(BridgeUi(smsDenied = true, versionName = "1.1.0"))
        compose.onNodeWithText("Open App info").assertIsDisplayed()
        shot("setup_denied")
    }

    @Test
    fun readyToPairShowsWhereTheCodeIs() {
        show(BridgeUi(hasSmsPermission = true, batteryExempt = true, backfillDays = 7, versionName = "1.1.0"))
        compose.onNodeWithText("Where do I find the code?").performClick()
        compose.onNodeWithText("More → Settings → SMS Bridge → Pair a phone").assertIsDisplayed()
        compose.onNodeWithText("Admin Control → SMS Bridge → Pair a phone").assertIsDisplayed()
        shot("setup_ready")
    }

    @Test
    fun scanStartsTheScanner() {
        var scanned = false
        show(BridgeUi(hasSmsPermission = true), BridgeActions(scan = { scanned = true }))
        compose.onNodeWithText("Scan code").performClick()
        assertTrue(scanned)
    }

    @Test
    fun typedCodeIsGroupedAndPairsOnlyWhenComplete() {
        var paired: Pair<String, String>? = null
        show(
            BridgeUi(hasSmsPermission = true, batteryExempt = true),
            BridgeActions(pairWithCode = { code, url -> paired = code to url }),
        )
        compose.onNodeWithText("Enter code").performClick()
        compose.onNodeWithText("Pair phone").assertIsNotEnabled()
        compose.onNodeWithText("XXXXX-XXXXX").performTextInput("7k3qmz9tx")
        compose.onNodeWithText("7K3QM-Z9TX").assertIsDisplayed()
        compose.onNodeWithText("Pair phone").assertIsNotEnabled()
        compose.onNodeWithText("7K3QM-Z9TX").performTextInput("a")
        compose.onNodeWithText("7K3QM-Z9TXA").assertIsDisplayed()
        compose.onNodeWithText("Pair phone").assertIsEnabled()
        captureScreenRoboImage("build/outputs/roborazzi/enter_code.png")
        compose.onNodeWithText("Pair phone").performClick()
        assertEquals("7K3QMZ9TXA" to "https://prod.api.yegobox.com/", paired)
    }

    @Test
    fun aLinkFromFlipperAsksFirst() {
        var confirmed = false
        show(
            BridgeUi(
                hasSmsPermission = true,
                pendingLink = PairingPayload("https://prod.api.yegobox.com/", "7K3QMZ9TXA"),
            ),
            BridgeActions(confirmLink = { confirmed = true }),
        )
        compose.onNodeWithText("Pair with Flipper?").assertIsDisplayed()
        compose.onNodeWithText("prod.api.yegobox.com").assertIsDisplayed()
        captureScreenRoboImage("build/outputs/roborazzi/link_trusted.png")
        compose.onNodeWithText("Pair phone").performClick()
        assertTrue(confirmed)
    }

    @Test
    fun aLinkToAnotherServerIsFlagged() {
        show(BridgeUi(pendingLink = PairingPayload("https://sms.example.com/", "7K3QMZ9TXA")))
        compose.onNodeWithText("This is not a Flipper server. Only continue if your IT team set it up.")
            .assertIsDisplayed()
        captureScreenRoboImage("build/outputs/roborazzi/link_untrusted.png")
    }

    @Test
    fun live() {
        show(paired)
        compose.onNodeWithText("Forwarding to Kigali Main").assertIsDisplayed()
        compose.onNodeWithText("128").assertIsDisplayed()
        // What the phone itself saw, so a blocked broadcast is visible.
        compose.onNodeWithText("Last SMS caught: 3 min. ago · Inbox checked: 1 min. ago").assertIsDisplayed()
        shot("dashboard_live")
    }

    @Test
    fun retrying() {
        show(paired.copy(status = BridgeStatus.RETRYING, queued = 3, lastError = "No connection to Flipper; will retry."))
        compose.onNodeWithText("No connection to Flipper; will retry.").assertIsDisplayed()
        shot("dashboard_retrying")
    }

    @Test
    fun permissionLost() {
        show(paired.copy(status = BridgeStatus.NO_PERMISSION, hasSmsPermission = false, batteryExempt = false))
        compose.onNodeWithText("SMS access is off, so nothing is forwarded.").assertIsDisplayed()
        compose.onNodeWithText("Not forwarding to Kigali Main").assertIsDisplayed()
        shot("dashboard_no_permission")
    }

    @Test
    fun unpairedInFlipper() {
        show(paired.copy(status = BridgeStatus.NEEDS_PAIRING, queued = 5))
        compose.onNodeWithText("Pair this phone again").assertIsDisplayed()
        shot("dashboard_needs_pairing")
    }

    @Test
    fun findMissedAsksHowFarBack() {
        var days: Int? = null
        show(paired, BridgeActions(findMissed = { days = it }))
        compose.onNodeWithText("Find missed messages").performClick()
        compose.onNodeWithText("30 days").performClick()
        captureScreenRoboImage("build/outputs/roborazzi/find_missed.png")
        compose.onNodeWithText("Find").performClick()
        assertEquals(30, days)
    }

    @Test
    fun unpairAsksFirst() {
        var unpaired = false
        show(paired, BridgeActions(unpair = { unpaired = true }))
        compose.onNodeWithText("Unpair this phone").performClick()
        compose.onNodeWithText("Unpair this phone?").assertIsDisplayed()
        captureScreenRoboImage("build/outputs/roborazzi/unpair_confirm.png")
        assertTrue(!unpaired)
    }
}
