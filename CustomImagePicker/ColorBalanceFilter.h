//
//  ColorBalanceFilter.h
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/3/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface ColorBalanceFilter : GPUImageFilter

@property(nonatomic, readwrite) CGFloat redColor;
@property(nonatomic, readwrite) CGFloat greenColor;
@property(nonatomic, readwrite) CGFloat blueColor;
@property(nonatomic, readwrite) BOOL option;

@end
