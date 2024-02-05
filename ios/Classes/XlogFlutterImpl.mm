//
//  XlogFlutterImpl.m
//  xlog_flutter
//
//  Created by PC on 2024/2/1.
//

#import "XlogFlutterImpl.h"
#import <mars/xlog/appender.h>
#import <mars/xlog/xloggerbase.h>

using namespace mars::xlog;

@interface XlogFlutterImpl()

@property (nonatomic, strong) NSString *logDir;

@end

@implementation XlogFlutterImpl

- (void)flushWithCompletion:(nonnull void (^)(FlutterError * _Nullable))completion {
    appender_flush();
    if (completion) {
        completion(NULL);
    }
}

- (void)initMode:(XlogMode)mode 
     logFileName:(nonnull NSString *)logFileName
      logMaxSize:(NSInteger)logMaxSize
          logDir:(nonnull NSString *)logDir
        cacheDir:(nonnull NSString *)cacheDir
        cacheDay:(NSInteger)cacheDay
      completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    
    if (!logDir || logDir.length <= 0) {
        if (completion) {
            completion([FlutterError errorWithCode:@"-1" message:@"the logDir can't be empty" details:nil]);
        }
        return;
    }
    
    self.logDir = logDir.copy;
    
    switch (mode) {
        case XlogModeDebug:
            xlogger_SetLevel(kLevelDebug);
            appender_set_console_log(true);
            break;
        default:
            xlogger_SetLevel(kLevelInfo);
            appender_set_console_log(false);
            break;
    }
    
    appender_set_max_file_size(logMaxSize);
    
    XLogConfig config;
    config.mode_ = kAppenderAsync;
    config.logdir_ = [logDir UTF8String];
    config.nameprefix_ = [logFileName UTF8String];
    config.pub_key_ = "";
    config.compress_mode_ = kZlib;
    config.compress_level_ = 0;
    config.cachedir_ = [cacheDir UTF8String];
    config.cache_days_ = (int)cacheDay;
    appender_open(config);
    
    if(completion) {
        completion(nil);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
         [self cleanLogFiles];
     });
}

- (void)printTag:(nonnull NSString *)tag
           level:(LogLevel)level
         message:(nonnull NSString *)message
        fileName:(NSString *)fileName
        funcName:(NSString *)funcName
      lineNumber:(NSInteger)lineNumber
      completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    
    struct timeval time;
    gettimeofday(&time, NULL);
    uintptr_t tid = (uintptr_t)[NSThread currentThread];
    dispatch_async([self loggerQueue], ^{
        [self writeLogWithLevel:level 
                     moduleName:tag
                        message:message
                       fileName:fileName
                       funcName:funcName
                     lineNumber:(int)lineNumber
                           time:time
                            tid:tid];
    });
    
    if(completion) {
        completion(nil);
    }
}

- (dispatch_queue_t)loggerQueue {
    
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.dianyun.meet.xlogger", DISPATCH_QUEUE_SERIAL);
    });
    
    return queue;
}

- (void)writeLogWithLevel:(LogLevel)logLevel
               moduleName:(NSString *)moduleName
                  message:(NSString *)message
                 fileName:(NSString *)fileName
                 funcName:(NSString *)funcName
               lineNumber:(int)lineNumber
                     time:(struct timeval)time
                      tid:(uintptr_t)tid {
    NSString *tag = [NSString stringWithFormat:@"<%@>%@", [[self class] getTagDescByLogLevel:logLevel], (moduleName && moduleName.length) ? [NSString stringWithFormat:@"<%@>", moduleName] : @""];
    
    XLoggerInfo info;
    info.level = (TLogLevel)logLevel;
    info.tag = tag.UTF8String;
    info.filename = (fileName && fileName.length) ? fileName.UTF8String : NULL;
    info.func_name = (funcName && funcName.length) ? funcName.UTF8String : NULL;
    info.line = lineNumber;
    info.timeval = time;
    info.tid = tid;
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = 0;
    
    xlogger_Write(&info, message.UTF8String);
}

+ (NSString *)getTagDescByLogLevel:(LogLevel)level {
    static NSDictionary<NSNumber *,NSString *> *levelDescDict = @{
        @(LogLevelNone)      : @"NONE",
        @(LogLevelFatal)     : @"FATAL",
        @(LogLevelError)     : @"ERROR",
        @(LogLevelWarning)   : @"WARNING",
        @(LogLevelInfo)      : @"INFO",
        @(LogLevelDebug)     : @"DEBUG",
        @(LogLevelVerbose)   : @"VERBOSE"
    };
    return ([levelDescDict objectForKey:@(level)] ? : @"UNKNOWN");
}

- (void)cleanLogFiles {
    NSError *error= nil;
    
    if (!self.logDir || self.logDir.length <= 0) {
        return;
    }
    
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.logDir
                                                                            error:&error];
    if (logFiles == nil || [logFiles count] == 0) {
        NSLog(@"Error happened when clearnLogFiles:%@", error);
        return;
    }
    
#ifdef DEBUG
    NSDate* date = [[NSDate date] dateByAddingTimeInterval:-10*24*60*60];
#else
    NSDate* date = [[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
#endif
    
    for (NSString *logFile in logFiles) {
        NSString *logFilePath = [self.logDir stringByAppendingPathComponent:logFile];
        if ([[logFilePath pathExtension] isEqualToString:@"xlog"]) {
            NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:logFilePath
                error:&error];
            if (fileAttr) {
                NSDate *creationDate = [fileAttr valueForKey:NSFileCreationDate];
                if ([creationDate compare:date] == NSOrderedAscending) {
                    NSLog(@"[Kiwi:LogExt] cleanLogFiles: %@ will be deleted", logFile);
                    [[NSFileManager defaultManager] removeItemAtPath:logFilePath error:&error];
                    NSLog(@"[Kiwi:LogExt] cleanLogFiles: %@ was deleted, error number is %ld", logFilePath, (long)error.code);
                }
            }
        }
    }
}

#pragma mark -FlutterApplicationLifeCycleDelegate
- (void)applicationWillTerminate:(UIApplication *)application {
    appender_close();
}

@end
