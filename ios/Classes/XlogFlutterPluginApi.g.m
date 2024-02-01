// Autogenerated from Pigeon (v14.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "XlogflutterPluginApi.g.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}

static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@implementation LogLevelBox
- (instancetype)initWithValue:(LogLevel)value {
  self = [super init];
  if (self) {
    _value = value;
  }
  return self;
}
@end

@implementation XlogModeBox
- (instancetype)initWithValue:(XlogMode)value {
  self = [super init];
  if (self) {
    _value = value;
  }
  return self;
}
@end

NSObject<FlutterMessageCodec> *XlogFlutterApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void SetUpXlogFlutterApi(id<FlutterBinaryMessenger> binaryMessenger, NSObject<XlogFlutterApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.init"
        binaryMessenger:binaryMessenger
        codec:XlogFlutterApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(initMode:logFileName:logMaxSize:completion:)], @"XlogFlutterApi api (%@) doesn't respond to @selector(initMode:logFileName:logMaxSize:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        XlogMode arg_mode = [GetNullableObjectAtIndex(args, 0) integerValue];
        NSString *arg_logFileName = GetNullableObjectAtIndex(args, 1);
        NSInteger arg_logMaxSize = [GetNullableObjectAtIndex(args, 2) integerValue];
        [api initMode:arg_mode logFileName:arg_logFileName logMaxSize:arg_logMaxSize completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.print"
        binaryMessenger:binaryMessenger
        codec:XlogFlutterApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(printTag:level:message:completion:)], @"XlogFlutterApi api (%@) doesn't respond to @selector(printTag:level:message:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_tag = GetNullableObjectAtIndex(args, 0);
        LogLevel arg_level = [GetNullableObjectAtIndex(args, 1) integerValue];
        NSString *arg_message = GetNullableObjectAtIndex(args, 2);
        [api printTag:arg_tag level:arg_level message:arg_message completion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.getLogFolderPath"
        binaryMessenger:binaryMessenger
        codec:XlogFlutterApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getLogFolderPathWithCompletion:)], @"XlogFlutterApi api (%@) doesn't respond to @selector(getLogFolderPathWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api getLogFolderPathWithCompletion:^(NSString *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.getLogFilePath"
        binaryMessenger:binaryMessenger
        codec:XlogFlutterApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getLogFilePathWithCompletion:)], @"XlogFlutterApi api (%@) doesn't respond to @selector(getLogFilePathWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api getLogFilePathWithCompletion:^(NSString *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.flush"
        binaryMessenger:binaryMessenger
        codec:XlogFlutterApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(flushWithCompletion:)], @"XlogFlutterApi api (%@) doesn't respond to @selector(flushWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api flushWithCompletion:^(FlutterError *_Nullable error) {
          callback(wrapResult(nil, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
