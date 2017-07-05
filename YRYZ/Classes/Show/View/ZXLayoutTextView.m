//
//  LayoutTextView.m
//  LayoutTextView
//
//  Created by JiaHaiyang on 16/7/6.
//  Copyright © 2016年 PlutusCat. All rights reserved.
//

#import "ZXLayoutTextView.h"
#import "YRReportTextView.h"
#define textViewFont [UIFont systemFontOfSize:17]

static CGFloat maxHeight = 80.0f;
static CGFloat leftFloat = 10.0f;
static CGFloat textViewHFloat = 36.0f;

@interface ZXLayoutTextView()<UITextViewDelegate>
@property (assign, nonatomic) CGFloat superHight;
@property (assign, nonatomic) CGFloat textViewY;
@property (assign, nonatomic) CGFloat keyBoardHight;
@property (assign, nonatomic) CGRect originalFrame;
@property (copy,nonatomic) NSString  *lastText;

@end

@implementation ZXLayoutTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _originalFrame = frame;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor = [UIColor whiteColor];
        
        YRReportTextView *textView   = [[YRReportTextView alloc] init];
        textView.delegate            = self;
        textView.placeholder         = _placeholder;
        textView.backgroundColor     = [UIColor whiteColor];
        textView.font                = textViewFont;
        textView.layer.cornerRadius  = 5;
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth   = 0.5;
        textView.returnKeyType       = UIReturnKeySend;
        textView.layer.borderColor   = [[UIColor grayColor] CGColor];
        textView.layoutManager.allowsNonContiguousLayout = NO;
        [self addSubview:textView];
        self.textView = textView;

        CGFloat textViewX = leftFloat;
        CGFloat textViewW = SCREEN_WIDTH-2*textViewX;
        CGFloat textViewH = textViewHFloat;
        CGFloat textViewY = (self.frame.size.height-textViewH)*0.5;
        
        _textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
        _textViewY        = textViewY;
        _superHight       = self.frame.size.height;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.textView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textView.placeholder = _placeholder;
}

#pragma mark - == UITextViewDelegate ==
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.lastText = @"";
    
    _textView.placeholder = _placeholder;
}
- (void)textViewDidChange:(UITextView *)textView{

    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height<=frame.size.height) {

    }else{
        if (size.height>=maxHeight){
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }else{
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    CGFloat superHeight = CGRectGetMaxY(textView.frame)+_textViewY;
    
    [UIView animateWithDuration:0.15 animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, SCREEN_HEIGHT-(_keyBoardHight+superHeight), self.frame.size.width, superHeight)];
    }];

    CGFloat h = [self heightForString:textView.text fontSize:17];
    
    if (textView.text.length >self.lastText.length+5) {
        if (h>maxHeight) {
            [textView setContentOffset:CGPointMake(0, (h-maxHeight)) animated:NO];
        }
    }
    DLog(@"文字高度：%f",h);
    
    self.lastText = textView.text;
}

-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{

    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.scrollEnabled = NO;
    CGRect frame           = textView.frame;
    textView.frame         = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textViewHFloat);
    [textView layoutIfNeeded];
    [_textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *str = [[NSString alloc]initWithString:[textView.text stringByTrimmingCharactersInSet:whiteSpace]];
        if (str.length != 0) {
   
                if (_sendBlock) {
                    _sendBlock(_textView);
                    [_textView resignFirstResponder];
                    _textView.placeholder = _placeholder;
                }
            
        }
        return NO;
    }
    return YES;
}

#pragma mark - == 键盘弹出事件 ==
- (void)keyboardWasShow:(NSNotification*)notification{

    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyBoardHight       = keyBoardFrame.size.height+64;
    
    DLog(@"键盘高度：%f",_keyBoardHight);
    
    [self translationWhenKeyboardDidShow:_keyBoardHight];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification{
    
    self.textView.placeholder = _placeholder;
    [self translationWhenKeyBoardDidHidden];
    
//    [self setNeedsDisplay];
}

- (void)translationWhenKeyboardDidShow:(CGFloat)keyBoardHight{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, SCREEN_HEIGHT - (keyBoardHight+self.frame.size.height), self.frame.size.width, self.frame.size.height);
    }];
}
- (void)translationWhenKeyBoardDidHidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = _originalFrame;
    }];
}
- (void)textViewEditChanged:(NSNotification *)obj {
    
    self.textView = (YRReportTextView *)obj.object;
    NSString *toBeString = self.textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.textView markedTextRange];
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > 100) {
                self.textView.text = [toBeString substringToIndex:100];
            }
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
        }
    }else {
        if (self.textView.text.length == 0) {
       
        }else{
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
            if (toBeString.length > 100) {
                self.textView.text = [toBeString substringToIndex:100];
            }
        }
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
