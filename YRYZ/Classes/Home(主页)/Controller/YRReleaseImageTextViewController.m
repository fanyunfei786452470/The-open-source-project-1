//
//  YRReleaseImageTextViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRReleaseImageTextViewController.h"
#import "SKTagView.h"
#import "IQKeyboardManager.h"
#import "YRHttpRequest.h"
#import "AFNetWorking.h"
@interface YRReleaseImageTextViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(strong,nonatomic) UITableView             *uploadTableView;
@property (nonatomic,strong) UITextField            *titleTextField;
@property (nonatomic,strong) UILabel                *titleNumLab;
@property (nonatomic,strong) UIView                 *bottomView;
@property (nonatomic,strong) UITextView             *textView;
@property (nonatomic,strong)NSMutableArray * selectedImages;

/**
 * 照片数组 ->用于管理
 * 1. 上传到服务器时需要
 * 2. 添加新的照片时需要
 * 3. 删除已在文中的照片时需要
 */
@property (nonatomic, strong) NSMutableArray    *photos;

/**
 * 索引数组 －>编辑时记录图片location
 * 1. 添加图片时，要记录该图片的location
 * 2. 删除图片时，通过location与该数组判断得出删除的是哪张照片
 */
@property (nonatomic, strong) NSMutableArray    *locations;


/** 图片的size数组*/
@property (nonatomic, strong) NSArray           *imageSizeArray;
/** 所有图片key数组*/
@property (nonatomic, strong) NSArray           *imageKeyArray;
/** 标准图片的字典*/
@property (nonatomic, strong) NSDictionary      *b_imageDictionary;
/** 原始图片等字典*/
@property (nonatomic, strong) NSDictionary      *r_imageDictionary;



@end

@implementation YRReleaseImageTextViewController


- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}

- (NSMutableArray *)locations{
    if (!_locations) {
        _locations = @[].mutableCopy;
    }
    return _locations;
}

- (NSMutableArray * )selectedImages{
    if (!_selectedImages) {
        _selectedImages = @[].mutableCopy;
    }
    return _selectedImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图文发布";
    [self setLeftNavButtonWithTitle:@"取消"];
    [self setRightNavButtonWithTitle:@"发布"];
    
    [self setupView];
    [self initBottomView];
    
}

- (void)rightNavAction:(UIButton *)button{
    [self postToServer];
}


-(void)setupView{
    _uploadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
    _uploadTableView.delegate = self;
    _uploadTableView.dataSource = self;
    _uploadTableView.separatorStyle = NO;
    //    _uploadTableView.scrollEnabled = NO;
    [self.view addSubview:_uploadTableView];
}

- (void)initBottomView{
    
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
    [self.bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.bottomView];
    
    UILabel *lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabe.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.bottomView  addSubview:lineLabe];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 120, 10, 110, 30);
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    [button setBackgroundColor:RGB_COLOR(204, 204, 204)];
    [button addTarget:self action:@selector(addSomePhotos) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 0;
    switch (indexPath.section) {
        case 0:
            cellHeight = 44;
            break;
        case 1:
            cellHeight = SCREEN_HEIGHT - 64 - 44 - 125 -50;
            break;
        case 2:
            cellHeight = 125;
            break;
        default:
            break;
    }
    
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        switch (indexPath.section) {
            case 0:
            {
                
                NSAttributedString *art = [[NSAttributedString alloc]initWithString:@"添加标题" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:RGB_COLOR(126, 126, 126)}];
                
                UITextField *addtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-80, 44)];
                addtitleTextField.delegate     = self;
                addtitleTextField.font         = [UIFont boldSystemFontOfSize:22.f];
                addtitleTextField.attributedPlaceholder = art;
                [cell.contentView addSubview:addtitleTextField];
                self.titleTextField = addtitleTextField;
                
                
                UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-63, 12, 25, 20)];
                textNumber.textAlignment = NSTextAlignmentRight;
                textNumber.textColor     = [UIColor themeColor];
                textNumber.font          = [UIFont systemFontOfSize:15.f];
                textNumber.text          = @"0";
                [cell.contentView addSubview:textNumber];
                self.titleNumLab = textNumber;
                
                UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 12, 25, 20)];
                maxNumber.textAlignment = NSTextAlignmentRight;
                maxNumber.textColor     = [UIColor lightGrayColor];
                maxNumber.font          = [UIFont systemFontOfSize:15.f];
                maxNumber.text          = @"/20";
                [cell.contentView addSubview:maxNumber];
                
                [addtitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 1:
            {
                
                
                self.textView        = [[UITextView alloc]init];
                self.textView .delegate           = self;
                //                self.textView .textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
                self.textView .font               = [UIFont systemFontOfSize:16];
                self.textView .frame              = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 125 -50);
                self.textView .placeholder = @"添加正文";
                self.textView.font = [UIFont systemFontOfSize:14];
                self.textView .delegate = self;
//                self.textView.attributedText = [self replaceSymbolStringWithSymbol:@"img" string:textString_2 images:images];
                [cell.contentView addSubview:self.textView ];
                
                
                //                _palceholderLabel           = [[UILabel alloc]init];
                //                _palceholderLabel.frame     = CGRectMake(15, 12, 70, 15);
                //                _palceholderLabel.text      = @"添加描述";
                //                _palceholderLabel.textColor = RGB_COLOR(126, 126, 126);
                //                _palceholderLabel.font      = [UIFont systemFontOfSize:16];
                //                [cell.contentView addSubview:_palceholderLabel];
                //                self.contextText = detailTextView;
                
                //                UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 85, 52, 20)];
                //                textNumber.textAlignment = NSTextAlignmentRight;
                //                textNumber.textColor     = [UIColor themeColor];
                //                textNumber.font          = [UIFont systemFontOfSize:15.f];
                //                textNumber.text          = @"0";
                //                [cell.contentView addSubview:textNumber];
                //                self.detailNumLab = textNumber;
                //
                //                UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, 85, 35, 20)];
                //                maxNumber.textAlignment = NSTextAlignmentRight;
                //                maxNumber.textColor     = [UIColor lightGrayColor];
                //                maxNumber.font          = [UIFont systemFontOfSize:15.f];
                //                maxNumber.text          = @"/100";
                //                [cell.contentView addSubview:maxNumber];
                
                
//                NSString *textString_2 = @"我今天很开心[图片], 因为我学会了吃饭[图片][图片]";
//                NSMutableArray *images = [NSMutableArray array];
//                for (int i = 0; i < 3; i++) {
//                    NSString *name = [NSString stringWithFormat:@"%d", i+1];
//                    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]];
//                    [images addObject:image];
//                }
                
//                self.textView.attributedText = [self replaceSymbolStringWithSymbol:@"[图片]" string:textString_2 images:images];

                
                
                
                
            }
                break;
            case 2:
            {
                UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 10, 15)];
                titleLable.text = @"选择标签";
                titleLable.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:titleLable];
                
                
                [cell.contentView addSubview:[self tagView]];
                
            }
                break;
            default:
                break;
        }
    }
    return cell;
}


- (SKTagView*)tagView{
    
    SKTagView   *tagView = [[SKTagView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 80)];
    tagView.backgroundColor = [UIColor whiteColor];
    tagView.padding    = UIEdgeInsetsMake(10, 10, 10, 10);
    tagView.interitemSpacing = 8;
    tagView.lineSpacing = 10;
    
    
    [@[@"Python", @"Javascript", @"HTML", @"Go",@"A",@"Android",@"C",@"Switf",@"J"] enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText:text];
        tag.textColor = UIColor.whiteColor;
        tag.bgImg = [UIImage imageNamed:@"yr_buttontag_bg"];
        tag.cornerRadius = 3;
        tag.fontSize = 15;
        tag.padding = UIEdgeInsetsMake(8, 5, 8, 5);
        [tagView addTag:tag];
    }];
    
    
    tagView.didTapTagAtIndex = ^(NSUInteger index){
        NSLog(@"Tap%ld",index);
        
    };
    
    return tagView;
}


#pragma mark tf代理

//监听标题文字
-(void)textFieldDidChange:(UITextField *)theTextField{
    DLog( @"text changed: %@", theTextField.text);
    
    NSString *toBeString = self.titleTextField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [self.titleTextField markedTextRange];
        UITextPosition *position = [self.titleTextField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.titleTextField.text.length == 0) {
                self.titleNumLab.text = @"0";
            }else{
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 20) {
                    self.titleNumLab.text = @"20";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 20) {
                self.titleTextField.text = [toBeString substringToIndex:20];
            }
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
        }
    }else{
        if (self.titleTextField.text.length == 0) {
            self.titleNumLab.text = @"0";
        }else{
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
            if (toBeString.length > 20) {
                self.titleTextField.text = [toBeString substringToIndex:20];
            }else {
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 20) {
                    self.titleNumLab.text = @"20";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
}

#pragma mark tv代理


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT- 50 - 64 -216 - 36, SCREEN_WIDTH, 50);
                     } completion:nil];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50);
                     } completion:nil];
}

//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}



- (void)addSomePhotos{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.textView  becomeFirstResponder];
    
    // 1.取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self setAttributeStringWithImage:(UIImage *)image];
}

#define MARGIN 20.0
/** 将图片插入到富文本中*/
- (void)setAttributeStringWithImage:(UIImage *)image{
    // 1. 保存图片与图片的location
    //[self.photos addObject:image];
    //[self.locations addObject:@(self.textView.selectedRange.location)];
    
    // 2. 将图片插入到富文本中
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    CGFloat imageRate = image.size.width / image.size.height;
    attach.bounds = CGRectMake(0, 10, self.textView.frame.size.width - MARGIN, (self.textView.frame.size.width - MARGIN) / imageRate);
    
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
    //    [mutableAttr replaceCharactersInRange:range withAttributedString:imageAttr];
    NSMutableAttributedString *mutableAttr = [self.textView.attributedText mutableCopy];
    NSLog(@"numtbleAttr:%@",mutableAttr);
    [mutableAttr insertAttributedString:imageAttr atIndex:self.textView.selectedRange.location];
    self.textView.attributedText = mutableAttr;
    
}

#pragma mark - UITextViewDelegate
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSLog(@"location:%d,length:%d",(int)range.location, (int)range.length);
//    // 模拟点击回车发送资料到服务器
//    if ([text isEqualToString:@"\n"]) {
//        // 提交到服务器
//        [self postToServer];
//    }
//
//    return YES;
//}

/** 发送数据到服务器*/
- (void)postToServer{
    NSLog(@"\n\n------------------%@",self.textView.attributedText  );
    // 1. 发送带有图片标志的纯文本到服务器
//    NSString *textString = [self textStringWithSymbol:@"<p><img>" attributeString:self.textView.attributedText];
//    NSLog(@"------%@", textString);
    
    
}

/** 将富文本转换为带有图片标志的纯文本*/
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    string = [self stringDeleteString:@"\n" frontString:@"img" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length)
                                options:0
                             usingBlock:^(id value, NSRange range, BOOL *stop) {
                                 //检查类型是否是自定义NSTextAttachment类
                                 if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                                     //替换
                                     [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
                                     //增加偏移量
                                     base += (symbol.length - 1);
                                 }
                             }];
    
    return textString;
}

///**
// * 将纯文本中带有图片标志的文本替换为富文本
// * symbol: 图片标志
// * string: 后台返回的纯文本
// * images: 已经保存到本地的图片 -> 网络图片先download到沙盒才能控制size
// */
//- (NSAttributedString *)replaceSymbolStringWithSymbol:(NSString *)symbol string:(NSString *)string images:(NSArray *)images{
//    
//    string = [self stringInsertString:@"\n" frontString:@"[图片]" inString:string];
//    // 取出所有图片标志的索引
//    NSArray *ranges = [self rangeOfSymbolString:symbol inString:string];
//    
//#warning Tips 可以先将后台返回的纯文字转成富文本再赋值给textView.attributeText, 或者先其他方式
//    
//    NSMutableParagraphStyle *paragraStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraStyle.lineSpacing = 4.0;
//    
//    self.textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraStyle,NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    
//    // 只有mutable类型的富文本才能进行编辑
//    NSMutableAttributedString *attributeString = [self.textView.attributedText mutableCopy];
//    
//#warning Tips about size: 和后台约定好，自己算或者后台给，一般只需要比例即可，可以下载好图片后，利用图片等size计算宽高比.
//    
//#warning Tips about base: 因为将图片标志替换为图片之后，attributeString的长度回发生变化，所以需要用base进行修正
//    
//    int base = 0;
//    for(int i=0; i < ranges.count; i++){
//        NSRange range = NSRangeFromString(ranges[i]);
//        // 这里替换图片
//        UIImage *image = images[i];
//        CGFloat rate = image.size.width / image.size.height;
//        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//        attach.image = image;
//        attach.bounds = CGRectMake(0, 10, self.textView.frame.size.width - MARGIN, (self.textView.frame.size.width - MARGIN) / rate);
//        [attributeString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
//        base -= (symbol.length - 1);
//    }
//    
//    return attributeString;
//}
//
//
/** 删除字符串*/
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (NSString *rangeString in ranges) {
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    return [mutableString copy];
}

/** 统计文本中所有图片资源标志的range*/
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            [rangeArray addObject:NSStringFromRange(range)];
        }
    }
    return rangeArray;
}




///** 插入字符串*/
//- (NSString *)stringInsertString:(NSString *)insertString frontString:(NSString *)frontString inString:(NSString *)inString{
//    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
//    NSMutableString *mutableString = [inString mutableCopy];
//    NSUInteger base = 0;
//    for (NSString *rangeString in ranges) {
//        NSRange range = NSRangeFromString(rangeString);
//        [mutableString insertString:insertString atIndex:range.location + base];
//        base += insertString.length;
//    }
//    return [mutableString copy];
//}
//
///** 将超文本格式化为富文本*/
//- (NSAttributedString *)htmlAttributeStringByHtmlString:(NSString *)htmlString{
//    NSAttributedString *attributeString;
//    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                   NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
//    NSError *error = nil;
//    attributeString = [[NSAttributedString alloc] initWithData:htmlData options:importParams documentAttributes:NULL error:&error];
//    return attributeString;
//}
//
///** 将富文本格式化为超文本*/
//- (NSString *)htmlStringByHtmlAttributeString:(NSAttributedString *)htmlAttributeString{
//    NSString *htmlString;
//    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                   NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
//    
//    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
//    htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//    return htmlString;
//}
//





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
