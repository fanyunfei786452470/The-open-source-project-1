//
//  YRCommentListModel.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCommentListModel.h"

@implementation YRCommentListModel

@synthesize content = _content;

@synthesize authorName = _authorName;

- (void)setAuthorName:(NSString *)authorName{
    _authorName = authorName;
}

- (void)setContent:(NSString *)content{

    _content = content;
}

- (CGFloat)cellHeight{
    
    CGFloat contextH;
    
    if (![self.authorName isEqualToString:@""] && self.authorName != nil) {
        contextH = [self heightForString:[NSString stringWithFormat:@"回复%@： %@",self.authorName,self.content] fontSize:16.f] >20 ? [self heightForString:[NSString stringWithFormat:@"回复%@： %@",self.authorName,self.content] fontSize:16.f] :20;
    }else{
        contextH = [self heightForString:self.content fontSize:16.f] >20 ? [self heightForString:self.content fontSize:16.f] :20;
    }
    return contextH +40;
}

//获取字符串的高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-105, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}


@end
