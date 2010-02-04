//
//  CKUIImage+Transformations.h
//  CloudKit
//
//  Created by Fred Brunel on 10-02-03.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CKUIImageTransformationsAdditions)

- (UIImage *)imageThatFits:(CGSize)size crop:(BOOL)crop;
- (UIImage *)imageByAddingBorderWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end