//
//  ColorBalanceFilter.m
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/3/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

#import "ColorBalanceFilter.h"

@interface ColorBalanceFilter() {
    GLint redUniform;
    GLint greenUniform;
    GLint blueUniform;
    GLint optionUniform;
}

@end

@implementation ColorBalanceFilter

@synthesize redColor = _redColor;
@synthesize greenColor = _greenColor;
@synthesize blueColor = _blueColor;
@synthesize option = _option;

- (id)init {
    if (self = [super initWithFragmentShaderFromFile:@"color_balance"]) {
        redUniform = [filterProgram uniformIndex:@"redBalance"];
        greenUniform = [filterProgram uniformIndex:@"greenBalance"];
        blueUniform = [filterProgram uniformIndex:@"blueBalance"];
        optionUniform = [filterProgram uniformIndex:@"option"];
        self.redColor = 0.5;
        self.greenColor = 0.5;
        self.blueColor = 0.5;
        self.option = NO;
    }
    return self;
}

- (void)setRedColor:(CGFloat)redColor {
    _redColor = redColor;
    [self setFloat:_redColor forUniform:redUniform program:filterProgram];
}

- (void)setGreenColor:(CGFloat)greenColor {
    _greenColor = greenColor;
    [self setFloat:_greenColor forUniform:greenUniform program:filterProgram];
}

- (void)setBlueColor:(CGFloat)blueColor {
    _blueColor = blueColor;
    [self setFloat:_blueColor forUniform:blueUniform program:filterProgram];
}

- (void)setOption:(BOOL)option {
    _option = option;
    [self setInteger:_option ? 1 : 0 forUniform:optionUniform program:filterProgram];
}

@end
