//
//  RRZAddressAddFriendController.m
//  Rrz
//
//  Created by 易超 on 16/3/10.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressAddFriendController.h"
#import "RRZAddressAddFriendTopView.h"
#import "RRZAddressAddFriendCell.h"
#import "RRZAddressCommendFriendController.h"
#import "RRZAddressNewFriendController.h"
#import "RRZAddressSearchFriendController.h"
#import "YRSearchFriendController.h"

#import <QRCodeReaderViewController.h>
#import <QRCodeReader.h>

#import "QRCodeViewController.h"

//#import "RRZInfoDetailPageController.h"
//#import "RRZFriendInfoController.h"
#import "QRCodeViewController.h"

#import "YRMobilePhoneContactController.h"
#import "YRSearchResultController.h"

//#import "RRZScanQRCodeController.h"


static NSString *addFriendCellID = @"RRZAddressAddFriendCell";
@interface RRZAddressAddFriendController ()<UIGestureRecognizerDelegate,QRCodeReaderDelegate,UISearchBarDelegate>

/** 头视图*/
@property (weak, nonatomic) RRZAddressAddFriendTopView *topView;

@property (nonatomic,strong) UISearchController *searchVC;

@end

@implementation RRZAddressAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加好友";
    
    [self setupTopView];
    
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZAddressAddFriendCell class]) bundle:nil] forCellReuseIdentifier:addFriendCellID];
    
    self.tableView.rowHeight = 67;
}

/**
 *  @author yichao, 16-03-10 10:03:46
 *
 *  设置头视图
 */

- (void)viewWillDisappear:(BOOL)animated{
    [self.topView.seachTextField endEditing:YES];
}
-(void)setupTopView{
    
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    search.backgroundColor = RGB_COLOR(245, 245, 245);
    search.barTintColor =  RGB_COLOR(245, 245, 245);
    search.placeholder = @"搜索悠然一指用户";
    search.layer.borderWidth = 1;
    search.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    search.delegate = self;
    self.tableView.tableHeaderView = search;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topView.height = 55;
}
-(void)textFieldDisEditAction{
    YRSearchFriendController *searchFriendVC = [[YRSearchFriendController alloc]init];
    [self.navigationController pushViewController:searchFriendVC animated:YES];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    YRSearchFriendController *searchFriendVC = [[YRSearchFriendController alloc]init];
    [self.navigationController pushViewController:searchFriendVC animated:YES];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRZAddressAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"r_address_scan"];
        cell.titleLabel.text = @"扫一扫";
        cell.subTitleLabel.text = @"扫描二维码名片";
    }else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"r_address_linkman"];
        cell.titleLabel.text = @"手机联系人";
        cell.subTitleLabel.text = @"添加或邀请手机通讯录中的朋友";
    }
    //    else if (indexPath.row == 2){
    //        cell.iconImageView.image = [UIImage imageNamed:@"r_address_commendFriend"];
    //        cell.titleLabel.text = @"推荐朋友";
    //        cell.subTitleLabel.text = @"添加系统给您推荐的朋友";
    //    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            //            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请在设置中打开相机权限" cancelButtonText:@"确定"];
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请在设置中打开相机权限" cancelButtonText:@"确定" ];
            alertView.addCancelAction = ^(){
                
            };
            [alertView show];
        }else{
            //        [self scanClick];
            QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc]init];
            //        [self.navigationController pushViewController:QRCodeVC animated:YES];
            QRCodeVC.delegate = self;
            [self presentViewController:QRCodeVC animated:YES completion:nil];
        }
    }else if(indexPath.row == 1){
        
        //        RRZAddressNewFriendController *newFriendController = [[RRZAddressNewFriendController alloc]init];
        //        [self.navigationController pushViewController:newFriendController animated:YES];
        
        YRMobilePhoneContactController *phoneFriend = [[YRMobilePhoneContactController alloc]init];
        
        [self.navigationController pushViewController:phoneFriend animated:YES];
        
        
        
    }
    //    else if(indexPath.row == 2){
    //        RRZAddressCommendFriendController *commendFriendController = [[RRZAddressCommendFriendController alloc]init];
    //        [self.navigationController pushViewController:commendFriendController animated:YES];
    //    }
}

#pragma mark - 扫描二维码

-(void)scanClick{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader = [[QRCodeReaderViewController alloc]initWithCancelButtonTitle:@"取消"];
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            
            if (resultAsString.length > 0) {
                NSString *parametersType = [self jiexi:@"type" webaddress:resultAsString];
                //                NSString *parametersId = [self jiexi:@"id" webaddress:resultAsString];
                //                DLog(@"parametersType = %@  , parametersId = %@ ",parametersType,parametersId);
                
                if (parametersType.integerValue == 2) {
                    //                    RRZFriendInfoController *friendInfoController = [[RRZFriendInfoController alloc]init];
                    //                    friendInfoController.custId = parametersId;
                    //                    [self.navigationController pushViewController:friendInfoController animated:YES];
                }else if(parametersType.integerValue == 1){
                    //                    RRZInfoDetailPageController *detailPageController = [[RRZInfoDetailPageController alloc]init];
                    //                    detailPageController.infoID = parametersId;
                    //                    [self.navigationController pushViewController:detailPageController animated:YES];
                }else{
                    [MBProgressHUD showError:@"无法识别该二维码" toView:self.view];
                }
            }
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
        //        [self.navigationController pushViewController:reader animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持扫描" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}





#pragma mark - NSString

/**
 *  @author yichao, 16-04-21 11:04:39
 *
 *  从URL中获取参数
 *
 *  @param CS         参数名称
 *  @param webaddress URL
 *
 *  @return 参数
 */
-(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://www.baidu.com/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

@end
