package rw.flipper.smsbridge

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import rw.flipper.smsbridge.core.InboundSms
import java.security.MessageDigest

/** A message waiting to be uploaded. [id] is sent as the `clientId`. */
data class QueuedSms(val id: Long, val sender: String, val body: String, val receivedAtMs: Long)

/**
 * Messages received but not yet accepted by the connector.
 *
 * Written by [SmsReceiver] the moment an SMS arrives, so nothing is lost if
 * the phone is offline or the app is killed; drained by [UploadWorker].
 * `(sender, received_at, body hash)` is unique, so the pairing backfill and
 * live capture can both see one SMS without queueing it twice.
 */
class SmsQueue private constructor(context: Context) :
    SQLiteOpenHelper(context, "sms_queue.db", null, 1) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            """
            CREATE TABLE queue (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              sender TEXT NOT NULL,
              body TEXT NOT NULL,
              received_at INTEGER NOT NULL,
              body_sha256 TEXT NOT NULL,
              attempts INTEGER NOT NULL DEFAULT 0,
              UNIQUE (sender, received_at, body_sha256)
            )
            """.trimIndent(),
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) = Unit

    /** False when the message was already queued. */
    fun add(sms: InboundSms): Boolean {
        val values = ContentValues().apply {
            put("sender", sms.sender)
            put("body", sms.body)
            put("received_at", sms.receivedAtMs)
            put("body_sha256", sha256(sms.body))
        }
        return writableDatabase.insertWithOnConflict("queue", null, values, SQLiteDatabase.CONFLICT_IGNORE) != -1L
    }

    fun next(limit: Int): List<QueuedSms> =
        readableDatabase.query(
            "queue", arrayOf("id", "sender", "body", "received_at"),
            null, null, null, null, "id ASC", limit.toString(),
        ).use { c ->
            buildList {
                while (c.moveToNext()) {
                    add(QueuedSms(c.getLong(0), c.getString(1), c.getString(2), c.getLong(3)))
                }
            }
        }

    fun delete(ids: Collection<Long>) {
        if (ids.isEmpty()) return
        writableDatabase.delete("queue", "id IN (${ids.joinToString(",")})", null)
    }

    /** Counts a failed attempt; drops messages that have failed for too long. */
    fun recordFailure(ids: Collection<Long>, maxAttempts: Int) {
        if (ids.isEmpty()) return
        val db = writableDatabase
        db.execSQL("UPDATE queue SET attempts = attempts + 1 WHERE id IN (${ids.joinToString(",")})")
        db.delete("queue", "attempts >= ?", arrayOf(maxAttempts.toString()))
    }

    fun size(): Int =
        readableDatabase.rawQuery("SELECT COUNT(*) FROM queue", null).use { c ->
            if (c.moveToFirst()) c.getInt(0) else 0
        }

    /** Unpairing: queued SMS belong to the old branch and must not follow the phone. */
    fun clear() {
        writableDatabase.delete("queue", null, null)
    }

    companion object {
        @Volatile private var instance: SmsQueue? = null

        fun get(context: Context): SmsQueue =
            instance ?: synchronized(this) {
                instance ?: SmsQueue(context.applicationContext).also { instance = it }
            }

        private fun sha256(text: String): String =
            MessageDigest.getInstance("SHA-256")
                .digest(text.toByteArray(Charsets.UTF_8))
                .joinToString("") { "%02x".format(it) }
    }
}
