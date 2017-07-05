//
//  YRSettingController.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSettingController.h"
#import "YRLoginOutCell.h"
#import "NSObject+FileManager.h"
#import "YRAccoutSafeViewController.h"
#import "YRYYCache.h"
#import "SPKitExample.h"

#import "YRMyShareView.h"

#import <MessageUI/MessageUI.h>
#import "UITabBar+badge.h"


#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "YRLoginController.h"
#import "YRMineAccoutSafeController.h"
#import "YRTAccountSafeController.h"

#import <WebKit/WKFoundation.h>
#import <WebKit/WKWebsiteDataRecord.h>
#import <WebKit/WebKit.h>
static NSString *cellID = @"YRSettingControllerCellID";
static NSString *loginOutCellID = @"YRLoginOutCellID";
@interface YRSettingController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSArray           *titles;
/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;

@property (nonatomic,strong) YRMyShareView *share;

@property (nonatomic,assign) BOOL isLogin;

@end

@implementation YRSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    [self setupTableView];
    self.shareImage = [UIImage imageNamed:@"yr_great_video_default"];
    
    @weakify(self);
    [self getFileCacheSizeWithPath:self.cachePath completion:^(NSInteger total) {
        @strongify(self);
        _total = total;
        [self.tableView reloadData];
    }];
    
}


- (void)setTotal:(NSInteger)total{

    _total = total;
    
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSString *)getSizeStr
{
    NSString *cacheStr = @"";
    if (_total) {
        CGFloat totalF = _total;
        NSString *unit = @"B";
        if (_total > 1000 * 1000) { // MB
            totalF = _total / 1000.0 / 1000.0;
            unit = @"MB";
        }else if (_total > 1000){ // KB
            unit = @"KB";
            totalF = _total / 1000.0 ;
        }
        
        cacheStr = [NSString stringWithFormat:@"%@%.1f%@",cacheStr,totalF,unit];
    }
    
    return cacheStr;
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRLoginOutCell class]) bundle:nil] forCellReuseIdentifier:loginOutCellID];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 2;
    if ([YRUserInfoManager manager].currentUser.custId) {
        section = 3;
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        YRLoginOutCell *cell = [tableView dequeueReusableCellWithIdentifier:loginOutCellID];
        __weak typeof(self) vc = self;
        cell.loginOutBtnClickBlock = ^{
            [vc setupActionSheet];
        };
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        if (indexPath.section == 0) {
            cell.textLabel.text = @"账户与安全";
            cell.detailTextLabel.text = nil;
        }else if(indexPath.section==1&&indexPath.row==0){
            cell.textLabel.text = @"清除缓存";
            cell.detailTextLabel.text = [self getSizeStr];
        }else{
            cell.textLabel.text = @"分享悠然一指";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont titleFont17];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 100;
    }else{
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = RGB_COLOR(245, 245, 245);
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([YRUserInfoManager manager].currentUser){
//            YRAccoutSafeViewController  *yrVc = [[YRAccoutSafeViewController alloc] init];
//            [self.navigationController pushViewController:yrVc animated:YES];
            
//            YRMineAccoutSafeController *safe = [[YRMineAccoutSafeController alloc]init];
//            safe.delegate = self.delegate;
            
            YRTAccountSafeController *safe = [[YRTAccountSafeController alloc]init];
            safe.delegate = self.delegate;
            [self.navigationController pushViewController:safe animated:YES];
        }else{
            [self noLoginTip];
        }
    }else if (indexPath.section == 1&&indexPath.row==0){
        [self setupAlertView];
    }else if (indexPath.section==1&&indexPath.row==1){
        
        
        if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]&&![QQApiInterface isQQInstalled]) {
            
            MFMessageComposeViewController *vc =[[MFMessageComposeViewController alloc] init];
            vc.messageComposeDelegate = self;
            [vc.navigationBar setTranslucent:YES];
            vc.body = @"悠然一指欢迎您的加入";
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            self.share = [[YRMyShareView alloc]initWithNoToReport];
            self.share.delegate = self;
            self.share.chooseShareCell = ^(NSInteger item,NSString *name){
                DLog(@"%ld %@",item,name);
            };
            [self.share show];
        }
    }
}

#pragma ---mark  messageComposeDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView
-(void)setupAlertView{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定清除缓存？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];

    
   YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定清除缓存？" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        NSDictionary *dic = (NSDictionary *)[[YRYYCache share].yyCache objectForKey:[YRUserInfoManager manager].currentUser.custId];

        [MBProgressHUD showMessage:@"正在删除..."];
        
        __weak typeof(self) vc = self;
        // 清楚缓存
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            // 清空缓存
            //              [cache.memoryCache removeAllObjects];
            //              [cache.diskCache removeAllObjects];
            //              [cache removeImageForKey:@"" withType:YYImageCacheTypeAll];
            // 清空磁盘缓存，带进度回调
            [vc removeAllImageForbetter];
            [MBProgressHUD hideHUD];
            vc.total = 0;
            [MBProgressHUD showError:@"清除完成"];
        }else{
            [vc removeCacheWithCompletion:^{
                [MBProgressHUD hideHUD];
                vc.total = 0;
                [MBProgressHUD showError:@"清除完成"];
            }];
        }
        
        [[YRYYCache share].yyCache setObject:dic forKey:[YRUserInfoManager manager].currentUser.custId];
        
//        [YRUserInfoManager manager].currentUser.mineShowCount = 0;
//        [YRUserInfoManager manager].currentUser.friendsShowCount = 0;
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
//        
//        
//        NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
//        NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
//        NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
//        
//        if ((fCount + mineCount + msgCount) == 0) {
//            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
//        }
        

        
        
    };
    [alertView show];
    
    
}

- (void)removeAllImageForbetter{
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                    WKWebsiteDataTypeDiskCache,
                                                    WKWebsiteDataTypeOfflineWebApplicationCache,
                                                    WKWebsiteDataTypeMemoryCache,
                                                    WKWebsiteDataTypeLocalStorage,
                                                    WKWebsiteDataTypeCookies,
                                                    WKWebsiteDataTypeSessionStorage,
                                                    WKWebsiteDataTypeIndexedDBDatabases,
                                                    WKWebsiteDataTypeWebSQLDatabases
                                                    ]];
    //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes   
                                               modifiedSince:dateFrom completionHandler:^{ // code
                                               }];
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{}];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [[YRYYCache share].yyCache removeAllObjects];
}




#pragma mark - UIActionSheet
-(void)setupActionSheet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *titles = @[@"确认退出"];
    [self addActionTarget:alert titles:titles];
    [self addCancelActionTarget:alert title:@"取消"];
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font         = [UIFont systemFontOfSize:15];
    appearanceLabel.font = font;
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 发布
// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    
    @weakify(self);
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"确认退出"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                [[NSUserDefaults standardUserDefaults] setObject:@"logOut" forKey:@"logOut"];//设置选择个数

                [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];

                [YRHttpRequest userLoginOutSuccess:^(id data) {
                    @strongify(self);
                    [YRUserInfoManager manager].currentUser = nil;
                    YRLoginController *login = [[YRLoginController alloc]init];
                    self.isLogin = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate.navigationController pushViewController:login animated:YES];
                    
                } failure:^(id data) {
                    @strongify(self);

     
                    [YRUserInfoManager manager].currentUser = nil;
                    self.isLogin = YES;
                    YRLoginController *login = [[YRLoginController alloc]init];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate.navigationController pushViewController:login animated:YES];
                }];


                self.total = 0;

                [[NSNotificationCenter defaultCenter] postNotificationName:Logout_Notification_Key object:self];
                
            }];
            if (SYSTEMVERSION>8.4) {
                 [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }           
            [alertController addAction:action];
        }
        
    }
}
// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    if (SYSTEMVERSION>8.4) {
       [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    }
    [alertController addAction:action];
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGB_COLOR(0, 121, 255) forState:UIControlStateNormal];
        }
    }
}



@end
