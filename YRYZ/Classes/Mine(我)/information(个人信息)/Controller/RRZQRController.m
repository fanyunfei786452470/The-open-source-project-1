//
//  RRZQRController.m
//  Rrz
//
//  Created by 易超 on 16/3/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZQRController.h"
#import "RRZUserInfoItem.h"
#import <Photos/Photos.h>

@interface RRZQRController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;

@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;

@end

@implementation RRZQRController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"我的二维码"];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
    
//    DLog(@"headImageUrl = %@",self.item.custImgId);
//    DLog(@"headImageUrl = %@",[NSString headImageUrl:self.item.custImgId]);
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:self.item.custImgId]] placeholderImage:[UIImage defaultHead]];
   
    
    self.nameLabel.text = self.item.custNname;
    
//    DLog(@"%@",self.item.twoDimenCode);
//    DLog(@"%@",[NSString headImageUrl:self.item.twoDimenCode]);
//    [self.QRImageView sd_setImageWithURL:[NSURL URLWithString:[NSString headImageUrl:self.item.twoDimenCode]]];
    
    YRUserInfoManager *manager = [YRUserInfoManager manager];
     [self.iconImageView setImageWithURL:[NSURL URLWithString:manager.currentUser.custImg] placeholder:[UIImage defaultHead]];
    
    [self.QRImageView setImageWithURL:[NSURL URLWithString:manager.currentUser.custQr] placeholder:nil];
    self.QRImageView.backgroundColor = RGB_COLOR(245, 245, 245);
    
    self.name.text = manager.currentUser.custNname;
    self.place.text =  manager.currentUser.custLocation;
    self.name.textColor = RGB_COLOR(26, 191, 181);
    self.place.textColor = RGB_COLOR(142, 142, 142);
     self.QRImageView.userInteractionEnabled = YES;
    
    self.buttomLabel.text = @"扫一扫上面的二维码，加我吧   长按保存图片";
    self.buttomLabel.textAlignment = NSTextAlignmentCenter;
    
    [self savePhoto];
    
    
}
- (void)savePhoto{
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapCliclk:)];
    
   
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    longTap.minimumPressDuration = 2;
//    longTap.numberOfTouchesRequired = 1;
    [self.QRImageView addGestureRecognizer:longTap];
    
    
    
    
    
}
-(void)imglongTapClick:(UILongPressGestureRecognizer *)longTap{
    
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
//    UIImageWriteToSavedPhotosAlbum(self.QRImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    self
    
    
    if (longTap.state == UIGestureRecognizerStateBegan) {
//         UIImageWriteToSavedPhotosAlbum(self.QRImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
        // requestAuthorization方法的功能
        //    1.如果用户还没有做过选择，这个方法就会弹框让用户做出选择
        //    1> 用户做出选择以后才会回调block
        //    2.如果用户之前已经做过选择，这个方法就不会再弹框，直接回调block，传递现在的授权状态给block
        PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusAuthorized: {
                        //  保存图片到相册
                        [self saveImageIntoAlbum];
                        break;
                    }
                    case PHAuthorizationStatusDenied: {
                        if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请打开相册访问权限" cancelButtonText:@"确定"];
                        
                        [alertView show];

                        break;
                    }
                    case PHAuthorizationStatusRestricted: {
                        
                        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"因系统原因，无法访问相册" cancelButtonText:@"确定"];
                        
                        [alertView show];
                        break;
                    }       
                    default:
                        break;
                }
            });
        }];
        
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"成功保存到相册" cancelButtonText:@"确定"];

        [alertView show];
        
    }else
    {
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"保存相册失败" cancelButtonText:@"确定"];
        
        [alertView show];
    }
    NSLog(@"message is %@",message);

}

-(PHFetchResult<PHAsset *> *)createdAssets
{
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.QRImageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}
-(PHAssetCollection *)createdCollection
{
    // 获取软件的名字作为相册的标题(如果需求不是要软件名称作为相册名字就可以自己把这里改成想要的名称)
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (createdCollectionId == nil) return nil;
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}

-(void)saveImageIntoAlbum
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdAssets == nil || createdCollection == nil) {
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"保存相册失败" cancelButtonText:@"确定"];
        
        [alertView show];
        return;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 保存结果
    if (error) {
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"保存相册失败" cancelButtonText:@"确定"];
        
        [alertView show];

    } else {
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"成功保存到相册" cancelButtonText:@"确定"];
        
        [alertView show];

    }
}



@end



























