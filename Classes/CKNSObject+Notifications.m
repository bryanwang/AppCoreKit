//
//  CKNSObject+Notifications.m
//  CloudKit
//
//  Created by Fred Brunel on 10-12-21.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import "CKNSObject+Notifications.h"

@implementation NSObject (CKNSObjectNotifications)

- (void)observeNotificationName:(NSString *)name selector:(SEL)selector { 
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:selector
												 name:name
											   object:nil];	
}

- (void)unobserveNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo {
	[[NSNotificationCenter defaultCenter] postNotificationName:name
														object:self 
													  userInfo:userInfo];
}

@end
