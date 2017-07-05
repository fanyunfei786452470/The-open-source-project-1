//
//  RRZMineMyInfoController.m
//  Rrz
//
//  Created by 易超 on 16/3/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZMineMyInfoController.h"
#import "RRZMineInfoCell.h"
#import "RRZProvinceSelectController.h"
#import "RRZSetupNotsController.h"
#import "RRZSetupSignatureViewController.h"
#import "RRZUserInfoItem.h"
#import "RRZSetupSexController.h"
#import "RRZQRController.h"
#import "BaseNavigationController.h"

#import <AliyunOSSiOS/OSSService.h>
#import "SPKitExample.h"
#import <AVFoundation/AVFoundation.h>
static NSString *mineInfoCellID = @"RRZMineInfoCell";
@interface RRZMineMyInfoController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
//    OSSClient * client;
    OSSClient * Imgclient;
}
/** <#注释#>*/
@property (strong, nonatomic) UITableView   *tableView;

/** icon*/
@property (weak, nonatomic)  UIImageView    *iconImageView;

/** 模型*/
@property (strong,nonatomic) RRZUserInfoItem *item;

/** <#注释#>*/
@property (strong, nonatomic) NSDictionary    *dic;


@property (nonatomic,weak) UserModel *model;

@property (nonatomic,strong) UIImage *iconImage;


@property (nonatomic,copy) NSString *urlImage;

@end

@implementation RRZMineMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"个人信息"];
    
//    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.iconImage = [UIImage imageNamed:@"yr_user_defaut"];
    
    YRUserInfoManager *manager = [YRUserInfoManager manager];
    
    self.model = manager.currentUser;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = YRMargin;
    [self.view addSubview:self.tableView];
    //    self.tableView.
    //    self.tableView.rowHeight = 48;
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RRZMineInfoCell class]) bundle:nil] forCellReuseIdentifier:mineInfoCellID];
    
    [self registerData];
    
    //    @weakify(self);
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:EditUserInfo_key object:nil] subscribeNext:^(NSNotification *notification) {
    //        @strongify(self);
    //        [self registerData];
    //    }];
    
  //  [self setRightNavButtonWithTitle:@"保存"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - 网络请求
-(void)registerData{
    
    //    [[RRZNetworkController sharedController] getUserInfoWithSuccess:^(NSDictionary *data) {
    //
    ////        DLog(@"=== %@",data);
    //        self.item = [RRZUserInfoItem mj_objectWithKeyValues:data[@"data"]];
    //        [[RRZDataCache sharedController] saveModel:self.item forKey:@"RRZMineMyInfoController"];
    ////        [RRZUserInfoItem saveSingleModel:self.item forKey:@"RRZMineMyInfoController"];
    //
    //        [self.tableView reloadData];
    //
    //    } failure:^(id data) {
    ////        DLog(@"failure = %@",data);
    //         [MBProgressHUD showError:NetworkError toView:self.view];
    //    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 4;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRZMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mineInfoCellID];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"头像";
            cell.imageHCons.constant = 40;
            cell.imageWCons.constant = 40;
            [cell.IconImageView setImageWithURL:[NSURL URLWithString:self.model.custImg] placeholder:[UIImage imageNamed:@"yr_user_defaut"]];
            
//            self.iconImageView = cell.IconImageView;
//            cell.IconImageView.image = self.iconImage;
            
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"昵称";
            cell.subTitleLabel.text = self.model.custNname;
        }
        else if (indexPath.row == 2){
            cell.titleLabel.text = @"我的二维码";
            cell.IconImageView.image = [UIImage imageNamed:@"yr_QRCode"];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            cell.titleLabel.text = @"性别";
            if (self.model.custSex.integerValue == 0) {
                cell.subTitleLabel.text = @"女";
            }else if (self.model.custSex.integerValue == 1){
                cell.subTitleLabel.text = @"男";
            }
        }else  if (indexPath.row == 1) {
            cell.titleLabel.text = @"地区";
            cell.subTitleLabel.text = self.model.custLocation;
//            cell.subTitleLabel.text = @"湖北武汉";
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"个人签名";
            cell.subTitleLabel.text = self.model.custSignature;
//            cell.subTitleLabel.text = @"开心过每一天";
        }
        else if (indexPath.row == 3){
            cell.titleLabel.text = @"个人简介";
            cell.subTitleLabel.text = self.model.custDesc;
            cell.subTitleLabel.textAlignment = NSTextAlignmentRight;
//            cell.subTitleLabel.text = @"开心过每一天开心过每一天开心过每一天开心过每一天开心过每一天";
//            cell.subTitleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    cell.titleLabel.font = [UIFont titleFont17];
    cell.subTitleLabel.font = [UIFont titleFont17];
    cell.subTitleLabel.textColor = [UIColor grayColorOne];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 48;
        }
    }
    else if (indexPath.section==1&&indexPath.row==3){
        return 60;
    }
    else{
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 10;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取照片", nil];
            
            
            [actionSheet showInView:self.tableView];
        }
        else if (indexPath.row == 1){
            
//            RRZSetupNotsController *setupNotsVC = [[RRZSetupNotsController alloc]init];
            
            RRZSetupNotsController *setup = [[RRZSetupNotsController alloc]initWithNibName:@"RRZSetupNotsController" bundle:nil];
            
            setup.title = @"修改昵称";
            //            DLog(@"==%@",self.item);
                        setup.item = self.item;
            [self.navigationController pushViewController:setup animated:YES];
        }
        else if (indexPath.row == 2){
            
            RRZQRController *QRvc = [[RRZQRController alloc]init];
            //            QRvc.item = self.item;
            [self.navigationController pushViewController:QRvc animated:YES];
        }
    
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            RRZSetupSexController *setupSexVC = [[RRZSetupSexController alloc]init];
            setupSexVC.item = self.item;
            [self.navigationController pushViewController:setupSexVC animated:YES];
        }else if (indexPath.row ==1){
            
            RRZProvinceSelectController *provinceVC = [[RRZProvinceSelectController alloc]init];
            provinceVC.item = self.item;
            [self.navigationController pushViewController:provinceVC animated:YES];
            
            
        }else if (indexPath.row == 2){
          
            
            RRZSetupSignatureViewController *setupSignatureVC = [[RRZSetupSignatureViewController alloc]init];
               setupSignatureVC.title = @"个人签名";
            setupSignatureVC.item = self.item;
            [self.navigationController pushViewController:setupSignatureVC animated:YES];
        }
        else if (indexPath.row == 3){
            
            
            RRZSetupSignatureViewController *setupSignatureVC = [[RRZSetupSignatureViewController alloc]init];
            setupSignatureVC.item = self.item;
            setupSignatureVC.title = @"个人简介";
            [self.navigationController pushViewController:setupSignatureVC animated:YES];
        }
    }
    
}


#pragma mark - Action Sheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
               
            }
        else{
             [self cameraBtnClick];
        }
    }else if (buttonIndex == 1){
        [self albumBtnClick];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            //            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请在设置中打开相机权限" cancelButtonText:@"确定"];
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请在设置中打开相机权限" cancelButtonText:@"确定"];
            alertView.addCancelAction = ^(){
                
            };
            [alertView show];
        }
    }

}
-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])//ios8
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor = [UIColor themeColor];
        }
    }
    else//ios7
    {
        for( UIView * subView in actionSheet.subviews )
            
        {
            if( [subView isKindOfClass:[UIButton class]] )
            {
                UIButton * btn = (UIButton*)subView;
                [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)albumBtnClick{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
        [alert show];
    }
    else {
        UIImagePickerController *filePicker = [[UIImagePickerController alloc] init];
        filePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        filePicker.delegate = self;
        //        filePicker.mediaTypes = [NSArray arrayWithObject:@"public.image"];
        filePicker.allowsEditing = YES;
        [filePicker setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        filePicker.view.backgroundColor = [UIColor whiteColor];
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor whiteColor];
        shadow.shadowOffset = CGSizeMake(0, 0);
        
        filePicker.navigationBar.barTintColor = Global_Color;
        [filePicker.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor auxiliaryColor]}];
        
        //        [self.navigationController presentViewController:filePicker animated:YES completion:nil];
        BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
        [navi presentViewController:filePicker animated:YES completion:nil];
    }
}

-(void)cameraBtnClick{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
        [alert show];
    }
    else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        //        imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
        imagePickerController.allowsEditing = YES;
        [imagePickerController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

#pragma mark - imagePicker代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerEditedImage];
    
//    self.iconImageView.image = photo;
    
    self.iconImage = photo;
    [self uploadImage:photo withPickerController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImage:(UIImage *)image withPickerController:(UIImagePickerController *)picker{

    
    @weakify(self);
    //自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
        if (signature != nil) {
            //                *error = nil;
        } else {
            // construct error object
            //            *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", OSS_ACCESSKEYID, signature];
    }];
    NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    Imgclient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = OSS_BUCKETNAME;
    put.objectKey = [NSString stringWithFormat:@"headImage/%@.jpg",[self getTimeNow]];
    put.uploadingData = [image resetSizeOfImageData];;
    
    OSSTask * putTask = [Imgclient putObject:put];
      [MBProgressHUD showMessage:@""];
    [putTask continueWithBlock:^id(OSSTask *task) {
        DLog(@"%@",task);
        if (!task.error) {
              @strongify(self);
            task = [Imgclient presignPublicURLWithBucketName:OSS_BUCKETNAME
                                               withObjectKey:put.objectKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *imageUrl = (NSString *)task.result;
                self.urlImage = imageUrl;
//                self.model.custImg = imageUrl;
                [picker dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD hideHUD];
                [self upEndImage];
            });
        } else {
             [MBProgressHUD hideHUD];
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
- (void)upEndImage{
    [MBProgressHUD showMessage:@""];
    [YRHttpRequest ModifyPersonalInformationByChangeName:@"headImg" value:self.urlImage success:^(NSDictionary *data) {
        [YRUserInfoManager manager].currentUser.custImg = self.urlImage;
         [self saveModelInfoToDisk];
        [MBProgressHUD hideHUD];
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:@"修改个人头像成功"];
        
        YWPerson *person = [[YWPerson alloc] initWithPersonId:[YRUserInfoManager manager].currentUser.custId];
        [[SPKitExample sharedInstance].ywIMKit removeCachedProfileForPerson:person];


    } failure:^(NSString *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];
}
- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
//    NSLog(@"%@", timeNow);
    return timeNow;
}

@end
