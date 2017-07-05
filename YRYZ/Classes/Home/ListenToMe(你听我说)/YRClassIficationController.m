//
//  YRClassIficationController.m
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRClassIficationController.h"
#import "YRListenToMeTableViewCell.h"
#import "YRInfoProductTypeModel.h"
@interface YRClassIficationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) YRListenToMeTableViewCell *myCell;

@property (nonatomic,assign) BOOL isChoose;

@end

@implementation YRClassIficationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChoose = NO;
    // Do any additional setup after loading the view.
    self.title = @"选择分类";
//    self.view.backgroundColor = [UIColor redColor];

    
    [self configUI];
}
- (void)configUI{
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tabel registerNib:[UINib nibWithNibName:@"YRListenToMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    
    tabel.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self.view addSubview:tabel];
    tabel.bounces = NO;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    label.backgroundColor = RGB_COLOR(245, 245, 245);
    label.text = @" 点击选择";
    tabel.tableHeaderView = label;
    
    label.textColor = RGB_COLOR(67, 67, 67);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    tabel.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videoTypeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRListenToMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YRInfoProductTypeModel *model = self.videoTypeArr[indexPath.row];

    if ([model.channelName isEqualToString:self.typeName]) {
        cell.yesImage.image = [UIImage imageNamed:@"yr_choose_yes"];
        self.isChoose = NO;
        _myCell = cell;
    }else{
        if (self.isChoose) {
            cell.yesImage.image = [UIImage imageNamed:@"yr_choose_yes"];
            self.isChoose = NO;
            _myCell = cell;
        }else{
            cell.yesImage.image = [UIImage imageNamed:@"yr_choose_no"];
        }
    }

    cell.name.text = model.channelName;
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _myCell.yesImage.image = [UIImage imageNamed:@"yr_choose_no"];
    YRListenToMeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.yesImage.image = [UIImage imageNamed:@"yr_choose_yes"];
    _myCell = cell;
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        YRInfoProductTypeModel *model = self.videoTypeArr[indexPath.row];
        
        self.seleteType(model.uid,model.channelName);
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
 
    
}
- (void)returnSeleteType:(SeleteTypeblk_t)block{

    self.seleteType = block;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
