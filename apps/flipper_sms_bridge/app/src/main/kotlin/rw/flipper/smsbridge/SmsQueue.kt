package rw.flipper.smsbridge

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import rw.flipper.smsbridge.core.InboundSms
import rw.flipper.smsbridge.core.InboxSweep
import java.security.MessageDigest

/** A message waiting to be uploaded. [id] is sent as the `clientId`. */
data class QueuedSms(val id: Long, val sender: String, val body: String, val receivedAtMs: Long)

/**
 * Messages received but not yet accepted by the connector.
 *
 * Written by [SmsReceiver] the moment an SMS arrives, so nothing is lost if
 * the phone is offline or the app is killed; drained by [UploadWorker].
 * The receiver and the inbox sweep see the same SMS with different
 * timestamps, so a message is identified by [InboxSweep.dedupeKey]: unique
 * while queued, and remembered in `seen` for a while after delivery so the
 * next sweep does not send it again.
 */
class SmsQueue private constructor(context: Context) :
    SQLiteOpenHelper(context, "sms_queue.db", null, 2) {

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
        addDedupe(db)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) addDedupe(db)
    }

    /** v2: one row per message whichever path saw it, and what was already sent. */
    private fun addDedupe(db: SQLiteDatabase) {
        db.execSQL("ALTER TABLE queue ADD COLUMN dedupe_key TEXT")
        db.execSQL("CREATE UNIQUE INDEX queue_dedupe ON queue (dedupe_key)")
        db.execSQL("CREATE TABLE seen (key TEXT PRIMARY KEY, at INTEGER NOT NULL)")
    }

    /** False when the message is already queued or was already sent. */
    fun add(sms: InboundSms): Boolean {
        val key = InboxSweep.dedupeKey(sms.sender, sms.body)
        val db = writableDatabase
        val sent = db.rawQuery("SELECT 1 FROM seen WHERE key = ?", arrayOf(key)).use { it.moveToFirst() }
        if (sent) return false
        val values = ContentValues().apply {
            put("sender", sms.sender)
            put("body", sms.body)
            put("received_at", sms.receivedAtMs)
            put("body_sha256", sha256(sms.body))
            put("dedupe_key", key)
        }
        return db.insertWithOnConflict("queue", null, values, SQLiteDatabase.CONFLICT_IGNORE) != -1L
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

    /** Drops delivered rows, remembering them so a later sweep skips them. */
    fun delete(ids: Collection<Long>) {
        if (ids.isEmpty()) return
        val db = writableDatabase
        val inList = ids.joinToString(",")
        val now = System.currentTimeMillis()
        db.beginTransaction()
        try {
            db.execSQL(
                "INSERT OR REPLACE INTO seen (key, at) " +
                    "SELECT dedupe_key, ? FROM queue WHERE id IN ($inList) AND dedupe_key IS NOT NULL",
                arrayOf(now),
            )
            db.delete("queue", "id IN ($inList)", null)
            // Well past any sweep window (InboxSweep.FIRST_SWEEP_MS, or a 30-day rescan).
            db.delete("seen", "at < ?", arrayOf((now - SEEN_TTL_MS).toString()))
            db.setTransactionSuccessful()
        } finally {
            db.endTransaction()
        }
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
        writableDatabase.delete("seen", null, null)
    }

    companion object {
        private const val SEEN_TTL_MS = 35 * 24 * 60 * 60 * 1000L

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
