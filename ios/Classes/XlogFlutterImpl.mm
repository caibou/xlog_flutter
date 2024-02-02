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

@end

@implementation XlogFlutterImpl

- (void)flushWithCompletion:(nonnull void (^)(FlutterError * _Nullable))completion {
    appender_flush();
    if (completion) {
        completion(NULL);
    }
}

- (void)getLogFilePathWithCompletion:(nonnull void (^)(NSString * _Nullable, FlutterError * _Nullable))completion {
    if (completion) {
        completion([[self class] lastLogFilePathName], nil);
    }
}

- (void)getLogFolderPathWithCompletion:(nonnull void (^)(NSString * _Nullable, FlutterError * _Nullable))completion {
    if(completion) {
        completion([[self class] logFolderPath], nil);
    }
}

- (void)initMode:(XlogMode)mode
     logFileName:(nonnull NSString *)logFileName
      logMaxSize:(NSInteger)logMaxSize
      completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    
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
    config.logdir_ = [[[self class] logFolderPath] UTF8String];
    config.nameprefix_ = [logFileName UTF8String];
    config.pub_key_ = "";
    config.compress_mode_ = kZlib;
    config.compress_level_ = 0;
    config.cachedir_ = "";
    config.cache_days_ = 0;
    appender_open(config);
    
    if(completion) {
        completion(nil);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
         [[self class] cleanLogFiles];
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
        queue = dispatch_queue_create("com.jitian.meet.xlogger", DISPATCH_QUEUE_SERIAL);
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

+ (NSString *)lastLogFilePathName {
    return [[self class] logFilePathListByReverse].lastObject;
}

+ (NSArray *)logFilePathListByReverse {
    NSString *logFolderPath = [[self class] logFolderPath];
    NSError *error = nil;
    NSArray *logFileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logFolderPath 
                                                                               error:&error];
    if (logFileList == nil || [logFileList count] == 0){
        return nil;
    }
    NSMutableArray *tmpLogFileList = [NSMutableArray new];
    [logFileList enumerateObjectsUsingBlock:^(NSString * logFilePath, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[logFilePath pathExtension] isEqualToString:@"xlog"]) {
            [tmpLogFileList addObject:[logFolderPath stringByAppendingPathComponent:logFilePath]];
        }
    }];
    
    return [[tmpLogFileList sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        NSDictionary *firstProperties = [[NSFileManager defaultManager] attributesOfItemAtPath:obj1
                                                                                         error:nil];
        NSDate *firstDate = [firstProperties objectForKey:NSFileModificationDate];
        NSDictionary *secondProperties = [[NSFileManager defaultManager] attributesOfItemAtPath:obj2 
                                                                                          error:nil];
        NSDate *secondDate = [secondProperties objectForKey:NSFileModificationDate];
        return [secondDate compare:firstDate];
    }] copy];
}

+ (NSString *)logFolderPath {
    NSString *path = [[self class] getLogPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:path 
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return path;
}

+ (NSString *)getLogDirectory {
    NSString *logParentPath = nil;
    
    do {
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        if ([directories count] < 1)
            break;
        
        logParentPath = [directories objectAtIndex:0];
        
        NSUInteger length = [logParentPath length];
        
        if (length < 1) {
            break;
        }
        
        if ('/' == [logParentPath characterAtIndex:length - 1])
            break;
        
        logParentPath = [logParentPath stringByAppendingString:@"/"];
        
    } while (false);
    
    return logParentPath;
}

+ (NSString *)getLogPath {
    static NSString * kLogDir = @"logs/";
    NSString *cacheDir = [[self class] getLogDirectory];
    if (cacheDir == nil){
        return nil;
    }
    return [cacheDir stringByAppendingPathComponent:kLogDir];
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

+ (void)cleanLogFiles {
    NSError *error= nil;
    NSString *logFolder = [[self class] logFolderPath];
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logFolder 
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
        NSString *logFilePath = [logFolder stringByAppendingPathComponent:logFile];
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
