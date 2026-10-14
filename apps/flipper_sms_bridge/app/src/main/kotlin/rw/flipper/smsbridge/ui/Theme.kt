package rw.flipper.smsbridge.ui

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Shapes
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

/**
 * Flipper's palette (the same values as `PosTokens` in the Flutter app).
 * Brand blue is the only action colour: two actions side by side are filled
 * blue vs outlined blue, never a second hue. Green, amber and red only ever
 * carry meaning (status), never a button.
 */
object Bridge {
    val blue = Color(0xFF2563EB)
    val blueDark = Color(0xFF1D4ED8)
    val blueTint = Color(0xFFEFF4FF)

    val ink = Color(0xFF0F172A)
    val ink2 = Color(0xFF334155)
    val ink3 = Color(0xFF64748B)
    val ink4 = Color(0xFF94A3B8)
    val line = Color(0xFFE2E8F0)
    val surface = Color(0xFFF6F7F9)
    val card = Color.White

    val ok = Color(0xFF16A34A)
    val okTint = Color(0xFFEAF7EF)
    val warn = Color(0xFFD97706)
    val warnTint = Color(0xFFFEF5E7)
    val danger = Color(0xFFDC2626)
    val dangerTint = Color(0xFFFDEDED)

    val mono = FontFamily.Monospace
}

private val colors = lightColorScheme(
    primary = Bridge.blue,
    onPrimary = Color.White,
    primaryContainer = Bridge.blueTint,
    onPrimaryContainer = Bridge.blueDark,
    secondary = Bridge.blue,
    onSecondary = Color.White,
    secondaryContainer = Bridge.blueTint,
    onSecondaryContainer = Bridge.blueDark,
    background = Bridge.surface,
    onBackground = Bridge.ink,
    surface = Bridge.card,
    onSurface = Bridge.ink,
    surfaceVariant = Bridge.surface,
    onSurfaceVariant = Bridge.ink3,
    surfaceContainerLow = Bridge.card,
    surfaceContainer = Bridge.card,
    surfaceContainerHigh = Bridge.card,
    outline = Bridge.line,
    outlineVariant = Bridge.line,
    error = Bridge.danger,
)

private val type = Typography().let { base ->
    base.copy(
        headlineSmall = base.headlineSmall.copy(
            fontSize = 26.sp,
            lineHeight = 32.sp,
            fontWeight = FontWeight.SemiBold,
            letterSpacing = (-0.3).sp,
            color = Bridge.ink,
        ),
        titleLarge = base.titleLarge.copy(fontSize = 20.sp, fontWeight = FontWeight.SemiBold),
        titleMedium = base.titleMedium.copy(fontSize = 16.sp, fontWeight = FontWeight.SemiBold),
        bodyLarge = base.bodyLarge.copy(fontSize = 15.sp, lineHeight = 22.sp),
        bodyMedium = base.bodyMedium.copy(fontSize = 14.sp, lineHeight = 20.sp),
        labelLarge = base.labelLarge.copy(fontSize = 15.sp, fontWeight = FontWeight.SemiBold),
        labelSmall = base.labelSmall.copy(
            fontSize = 11.sp,
            fontWeight = FontWeight.SemiBold,
            letterSpacing = 0.8.sp,
        ),
    )
}

/** The pairing code: big, monospaced, spaced, so 0/O and 1/I never get confused. */
val CodeTextStyle = TextStyle(
    fontFamily = Bridge.mono,
    fontSize = 26.sp,
    fontWeight = FontWeight.SemiBold,
    letterSpacing = 3.sp,
    color = Bridge.ink,
)

@Composable
fun BridgeTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = colors,
        typography = type,
        shapes = Shapes(
            small = RoundedCornerShape(10.dp),
            medium = RoundedCornerShape(14.dp),
            large = RoundedCornerShape(20.dp),
        ),
        content = content,
    )
}
