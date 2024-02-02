#import "XlogFlutterPlugin.h"
#import "XlogFlutterImpl.h"
#import "XlogflutterPluginApi.g.h"

@implementation XlogFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    XlogFlutterImpl *xlogImpl = [[XlogFlutterImpl alloc] init];
    [registrar addApplicationDelegate:(NSObject<FlutterPlugin> *)xlogImpl];
    SetUpXlogFlutterApi(registrar.messenger, xlogImpl);
}
@end
