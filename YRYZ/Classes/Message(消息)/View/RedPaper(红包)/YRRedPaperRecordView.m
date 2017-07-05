//
//  YRRedPaperRecordView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperRecordView.h"

#define cellHeight 60


@interface YRRedPaperRecordView()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UILabel *selectLineLabel;
@property(strong,nonatomic) UIView *tableHeaderView;
@property(strong,nonatomic) UITableView *redPaperListTableView;

@property NSInteger type;

@end


@implementation YRRedPaperRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _type = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    NSArray* buttonTitleArray = @[@"收到的红包",@"发出的红包"];
    
    for (int index = 0; index < 2; index++) {
        UIButton *typeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 100 + index;
        typeButton.frame = CGRectMake(SCREEN_WIDTH / 2.0f * index, 0, SCREEN_WIDTH / 2.0f, 44);
        typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [typeButton setTitle:[buttonTitleArray objectAtIndex:index] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeButton];
        if (index == 0) {
            [typeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        }else{
            [typeButton setTitleColor:[UIColor grayColorOne] forState:UIControlStateNormal];
        }
    }
    
    _selectLineLabel = [[UILabel alloc]init];
    _selectLineLabel.frame = CGRectMake(32, 42, SCREEN_WIDTH / 2.0f - 64, 2);
    _selectLineLabel.backgroundColor = [UIColor themeColor];
    [self addSubview:_selectLineLabel];
    
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(SCREEN_WIDTH / 2.0f , 8, 0.5, 26);
    lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [self addSubview:lineLabel];
    
    UILabel *horizontalLineLabel = [[UILabel alloc]init];
    horizontalLineLabel.frame = CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5);
    horizontalLineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [self addSubview:horizontalLineLabel];
    
    
    _tableHeaderView = [[UIView alloc]init];
    _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 164);
    _tableHeaderView.backgroundColor = [UIColor whiteColor];

    
    UILabel *moneyTintLabel = [[UILabel alloc]init];
    moneyTintLabel.frame = CGRectMake(0, 24, SCREEN_WIDTH, 16);
    moneyTintLabel.textColor = [UIColor wordColor];
    moneyTintLabel.text = @"发出红包总金额";
    moneyTintLabel.textAlignment = NSTextAlignmentCenter;
    moneyTintLabel.font = [UIFont systemFontOfSize:16];
    [_tableHeaderView addSubview:moneyTintLabel];
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"100.00元"];
    [moneyString addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:50]
                       range:NSMakeRange(0, 6)];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.frame = CGRectMake(0, 58, SCREEN_WIDTH, 50);
    moneyLabel.textColor = [UIColor themeColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.attributedText = moneyString;
    [_tableHeaderView addSubview:moneyLabel];
    
    
    UILabel *tintLabel = [[UILabel alloc]init];
    tintLabel.frame = CGRectMake(0, 120, SCREEN_WIDTH, 15);
    tintLabel.textAlignment = NSTextAlignmentCenter;
    tintLabel.text = @"共发出了10个";
    tintLabel.textColor = [UIColor grayColorTwo];
    tintLabel.font = [UIFont systemFontOfSize:15];
    [_tableHeaderView addSubview:tintLabel];
    
    UILabel *headerLineLabel = [[UILabel alloc]init];
    headerLineLabel.frame = CGRectMake(0, 163.5, SCREEN_WIDTH, 0.5);
    headerLineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [_tableHeaderView addSubview:headerLineLabel];
    
    
    _redPaperListTableView = [[UITableView alloc]init];
    _redPaperListTableView.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    _redPaperListTableView.delegate = self;
    _redPaperListTableView.dataSource = self;
    _redPaperListTableView.tableHeaderView = _tableHeaderView;
    _redPaperListTableView.separatorStyle = NO;
    [self addSubview:_redPaperListTableView];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.frame = CGRectMake(10, 12, 150, 16);
        nameLabel.text = @"天堂之翼";
        nameLabel.textColor = [UIColor wordColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.frame = CGRectMake(10, 35, 150, 13);
        typeLabel.text = @"普通红包";
        typeLabel.textColor = [UIColor grayColorTwo];
        typeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:typeLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.frame = CGRectMake(SCREEN_WIDTH - 160, 12, 150, 15);
        moneyLabel.text = @"9.48元";
        moneyLabel.textColor = [UIColor wordColor];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:moneyLabel];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.frame = CGRectMake(SCREEN_WIDTH - 160, 35, 150, 13);
        timeLabel.text = @"07-06";
        timeLabel.textColor = [UIColor grayColorTwo];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:timeLabel];

        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, cellHeight - 0.5, SCREEN_WIDTH, 0.5);
        lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
        [cell.contentView addSubview:lineLabel];
        
    }
    _redPaperListTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 234 + cellHeight * 3);
    return cell;
}

-(void)refreshData{
    [_redPaperListTableView reloadData];
}

-(void)changeTypeAction:(UIButton*)selectedButton{
    if (_type == selectedButton.tag - 100) {
        return;
    }
    else
    {
        _type = selectedButton.tag - 100;
    }
    
    UIButton *unSelectedButton = (UIButton*)[[selectedButton superview]viewWithTag:(201 - selectedButton.tag)];
    
    [selectedButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [unSelectedButton setTitleColor:[UIColor grayColorOne] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectLineLabel.frame = CGRectMake(32 + SCREEN_WIDTH / 2.0f * (selectedButton.tag - 100), 42, SCREEN_WIDTH / 2.0f - 64, 2);
    }];
}

@end
