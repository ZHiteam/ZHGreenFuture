//
//  PKReachAbilityManager.h
//  Pumkin
//
//  Created by xxx on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FEReachability;
@interface FEReachAbilityManager : NSObject
- (void) updateStatusWithReachability: (FEReachability*) curReach;
- (void) reachabilityChanged: (NSNotification* )note;

+(BOOL) isWifiAvailable;
+(BOOL) isInternetAvailable;
@end
