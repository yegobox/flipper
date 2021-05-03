package dev.jrge.pusher_beams

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.pusher.pushnotifications.PushNotifications
import com.pusher.pushnotifications.PushNotificationsInstance
import io.flutter.Log

/** PusherBeamsPlugin */
class PusherBeamsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context : Context

  private  var instance: PushNotificationsInstance? = null
  private  var instanceId: String? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pusher_beams")
    channel.setMethodCallHandler(this)

    // Context for PusherBeams start
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    if (call.method != "start" && instance == null) {
      return result.error(null, "You should must call .start() before anything", null)
    }

    when (call.method) {
      "start" -> this.start(result, call.arguments<String>())
      "stop" -> this.stop(result)
      "addDeviceInterest" -> this.addDeviceInterest(result, call.arguments<String>())
      "removeDeviceInterest" -> this.removeDeviceInterest(result, call.arguments<String>())
      "getDeviceInterests" -> this.getDeviceInterests(result)
      "setDeviceInterests" -> this.setDeviceInterests(result, call.arguments<List<String>>())
      "clearDeviceInterests" -> this.clearDeviceInterests(result)
      "clearAllState" -> this.clearAllState(result)
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun start(result: Result, newInstanceId: String) {
    try {
      if (instance == null) {
        instance = PushNotifications.start(context, newInstanceId)
        instanceId = newInstanceId
      } else if (instanceId != newInstanceId) {
        return result.error(null, "You should use this library as a Singleton", null)
      }

      Log.i(this.toString(), "Start $newInstanceId")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun stop(result: Result) {
    try {
      instance?.stop()
      Log.i(this.toString(), "Stop")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun addDeviceInterest(result: Result, interest: String) {
    try {
      instance?.addDeviceInterest(interest)
      Log.i(this.toString(), "AddInterest: $interest")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun removeDeviceInterest(result: Result, interest: String) {
    try {
      instance?.removeDeviceInterest(interest)
      Log.i(this.toString(), "RemoveInterest: $interest")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun getDeviceInterests(result: Result) {
    try {
      val interests = instance?.getDeviceInterests();
      Log.i(this.toString(), "GetInterests: ${interests.toString()}")

      result.success(interests?.toList())
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun setDeviceInterests(result: Result, interests: List<String>) {
    try {
      instance?.setDeviceInterests(interests.toSet());
      Log.i(this.toString(), "SetInterests: ${interests.toString()}")

      result.success(interests.toList())
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun clearDeviceInterests(result: Result) {
    try {
      instance?.clearDeviceInterests()
      Log.i(this.toString(), "ClearInterests")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  private fun clearAllState(result: Result) {
    try {
      instance?.clearAllState()
      Log.i(this.toString(), "ClearAllState")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }
}
