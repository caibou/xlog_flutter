#import "XlogFlutterPlugin.h"
#import "XlogFlutterImpl.h"
#import "XlogflutterPluginApi.g.h"

@implementation XlogFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    XlogFlutterImpl *xlogImpl = [[XlogFlutterImpl alloc] init];
    XlogFlutterApiSetup(registrar.messenger, xlogImpl);
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
