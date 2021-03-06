//
//  UIView+CKLayout.h
//  AppCoreKit
//
//  Created by Sebastien Morel on 2013-06-26.
//  Copyright (c) 2013 Wherecloud. All rights reserved.
//

#import "CKLayoutBoxProtocol.h"
#import "CKLayoutBox.h"

/**
 */
@interface UIView (CKLayout)<CKLayoutBoxProtocol>

/** Default value is YES. that means layoutting the view will automatically shrink or expand its size to fit the layouted content.
 Views managed by UIViewController or UITableViewCellContentView are forced to NO as the controller, container controller or table view cell controller is responsible to manage it's view frame.
 */
@property(nonatomic,assign) BOOL sizeToFitLayoutBoxes;

/** This method will lookup for a style with the specified id in the global stylesheet scope.
  This style requiers a "@class" key to be defined and the class must be a subclass of UIView.
  You can define a layout and any of the view hierarchy property and style in this scope.
  The view that gets returned will get the subview hierarchy style applied to it.
 */
+ (id)inflateViewFromStyleWithId:(NSString*)styleId;

@end