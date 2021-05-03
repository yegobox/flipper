import Flutter
import UIKit
import PushNotifications

public class SwiftPusherBeamsPlugin: NSObject, FlutterPlugin {
    
    var instanceId : String?
    var beamsClient = PushNotifications.shared

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pusher_beams", binaryMessenger: registrar.messenger())
        let instance = SwiftPusherBeamsPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        
        // To Init Registration
        PushNotifications.shared.registerForRemoteNotifications()
    }

    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.beamsClient.registerDeviceToken(deviceToken)
    }

    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.beamsClient.handleNotification(userInfo: userInfo)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "start" && instanceId != nil) {
            return result(FlutterError(code: "", message: "You should must call .start() before anything", details: nil))
        }
        
        let unwrappedArgs = call.arguments ?? "Nothing here"
        
        switch call.method {
        case "start":
            self.start(result: result, newInstanceId: String(describing: unwrappedArgs))
        case "stop":
            self.stop(result: result)
        case "addDeviceInterest":
            self.addDeviceInterest(result: result, interest: String(describing: unwrappedArgs))
        case "removeDeviceInterest":
            self.removeDeviceInterest(result: result, interest: String(describing: unwrappedArgs))
        case "getDeviceInterests":
            self.getDeviceInterests(result: result)
        case "setDeviceInterests":
            self.setDeviceInterests(result: result, interests: unwrappedArgs as! [String])
        case "clearDeviceInterests":
            self.clearDeviceInterests(result: result)
        case "clearAllState":
            self.clearAllState(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
    
    private func start(result: FlutterResult, newInstanceId: String) {
        instanceId = newInstanceId
        
        self.beamsClient.start(instanceId: newInstanceId)
        
        result(nil)
    }
    
    private func stop(result: FlutterResult) {
        self.beamsClient.stop {
            print("Pusher Beams stopped!")
        }
        
        result(nil)
    }
    
    private func addDeviceInterest(result: FlutterResult, interest: String) {
        try? self.beamsClient.addDeviceInterest(interest: interest)
        
        result(nil)
    }
    
    private func removeDeviceInterest(result: FlutterResult, interest: String) {
        try? self.beamsClient.addDeviceInterest(interest: interest)
        
        result(nil)
    }
    
    private func getDeviceInterests(result: FlutterResult) {
        result(self.beamsClient.getDeviceInterests())
    }
    
    private func setDeviceInterests(result: FlutterResult, interests: [String]) {
        try? self.beamsClient.setDeviceInterests(interests: interests)
        
        result(nil)
    }
    
    private func clearDeviceInterests(result: FlutterResult) {
        try? self.beamsClient.clearDeviceInterests()
        
        result(nil)
    }
    
    private func clearAllState(result: FlutterResult) {
        self.beamsClient.clearAllState {
            print("Pusher Beams State cleared!")
        }
        
        result(nil)
    }
}
