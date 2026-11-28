package rw.flipper

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine

/**
 * The one FlutterEngine of this process, and so its one Dart isolate running
 * main().
 *
 * By default every FlutterActivity builds its own engine. When Android starts
 * a second MainActivity, or recreates it, while the process lives, a second
 * isolate runs main() and opens Ditto on the directory the first one still
 * holds: "File already locked". DittoSingleton's guard is a Dart static and
 * the file lock is per process, so neither can see another isolate. Every
 * MainActivity attaches to this engine instead, so Dart and its Ditto store
 * live as long as the process.
 */
internal object ProcessFlutterEngine {
    private val slot = ProcessSlot<FlutterEngine>()

    /**
     * Whether Flutter handles back, as it last told an activity. A new
     * activity joining the running engine starts from this, or a back gesture
     * would close the app over a route Flutter could pop.
     */
    @Volatile
    var frameworkHandlesBack: Boolean = false

    /** True once main() runs in this process: a new activity joins warm. */
    val isDartRunning: Boolean
        get() = slot.peek()?.dartExecutor?.isExecutingDart == true

    fun obtain(context: Context, flags: List<String>): FlutterEngine =
        slot.obtain {
            // The application context: the engine outlives any one activity.
            FlutterEngine(context.applicationContext, flags.toTypedArray()).also { engine ->
                engine.addEngineLifecycleListener(
                    object : FlutterEngine.EngineLifecycleListener {
                        override fun onPreEngineRestart() = Unit

                        override fun onEngineWillDestroy() = slot.release(engine)
                    },
                )
            }
        }
}
