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
#import "JFImagePickerController.h"
#import <AliyunOSSiOS/OSSService.h>

#define itemsH  (SCREEN_WIDTH - 50)/4

static NSString *yrPublishAddCellIdentifier = @"yrPublishAddCellIdentifier";
static NSString *yrPublishImageCellIdentifier = @"yrPublishImageCellIdentifier";

@interface YRPublishTextViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,QBImagePickerControllerDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,YRSunImageCellDelegate>

@property (nonatomic,weak)YRReportTextView *textView;

@property (nonatomic,strong) UILabel *numberLab;

@property (nonatomic,weak) UICollectionView *ct_View;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL isSend;


@end
OSSClient * textClient;

@implementation YRPublishTextViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随手晒";
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"yr_show_edit"] forState:UIControlStateNormal];
    [rightBtn setTitle:@" 发布" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem     *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UIScrollView *scrollView   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate        = self;
    scrollView.contentSize     = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    
    YRReportTextView *textView = [[YRReportTextView alloc] init];
    textView.mj_x              = 10.f;
    textView.mj_y              = 10.f;
    textView.mj_w              = SCREEN_WIDTH - 20;
    textView.mj_h              = 150.f;
    textView.font              = [UIFont systemFontOfSize:17.f];
    textView.placeholder       = @"写点什么来随手晒吧...";
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
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+30, kScreenWidth, itemsH*3+30) collectionViewLayout:flowLayout];
    collection.delegate          = self;
    collection.dataSource        = self;
    collection.backgroundColor   = [UIColor whiteColor];
    collection.scrollEnabled     = NO;
    [collection registerClass:[YRSunAddImageCell class] forCellWithReuseIdentifier:yrPublishAddCellIdentifier];
    [collection registerClass:[YRSunImageCell class] forCellWithReuseIdentifier:yrPublishImageCellIdentifier];
    [scrollView addSubview:collection];

    self.ct_View = collection;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:textView];
    
    if (self.imageArr.count >0) {
        [self.dataSource addObjectsFromArray:self.imageArr];
        [self.ct_View reloadData];
    }
    
    if (self.isText) {
        collection.hidden = YES;
    }else{
        collection.hidden = NO;
    }

}


/**
 *  @author ZX, 16-08-13 13:08:11
 *
 *  返回
 */
- (void)backAction{
    [self.view endEditing:YES];
    
    if (self.isSend) {
        return;
    }

    @weakify(self);
    if (self.dataSource.count == 0 && self.textView.text.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布吗？" cancelButtonText:@"退出" confirmButtonText:@"取消"];
        
        alertView.addCancelAction = ^{
            [JFImagePickerController clear];

            
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            
        };
        alertView.addConfirmAction = ^{
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
    
    [self.view endEditing:YES];
    
    
    @weakify(self);
    
    if (self.dataSource.count == 0) {
        
        if (self.dataSource.count == 0 && self.textView.text.length == 0) {
            
            [MBProgressHUD showError:@"内容不能为空"];
        }else{
            
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"发布之后内容不能修改，确定发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
            
        alertView.addCancelAction = ^{
        };
        alertView.addConfirmAction = ^{
            
            self.isSend = YES;
            
            [MBProgressHUD showMessage:@""];
            [YRHttpRequest sendSunTextByCustContent:self.textView.text Pics:@[] VideoPic:nil VideoUrl:nil success:^(NSDictionary *data) {
                NSDate *senddate = [NSDate date];
                NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                 NSDictionary *dic = @{@"comments":@[],
                                      @"content":self.textView.text?self.textView.text:@"",
                                       @"custId":[YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                       @"custImg":[YRUserInfoManager manager].currentUser.custImg?[YRUserInfoManager manager].currentUser.custImg:@"",
                                       @"custNname":[YRUserInfoManager manager].currentUser.custNname?[YRUserInfoManager manager].currentUser.custNname:@"",
                                      @"isLike":@(0),
                                      @"likes":@[],
                                      @"pics":@[],
                                      @"sendTime":@"",
                                      @"sid":data[@"sid"]?data[@"sid"]:@"",
                                      @"timeStamp":date2,
                                      @"videoPic":@"",
                                      @"videoUrl":@""
                                      };
                
                
                @strongify(self);
                [MBProgressHUD hideHUDForView:nil];

                [MBProgressHUD showError:@"发布成功"];

                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if ([self.delegate respondsToSelector:@selector(getYRPublishTextShowSunTextWithDic:)]) {
                        [self.delegate getYRPublishTextShowSunTextWithDic:dic];
                    }
                }];

            } failure:^(NSString *errorInfo) {
                [MBProgressHUD hideHUDForView:nil];
                self.isSend = NO;

                DLog(@"error:%@",errorInfo);
            }];
            
        };
            
        [alertView show];
            
        }

    }else{
//        @weakify(self);

        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"发布之后内容不能修改，确定发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{

        };
        alertView.addConfirmAction = ^{
        
        
        [MBProgressHUD showMessage:@""];
            
        self.isSend = YES;

        NSMutableArray *imageUrlArr = [NSMutableArray array];
            
            
        
        for (int i = 0;i<self.dataSource.count;i++ ) {
            
            //自实现签名，可以用本地签名也可以远程加签
            id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
                NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
                return [NSString stringWithFormat:@"OSS %@:%@",OSS_ACCESSKEYID, signature];
            }];
            NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            textClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
            
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
            NSString *identifierNumber = [NSString stringWithFormat:@"%@",uuidstring];
            
            DLog(@"UUID：%@",identifierNumber);
            NSDictionary *dic = @{@"id":@(i),@"url":[NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",identifierNumber] };
            [imageUrlArr addObject:dic];
            
            UIImage *imageData =  self.dataSource[i];
//            UIImage *picImg = [self fixOrientation:imageData];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = OSS_BUCKETNAME;
            
            put.objectKey = [NSString stringWithFormat:@"picture/%@_iOS.jpg",identifierNumber];
            put.uploadingData = UIImagePNGRepresentation(imageData);
            
            OSSTask * putTask = [textClient putObject:put];
            
            [putTask continueWithBlock:^id(OSSTask *task) {
          
                if (!task.error) {
                    NSLog(@"upload object success!");
                 
                                } else {
                    NSLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
           }

            if (imageUrlArr.count == self.dataSource.count) {
                [self imageDataUploadingWith:imageUrlArr];
            }
        };
        [alertView show];
    }
}

- (void)imageDataUploadingWith:(NSArray *)imagUrlArr{
    
    @weakify(self);
    
    if (self.dataSource.count == 0 && self.textView.text.length == 0) {
    
        [MBProgressHUD showError:@"内容不能为空"];
    }else{
    
            
            [YRHttpRequest sendSunTextByCustContent:self.textView.text Pics:imagUrlArr VideoPic:nil VideoUrl:nil success:^(NSDictionary *data) {
                NSDate *senddate = [NSDate date];
                NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                NSDictionary *dic = @{@"comments":@[],
                                      @"content":self.textView.text?self.textView.text:@"",
                                      @"custId":[YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                      @"custImg":[YRUserInfoManager manager].currentUser.custImg?[YRUserInfoManager manager].currentUser.custImg:@"",
                                      @"custNname":[YRUserInfoManager manager].currentUser.custNname?[YRUserInfoManager manager].currentUser.custNname:@"",
                                      @"isLike":@(0),
                                      @"likes":@[],
                                      @"pics":imagUrlArr,
                                      @"sendTime":@"",
                                      @"sid":data[@"sid"]?data[@"sid"]:@"",
                                      @"timeStamp":date2,
                                      @"videoPic":@"",
                                      @"videoUrl":@""
                                      };

                @strongify(self);
                DLog(@"data:%@",data);
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if ([self.delegate respondsToSelector:@selector(getYRPublishTextShowSunTextWithDic:)]) {
                        [self.delegate getYRPublishTextShowSunTextWithDic:dic];
                    }
                }];
                [JFImagePickerController clear];

                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD hideHUDForView:nil];
                [MBProgressHUD showError:@"发布成功"];

            } failure:^(NSString *errorInfo) {
                [MBProgressHUD hideHUDForView:nil];
                self.isSend = NO;

                DLog(@"error:%@",errorInfo);
            }];
    }
}


// 压缩图片
- (UIImage *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    CGSize newSize;
    if(source_image.size.width / source_image.size.height > 750.0f / 1334.0f){
        newSize = CGSizeMake(750, source_image.size.height * 750.0f / source_image.size.width);
    }else{
        newSize = CGSizeMake(source_image.size.width * 1334.0f / source_image.size.height, 1334);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YRSunAddImageCell *cell;
    
    if (indexPath.row == self.dataSource.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrPublishAddCellIdentifier forIndexPath:indexPath];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrPublishImageCellIdentifier forIndexPath:indexPath];
        
        UIImage *imageData =  self.dataSource[indexPath.row];
        cell.imgV.image = [self fixOrientation:imageData];
        cell.imgV.clipsToBounds = YES;
        cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
        YRSunImageCell *imgCell = (YRSunImageCell *)cell;
        imgCell.indexPath = indexPath;
        imgCell.delegate = self;
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

//删除图片
- (void)didClickDelegatePhotoWithIndex:(NSIndexPath *)indexPath{
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    
    [self.ct_View reloadData];

}

- (void)addPhotos{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"拍照",@"从相册选取"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];

}

- (void)lookAndDeletePhotosWithIndex:(NSIndexPath *)indexPath{

    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *copyOfOriginalImage =  self.dataSource[idx];
  
        MWPhoto *photo = [MWPhoto photoWithImage:copyOfOriginalImage];
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


- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
    NSMutableArray *dataArray = [NSMutableArray array].mutableCopy;
    
    for (ALAsset *asset in picker.assets) {
        UIImage *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        
        UIImage *image = [self resetSizeOfImageData:copyOfOriginalImage maxSize:150];
        
        if ([image isKindOfClass:[UIImage class]]) {
            [dataArray addObject:image];
        }
    }
    
    if (dataArray.count == picker.assets.count) {
         @weakify(self);
        [picker dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self.dataSource addObjectsFromArray:dataArray];
            [self.ct_View reloadData];
            
            [JFImagePickerController clear];
            
        }];
    }
}
- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    

    NSMutableArray *dataArray = [NSMutableArray array].mutableCopy;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *images = [self resetSizeOfImageData:image maxSize:150];
    [dataArray addObject:images];
    
    [self.dataSource addObjectsFromArray:dataArray];

    [self.ct_View reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    
    @weakify(self);
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"从相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                NSInteger seleteCount = 9 - self.dataSource.count;
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",seleteCount] forKey:@"seletePicCount"];//设置选择个数

                JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:self];
                picker.pickerDelegate = self;
                [self presentViewController:picker animated:YES completion:nil];
                
            }];
            
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
        }else if ([title isEqualToString:@"拍照"]){
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
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
            if (SYSTEMVERSION>=8.4) {
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
