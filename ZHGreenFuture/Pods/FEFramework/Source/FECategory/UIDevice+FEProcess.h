//
//  UIDevice+FEProcess.h
//  FETestCategory
//
//  Created by xxx on 13-9-16.
//  Copyright (c) 2013年 Ferrari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (FEProcess)
- (NSArray *) runningProcesses;
- (NSArray *) runningProcessNames;
- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;
- (NSUInteger) pageSize;
- (NSUInteger) maxSocketBufferSize;
- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;
- (NSString *) batteryStateString;
@end
