package rw.flipper.smsbridge.ui

import android.content.ClipboardManager
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextRange
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import rw.flipper.smsbridge.R
import rw.flipper.smsbridge.core.PairingPayload

/**
 * Typing the code: one big monospaced field that groups itself as
 * `XXXXX-XXXXX`, a Paste shortcut (which also takes a whole pairing link),
 * and the server address tucked under "Server" because almost nobody
 * changes it.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EnterCodeSheet(ui: BridgeUi, actions: BridgeActions, onDismiss: () -> Unit) {
    val context = LocalContext.current
    val sheet = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var code by remember { mutableStateOf(TextFieldValue("")) }
    var server by rememberSaveable { mutableStateOf(ui.defaultServerUrl) }
    var showServer by rememberSaveable { mutableStateOf(false) }
    var localError by remember { mutableStateOf<String?>(null) }
    val badCode = stringResource(R.string.pair_bad_code)

    fun setCode(text: String) {
        val formatted = PairingPayload.formatCode(text)
        code = TextFieldValue(formatted, TextRange(formatted.length))
        localError = null
        actions.clearPairError()
    }

    fun submit() {
        val normalized = PairingPayload.normalizeCode(code.text)
        if (normalized.length != PairingPayload.CODE_LENGTH) {
            localError = badCode
        } else {
            actions.pairWithCode(normalized, server)
        }
    }

    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheet, containerColor = Bridge.card) {
        Column(
            Modifier
                .padding(horizontal = 24.dp)
                .padding(bottom = 28.dp)
                .imePadding(),
        ) {
            Text(stringResource(R.string.code_sheet_title), style = MaterialTheme.typography.titleLarge)
            Spacer(Modifier.height(6.dp))
            Text(stringResource(R.string.code_sheet_body), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
            Spacer(Modifier.height(20.dp))

            val error = localError ?: ui.pairError
            OutlinedTextField(
                value = code,
                onValueChange = { setCode(it.text) },
                modifier = Modifier.fillMaxWidth(),
                textStyle = CodeTextStyle.copy(textAlign = TextAlign.Center),
                placeholder = {
                    Text(
                        stringResource(R.string.code_placeholder),
                        modifier = Modifier.fillMaxWidth(),
                        style = CodeTextStyle.copy(textAlign = TextAlign.Center, color = Bridge.ink4.copy(alpha = 0.6f)),
                    )
                },
                singleLine = true,
                isError = error != null,
                shape = MaterialTheme.shapes.medium,
                keyboardOptions = KeyboardOptions(
                    capitalization = KeyboardCapitalization.Characters,
                    autoCorrectEnabled = false,
                    keyboardType = KeyboardType.Ascii,
                    imeAction = ImeAction.Done,
                ),
                keyboardActions = KeyboardActions(onDone = { submit() }),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = Bridge.blue,
                    unfocusedBorderColor = Bridge.line,
                    cursorColor = Bridge.blue,
                ),
            )
            Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
                Text(
                    error.orEmpty(),
                    modifier = Modifier.weight(1f),
                    style = MaterialTheme.typography.bodyMedium,
                    color = Bridge.danger,
                )
                TextButton(
                    onClick = {
                        val clip = context.getSystemService(ClipboardManager::class.java)
                            ?.primaryClip?.takeIf { it.itemCount > 0 }
                            ?.getItemAt(0)?.coerceToText(context)?.toString().orEmpty()
                        val link = PairingPayload.parse(clip)
                        if (link != null) {
                            server = link.connectorUrl
                            setCode(link.code)
                        } else if (clip.isNotBlank()) {
                            setCode(clip)
                        }
                    },
                ) {
                    Text(stringResource(R.string.code_paste), color = Bridge.blue, fontWeight = FontWeight.SemiBold)
                }
            }

            Spacer(Modifier.height(4.dp))
            Row(
                Modifier
                    .fillMaxWidth()
                    .clickable { showServer = !showServer }
                    .padding(vertical = 10.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(stringResource(R.string.code_server), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
                Spacer(Modifier.width(8.dp))
                Text(
                    PairingPayload.hostOf(server),
                    modifier = Modifier.weight(1f),
                    style = MaterialTheme.typography.bodyMedium,
                    color = Bridge.ink2,
                    maxLines = 1,
                )
                Icon(
                    if (showServer) Icons.Filled.KeyboardArrowUp else Icons.Filled.KeyboardArrowDown,
                    contentDescription = null,
                    tint = Bridge.ink3,
                )
            }
            AnimatedVisibility(showServer) {
                OutlinedTextField(
                    value = server,
                    onValueChange = { server = it.trim() },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 8.dp),
                    label = { Text(stringResource(R.string.pair_url_hint)) },
                    singleLine = true,
                    shape = MaterialTheme.shapes.medium,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri, autoCorrectEnabled = false),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = Bridge.blue,
                        unfocusedBorderColor = Bridge.line,
                        focusedLabelColor = Bridge.blue,
                    ),
                )
            }

            Spacer(Modifier.height(12.dp))
            PrimaryButton(
                stringResource(R.string.pair_submit),
                ::submit,
                enabled = PairingPayload.normalizeCode(code.text).length == PairingPayload.CODE_LENGTH,
                busy = ui.pairing,
            )
        }
    }
}

/**
 * A `flipper-sms-bridge://pair` link opened this app (usually Flipper on the
 * same phone). Any app can fire that link, so nothing pairs until the user
 * has seen where the SMS will go, with a warning for a non-Flipper server.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ConfirmLinkSheet(link: PairingPayload, ui: BridgeUi, actions: BridgeActions) {
    val sheet = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val trusted = PairingPayload.isFlipperServer(link.connectorUrl)
    ModalBottomSheet(onDismissRequest = actions.dismissLink, sheetState = sheet, containerColor = Bridge.card) {
        Column(Modifier.padding(horizontal = 24.dp).padding(bottom = 28.dp)) {
            Text(stringResource(R.string.confirm_title), style = MaterialTheme.typography.titleLarge)
            Spacer(Modifier.height(6.dp))
            Text(stringResource(R.string.confirm_body), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink3)
            Spacer(Modifier.height(14.dp))
            Row(
                Modifier
                    .fillMaxWidth()
                    .background(if (trusted) Bridge.surface else Bridge.dangerTint, MaterialTheme.shapes.medium)
                    .padding(14.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Icon(
                    if (trusted) Icons.Filled.Lock else Icons.Filled.Warning,
                    contentDescription = null,
                    tint = if (trusted) Bridge.ink3 else Bridge.danger,
                    modifier = Modifier.size(18.dp),
                )
                Spacer(Modifier.width(10.dp))
                Column {
                    Text(
                        PairingPayload.hostOf(link.connectorUrl),
                        fontFamily = Bridge.mono,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Bridge.ink,
                    )
                    if (!trusted) {
                        Spacer(Modifier.height(4.dp))
                        Text(stringResource(R.string.confirm_untrusted), style = MaterialTheme.typography.bodyMedium, color = Bridge.danger)
                    }
                }
            }
            Spacer(Modifier.height(18.dp))
            Text(stringResource(R.string.pair_backfill_label), style = MaterialTheme.typography.bodyMedium, color = Bridge.ink2)
            Spacer(Modifier.height(8.dp))
            BackfillChoice(ui.backfillDays, actions.setBackfill)
            if (ui.pairError != null) {
                Spacer(Modifier.height(12.dp))
                Text(ui.pairError, style = MaterialTheme.typography.bodyMedium, color = Bridge.danger)
            }
            Spacer(Modifier.height(20.dp))
            PrimaryButton(stringResource(R.string.confirm_pair), actions.confirmLink, busy = ui.pairing)
            Spacer(Modifier.height(6.dp))
            TextButton(onClick = actions.dismissLink, modifier = Modifier.fillMaxWidth().height(48.dp)) {
                Text(stringResource(R.string.cancel), color = Bridge.ink2)
            }
        }
    }
}
