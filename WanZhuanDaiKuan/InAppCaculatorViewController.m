//
//  InAppCaculatorViewController.m
//  Compute
//
//  Created by 张保国 on 15/7/20.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "InAppCaculatorViewController.h"
#import "CaculatorBrain.h"

@interface InAppCaculatorViewController ()

@property BOOL isUseInEnteringANumber;
@property (nonatomic)CaculatorBrain *brain;
@property BOOL isContinue;
@property BOOL secondEqual;
@property BOOL firstEqual;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

- (IBAction)textFieldTouchDown:(UITextField *)sender;
@property (strong,nonatomic) NSString *textFieldText;

- (IBAction)closeButtonTouchDown:(UIButton *)sender;

@end

@implementation InAppCaculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置背景半透明
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    //隐藏工具栏
    [self.navigationController setToolbarHidden:YES];
    
    
    
    for (UIButton *btn in _buttonCollection) {
        
        [btn.layer setCornerRadius:0];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        //[btn setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.3 alpha:1]];
    }
    
    [_displayTextField.layer setCornerRadius:0];
    [_displayTextField.layer setBorderWidth:1];
    [_displayTextField.layer setBorderColor:[UIColor grayColor].CGColor];
    //[_displayTextField setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.3 alpha:1]];
    _displayTextField.textAlignment=NSTextAlignmentRight;
    _displayTextField.placeholder=NSLocalizedString(@"点击文本框可以将计算数值复制到剪贴板哦",@"");
    //_displayTextField.enabled=NO;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CaculatorBrain *)brain
{
    if (!_brain) {
        _brain = [CaculatorBrain new];
    }
    return _brain;
}
- (IBAction)digitPressed:(UIButton *)sender
{
    
    _secondEqual = NO;
    NSString *digit = sender.currentTitle;
    if (_isUseInEnteringANumber) self.displayTextField.text = [self.displayTextField.text stringByAppendingString:digit];
    else {
        self.displayTextField.text = digit;
        _isUseInEnteringANumber = YES;
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    
    self.firstEqual = YES;
    _secondEqual = NO;
    if(_isContinue) [self equalR];
    [self.brain pushOperation:sender.currentTitle];
    
    [self numberInBrain];
    _isContinue = YES;
}

- (IBAction)zeroPressed {
    self.displayTextField.text = @"0";
    [self.brain zero];
    _isContinue = NO;
    _isUseInEnteringANumber = NO;
    
    [self.brain pushNumberInStack:0.0 andBool:NO];
    self.secondEqual = NO;
    self.firstEqual = NO;
    
    
}

- (void)numberInBrain
{
    _isUseInEnteringANumber = NO;
    
    
    [self.brain pushNumberInStack:[self.displayTextField.text doubleValue] andBool:self.secondEqual];
}
- (IBAction)equalR {
    NSString *format=@"%.2f";
    if (self.firstEqual) {
        
        
        _isContinue = NO;
        [self numberInBrain];
        double resultNumber = [self.brain result:_secondEqual];
        if (resultNumber==floor(resultNumber)) {
            format=@"%0.f";
        }
        NSMutableString *resultStr = [NSMutableString stringWithFormat:format,resultNumber];
       
        /*
          NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%lg",resultNumber];
        //    NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%lf",resultNumber];
        //
        //    while ([resultStr hasSuffix:@"0"]) {
        //        [resultStr deleteCharactersInRange:NSMakeRange([resultStr length]-1, 1)];
        //    }
        //    while ([resultStr hasSuffix:@"."]) {
        //        [resultStr deleteCharactersInRange:NSMakeRange([resultStr length]-1, 1)];
        //    }
        
        if(resultNumber>1000000000){
            
            int count = 0;
            while (resultNumber >=10) {
                resultNumber/= 10;
                count++;
            }
            [resultStr deleteCharactersInRange:NSMakeRange(0, [resultStr length])];
            [resultStr appendFormat:@"%lg",resultNumber];
            [resultStr appendFormat:@" E%d",count];
            
        }
         */
        self.displayTextField.text = resultStr;
        [resultStr deleteCharactersInRange:NSMakeRange(0, [resultStr length])];
        _secondEqual = YES;
    }else {
        NSLog(@"right!");
        double resultNumber = [self.displayTextField.text doubleValue];
        if (resultNumber==floor(resultNumber)) {
            format=@"%0.f";
        }
        NSMutableString *resultStr = [NSMutableString stringWithFormat:format,resultNumber];
        /*
         NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%lg",resultNumber];
        if(resultNumber>1000000000){
            
            double count = 0.0;
            while (resultNumber >=10) {
                resultNumber /= 10.0;
                count += 1.0;
            }
            [resultStr deleteCharactersInRange:NSMakeRange(0, [resultStr length])];
            [resultStr appendFormat:@"%lg",resultNumber];
            [resultStr appendFormat:@"e%g",count];
            
        }
         */
        self.displayTextField.text = resultStr;
        [resultStr deleteCharactersInRange:NSMakeRange(0, [resultStr length])];
        
        
    }
    self.firstEqual = YES;
    
    
}

- (IBAction)textFieldTouchDown:(UITextField *)sender {
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string=sender.text;
    _textFieldText=sender.text;
    sender.text=NSLocalizedString(@"数值已复制到剪贴板",@"");
    sender.enabled=NO;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showPasteboardInfo:) userInfo:nil repeats:NO];
}

-(void)showPasteboardInfo:(id)sender{
    _displayTextField.text=_textFieldText;
    _displayTextField.enabled=YES;
}

- (IBAction)closeButtonTouchDown:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
