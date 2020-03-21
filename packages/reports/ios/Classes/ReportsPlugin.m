#import "ReportsPlugin.h"
#if __has_include(<reports/reports-Swift.h>)
#import <reports/reports-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "reports-Swift.h"
#endif

@implementation ReportsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReportsPlugin registerWithRegistrar:registrar];
}
@end
