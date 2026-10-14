package rw.flipper.smsbridge

import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL

/** The connector answered, but not with success. */
class ApiException(val status: Int, message: String) : IOException(message)

/**
 * The data-connector routes the bridge uses
 * (`data-connector/src/api/sms_bridge.rs`, `src/auth/routes.rs`).
 *
 * Blocking; call from a worker or a background thread.
 */
object ConnectorApi {
    private const val TIMEOUT_MS = 20_000

    data class TokenGrant(
        val deviceId: String,
        val accessToken: String,
        val refreshToken: String,
        val expiresInSec: Long,
        val businessId: String?,
        val branchId: String?,
        val branchName: String?,
    )

    /** Trades a pairing code for this phone's own credentials. */
    fun claim(baseUrl: String, code: String, installId: String, label: String?): TokenGrant {
        val body = JSONObject().put("code", code).put("installId", installId)
        if (!label.isNullOrBlank()) body.put("label", label)
        return grant(request("POST", baseUrl, "auth/sms-bridge/claim", null, body))
    }

    /**
     * Rotates the refresh token. The old one is dead the moment this returns,
     * so the caller must persist the new one before doing anything else.
     */
    fun refresh(baseUrl: String, refreshToken: String): TokenGrant =
        grant(request("POST", baseUrl, "auth/token", null, JSONObject().put("refreshToken", refreshToken)))

    /** Allowlisted senders (normalised) from the connector. */
    fun senders(baseUrl: String, accessToken: String): List<String> {
        val json = request("GET", baseUrl, "api/sms-bridge/config", accessToken, null)
        val arr = json.optJSONArray("senders") ?: return emptyList()
        return (0 until arr.length()).mapNotNull { arr.optJSONObject(it)?.optString("sender") }
            .filter { it.isNotEmpty() }
    }

    /** Posts a batch; returns `clientId → status`. */
    fun upload(baseUrl: String, accessToken: String, batch: List<QueuedSms>): Map<String, String> {
        val messages = JSONArray()
        for (m in batch) {
            messages.put(
                JSONObject()
                    .put("clientId", m.id.toString())
                    .put("sender", m.sender)
                    .put("body", m.body)
                    .put("receivedAtMs", m.receivedAtMs),
            )
        }
        val json = request("POST", baseUrl, "api/sms-bridge/messages", accessToken, JSONObject().put("messages", messages))
        val results = json.optJSONArray("results") ?: return emptyMap()
        return (0 until results.length()).mapNotNull { i ->
            val r = results.optJSONObject(i) ?: return@mapNotNull null
            r.optString("clientId") to r.optString("status")
        }.toMap()
    }

    private fun grant(json: JSONObject) = TokenGrant(
        deviceId = json.getString("deviceId"),
        accessToken = json.getString("accessToken"),
        refreshToken = json.getString("refreshToken"),
        expiresInSec = json.optLong("expiresIn", 900),
        businessId = json.optString("businessId").takeIf { it.isNotEmpty() },
        branchId = json.optString("branchId").takeIf { it.isNotEmpty() },
        branchName = json.optString("branchName").takeIf { it.isNotEmpty() },
    )

    private fun request(method: String, baseUrl: String, path: String, bearer: String?, body: JSONObject?): JSONObject {
        val conn = URL(baseUrl + path).openConnection() as HttpURLConnection
        try {
            conn.requestMethod = method
            conn.connectTimeout = TIMEOUT_MS
            conn.readTimeout = TIMEOUT_MS
            conn.setRequestProperty("Accept", "application/json")
            conn.setRequestProperty("User-Agent", "flipper-sms-bridge/${BuildConfig.VERSION_NAME}")
            if (bearer != null) conn.setRequestProperty("Authorization", "Bearer $bearer")
            if (body != null) {
                conn.doOutput = true
                conn.setRequestProperty("Content-Type", "application/json")
                conn.outputStream.use { it.write(body.toString().toByteArray(Charsets.UTF_8)) }
            }
            val status = conn.responseCode
            val stream = if (status in 200..299) conn.inputStream else conn.errorStream
            val text = stream?.bufferedReader()?.use { it.readText() }.orEmpty()
            if (status !in 200..299) {
                val message = try {
                    JSONObject(text).optString("error")
                } catch (_: Exception) {
                    ""
                }
                throw ApiException(status, message.ifEmpty { "HTTP $status" })
            }
            return if (text.isBlank()) JSONObject() else JSONObject(text)
        } finally {
            conn.disconnect()
        }
    }
}
