//
//  CKNSDictionary+TableView.h
//  FeedView
//
//  Created by Sebastien Morel on 11-03-18.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** TODO
 */
extern NSString * const CKTableViewAttributeBounds;

/** TODO
 */
extern NSString * const CKTableViewAttributePagingEnabled;

/** TODO
 */
extern NSString * const CKTableViewAttributeInterfaceOrientation;

/** TODO
 */
extern NSString * const CKTableViewAttributeOrientation;

/** TODO
 */
extern NSString * const CKTableViewAttributeAnimationDuration;

/** TODO
 */
extern NSString * const CKTableViewAttributeEditable;

/** TODO
 */
extern NSString * const CKTableViewAttributeStyle;

/** TODO
 */
extern NSString * const CKTableViewAttributeParentController;

/** TODO
 */
extern NSString * const CKTableViewAttributeObject;


/** TODO
 */
typedef enum {
	CKTableViewOrientationPortrait,
	CKTableViewOrientationLandscape
} CKTableViewOrientation;


/** TODO
 */
@interface NSDictionary (CKTableViewAttributes)

- (BOOL)pagingEnabled;
- (UIInterfaceOrientation)interfaceOrientation;
- (CGSize)bounds;
- (CKTableViewOrientation)tableOrientation;
- (NSTimeInterval)animationDuration;
- (BOOL)editable;
- (id)style;
- (UIViewController*)parentController;
- (id)object;

@end
