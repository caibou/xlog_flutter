// Autogenerated from Pigeon (v14.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LogLevel) {
  LogLevelNone = 0,
  LogLevelFatal = 1,
  LogLevelError = 2,
  LogLevelWarning = 3,
  LogLevelInfo = 4,
  LogLevelDebug = 5,
  LogLevelVerbose = 6,
};

/// Wrapper for LogLevel to allow for nullability.
@interface LogLevelBox : NSObject
@property(nonatomic, assign) LogLevel value;
- (instancetype)initWithValue:(LogLevel)value;
@end

typedef NS_ENUM(NSUInteger, XlogMode) {
  XlogModeDebug = 0,
  XlogModeRelease = 1,
};

/// Wrapper for XlogMode to allow for nullability.
@interface XlogModeBox : NSObject
@property(nonatomic, assign) XlogMode value;
- (instancetype)initWithValue:(XlogMode)value;
@end


/// The codec used by XlogFlutterApi.
NSObject<FlutterMessageCodec> *XlogFlutterApiGetCodec(void);

@protocol XlogFlutterApi
- (void)initMode:(XlogMode)mode logFileName:(NSString *)logFileName logMaxSize:(NSInteger)logMaxSize logDir:(NSString *)logDir cacheDir:(NSString *)cacheDir cacheDay:(NSInteger)cacheDay completion:(void (^)(FlutterError *_Nullable))completion;
- (void)printTag:(NSString *)tag level:(LogLevel)level message:(NSString *)message fileName:(NSString *)fileName funcName:(NSString *)funcName lineNumber:(NSInteger)lineNumber completion:(void (^)(FlutterError *_Nullable))completion;
- (void)flushWithCompletion:(void (^)(FlutterError *_Nullable))completion;
@end

extern void SetUpXlogFlutterApi(id<FlutterBinaryMessenger> binaryMessenger, NSObject<XlogFlutterApi> *_Nullable api);

NS_ASSUME_NONNULL_END
