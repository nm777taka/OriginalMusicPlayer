//
//  colorArt.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/10/04.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorArt : NSObject
@property(retain,readonly) UIColor *backgroundColor;
@property(retain,readonly) UIColor *primaryColor;
@property(retain,readonly) UIColor *secondaryColor;
@property(retain,readonly) UIColor *detailColor;
@property(retain,nonatomic) UIImage* scaledImage;

- (id)initWithImage:(UIImage*)image;
- (id)initWithImage:(UIImage*)image scaledSize:(CGSize)size;

@end
