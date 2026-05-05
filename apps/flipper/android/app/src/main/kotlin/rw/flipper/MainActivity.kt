package rw.flipper

import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var shortcutsChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        captureColdStartShortcut(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        dispatchWarmShortcut(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        shortcutsChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).also { channel ->
                channel.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "isPinShortcutSupported" -> {
                            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                                result.success(false)
                                return@setMethodCallHandler
                            }
                            val sm = getSystemService(ShortcutManager::class.java)
                            result.success(sm?.isRequestPinShortcutSupported == true)
                        }

                        "consumePendingShortcutPage" -> {
                            result.success(MainActivity.peekAndConsumeColdShortcutPage())
                        }

                        "requestPinShortcut" -> {
                            val id = call.argument<String>("id")
                            val label = call.argument<String>("label")
                            val page = call.argument<String>("page")
                            if (id == null || label == null || page == null) {
                                result.error("bad_args", "missing fields", null)
                                return@setMethodCallHandler
                            }
                            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                                result.success(
                                    mapOf("ok" to false, "reason" to "android_o_required"),
                                )
                                return@setMethodCallHandler
                            }
                            val sm = getSystemService(ShortcutManager::class.java)
                            if (sm == null || !sm.isRequestPinShortcutSupported) {
                                result.success(
                                    mapOf("ok" to false, "reason" to "launcher_unsupported"),
                                )
                                return@setMethodCallHandler
                            }

                            val launchIntent =
                                Intent(this@MainActivity, MainActivity::class.java).apply {
                                    action = Intent.ACTION_MAIN
                                    addCategory(Intent.CATEGORY_DEFAULT)
                                    flags =
                                        Intent.FLAG_ACTIVITY_NEW_TASK or
                                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                                    putExtra(EXTRA_SHORTCUT_PAGE, page)
                                }

                            val shortcut =
                                ShortcutInfo.Builder(applicationContext, id)
                                    .setShortLabel(label)
                                    .setLongLabel(label)
                                    .setIcon(
                                        Icon.createWithResource(
                                            applicationContext,
                                            R.mipmap.launcher_icon,
                                        ),
                                    )
                                    .setIntent(launchIntent)
                                    .build()

                            try {
                                sm.requestPinShortcut(shortcut, null)
                                result.success(mapOf("ok" to true))
                            } catch (e: Exception) {
                                result.success(
                                    mapOf(
                                        "ok" to false,
                                        "reason" to (e.message ?: "shortcut_failed"),
                                    ),
                                )
                            }
                        }

                        else -> result.notImplemented()
                    }
                }
            }
    }

    private fun captureColdStartShortcut(intent: Intent?) {
        val page = intent?.getStringExtra(EXTRA_SHORTCUT_PAGE) ?: return
        MainActivity.storeColdShortcutPage(page)
    }

    private fun dispatchWarmShortcut(intent: Intent?) {
        val page = intent?.getStringExtra(EXTRA_SHORTCUT_PAGE) ?: return
        shortcutsChannel?.invokeMethod(
            "onShortcutLaunched",
            mapOf("page" to page),
        )
    }

    companion object {
        private const val CHANNEL = "rw.flipper/app_shortcuts"
        private const val EXTRA_SHORTCUT_PAGE = "shortcut_page"

        @Volatile
        private var coldShortcutPagePending: String? = null

        fun peekAndConsumeColdShortcutPage(): String? {
            val page = coldShortcutPagePending
            coldShortcutPagePending = null
            return page
        }

        fun storeColdShortcutPage(page: String) {
            coldShortcutPagePending = page
        }
    }
}
