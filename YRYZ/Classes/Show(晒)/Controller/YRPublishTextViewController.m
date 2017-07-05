//
//  YRPublishViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPublishTextViewController.h"
#import "YRReportTextView.h"
#import "YRSunAddImageCell.h"
#import "YRSunImageCell.h"
#import "QBImagePickerController.h"
#import "BaseNavigationController.h"
#import "YRSunImageModel.h"
#import "MWPhotoBrowser.h"
#import <AliyunOSSiOS/OSSService.h>

#define itemsH  (SCREEN_WIDTH - 50)/4

static NSString *yrPublishAddCellIdentifier = @"yrPublishAddCellIdentifier";
static NSString *yrPublishImageCellIdentifier = @"yrPublishImageCellIdentifier";

@interface YRPublishTextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QBImagePickerControllerDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)YRReportTextView *textView;

@property (nonatomic,strong) UILabel *numberLab;

@property (nonatomic,strong) UIActionSheet *actionSheet;

@property (nonatomic,strong) UICollectionView *ct_View;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic,strong) NSTimer *timer;
@end
OSSClient * textClient;

@implementation YRPublishTextViewController
- (UIActionSheet *)actionSheet
{
    if(_actionSheet == nil)
    {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
    }
    
    return _actionSheet;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒一晒";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UIScrollView *scrollView   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize     = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.contentInset    = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.view addSubview:scrollView];
    
    
    YRReportTextView *textView = [[YRReportTextView alloc] init];
    textView.mj_x              = 10.f;
    textView.mj_y              = 10.f;
    textView.mj_w              = SCREEN_WIDTH - 20;
    textView.mj_h              = 150.f;
    textView.font              = [UIFont systemFontOfSize:17.f];
    textView.placeholder       = @"晒一晒...";
    textView.clipsToBounds     = YES;
    self.textView              = textView;
    [scrollView addSubview:textView];
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(10, CGRectGetMaxY(textView.frame)+10, SCREEN_WIDTH-20, 1);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [scrollView.layer addSublayer:layer];
    
    UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(textView.frame)+12, 52, 18)];
    textNumber.textAlignment = NSTextAlignmentRight;
    textNumber.textColor     = [UIColor themeColor];
    textNumber.font          = [UIFont systemFontOfSize:15.f];
    textNumber.text          = @"0";
    self.numberLab           = textNumber;
    [scrollView addSubview:textNumber];
    
    UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, CGRectGetMaxY(textView.frame)+12, 38, 18)];
    maxNumber.textAlignment = NSTextAlignmentRight;
    maxNumber.textColor     = [UIColor lightGrayColor];
    maxNumber.font          = [UIFont systemFontOfSize:15.f];
    maxNumber.text          = @"/300";
    [scrollView addSubview:maxNumber];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize                    = CGSizeMake(itemsH, itemsH);
    flowLayout.sectionInset                = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumInteritemSpacing     = 10;
    flowLayout.minimumLineSpacing          = 10;
    
    /**创建Collectionview*/
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+30, kScreenWidth, itemsH*2+30) collectionViewLayout:flowLayout];
    collection.delegate          = self;
    collection.dataSource        = self;
    collection.backgroundColor   = [UIColor whiteColor];
    [collection registerClass:[YRSunAddImageCell class] forCellWithReuseIdentifier:yrPublishAddCellIdentifier];
    [collection registerClass:[YRSunImageCell class] forCellWithReuseIdentifier:yrPublishImageCellIdentifier];
    [scrollView addSubview:collection];

    self.ct_View = collection;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:textView];

}
/**
 *  @author ZX, 16-08-13 13:08:11
 *
 *  返回
 */
- (void)backAction{
    [self.view endEditing:YES];

    if (self.dataSource.count == 0 && self.textView.text.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定放弃当前编辑" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            
        [self dismissViewControllerAnimated:YES completion:nil];
        };
        [alertView show];
        
        }
}

/**
 *  @author ZX, 16-07-28 16:07:35
 *
 *  发布
 */
- (void)publishAction{
    
    
    if (self.dataSource.count == 0) {
        
        if (self.dataSource.count == 0 && self.textView.text.length == 0) {
            
            [MBProgressHUD showError:@"内容不能为空"];
        }else{
            
            //        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"发布之后内容不能修改，确定发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
            //
            //        alertView.addCancelAction = ^{
            //
            //        };
            //        alertView.addConfirmAction = ^{
            
            [YRHttpRequest sendSunTextByCustContent:self.textView.text Pics:@[] VideoPic:nil VideoUrl:nil success:^(NSDictionary *data) {
                
                DLog(@"data:%@",data);
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showError:@"发布成功"];
                
            } failure:^(NSString *errorInfo) {
                
                DLog(@"error:%@",errorInfo);
            }];
            
            
            //        };
            //        [alertView show];
        }
        

        
    }else{
        
        NSMutableArray *imageUrlArr = [NSMutableArray array];
        
        @weakify(self);
        for (int i = 0;i<self.dataSource.count;i++ ) {
            
            //自实现签名，可以用本地签名也可以远程加签
            id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
                NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"wzZjbJwDpzxN9smCMUZIIHt3HpEeVs"];
                return [NSString stringWithFormat:@"OSS %@:%@", @"Oul8T3WUa6qjuLLm", signature];
            }];
            NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            textClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
            
            
            YRSunImageModel *model = self.dataSource[i];
            
            NSData *imageData = [self resetSizeOfImageData:model.image maxSize:150];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            
            // 必填字段
            put.bucketName = @"yryz";
            put.objectKey = [NSString stringWithFormat:@"yryz_ios_pic_%d.jpg",i];
            put.uploadingData = imageData;
            
            OSSTask * putTask = [textClient putObject:put];
            
            [putTask continueWithBlock:^id(OSSTask *task) {
                
                @strongify(self);
                if (!task.error) {
                    NSLog(@"upload object success!");
                    NSDictionary *dic = @{@"id":@(i),@"url":[NSString stringWithFormat:@"http://oss-cn-hangzhou.aliyuncs.com/yryz_ios_pic_%d.jpg",i] };
                    
                    [imageUrlArr addObject:dic];
                    
                    if (imageUrlArr.count == self.dataSource.count) {
                        [self imageDataUploadingWith:imageUrlArr];
                        
                        DLog(@"数量达到叨叨");
                        
                    }
                    
                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }
    }
}

- (void)imageDataUploadingWith:(NSArray *)imagUrlArr{
    
    if (self.dataSource.count == 0 && self.textView.text.length == 0) {
    
        [MBProgressHUD showError:@"内容不能为空"];
    }else{
    
//        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"发布之后内容不能修改，确定发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
//        
//        alertView.addCancelAction = ^{
//            
//        };
//        alertView.addConfirmAction = ^{
            
            
            [YRHttpRequest sendSunTextByCustContent:self.textView.text Pics:imagUrlArr VideoPic:nil VideoUrl:nil success:^(NSDictionary *data) {
                
                DLog(@"data:%@",data);
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showError:@"发布成功"];
                
            } failure:^(NSString *errorInfo) {
                
                DLog(@"error:%@",errorInfo);
                    
            }];
            

//        };
//        [alertView show];
    }
}

// 压缩图片
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData;
    if (UIImagePNGRepresentation(newImage)) {
        imageData = UIImagePNGRepresentation(newImage);
    }else{
        imageData = UIImageJPEGRepresentation(newImage, 0.5);
    }
    
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YRSunAddImageCell *cell;
    
    
    if (indexPath.row == self.dataSource.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrPublishAddCellIdentifier forIndexPath:indexPath];
        cell.imgV.backgroundColor = RGB_COLOR(245, 245, 245);

    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrPublishImageCellIdentifier forIndexPath:indexPath];
        YRSunImageModel *model = self.dataSource[indexPath.row];
        cell.imgV.clipsToBounds = YES;
        cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgV.image = model.image;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == self.dataSource.count) {
        if (self.dataSource.count < 9) {
            [self addPhotos];
        }else{
            [MBProgressHUD showError:@"最多选取9张照片！"];
        }
    }else{
            [self lookAndDeletePhotosWithIndex:indexPath];
    }
}

- (void)addPhotos{
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"拍照",@"从相册选取"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self.actionSheet showInView:self.view];
    }
}

- (void)lookAndDeletePhotosWithIndex:(NSIndexPath *)indexPath{

    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YRSunImageModel *model = self.dataSource[idx];
        
        MWPhoto *photo = [MWPhoto photoWithImage:model.image];
        //            photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
        [photos addObject:photo];
        
    }];
    
    BOOL displayActionButton     = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows        = NO;
    BOOL enableGrid              = NO;
    BOOL startOnGrid             = NO;
    BOOL autoPlayOnAppear        = NO;
    
    // Options
    self.photos = photos;
    self.thumbs = thumbs;
    
    // Create browser
    MWPhotoBrowser *browser         = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton     = displayActionButton;
    browser.displayNavArrows        = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls      = displaySelectionButtons;
    browser.zoomPhotosToFill        = YES;
    browser.enableGrid              = enableGrid;
    browser.startOnGrid             = startOnGrid;
    browser.enableSwipeToDismiss    = NO;
    browser.autoPlayOnAppear        = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:indexPath.row];
    
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    
    static NSInteger index = 0;
    
    index = assets.count;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:index];
    for (PHAsset *asset in assets) {
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        
        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            
            YRSunImageModel *model = [[YRSunImageModel alloc] init];
            
            model.image = result;
            
            [images addObject:model];
            index --;
            
            if (index == 0) {
                [self uploadImages:images];
            }
         
        }];
    }
    [self.ct_View reloadData];

    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];

}

-(void)uploadImages:(NSArray *)images
{
    [self.dataSource addObjectsFromArray:images];
    
    [self.ct_View reloadData];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 9 - self.dataSource.count;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}
#pragma mark UIImagePickerControllerDelegate
// 拍照回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    YRSunImageModel *model = [[YRSunImageModel alloc] init];
    
    model.image = pickerImage;
    [self.dataSource addObject:model];
    
    [self.ct_View reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    for (NSString *title in titles) {
        if ([title isEqualToString:@"从相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                QBImagePickerController *imagePickerController = [QBImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = 9 - self.dataSource.count;
                imagePickerController.showsNumberOfSelectedAssets = YES;
                
                [self presentViewController:imagePickerController animated:YES completion:NULL];
                
            }];
            
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }else if ([title isEqualToString:@"拍照"]){
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持拍照" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
                    [alert show];
                }else{
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;//设置可编辑
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
                }
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

// iOS8.0之前可用
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


#pragma mark - 文字改变

- (void)textViewEditChanged:(NSNotification *)obj {
    
    self.textView = (YRReportTextView *)obj.object;
    NSString *toBeString = self.textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.textView markedTextRange];
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.textView.text.length == 0) {
                self.textView.placeholder = @"晒一晒...";
                self.numberLab.text = @"0";
            }else{
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 300) {
                    self.numberLab.text = @"300";
                }else {
                    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 300) {
//                [[DMCAlertCenter defaultCenter]postAlertWithMessage:@"超过最大字数200!"];
                self.textView.text = [toBeString substringToIndex:300];
            }
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
        }else {
            
        }
    }else {
        if (self.textView.text.length == 0) {
            self.textView.placeholder = @"晒一晒...";
            self.numberLab.text = @"0";
        }else{
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
                
            }
            if (toBeString.length > 300) {
//                [[DMCAlertCenter defaultCenter]postAlertWithMessage:@"超过最大字数200!"];
                self.textView.text = [toBeString substringToIndex:300];
            }else {
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 300) {
                    self.numberLab.text = @"300";
                }else {
                    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
