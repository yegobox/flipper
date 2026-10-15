package rw.flipper.smsbridge.ui

import android.text.format.DateUtils
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Send
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SegmentedButton
import androidx.compose.material3.SegmentedButtonDefaults
import androidx.compose.material3.SingleChoiceSegmentedButtonRow
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch
import rw.flipper.smsbridge.R
import rw.flipper.smsbridge.core.BridgeStatus

/** The whole app: setup until paired, then the status dashboard. */
@Composable
fun BridgeRoot(ui: BridgeUi, actions: BridgeActions) {
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    LaunchedEffect(ui.notice) {
        val notice = ui.notice ?: return@LaunchedEffect
        scope.launch { snackbar.showSnackbar(notice) }
        actions.noticeShown()
    }
    Scaffold(
        containerColor = Bridge.surface,
        snackbarHost = { SnackbarHost(snackbar) },
    ) { insets ->
        Column(
            Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(insets)
                .padding(horizontal = 20.dp, vertical = 16.dp),
        ) {
            AppHeader()
            Spacer(Modifier.height(28.dp))
            if (ui.status == BridgeStatus.NOT_PAIRED) {
                SetupContent(ui, actions)
            } else {
                DashboardContent(ui, actions)
            }
            Spacer(Modifier.height(24.dp))
            if (ui.versionName.isNotBlank()) Text(
                stringResource(R.string.version, ui.versionName),
                modifier = Modifier.fillMaxWidth(),
                style = MaterialTheme.typography.bodySmall,
                color = Bridge.ink4,
                textAlign = TextAlign.Center,
            )
        }
    }
    ui.pendingLink?.let { ConfirmLinkSheet(it, ui, actions) }
}

// ---------------------------------------------------------------- setup

@Composable
private fun SetupContent(ui: BridgeUi, actions: BridgeActions) {
    Text(stringResource(R.string.setup_title), style = MaterialTheme.typography.headlineSmall)
    Spacer(Modifier.height(8.dp))
    Text(stringResource(R.string.setup_body), style = MaterialTheme.typography.bodyLarge, color = Bridge.ink3)
    Spacer(Modifier.height(20.dp))

    BridgeCard {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Filled.Lock, contentDescription = null, tint = Bridge.ink3, modifier = Modifier.size(18.dp))
            Spacer(Modifier.width(10.dp))
            Column {
                Text(stringResource(R.string.privacy_title), style = MaterialTheme.typography.titleMedium.copy(fontSize = 15.sp))
                Text(stringResource(R.string.privacy_body), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
            }
        }
        Spacer(Modifier.height(14.dp))
        ProviderChips()
    }

    Spacer(Modifier.height(28.dp))
    SectionLabel(stringResource(R.string.setup_steps))

    // The first step not yet done is the one we point at.
    val active = when {
        !ui.hasSmsPermission -> 1
        !ui.batteryExempt -> 2
        else -> 3
    }
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        StepCard(
            number = 1,
            title = stringResource(R.string.step_sms_title),
            body = stringResource(R.string.step_sms_body),
            done = ui.hasSmsPermission,
            active = active == 1,
            action = { SmallButton(stringResource(R.string.step_sms_action), actions.allowSms) },
        ) {
            if (ui.smsDenied && !ui.hasSmsPermission) RestrictedHelp(actions)
        }
        StepCard(
            number = 2,
            title = stringResource(R.string.step_background_title),
            body = stringResource(R.string.step_background_body),
            done = ui.batteryExempt,
            active = active == 2,
            action = { SmallButton(stringResource(R.string.step_background_action), actions.allowBackground) },
        )
        StepCard(
            number = 3,
            title = stringResource(R.string.step_pair_title),
            body = stringResource(R.string.step_pair_body),
            done = false,
            active = active == 3,
        ) {
            Spacer(Modifier.height(16.dp))
            PairPanel(ui, actions)
        }
    }
}

@Composable
private fun StepCard(
    number: Int,
    title: String,
    body: String,
    done: Boolean,
    active: Boolean,
    action: (@Composable () -> Unit)? = null,
    extra: @Composable () -> Unit = {},
) {
    BridgeCard(highlighted = active) {
        Row(verticalAlignment = Alignment.Top) {
            StepBadge(number, done, active)
            Spacer(Modifier.width(14.dp))
            Column(Modifier.weight(1f)) {
                Text(title, style = MaterialTheme.typography.titleMedium, color = if (done) Bridge.ink3 else Bridge.ink)
                if (!done) {
                    Spacer(Modifier.height(2.dp))
                    Text(body, style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
                }
            }
            if (done) {
                Text(
                    stringResource(R.string.step_done),
                    modifier = Modifier.padding(top = 2.dp),
                    fontSize = 13.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Bridge.blue,
                )
            } else if (action != null) {
                Spacer(Modifier.width(12.dp))
                action()
            }
        }
        extra()
    }
}

@Composable
private fun RestrictedHelp(actions: BridgeActions) {
    Spacer(Modifier.height(14.dp))
    Box(
        Modifier
            .fillMaxWidth()
            .background(Bridge.warnTint, MaterialTheme.shapes.medium)
            .padding(14.dp),
    ) {
        Column {
            Text(stringResource(R.string.perm_restricted), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink2)
            Spacer(Modifier.height(10.dp))
            SecondaryButton(stringResource(R.string.perm_open_settings), actions.openAppInfo)
        }
    }
}

/**
 * Backfill choice, Scan / Enter code, and where the code lives. Used by the
 * setup's step 3 and by the dashboard when the phone must pair again.
 */
@Composable
fun PairPanel(ui: BridgeUi, actions: BridgeActions) {
    var codeSheet by rememberSaveable { mutableStateOf(false) }

    Text(stringResource(R.string.pair_backfill_label), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink2)
    Spacer(Modifier.height(8.dp))
    BackfillChoice(ui.backfillDays, actions.setBackfill)
    Spacer(Modifier.height(16.dp))
    PrimaryButton(
        stringResource(R.string.pair_scan),
        actions.scan,
        icon = painterResource(R.drawable.ic_qr_scan),
        busy = ui.pairing && !codeSheet,
    )
    Spacer(Modifier.height(10.dp))
    SecondaryButton(
        stringResource(R.string.pair_manual),
        { actions.clearPairError(); codeSheet = true },
        enabled = !ui.pairing,
    )
    if (ui.pairError != null && !codeSheet) {
        Spacer(Modifier.height(12.dp))
        Text(ui.pairError, style = MaterialTheme.typography.bodyMedium, color = Bridge.danger)
    }
    Spacer(Modifier.height(8.dp))
    WhereIsMyCode()

    if (codeSheet) {
        EnterCodeSheet(ui, actions, onDismiss = { codeSheet = false; actions.clearPairError() })
    }
}

@Composable
fun BackfillChoice(days: Int, onChange: (Int) -> Unit) {
    val options = listOf(
        0 to stringResource(R.string.pair_backfill_none),
        7 to stringResource(R.string.pair_backfill_7),
        30 to stringResource(R.string.pair_backfill_30),
    )
    SingleChoiceSegmentedButtonRow(Modifier.fillMaxWidth()) {
        options.forEachIndexed { i, (value, label) ->
            SegmentedButton(
                selected = days == value,
                onClick = { onChange(value) },
                shape = SegmentedButtonDefaults.itemShape(i, options.size),
                colors = SegmentedButtonDefaults.colors(
                    activeContainerColor = Bridge.blueTint,
                    activeContentColor = Bridge.blueDark,
                    activeBorderColor = Bridge.blue,
                    inactiveContainerColor = Color.White,
                    inactiveContentColor = Bridge.ink2,
                    inactiveBorderColor = Bridge.line,
                ),
            ) { Text(label, fontSize = 14.sp) }
        }
    }
}

@Composable
private fun WhereIsMyCode() {
    var open by rememberSaveable { mutableStateOf(false) }
    Row(
        Modifier
            .fillMaxWidth()
            .clickable { open = !open }
            .padding(vertical = 10.dp),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(stringResource(R.string.where_code), fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = Bridge.blue)
        Icon(
            if (open) Icons.Filled.KeyboardArrowUp else Icons.Filled.KeyboardArrowDown,
            contentDescription = null,
            tint = Bridge.blue,
            modifier = Modifier.size(20.dp),
        )
    }
    AnimatedVisibility(open) {
        Column(
            Modifier
                .fillMaxWidth()
                .background(Bridge.surface, MaterialTheme.shapes.medium)
                .padding(14.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            PathLine(stringResource(R.string.where_code_phone_title), stringResource(R.string.where_code_phone))
            PathLine(stringResource(R.string.where_code_desktop_title), stringResource(R.string.where_code_desktop))
            Text(stringResource(R.string.where_code_same_phone), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink2)
            Text(stringResource(R.string.where_code_expiry), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
        }
    }
}

@Composable
private fun PathLine(title: String, path: String) {
    Column {
        Text(title.uppercase(), style = MaterialTheme.typography.labelSmall, color = Bridge.ink3)
        Spacer(Modifier.height(2.dp))
        Text(path, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold, color = Bridge.ink)
    }
}

// ------------------------------------------------------------ dashboard

@Composable
private fun DashboardContent(ui: BridgeUi, actions: BridgeActions) {
    var confirmUnpair by remember { mutableStateOf(false) }

    StatusCard(ui, actions)

    if (ui.status == BridgeStatus.NEEDS_PAIRING) {
        Spacer(Modifier.height(12.dp))
        BridgeCard(highlighted = true) {
            Text(stringResource(R.string.pair_again_title), style = MaterialTheme.typography.titleMedium)
            Spacer(Modifier.height(14.dp))
            PairPanel(ui, actions)
        }
    }

    Spacer(Modifier.height(12.dp))
    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
        StatTile(stringResource(R.string.stat_sent), ui.forwarded.toString(), Modifier.weight(1f))
        StatTile(stringResource(R.string.stat_waiting), ui.queued.toString(), Modifier.weight(1f))
        StatTile(stringResource(R.string.stat_last), lastSentLabel(ui), Modifier.weight(1.3f))
    }
    if (ui.status != BridgeStatus.NEEDS_PAIRING) {
        Spacer(Modifier.height(12.dp))
        SecondaryButton(
            stringResource(R.string.send_now),
            actions.sendNow,
            icon = rememberVectorPainter(Icons.Filled.Send),
        )
    }

    Spacer(Modifier.height(28.dp))
    SectionLabel(stringResource(R.string.checks_title))
    BridgeCard(contentPadding = PaddingValues(horizontal = 18.dp, vertical = 4.dp)) {
        CheckRow(stringResource(R.string.check_sms), ui.hasSmsPermission, actions.allowSms)
        HorizontalDivider(color = Bridge.line)
        CheckRow(stringResource(R.string.check_background), ui.batteryExempt, actions.allowBackground)
        HorizontalDivider(color = Bridge.line)
        InfoRow(stringResource(R.string.check_server), ui.serverHost.orEmpty())
    }

    Spacer(Modifier.height(20.dp))
    TextButton(
        onClick = { confirmUnpair = true },
        modifier = Modifier.fillMaxWidth().height(48.dp),
    ) {
        Text(stringResource(R.string.unpair), color = Bridge.danger, style = MaterialTheme.typography.labelLarge)
    }

    if (confirmUnpair) {
        AlertDialog(
            onDismissRequest = { confirmUnpair = false },
            containerColor = Bridge.card,
            title = { Text(stringResource(R.string.unpair_title), style = MaterialTheme.typography.titleLarge) },
            text = { Text(stringResource(R.string.unpair_confirm), style = MaterialTheme.typography.bodyLarge, color = Bridge.ink2) },
            dismissButton = {
                TextButton(onClick = { confirmUnpair = false }) {
                    Text(stringResource(R.string.cancel), color = Bridge.ink2)
                }
            },
            confirmButton = {
                TextButton(onClick = { confirmUnpair = false; actions.unpair() }) {
                    Text(stringResource(R.string.unpair), color = Bridge.danger, fontWeight = FontWeight.SemiBold)
                }
            },
        )
    }
}

@Composable
private fun StatusCard(ui: BridgeUi, actions: BridgeActions) {
    val (label, color, tint) = when (ui.status) {
        BridgeStatus.LIVE -> Triple(R.string.status_live, Bridge.ok, Bridge.okTint)
        BridgeStatus.RETRYING -> Triple(R.string.status_retrying, Bridge.warn, Bridge.warnTint)
        BridgeStatus.NO_PERMISSION -> Triple(R.string.status_no_permission, Bridge.danger, Bridge.dangerTint)
        else -> Triple(R.string.status_needs_pairing, Bridge.danger, Bridge.dangerTint)
    }
    val body = when (ui.status) {
        BridgeStatus.LIVE -> stringResource(R.string.status_live_body)
        BridgeStatus.RETRYING -> ui.lastError ?: stringResource(R.string.status_retrying_fallback)
        BridgeStatus.NO_PERMISSION -> stringResource(R.string.status_no_permission_body)
        else -> stringResource(R.string.status_needs_pairing_body)
    }
    BridgeCard(contentPadding = PaddingValues(20.dp)) {
        StatusPill(stringResource(label), color, tint)
        Spacer(Modifier.height(14.dp))
        Text(
            stringResource(
                if (ui.status == BridgeStatus.LIVE || ui.status == BridgeStatus.RETRYING) {
                    R.string.status_forwarding_to
                } else {
                    R.string.status_not_forwarding_to
                },
                ui.branchName ?: "Flipper",
            ),
            style = MaterialTheme.typography.headlineSmall.copy(fontSize = 22.sp, lineHeight = 28.sp),
        )
        Spacer(Modifier.height(6.dp))
        Text(body, style = MaterialTheme.typography.bodyLarge, color = Bridge.ink3)
        if (ui.status == BridgeStatus.NO_PERMISSION) {
            Spacer(Modifier.height(16.dp))
            PrimaryButton(stringResource(R.string.step_sms_title), actions.allowSms)
            if (ui.smsDenied) RestrictedHelp(actions)
        }
    }
}

@Composable
private fun StatTile(label: String, value: String, modifier: Modifier = Modifier) {
    BridgeCard(modifier, contentPadding = PaddingValues(14.dp)) {
        Text(label.uppercase(), style = MaterialTheme.typography.labelSmall, color = Bridge.ink3, maxLines = 1)
        Spacer(Modifier.height(6.dp))
        Text(value, fontSize = 20.sp, fontWeight = FontWeight.SemiBold, color = Bridge.ink, maxLines = 1)
    }
}

@Composable
private fun CheckRow(label: String, ok: Boolean, onFix: () -> Unit) {
    Row(
        Modifier.fillMaxWidth().height(56.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(label, Modifier.weight(1f), style = MaterialTheme.typography.bodyLarge, color = Bridge.ink)
        if (ok) {
            Box(Modifier.size(8.dp).background(Bridge.ok, CircleShape))
            Spacer(Modifier.width(8.dp))
            Text(stringResource(R.string.check_ok), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
        } else {
            TextButton(onClick = onFix) {
                Text(stringResource(R.string.check_fix), color = Bridge.blue, fontWeight = FontWeight.SemiBold)
            }
        }
    }
}

@Composable
private fun InfoRow(label: String, value: String) {
    Row(
        Modifier.fillMaxWidth().height(56.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(label, Modifier.weight(1f), style = MaterialTheme.typography.bodyLarge, color = Bridge.ink)
        Text(value, style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3, maxLines = 1)
    }
}

@Composable
private fun lastSentLabel(ui: BridgeUi): String =
    if (ui.lastUploadAtMs == 0L) {
        stringResource(R.string.stat_never)
    } else {
        DateUtils.getRelativeTimeSpanString(
            ui.lastUploadAtMs,
            maxOf(ui.nowMs, ui.lastUploadAtMs),
            DateUtils.MINUTE_IN_MILLIS,
            DateUtils.FORMAT_ABBREV_RELATIVE,
        ).toString()
    }
