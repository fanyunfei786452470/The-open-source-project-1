//
//  YRSunTextDetailCommentCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailCommentCell.h"

@interface YRSunTextDetailCommentCell()

@property (nonatomic,weak) UIImageView *fromIconImage;//评论人头像

@property (nonatomic,weak) UILabel *fromNameLab;//评论人名字

@property (nonatomic,weak) UILabel *content;//评论内容

@property (nonatomic,weak) UILabel *timeLab;//时间

@property (nonatomic,weak) UIView *bkView;//背景


@end

@implementation YRSunTextDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundV.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 60);
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 60);
        view.backgroundColor = RGBA_COLOR(245, 245, 245, 1);
        [self.contentView addSubview:view];
        self.bkView = view;
        
        UIImageView *msgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_show_comment"]];
        msgImage.frame        = CGRectMake(22, 14, 15, 15);
        [self.contentView addSubview:msgImage];
        self.msgImage = msgImage;
        
        
        UILabel *fromNam      = [UILabel new];
        fromNam.frame         = CGRectMake(50, 10, 250, 20);
        fromNam.textAlignment = NSTextAlignmentLeft;
        fromNam.textColor     = RGB_COLOR(35, 205, 195);
        fromNam.font          = [UIFont systemFontOfSize:15.f];
        self.fromNameLab      = fromNam;
        [self.contentView addSubview:fromNam];
        
        UILabel *commentLab   = [UILabel new];
        commentLab.frame         = CGRectMake(50, CGRectGetMaxY(fromNam.frame)+5, SCREEN_WIDTH-105, 20);
        commentLab.numberOfLines = 0;
        commentLab.backgroundColor = RGB_COLOR(245, 245, 245);
        commentLab.textAlignment = NSTextAlignmentLeft;
        commentLab.textColor     = RGB_COLOR(51, 51, 51);
        commentLab.font          = [UIFont systemFontOfSize:17.f];

        self.content             = commentLab;
        [self.contentView addSubview:commentLab];
        
        UILabel *dataLab      = [UILabel new];
        dataLab.frame         = CGRectMake(SCREEN_WIDTH-120, 10, 100, 20);
        dataLab.textAlignment = NSTextAlignmentRight;
        dataLab.textColor     = RGB_COLOR(153, 153, 153);
        dataLab.font          = [UIFont systemFontOfSize:14.f];
        self.timeLab          = dataLab;
        [self.contentView addSubview:dataLab];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration           = 0.7;
        [self.contentView addGestureRecognizer:longPressGr];
    }
    return self;
}

/**
 *  @author ZX, 16-08-26 14:08:33
 *
 *  长按删除评论
 *
 */
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan){
         if ([self.delegate respondsToSelector:@selector(didClickLongPressGestureRecognizerCellWithIndexPath:)]){
            [self.delegate didClickLongPressGestureRecognizerCellWithIndexPath:self.indexPath];
        }
    }
}

- (void)setModel:(YRCommentListModel *)model{
    
    NSString *aName = model.authorNameNote?model.authorNameNote:model.authorName;
    NSString *cName = model.custNameNote?model.custNameNote:model.custName;
    
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix;
    if (![aName isEqualToString:@""] && aName != nil) {
      prefix  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复%@: %@",aName,model.content]];
      [prefix addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(35, 205, 195) range:NSMakeRange(2, aName.length)];
    }else{
      prefix  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.content]];
    }

    [cellText appendAttributedString:prefix];
    
    self.bkView.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, model.cellHeight);
    self.fromNameLab.text = cName;
    self.content.attributedText = cellText;
    self.content.font = [UIFont systemFontOfSize:16.f];
    self.content.frame = CGRectMake(50, 35, SCREEN_WIDTH-70, model.cellHeight-38);
    self.timeLab.text = [NSString getTimeFormatterWithString:model.timeStamp];
    
}


@end
