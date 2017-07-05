//
//  YRRedPaperListView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperListView.h"

#define cellHeight 60

@interface YRRedPaperListView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(strong,nonatomic) UITableView *redPaperListTableView;
@property(strong,nonatomic) UIView *tableHeaderView;
@property(strong,nonatomic) UIImageView *topBgView;

@end

@implementation YRRedPaperListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    _tableHeaderView = [[UIView alloc]init];
    _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 234);
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableHeaderView];
    
    _topBgView = [[UIImageView alloc]init];
    _topBgView.userInteractionEnabled = YES;
    _topBgView.frame = CGRectMake(0 , 0 ,SCREEN_WIDTH, 130);
    _topBgView.image = [UIImage imageNamed:@"topBgImage"];
    [_tableHeaderView addSubview:_topBgView];
    
    
    UIImageView *userPhoteImageView = [[UIImageView alloc]init];
    userPhoteImageView.userInteractionEnabled = YES;
    userPhoteImageView.image = [UIImage imageNamed:@"walletImage"];
    userPhoteImageView.frame = CGRectMake(SCREEN_WIDTH/2.0f -34, 56, 68, 68);
    [_topBgView addSubview:userPhoteImageView];
    
    NSMutableAttributedString *nameString= [[NSMutableAttributedString alloc] initWithString:@"魏世鹏的红包"];
    
    [nameString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor themeColor]
                       range:NSMakeRange(0, 3)];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(0, 146, SCREEN_WIDTH, 18);
    nameLabel.textColor = [UIColor wordColor];
    nameLabel.attributedText = nameString;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [_tableHeaderView addSubview:nameLabel];
    
    UIView *listTintView = [[UIView alloc]init];
    listTintView.frame = CGRectMake(0, 194, SCREEN_WIDTH, 40);
    listTintView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    [_tableHeaderView addSubview:listTintView];
    
    UILabel *tintLabel = [[UILabel alloc]init];
    tintLabel.frame = CGRectMake(10, 13, SCREEN_WIDTH - 10, 14);
    tintLabel.text = @"已领取红包2/10，共20.48/100.00元";
    tintLabel.textColor = [UIColor grayColorTwo];
    tintLabel.font = [UIFont systemFontOfSize:14];
    [listTintView addSubview:tintLabel];
    
    _redPaperListTableView = [[UITableView alloc]init];
    _redPaperListTableView.backgroundColor = RGB_COLOR(226, 57, 46);
    _redPaperListTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _redPaperListTableView.delegate = self;
    _redPaperListTableView.dataSource = self;
    _redPaperListTableView.tableHeaderView = _tableHeaderView;
    _redPaperListTableView.separatorStyle = NO;
    [self addSubview:_redPaperListTableView];
    
    
    UIView *tableFooterView = [[UIView alloc]init];
    tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 298 - cellHeight * 3);
    tableFooterView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableFooterView];
    _redPaperListTableView.tableFooterView = tableFooterView;
    
    /*
     UIButton *lookOtherButton =[UIButton buttonWithType:UIButtonTypeCustom];
     lookOtherButton.frame = CGRectMake(80, 340, 120, 20);
     [lookOtherButton setTitleColor:[UIColor colorWithR:255 g:220 b:182 a:1] forState:UIControlStateNormal];
     [lookOtherButton addTarget:self action:@selector(hideRedPaperView) forControlEvents:UIControlEventTouchUpInside];
     lookOtherButton.titleLabel.font = [UIFont systemFontOfSize:14];
     [lookOtherButton setTitle:@"看看大家的手气>" forState:UIControlStateNormal];
     [_redPaperBgView addSubview:lookOtherButton];*/
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *userImageView = [[UIImageView alloc]init];
        userImageView.userInteractionEnabled = YES;
        userImageView.image = [UIImage imageNamed:@"walletImage"];
        userImageView.frame = CGRectMake(10, 12, 36, 36);
        [cell.contentView addSubview:userImageView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.frame = CGRectMake(55, 12, 150, 16);
        nameLabel.text = @"天堂之翼";
        nameLabel.textColor = [UIColor wordColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.frame = CGRectMake(55, 35, 150, 13);
        timeLabel.text = @"16:30";
        timeLabel.textColor = [UIColor grayColorTwo];
        timeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:timeLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.frame = CGRectMake(SCREEN_WIDTH - 160, 0, 150, 60);
        moneyLabel.text = @"9.48元";
        moneyLabel.textColor = [UIColor wordColor];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:moneyLabel];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, cellHeight - 0.5, SCREEN_WIDTH, 0.5);
        lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
        [cell.contentView addSubview:lineLabel];
        
    }
    _redPaperListTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 234 + cellHeight * 3);
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.backgroundColor = RGB_COLOR(226, 57, 46);
    }else if(scrollView.contentOffset.y > 0){
        scrollView.backgroundColor = [UIColor whiteColor];
    }
}

@end
