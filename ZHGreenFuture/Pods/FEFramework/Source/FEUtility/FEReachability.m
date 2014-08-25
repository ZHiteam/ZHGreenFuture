#import <sys/socket.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>
#import "FEReachability.h"


@interface FEReachability()
{
	BOOL localWiFiRef;
	SCNetworkReachabilityRef reachabilityRef;
}
@end

@implementation FEReachability

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(__bridge NSObject*) info isKindOfClass: [FEReachability class]], @"info was wrong class in ReachabilityCallback");
    
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
    @autoreleasepool {
        FEReachability* noteObject =(__bridge FEReachability*) info;
        // Post a notification to notify the client that the network reachability changed.
        [[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
    }
	
	
}

- (BOOL) startNotifier
{
	BOOL retVal = NO;
	SCNetworkReachabilityContext	context = {0, (__bridge void *)(self), NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)){
		if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)){
			retVal = YES;
		}
	}
	return retVal;
}

- (void) stopNotifier
{
	if(reachabilityRef!= NULL){
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (void) dealloc
{
	[self stopNotifier];
	if(reachabilityRef!= NULL){
		CFRelease(reachabilityRef);
	}
}

+ (FEReachability*) reachabilityWithHostName: (NSString*) hostName;
{
	FEReachability* retVal = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if(reachability!= NULL){
		retVal= [[self alloc] init];
		if(retVal!= NULL){
			retVal->reachabilityRef = reachability;
			retVal->localWiFiRef = NO;
		}
	}
	return retVal;
}

+ (FEReachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;
{
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	FEReachability* retVal = NULL;
	if(reachability!= NULL){
		retVal= [[self alloc] init];
		if(retVal!= NULL){
			retVal->reachabilityRef = reachability;
			retVal->localWiFiRef = NO;
		}
	}
	return retVal;
}

+ (FEReachability*) reachabilityForInternetConnection;
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	return [self reachabilityWithAddress: &zeroAddress];
}

+ (FEReachability*) reachabilityForLocalWiFi;
{
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	FEReachability* retVal = [self reachabilityWithAddress: &localWifiAddress];
	if(retVal!= NULL){
		retVal->localWiFiRef = YES;
	}
	return retVal;
}

#pragma mark Network Flag Handling

- (PKNetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
    
	BOOL retVal = kNotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect)){
		retVal = kReachableViaWiFi;	
	}
	return retVal;
}

- (PKNetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{

	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0){
		// if target host is not reachable
		return kNotReachable;
	}
    
	BOOL retVal = kNotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = kReachableViaWiFi;
	}
	
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            // ... and no [user] intervention is needed
            retVal = kReachableViaWiFi;
        }
    }
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = kReachableViaWWAN;
	}
	return retVal;
}

- (BOOL) connectionRequired;
{
	NSAssert(reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)){
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
	return NO;
}

- (PKNetworkStatus) currentReachabilityStatus
{
	NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
	PKNetworkStatus retVal = kNotReachable;
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)){
		if(localWiFiRef){
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else{
			retVal = [self networkStatusForFlags: flags];
		}
	}
	return retVal;
}
@end
