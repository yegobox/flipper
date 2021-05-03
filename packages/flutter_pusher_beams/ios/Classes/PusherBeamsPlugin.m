#import "PusherBeamsPlugin.h"
#if __has_include(<pusher_beams/pusher_beams-Swift.h>)
#import <pusher_beams/pusher_beams-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pusher_beams-Swift.h"
#endif

@implementation PusherBeamsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPusherBeamsPlugin registerWithRegistrar:registrar];
}
@end
