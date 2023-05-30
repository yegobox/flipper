package plugin.flipper.system_time_check;

import android.content.Context;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SystemTimeCheckPlugin */
public class SystemTimeCheckPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private static final String channelName = "system_time_check";
  public Context context = null;

  private static void setup(SystemTimeCheckPlugin plugin, BinaryMessenger binaryMessenger) {
    plugin.channel = new MethodChannel(binaryMessenger, channelName);
    plugin.channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    setup(this, flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("isSystemTimeAutomatic")) {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
        // get context resolver using context
        int time = Settings.Global.getInt(context.getContentResolver(), Settings.Global.AUTO_TIME, 0);
        boolean isTimeAutomatic = time == 1;
        result.success(isTimeAutomatic);
      }else{
        result.success(false);
      }
    }else if(call.method.equals("isSystemTimeAutomaticDebug")){
      result.success(false);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
