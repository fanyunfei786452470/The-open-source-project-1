//
//  BaskContenCell.m
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import "BaskContenCell.h"

@implementation BaskContenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)cellHeight:(NSDictionary *)model{
     NSDictionary *dic = @{@"content":@"1111111111122222222"};
    if ([self getStringRect:dic[@"content"]].height+30>70) {
        return 70;
    }else{
    return [self getStringRect:dic[@"content"]].height+30;
    }
}
//  获取字符串的大小
- (CGSize)getStringRect:(NSString*)aString{
    
    CGSize size;
    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
    
    NSRange range = NSMakeRange(0, atrString.length);
    
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    
    size = [aString boundingRectWithSize:CGSizeMake(217, 200)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return  size;
}

@end
