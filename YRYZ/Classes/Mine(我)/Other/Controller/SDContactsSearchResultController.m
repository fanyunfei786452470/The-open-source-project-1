//
//  SDContactsSearchResultController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/29.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDContactsSearchResultController.h"
#import "YRAddressListCell.h"
//#import "RRZFriendInfoController.h"
#import "BaseNavigationController.h"
#import "YRAdListItem.h"

static NSString *cellID = @"SearchResultRRZAddressFriendListCell";
@implementation SDContactsSearchResultController


-(void)setFilterItems:(NSArray *)filterItems{
    _filterItems = filterItems;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    self.tableView.backgroundColor = RGB_COLOR(230, 230, 230);
    self.tableView.rowHeight = 50;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRAddressListCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filterItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    YRAdListItem *item = self.filterItems[indexPath.row];
    NSString *name;
    if (item.nameNotes) {
        name = item.nameNotes;
    }else{
        name = item.custNname;
    }
    NSRange range = [name rangeOfString:self.inputStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
    [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
    cell.nameLabel.attributedText = attr;
    [cell.iconImage setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    RRZGoodFriendItem *item = self.filterItems[indexPath.row];
    RRZFriendInfoController *friendInfoViewController = [[RRZFriendInfoController alloc]init];
    friendInfoViewController.isWhichController = 1;
    friendInfoViewController.custId = item.custId;
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:friendInfoViewController];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self presentPopupViewController:nav animationType:MJPopupViewAnimationSlideRightLeft];
    */

}

@end
