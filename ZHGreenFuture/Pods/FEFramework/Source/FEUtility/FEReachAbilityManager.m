//
//  FEReachAbilityManager.h.m
//  Pumkin
//
//  Created by xxx on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FEReachAbilityManager.h"
#import "FEReachability.h"


static PKNetworkStatus    internetReachStatus = kNotReachable;
static PKNetworkStatus    wifiReachStatus = kNotReachable;
static FEReachAbilityManager*	reachAbilityManager = nil;

@interface FEReachAbilityManager()
{
    FEReachability* internetReach_;
    FEReachability* wifiReach_;
}
@end

@implementation FEReachAbilityManager

-(id) init
{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

        internetReach_ = [FEReachability reachabilityForInternetConnection];
        [internetReach_ startNotifier];
        [self updateStatusWithReachability: internetReach_];
    
        wifiReach_ = [FEReachability reachabilityForLocalWiFi];
        [wifiReach_ startNotifier];
        [self updateStatusWithReachability: wifiReach_];
		reachAbilityManager = self;
    }
    
    return self;
}

-(void) dealloc{

	reachAbilityManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	FEReachability* curReach = [note object];
	if ([curReach isKindOfClass: [FEReachability class]]) {
		[self updateStatusWithReachability: curReach];
	}
}

- (void) updateStatusWithReachability: (FEReachability*) curReach
{
    if(curReach == internetReach_){
        internetReachStatus = [curReach currentReachabilityStatus];
	}
	if(curReach == wifiReach_){	
        wifiReachStatus = [curReach currentReachabilityStatus];
	}
}

+(BOOL) isWifiAvailable
{
	if (reachAbilityManager){
		return wifiReachStatus != kNotReachable;
	}
	else {
		NSLog(@">>>You Should Alloc FEReachAbilityManager.h First!!");
	}
	return NO;
}

+(BOOL) isInternetAvailable
{
	if (reachAbilityManager){
		return internetReachStatus != kNotReachable;
	}
	else{
		NSLog(@">>>You Should Alloc FEReachAbilityManager.h First!!");
	}
	return NO;
}

@end
