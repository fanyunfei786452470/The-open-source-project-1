//
//  YRSunTextDetailHeaderModel.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailHeaderModel.h"


@implementation YRSunTextDetailHeaderModel

@synthesize content = _content;

- (NSString *)type{
    NSString *type_;
    
    if (_videoPic == nil || [_videoPic isEqualToString:@""]) {
        type_ = @"image";
    }else{
        type_ = @"video";
    }
    
    return type_;
}

- (void)setContent:(NSString *)content{
    _content = content;
}

- (CGFloat)headerViewH{
    
    CGFloat contextH;
    
    if ([self.content isEqualToString:@""]) {
        contextH = 0;
    }else{
        contextH = [self heightForString:self.content fontSize:18.f];
    }
    
    CGFloat imageWidth = (SCREEN_WIDTH - 50.0f)/3.0f;
    CGFloat imageViewH = 0;
    CGFloat margin;
    
    if ([self.type isEqualToString:@"image"]) {
        if (self.pics.count == 0) {
            imageViewH = 0;
        }else if (self.pics.count == 1){
            
//            NSString* URLString = [self.pics objectAtIndex:0][@"url"];
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]]];
//            
//           if (image.size.width>image.size.height) {
//                imageViewH = imageWidth*1.7;
//           }else if (image.size.height>image.size.width){
//                imageViewH = (imageWidth*1.7*image.size.height/image.size.width)>(SCREEN_WIDTH-20)?(SCREEN_WIDTH-20):(imageWidth*1.7*image.size.height/image.size.width);
//           }else{
                imageViewH = imageWidth*1.7;
//           }
        }else if (self.pics.count <4){
            imageViewH = imageWidth;
        }else if (self.pics.count <7){
            imageViewH = imageWidth*2+5;
        }else{
            imageViewH = imageWidth*3+10;
        }
    }else if([self.type isEqualToString:@"video"]){
        imageViewH = 210;
    }
    if (contextH <1) {
        if ([self.type isEqualToString:@"image"]){
            margin = 20;

        }else if([self.type isEqualToString:@"video"]){
            margin = 10;
        }
    }else if (self.pics.count == 0) {
        margin = 10;
    }else{
        margin = 20;
    }

    return 60+contextH + imageViewH + 40 + margin +15;

}

//获取字符串的高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}
@end
