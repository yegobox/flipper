package rw.flipper.smsbridge

import android.annotation.SuppressLint
import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import org.json.JSONObject
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/** What pairing gave this phone. */
data class Credentials(
    val connectorUrl: String,
    val deviceId: String,
    val businessId: String,
    val branchId: String,
    val branchName: String?,
    val refreshToken: String,
    val accessToken: String?,
    val accessExpiresAtMs: Long,
)

/**
 * The bridge's credentials, encrypted with an Android Keystore key.
 *
 * The refresh token lets whoever holds it post SMS into a business's books,
 * so it is never written in the clear, and the app opts out of every backup
 * (manifest) so it cannot be restored onto another phone.
 */
class CredentialStore(context: Context) {
    private val prefs = context.getSharedPreferences("bridge_credentials", Context.MODE_PRIVATE)

    fun load(): Credentials? {
        val sealed = prefs.getString(KEY, null) ?: return null
        val json = try {
            JSONObject(decrypt(sealed))
        } catch (_: Exception) {
            // Key lost (e.g. the user cleared credentials in Settings): the
            // blob is unreadable, so the phone must pair again.
            clear()
            return null
        }
        return Credentials(
            connectorUrl = json.getString("connectorUrl"),
            deviceId = json.getString("deviceId"),
            businessId = json.getString("businessId"),
            branchId = json.getString("branchId"),
            branchName = json.optString("branchName").takeIf { it.isNotEmpty() },
            refreshToken = json.getString("refreshToken"),
            accessToken = json.optString("accessToken").takeIf { it.isNotEmpty() },
            accessExpiresAtMs = json.optLong("accessExpiresAtMs", 0),
        )
    }

    /** `commit`, not `apply`: a rotated refresh token must be on disk before it is used. */
    @SuppressLint("ApplySharedPref")
    fun save(c: Credentials) {
        val json = JSONObject()
            .put("connectorUrl", c.connectorUrl)
            .put("deviceId", c.deviceId)
            .put("businessId", c.businessId)
            .put("branchId", c.branchId)
            .put("branchName", c.branchName ?: "")
            .put("refreshToken", c.refreshToken)
            .put("accessToken", c.accessToken ?: "")
            .put("accessExpiresAtMs", c.accessExpiresAtMs)
        prefs.edit().putString(KEY, encrypt(json.toString())).commit()
    }

    @SuppressLint("ApplySharedPref")
    fun clear() {
        prefs.edit().remove(KEY).commit()
    }

    private fun key(): SecretKey {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(ALIAS, null) as? SecretKey)?.let { return it }
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(
            KeyGenParameterSpec.Builder(ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return gen.generateKey()
    }

    private fun encrypt(plain: String): String {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, key())
        val iv = cipher.iv
        val sealed = cipher.doFinal(plain.toByteArray(Charsets.UTF_8))
        return Base64.encodeToString(iv + sealed, Base64.NO_WRAP)
    }

    private fun decrypt(encoded: String): String {
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        val iv = bytes.copyOfRange(0, IV_BYTES)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, iv))
        return String(cipher.doFinal(bytes, IV_BYTES, bytes.size - IV_BYTES), Charsets.UTF_8)
    }

    private companion object {
        const val KEY = "sealed"
        const val ALIAS = "sms_bridge_credentials"
        const val TRANSFORMATION = "AES/GCM/NoPadding"
        const val IV_BYTES = 12
    }
}
