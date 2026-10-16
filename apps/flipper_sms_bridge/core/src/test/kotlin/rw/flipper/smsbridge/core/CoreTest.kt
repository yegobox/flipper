package rw.flipper.smsbridge.core

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNotEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class SenderAllowlistTest {
    @Test
    fun normalisationMatchesTheConnector() {
        // Same cases as `normalisation_ignores_case_spaces_and_dashes` in
        // data-connector/src/sms/senders.rs.
        assertEquals("MMONEY", SenderAllowlist.normalize("M-Money"))
        assertEquals("AIRTELMONEY", SenderAllowlist.normalize("  Airtel Money "))
        assertEquals("I&MBANK", SenderAllowlist.normalize("I&M Bank"))
    }

    @Test
    fun bankAndWalletSendersAreForwarded() {
        val list = SenderAllowlist.DEFAULT
        assertTrue(list.allows("BK"))
        assertTrue(list.allows("m-money"))
        assertTrue(list.allows("AirtelMoney"))
        assertTrue(list.allows("EQUITY BANK"))
    }

    @Test
    fun personalMessagesStayOnThePhone() {
        val list = SenderAllowlist.DEFAULT
        assertFalse(list.allows("+250780000000"))
        assertFalse(list.allows("Mum"))
        assertFalse(list.allows("MTN"))
        assertFalse(list.allows(""))
        assertFalse(list.allows(null))
    }

    @Test
    fun aServerListReplacesTheBuiltIns() {
        val list = SenderAllowlist(listOf("COGEBANQUE"))
        assertTrue(list.allows("Cogebanque"))
        assertFalse(list.allows("BK"))
    }
}

class MultipartJoinerTest {
    @Test
    fun partsFromOneSenderJoinInOrder() {
        val joined = MultipartJoiner.join(
            listOf(
                SmsPart("BK", "TRANSFER - EKASH Beneficiary: Jane DOE ", 2_000),
                SmsPart("BK", "Amount:RWF 2000.00", 2_001),
            ),
        )
        assertEquals(1, joined.size)
        assertEquals("TRANSFER - EKASH Beneficiary: Jane DOE Amount:RWF 2000.00", joined[0].body)
        assertEquals(2_000, joined[0].receivedAtMs)
    }

    @Test
    fun twoSendersInOneBroadcastStayApart() {
        val joined = MultipartJoiner.join(
            listOf(
                SmsPart("BK", "one", 1),
                SmsPart("M-Money", "two", 2),
                SmsPart("BK", " more", 3),
            ),
        )
        assertEquals(listOf("BK" to "one more", "M-Money" to "two"), joined.map { it.sender to it.body })
    }

    @Test
    fun emptyAndSenderlessPartsAreDropped() {
        val joined = MultipartJoiner.join(
            listOf(SmsPart(null, "x", 1), SmsPart("BK", "  ", 2), SmsPart(" ", "y", 3)),
        )
        assertTrue(joined.isEmpty())
    }
}

class PairingPayloadTest {
    @Test
    fun aFlipperQrParses() {
        val p = PairingPayload.parse(
            "flipper-sms-bridge://pair?v=1&url=https%3A%2F%2Fprod.api.yegobox.com&code=7k3qm-z9txa",
        )
        assertEquals(PairingPayload("https://prod.api.yegobox.com/", "7K3QMZ9TXA"), p)
    }

    @Test
    fun plainHttpIsRefusedExceptForALocalConnector() {
        assertNull(PairingPayload.normalizeUrl("http://prod.api.yegobox.com"))
        assertEquals("http://10.0.2.2:8084/", PairingPayload.normalizeUrl("http://10.0.2.2:8084"))
    }

    @Test
    fun otherQrCodesAreNotPairingCodes() {
        assertNull(PairingPayload.parse("https://example.com/?code=7K3QMZ9TXA"))
        assertNull(PairingPayload.parse("flipper-sms-bridge://pair?url=https%3A%2F%2Fa.b&code=SHORT"))
        assertNull(PairingPayload.parse("flipper-sms-bridge://pair?code=7K3QMZ9TXA"))
        assertNull(PairingPayload.parse("not a uri at all %%%"))
    }

    @Test
    fun typedCodesNormaliseLikeTheConnector() {
        assertEquals("00111", PairingPayload.normalizeCode(" 0oIl1 "))
    }

    @Test
    fun codesAreShownInTwoHalvesAsTheyAreTyped() {
        assertEquals("", PairingPayload.formatCode(""))
        assertEquals("7K3QM", PairingPayload.formatCode("7k3qm"))
        assertEquals("7K3QM-Z", PairingPayload.formatCode("7k3qmz"))
        assertEquals("7K3QM-Z9TXA", PairingPayload.formatCode("7K3QM-Z9TXA"))
        // Pasting with spaces or extra characters still gives one clean code.
        assertEquals("7K3QM-Z9TXA", PairingPayload.formatCode(" 7k3qm z9txa 99 "))
    }

    @Test
    fun onlyFlipperServersAreTrusted() {
        assertTrue(PairingPayload.isFlipperServer("https://prod.api.yegobox.com/"))
        assertTrue(PairingPayload.isFlipperServer("https://yegobox.com/"))
        assertFalse(PairingPayload.isFlipperServer("https://yegobox.com.evil.example/"))
        assertFalse(PairingPayload.isFlipperServer("https://notyegobox.com/"))
        assertFalse(PairingPayload.isFlipperServer("http://10.0.2.2:8084/"))
        assertFalse(PairingPayload.isFlipperServer("%%%"))
    }

    @Test
    fun theHostIsShownWithoutTheScheme() {
        assertEquals("prod.api.yegobox.com", PairingPayload.hostOf("https://prod.api.yegobox.com/"))
    }
}

class BridgeStatusTest {
    @Test
    fun theWorstProblemWins() {
        assertEquals(BridgeStatus.NOT_PAIRED, BridgeStatus.derive(false, true, false, "x"))
        assertEquals(BridgeStatus.NEEDS_PAIRING, BridgeStatus.derive(true, true, false, "x"))
        assertEquals(BridgeStatus.NO_PERMISSION, BridgeStatus.derive(true, false, false, "x"))
        assertEquals(BridgeStatus.RETRYING, BridgeStatus.derive(true, false, true, "offline"))
        assertEquals(BridgeStatus.LIVE, BridgeStatus.derive(true, false, true, null))
    }
}

class UploadPolicyTest {
    @Test
    fun onlyFinalStatusesDeleteARow() {
        val outcome = UploadPolicy.classify(
            listOf(1L, 2L, 3L, 4L, 5L),
            mapOf("1" to "stored", "2" to "duplicate", "3" to "ignored", "4" to "error"),
        )
        assertEquals(setOf(1L, 2L, 3L), outcome.delivered)
        // 5 got no answer at all: kept, never assumed delivered.
        assertEquals(setOf(4L, 5L), outcome.failed)
        // Only a newly stored message counts as "sent".
        assertEquals(setOf(1L), outcome.stored)
    }
}

class InboxSweepTest {
    private val now = 1_800_000_000_000L
    private val hour = 60 * 60 * 1000L

    @Test
    fun aFreshInstallLooksTwoDaysBack() {
        assertEquals(now - 48 * hour, InboxSweep.since(null, now))
        assertEquals(now - 48 * hour, InboxSweep.since(0, now))
    }

    @Test
    fun laterRunsStartJustBeforeTheWatermark() {
        assertEquals(now - hour - InboxSweep.OVERLAP_MS, InboxSweep.since(now - hour, now))
    }

    @Test
    fun newOnlyStillCoversTheMinutesSpentPairing() {
        // A bank SMS that lands while the user scans the QR used to be lost.
        assertEquals(now - 2 * hour, InboxSweep.pairingSince(0, now))
        assertEquals(now - 7 * 24 * hour, InboxSweep.pairingSince(7, now))
        assertEquals(now - 2 * hour, InboxSweep.pairingSince(-3, now))
    }

    @Test
    fun theReceiverAndTheInboxAgreeOnOneMessage() {
        // Synthetic BK layout. The joiner and the inbox can space it differently.
        val joined = "TRANSFER - EKASH Beneficiary: Jane DOE  Amount:RWF 2000.00\n"
        val inbox = "TRANSFER - EKASH Beneficiary: Jane DOE Amount:RWF 2000.00"
        assertEquals(InboxSweep.dedupeKey("BK", joined), InboxSweep.dedupeKey("bk", inbox))
        assertNotEquals(
            InboxSweep.dedupeKey("BK", inbox),
            InboxSweep.dedupeKey("BK", inbox.replace("2000.00", "2500.00")),
        )
        assertNotEquals(InboxSweep.dedupeKey("BK", inbox), InboxSweep.dedupeKey("MoMo", inbox))
    }
}
