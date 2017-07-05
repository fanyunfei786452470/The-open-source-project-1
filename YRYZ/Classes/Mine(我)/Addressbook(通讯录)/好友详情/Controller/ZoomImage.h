//
//  ZoomImage.h
//  YRYZ
//
//  Created by Sean on 16/10/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoomImage : NSObject
/**
 
 *	@brief	点击图片放大,再次点击缩小
 
 *
 
 *	@param oldImageView 头像所在的imageView
 
 */

+(void)showImage:(UIImageView*)avatarImageView;
@end
