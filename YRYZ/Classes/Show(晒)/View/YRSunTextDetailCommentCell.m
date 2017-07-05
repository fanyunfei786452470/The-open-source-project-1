//
//  YRSunTextDetailCommentCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailCommentCell.h"

@interface YRSunTextDetailCommentCell()

@property (nonatomic,strong) UIImageView *fromIconImage;//评论人头像

@property (nonatomic,strong) UILabel *fromNameLab;//评论人名字

@property (nonatomic,strong) UITextView *content;//评论内容

@property (nonatomic,strong) UILabel *timeLab;//时间

@property (nonatomic,strong) UIView *bkView;//背景


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
        msgImage.frame        = CGRectMake(22, 17, 15, 15);
        [self.contentView addSubview:msgImage];
        self.msgImage = msgImage;
        
        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.frame        = CGRectMake(50, 10, 30, 30);
        iconImg.image        = [UIImage imageNamed:@"yr_msg_headImg"];
        self.fromIconImage   = iconImg;
        [self.contentView addSubview:iconImg];
        
        UILabel *fromNam      = [UILabel new];
        fromNam.frame         = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, iconImg.mj_y, 150, 20);
        fromNam.textAlignment = NSTextAlignmentLeft;
        fromNam.textColor     = [UIColor themeColor];
        fromNam.font          = [UIFont systemFontOfSize:16.f];
        self.fromNameLab      = fromNam;
        [self.contentView addSubview:fromNam];
        
        UITextView *commentLab   = [UITextView new];
        commentLab.frame         = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, CGRectGetMaxY(fromNam.frame)+5, SCREEN_WIDTH-105, 20);
//        commentLab.numberOfLines = 0;
        commentLab.backgroundColor = RGB_COLOR(245, 245, 245);
        commentLab.textAlignment = NSTextAlignmentLeft;
        commentLab.textColor     = RGB_COLOR(40, 40, 40);
        commentLab.font          = [UIFont systemFontOfSize:16.f];
        commentLab.editable = NO;
        commentLab.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        commentLab.scrollEnabled = NO;//禁止滚动，让文字完全显现出来
        self.content             = commentLab;
        [self.contentView addSubview:commentLab];
        
        UILabel *dataLab      = [UILabel new];
        dataLab.frame         = CGRectMake(SCREEN_WIDTH-120, iconImg.mj_y, 100, 20);
        dataLab.textAlignment = NSTextAlignmentRight;
        dataLab.textColor     = [UIColor grayColor];
        dataLab.font          = [UIFont systemFontOfSize:13.f];
        self.timeLab          = dataLab;
        [self.contentView addSubview:dataLab];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration           = 1.0;
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
    
    NSURL *url = [NSURL URLWithString:model.userHeadImg];
    [self.fromIconImage setImageWithURL:url placeholder:[UIImage imageNamed:@"yr_msg_headImg"]];
    
    NSMutableAttributedString *cellText = [NSMutableAttributedString new];
    NSMutableAttributedString *prefix;
    if (![model.authorName isEqualToString:@""] && model.authorName != nil) {
      prefix  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复%@: %@",model.authorName,model.content]];
      [prefix addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(2, model.authorName.length)];
    }else{
      prefix  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.content]];
    }
    
    

    [cellText appendAttributedString:prefix];
    
    self.bkView.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, model.cellHeight);
    self.fromNameLab.text = model.userName;
    self.content.attributedText = cellText;
    self.content.font = [UIFont systemFontOfSize:16.f];
    self.content.frame = CGRectMake(85, 35, SCREEN_WIDTH-105, model.cellHeight-40);
    
    NSInteger timeStamp = [model.timeStamp integerValue];
    self.timeLab.text = [NSString compareCurrentTime:timeStamp];
    
}


@end
