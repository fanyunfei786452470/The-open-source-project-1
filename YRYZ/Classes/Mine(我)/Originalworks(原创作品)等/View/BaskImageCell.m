//
//  BaskImageCell.m
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import "BaskImageCell.h"

@implementation BaskImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc]initWithString:@"21"];
    NSMutableAttributedString *subfix = [[NSMutableAttributedString alloc]initWithString:@"六月"];
    [prefix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:28],
                            } range:NSMakeRange(0, prefix.length)];
    [subfix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:12],
                            } range:NSMakeRange(0, subfix.length)];
    
    [cellText appendAttributedString:prefix];
    [cellText appendAttributedString:subfix];
    
    self.timeLab.attributedText = cellText;
//    self.heaaimage.clipsToBounds = YES;
    
    
    if (kScreenWidth == kDevice_Is_iPhone4) {
        self.widthLayout.constant = 60;
        self.heightLyout.constant = 60;
        
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

- (void)setUIWithModel:(YRUserBaskSunModel *)model{
    
    
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix = [[NSMutableAttributedString alloc]initWithString:model.day];
    NSMutableAttributedString *subfix = [[NSMutableAttributedString alloc]initWithString:model.month];
    [prefix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:28],
                            } range:NSMakeRange(0, prefix.length)];
    [subfix addAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName : [UIFont systemFontOfSize:12],
                            } range:NSMakeRange(0, subfix.length)];
    
    [cellText appendAttributedString:prefix];
    [cellText appendAttributedString:subfix];
    
    self.timeLab.attributedText = cellText;
    
     self.contentLab.text = model.content;
    
    self.sumLab.text = [NSString stringWithFormat:@"共%ld张",model.pics.count];
        
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
