//
//  CKUIKeyboardInformation.h
//  CloudKit
//
//  Created by Olivier Collet on 10-09-17.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 */
CGRect CKUIKeyboardInformationFrameEnd(NSDictionary *keyboardUserInfo);

/**
 */
CGRect CKUIKeyboardInformationBounds(NSDictionary *keyboardUserInfo);

/**
 */
CGPoint CKUIKeyboardInformationCenterEnd(NSDictionary *keyboardUserInfo);

/**
 */
CGFloat CKUIKeyboardInformationAnimationDuration(NSDictionary *keyboardUserInfo);

/**
 */
UIViewAnimationCurve CKUIKeyboardInformationAnimationCurve(NSDictionary *keyboardUserInfo);
