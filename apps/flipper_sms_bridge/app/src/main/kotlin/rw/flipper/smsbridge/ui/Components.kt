package rw.flipper.smsbridge.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import rw.flipper.smsbridge.R

/** The app mark (launcher art on brand blue) and "Flipper / SMS Bridge". */
@Composable
fun AppHeader(modifier: Modifier = Modifier) {
    Row(modifier, verticalAlignment = Alignment.CenterVertically) {
        Box(
            Modifier
                .size(40.dp)
                .clip(RoundedCornerShape(11.dp))
                .background(Bridge.blue),
            contentAlignment = Alignment.Center,
        ) {
            Image(
                painterResource(R.drawable.ic_launcher_foreground),
                contentDescription = null,
                modifier = Modifier.size(56.dp),
            )
        }
        Spacer(Modifier.width(12.dp))
        Column {
            Text(
                stringResource(R.string.brand_eyebrow).uppercase(),
                style = MaterialTheme.typography.labelSmall,
                color = Bridge.ink3,
            )
            Text(
                stringResource(R.string.brand_title),
                style = MaterialTheme.typography.titleMedium,
                color = Bridge.ink,
            )
        }
    }
}

/** Small uppercase group label above a card. */
@Composable
fun SectionLabel(text: String, modifier: Modifier = Modifier) {
    Text(
        text.uppercase(),
        modifier = modifier.padding(start = 4.dp, bottom = 8.dp),
        style = MaterialTheme.typography.labelSmall,
        color = Bridge.ink3,
    )
}

/** White card with a hairline border: the only container on every screen. */
@Composable
fun BridgeCard(
    modifier: Modifier = Modifier,
    highlighted: Boolean = false,
    contentPadding: PaddingValues = PaddingValues(18.dp),
    content: @Composable ColumnScope.() -> Unit,
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        shape = MaterialTheme.shapes.large,
        color = Bridge.card,
        border = BorderStroke(if (highlighted) 1.5.dp else 1.dp, if (highlighted) Bridge.blue else Bridge.line),
    ) {
        Column(Modifier.padding(contentPadding), content = content)
    }
}

/** Filled brand-blue button, full width, 52dp, with an optional spinner. */
@Composable
fun PrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    icon: Painter? = null,
    enabled: Boolean = true,
    busy: Boolean = false,
) {
    Button(
        onClick = onClick,
        enabled = enabled && !busy,
        modifier = modifier.fillMaxWidth().height(52.dp),
        shape = MaterialTheme.shapes.medium,
        colors = ButtonDefaults.buttonColors(
            containerColor = Bridge.blue,
            disabledContainerColor = Bridge.blue.copy(alpha = 0.35f),
            disabledContentColor = Color.White,
        ),
    ) {
        if (busy) {
            CircularProgressIndicator(Modifier.size(20.dp), color = Color.White, strokeWidth = 2.dp)
        } else {
            if (icon != null) {
                Icon(icon, contentDescription = null, modifier = Modifier.size(20.dp))
                Spacer(Modifier.width(10.dp))
            }
            Text(text, style = MaterialTheme.typography.labelLarge)
        }
    }
}

/** Outlined brand-blue button: the second action beside a [PrimaryButton]. */
@Composable
fun SecondaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    icon: Painter? = null,
    enabled: Boolean = true,
) {
    OutlinedButton(
        onClick = onClick,
        enabled = enabled,
        modifier = modifier.fillMaxWidth().height(52.dp),
        shape = MaterialTheme.shapes.medium,
        border = BorderStroke(1.dp, Bridge.blue.copy(alpha = if (enabled) 1f else 0.35f)),
        colors = ButtonDefaults.outlinedButtonColors(contentColor = Bridge.blue),
    ) {
        if (icon != null) {
            Icon(icon, contentDescription = null, modifier = Modifier.size(20.dp))
            Spacer(Modifier.width(10.dp))
        }
        Text(text, style = MaterialTheme.typography.labelLarge)
    }
}

/** Compact blue button for a step or a check row ("Allow", "Turn on"). */
@Composable
fun SmallButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier) {
    Button(
        onClick = onClick,
        modifier = modifier.height(38.dp),
        shape = MaterialTheme.shapes.small,
        contentPadding = PaddingValues(horizontal = 16.dp),
        colors = ButtonDefaults.buttonColors(containerColor = Bridge.blue),
    ) {
        Text(text, style = MaterialTheme.typography.labelLarge.copy(fontSize = 14.sp))
    }
}

/** Numbered circle for a setup step; a blue check once done. */
@Composable
fun StepBadge(number: Int, done: Boolean, active: Boolean) {
    val size = Modifier.size(28.dp)
    when {
        done -> Box(size.clip(CircleShape).background(Bridge.blue), contentAlignment = Alignment.Center) {
            Icon(Icons.Filled.Check, contentDescription = null, tint = Color.White, modifier = Modifier.size(16.dp))
        }
        else -> Box(
            size.clip(CircleShape).border(1.5.dp, if (active) Bridge.blue else Bridge.line, CircleShape),
            contentAlignment = Alignment.Center,
        ) {
            Text(
                number.toString(),
                fontSize = 13.sp,
                fontWeight = FontWeight.SemiBold,
                color = if (active) Bridge.blue else Bridge.ink3,
            )
        }
    }
}

/** Coloured dot + word: the only place status colours appear. */
@Composable
fun StatusPill(text: String, color: Color, tint: Color) {
    Row(
        Modifier
            .clip(CircleShape)
            .background(tint)
            .padding(horizontal = 10.dp, vertical = 5.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Box(Modifier.size(8.dp).clip(CircleShape).background(color))
        Spacer(Modifier.width(7.dp))
        Text(text, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = color)
    }
}

/** The senders that may leave the phone, as quiet chips. */
@OptIn(ExperimentalLayoutApi::class)
@Composable
fun ProviderChips(modifier: Modifier = Modifier) {
    FlowRow(
        modifier,
        horizontalArrangement = Arrangement.spacedBy(6.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        for (name in PROVIDERS) {
            Text(
                name,
                modifier = Modifier
                    .clip(RoundedCornerShape(8.dp))
                    .background(Bridge.surface)
                    .border(1.dp, Bridge.line, RoundedCornerShape(8.dp))
                    .padding(horizontal = 10.dp, vertical = 5.dp),
                fontSize = 13.sp,
                fontWeight = FontWeight.Medium,
                color = Bridge.ink2,
            )
        }
    }
}

/** Brand names, so not translated. Matches `SenderAllowlist.DEFAULT`. */
private val PROVIDERS = listOf("BK", "MTN MoMo", "Airtel Money", "Equity", "I&M")
