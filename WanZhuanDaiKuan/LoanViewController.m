//
//  LoanViewController.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/12.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "LoanViewController.h"
#import "UIView+AEBHandyAutoLayout.h"
#import "UIFont+CTPMethods.h"
#import "UIDevice+CTPMethods.h"

#define NumberAndDecimal @"0123456789.\n"
#define Number @"0123456789\n"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\n"

@interface LoanViewController ()

@property NSArray *allConstraints;

@property UILabel *aTotalLabel;

@property UILabel *nMonthLabel;

@property CGFloat yOffsetOfSV;
@property BOOL yIsChangeed;

@end

@implementation LoanViewController

#pragma - Life Cycle
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //用于处理键盘遮住输入框相关内容
    //NSLog(@"%0.f",_yOffsetOfSV);
    if (_yOffsetOfSV!=0) {
        CGRect bounds=self.view.superview.bounds;
        bounds.origin.y-=_yOffsetOfSV;
        self.view.superview.bounds=bounds;
        _yOffsetOfSV=0;
        _yIsChangeed=NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _yIsChangeed=NO;
    
    _allConstraints=[NSArray new];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    int fontSize=10;
    if ([UIDevice isiPhone5]) {
        //NSLog(@"isiPhone5");
        fontSize=12;
    }else if([UIDevice isiPhone6]){
        //NSLog(@"isiPhone6");
        fontSize=14;
    }else if([UIDevice isiPad]){
        fontSize=20;
    }
    
    UIFont *font=[UIFont fontWithFamilyNames:0 size:fontSize];
    
    _tileLabel=[UILabel new];
    _tileLabel.text=@"贷款方式";
    _tileLabel.textAlignment=NSTextAlignmentCenter;
    _tileLabel.font=font;
    _tileLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_tileLabel];
    _tileLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    _aTotalLabel=[UILabel new];
    _aTotalLabel.font=font;
    _aTotalLabel.text=@"贷款总额";
    _aTotalLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_aTotalLabel];
    _aTotalLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    _iRateLabel=[UILabel new];
    _iRateLabel.font=font;
    _iRateLabel.text=@"贷款利率";
    _iRateLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_iRateLabel];
    _iRateLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    _nMonthLabel=[UILabel new];
    _nMonthLabel.text=@"贷款期次";
    _nMonthLabel.textAlignment=NSTextAlignmentCenter;
    _nMonthLabel.font=font;
    [self.view addSubview:_nMonthLabel];
    _nMonthLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    _aTotalTextField=[UITextField new];
    _aTotalTextField.font=font;
    _aTotalTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _aTotalTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _aTotalTextField.returnKeyType=UIReturnKeyDone;
    _aTotalTextField.borderStyle=UITextBorderStyleLine;
    _aTotalTextField.layer.borderColor=[[UIColor blueColor]CGColor];
    _aTotalTextField.placeholder=@"¥";
    _aTotalTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    [self.view addSubview:_aTotalTextField];
    _aTotalTextField.translatesAutoresizingMaskIntoConstraints=NO;
    _aTotalTextField.delegate=self;
    
    _iRateForYearTextField=[UITextField new];
    _iRateForYearTextField.font=font;
    _iRateForYearTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _iRateForYearTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _iRateForYearTextField.returnKeyType=UIReturnKeyDone;
    _iRateForYearTextField.borderStyle=UITextBorderStyleLine;
    _iRateForYearTextField.layer.borderColor=[[UIColor blueColor]CGColor];
    _iRateForYearTextField.placeholder=@"%";
    _iRateForYearTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    [self.view addSubview:_iRateForYearTextField];
    _iRateForYearTextField.translatesAutoresizingMaskIntoConstraints=NO;
    _iRateForYearTextField.delegate=self;
    
    _nInfoLabel=[UILabel new];
    _nInfoLabel.text=@"";
    _nInfoLabel.font=font;
    _nInfoLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_nInfoLabel];
    _nInfoLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    _nMonthCountsStepper=[UIStepper new];
    
    _nMonthCountsStepper.minimumValue=1;
    _nMonthCountsStepper.maximumValue=360;
    [self.view addSubview:_nMonthCountsStepper];
    _nMonthCountsStepper.translatesAutoresizingMaskIntoConstraints=NO;
    
    _nMonthCountsTextField=[UITextField new];
    _nMonthCountsTextField.font=font;
    _nMonthCountsTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _nMonthCountsTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _nMonthCountsTextField.returnKeyType=UIReturnKeyDone;
    _nMonthCountsTextField.borderStyle=UITextBorderStyleLine;
    _nMonthCountsTextField.placeholder=@"期";
    _nMonthCountsTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    [self.view addSubview:_nMonthCountsTextField];
    _nMonthCountsTextField.translatesAutoresizingMaskIntoConstraints=NO;
    _nMonthCountsTextField.delegate=self;
    _nMonthCountsTextField.tag=13;
    //_nMonthCountsTextField.enabled=NO;
    
    _nMonthCountsSlider=[UISlider new];
    _nMonthCountsSlider.minimumValue=1;
    _nMonthCountsSlider.maximumValue=360;
    
    //_nMonthCountsSlider setThumbImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    [self.view addSubview:_nMonthCountsSlider];
    _nMonthCountsSlider.translatesAutoresizingMaskIntoConstraints=NO;
    
    _repayTypeSeg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"等额本金",@"等额本息", nil]];
    _repayTypeSeg.selectedSegmentIndex=0;
    [self.view addSubview:_repayTypeSeg];
    _repayTypeSeg.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_nMonthCountsTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_nMonthCountsSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_aTotalTextField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[_aTotalTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    //[_aTotalTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_iRateForYearTextField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_nMonthCountsTextField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_nMonthCountsStepper addTarget:self action:@selector(stepValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_repayTypeSeg addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillLayoutSubviews{
    //删除原有约束
    //NSLog(@"LoanViewController viewWillLayoutSubviews");
    if ([_allConstraints count]>0) {
        //NSLog(@"%lu",(unsigned long)[_allConstraints count]);
        [self.view removeConstraints:_allConstraints];
    }
    _allConstraints=nil;
    //NSLog(@"%@",[UIDevice getDeviceVersion]);
    CGFloat blankA=20;
    CGFloat blankB=10;
    if ([UIDevice isiPhone5]) {
        blankB=15;
    }
    if ([UIDevice isiPhone6]) {
        blankB=20;
    }
    if ([UIDevice isiPad]) {
        //NSLog(@"Loan isiPad");
        blankB=35;
    }
    
    CGFloat viewWidth=self.view.frame.size.width;
    
    NSMutableArray *all=nil;
    UIApplication *app=[UIApplication sharedApplication];
    UIInterfaceOrientation currentOrientation=app.statusBarOrientation;
    
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        //竖屏
        NSArray *n1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tileLabel]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_tileLabel)];
        NSArray *n2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_aTotalLabel]-[_aTotalTextField]-[_repayTypeSeg]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_aTotalLabel,_aTotalTextField,_repayTypeSeg)];
        NSArray *n3=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_iRateLabel(_aTotalLabel)]-[_iRateForYearTextField(_aTotalTextField)]-[_nMonthCountsStepper]-[_nInfoLabel]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_iRateLabel,_aTotalLabel,_iRateForYearTextField,_aTotalTextField,_nMonthCountsStepper,_nInfoLabel)];
        NSArray *n4=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nMonthLabel(_aTotalLabel)]-[_nMonthCountsTextField(_aTotalTextField)]-[_nMonthCountsSlider]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_nMonthLabel,_aTotalLabel,_nMonthCountsTextField,_aTotalTextField,_nMonthCountsSlider)];
        
        NSArray *n11=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel]-b-[_aTotalLabel]-bB-[_iRateLabel]-bB-[_nMonthLabel]" options:0 metrics:@{@"b":@(blankA),@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalLabel,_iRateLabel,_nMonthLabel)];
        NSArray *n13=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel]-b-[_aTotalTextField(_nMonthCountsStepper)]-bB-[_iRateForYearTextField(_nMonthCountsStepper)]-bB-[_nMonthCountsTextField(_nMonthCountsStepper)]" options:0 metrics:@{@"b":@(blankA),@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalTextField,_iRateForYearTextField,_nMonthCountsTextField,_nMonthCountsStepper)];
        
        NSLayoutConstraint *s1=[_aTotalTextField constraintCenterYEqualToView:_aTotalLabel];
        NSLayoutConstraint *s2=[_repayTypeSeg constraintCenterYEqualToView:_aTotalLabel];
        
        NSLayoutConstraint *s3=[_iRateForYearTextField constraintCenterYEqualToView:_iRateLabel];
        NSLayoutConstraint *s4=[_nMonthCountsStepper constraintCenterYEqualToView:_iRateLabel];
        NSLayoutConstraint *s5=[_nInfoLabel constraintCenterYEqualToView:_iRateLabel];
        
        NSLayoutConstraint *s6=[_nMonthCountsTextField constraintCenterYEqualToView:_nMonthLabel];
        NSLayoutConstraint *s7=[_nMonthCountsSlider constraintCenterYEqualToView:_nMonthLabel];
        
        NSArray *n12=[_aTotalTextField constraintsRightInContainer:self.view.frame.size.width/2];
        NSLayoutConstraint *s8=[_aTotalTextField constraintWidth:self.view.frame.size.width/4];
        
        NSArray *ss=[NSArray arrayWithObjects:s1,s2,s3,s4,s5,s6,s7,s8, nil];
        
        all=[NSMutableArray new];
        [all addObjectsFromArray:n1];
        [all addObjectsFromArray:n2];
        [all addObjectsFromArray:n3];
        [all addObjectsFromArray:n4];
        //[all addObjectsFromArray:n8];
        //[all addObjectsFromArray:n9];
        //[all addObjectsFromArray:n10];
        [all addObjectsFromArray:n11];
        [all addObjectsFromArray:n12];
        [all addObjectsFromArray:n13];
        [all addObjectsFromArray:ss];

    }
    else if(UIInterfaceOrientationIsLandscape(currentOrientation)){
        //横屏
        //水平方向约束
        CGFloat textFieldWidth=(viewWidth-30)/2;
        NSArray *n4=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tileLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tileLabel)];
        NSArray *n5=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_aTotalLabel(w)]-(>=0)-[_aTotalTextField(w)]-|" options:0 metrics:@{@"b":@(blankA),@"w":@(textFieldWidth)} views:NSDictionaryOfVariableBindings(_aTotalLabel,_aTotalTextField,_nMonthCountsStepper)];
        NSArray *n6=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_iRateLabel(_aTotalLabel)]-(>=0@100)-[_iRateForYearTextField(_aTotalTextField)]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_iRateLabel,_aTotalLabel,_iRateForYearTextField,_aTotalTextField)];
        NSArray *n7=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nMonthLabel(_aTotalLabel)]-(>=0@100)-[_nMonthCountsTextField(_aTotalTextField)]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_nMonthLabel,_aTotalLabel,_nMonthCountsTextField,_aTotalTextField)];
        NSArray *n9=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_repayTypeSeg]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_repayTypeSeg)];
        NSArray *n12=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nInfoLabel(_aTotalLabel)]-(>=0@100)-[_nMonthCountsStepper]-|" options:0 metrics:@{@"b":@(blankA)} views:NSDictionaryOfVariableBindings(_nInfoLabel,_aTotalLabel,_nMonthCountsStepper,_aTotalTextField)];
        NSArray *n8=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nMonthCountsSlider]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nMonthCountsSlider)];
        
        //垂直方向约束
        NSArray *n10=nil;
        NSArray *n11=nil;
        
        if ([UIDevice isiPad]) {
            n10=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel]-bB-[_aTotalLabel]-bB-[_iRateLabel]-bB-[_repayTypeSeg]-bB-[_nMonthLabel]-bB-[_nInfoLabel]-bB-[_nMonthCountsSlider]" options:0 metrics:@{@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalLabel,_iRateLabel,_nMonthLabel,_nInfoLabel,_nMonthCountsSlider,_repayTypeSeg)];
            
            n11=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel]-bB-[_aTotalTextField]-bB-[_iRateForYearTextField]-bB-[_repayTypeSeg]-bB-[_nMonthCountsTextField]-bB-[_nMonthCountsStepper]-bB-[_nMonthCountsSlider]" options:0 metrics:@{@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalTextField,_iRateForYearTextField,_nMonthCountsTextField,_nMonthCountsStepper,_nMonthCountsSlider,_repayTypeSeg)];
        }
        else{
            n10=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel(<=15)]-bB-[_aTotalLabel(<=20)]-bB-[_iRateLabel(<=20)]-bB-[_repayTypeSeg(<=20)]-bB-[_nMonthLabel(<=20)]-bB-[_nInfoLabel]-[_nMonthCountsSlider]" options:0 metrics:@{@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalLabel,_iRateLabel,_nMonthLabel,_nInfoLabel,_nMonthCountsSlider,_repayTypeSeg)];
        
            n11=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tileLabel(<=15)]-bB-[_aTotalTextField(_nMonthCountsStepper)]-bB-[_iRateForYearTextField(_nMonthCountsStepper)]-bB-[_repayTypeSeg(_nMonthCountsStepper)]-bB-[_nMonthCountsTextField(_nMonthCountsStepper)]-bB-[_nMonthCountsStepper]-[_nMonthCountsSlider]" options:0 metrics:@{@"bB":@(blankB)} views:NSDictionaryOfVariableBindings(_tileLabel,_aTotalTextField,_iRateForYearTextField,_nMonthCountsTextField,_nMonthCountsStepper,_nMonthCountsSlider,_repayTypeSeg)];
        }
        
        NSLayoutConstraint *s1=[_nMonthLabel constraintCenterYEqualToView:_nMonthCountsTextField];
        NSLayoutConstraint *s2=[_nInfoLabel constraintCenterYEqualToView:_nMonthCountsStepper];
        NSArray *ss=[NSArray arrayWithObjects:s1,s2, nil];
        all=[NSMutableArray new];
        [all addObjectsFromArray:n4];
        [all addObjectsFromArray:n5];
        [all addObjectsFromArray:n6];
        [all addObjectsFromArray:n7];
        [all addObjectsFromArray:n8];
        [all addObjectsFromArray:n9];
        [all addObjectsFromArray:n10];
        [all addObjectsFromArray:n11];
        [all addObjectsFromArray:n12];
        [all addObjectsFromArray:ss];
    }
    
    
    
    
    _allConstraints=[NSArray arrayWithArray:all];
    [self.view addConstraints:_allConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Events
-(void)textFieldChanged:(UITextField *)sender{
    _nMonthCountsStepper.value=[sender.text intValue];
    _nMonthCountsSlider.value=[sender.text intValue];
    //_nInfoLabel.text=[self yearInfo:[sender.text floatValue]/12];
    _nInfoLabel.text=[self yearInfo:[_nMonthCountsTextField.text intValue]];
}

- (void)sliderChanged:(UISlider *)sender {
    _nMonthCountsStepper.value=sender.value;
    _nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%.0f",roundf(sender.value)];
    //_nInfoLabel.text=[self yearInfo:sender.value/12];
    _nInfoLabel.text=[self yearInfo:[_nMonthCountsTextField.text intValue]];
}

-(void)stepValueChanged:(UIStepper *)sender{
    _nMonthCountsSlider.value=sender.value;
    _nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%.0f",roundf(sender.value)];
    //_nInfoLabel.text=[self yearInfo:sender.value/12];
   _nInfoLabel.text=[self yearInfo:[_nMonthCountsTextField.text intValue]];
}

-(void)segmentedChanged:(UISegmentedControl *)sender{
    if (_loanType==2) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                _iRateLabel.text=@"手续费率";
                _iRateForYearTextField.placeholder=@"%";
                break;
            case 1:
                _iRateLabel.text=@"手 续 费";
                _iRateForYearTextField.placeholder=@"¥";
                break;
            default:
                break;
        }

    }
}


- (void)textFieldDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
    //NSLog(@"textFieldDidEndOnExit");
}

- (void)backGroundTap:(UIControl *)sender {
    [self.aTotalTextField resignFirstResponder];
    [self.iRateForYearTextField resignFirstResponder];
    [self.nMonthCountsTextField resignFirstResponder];
}

#pragma - Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *allowedString=NumberAndDecimal;
    if (textField.tag==13) {
        //如果是期次，不允许输入小数点
        allowedString=Number;
    }
    NSCharacterSet *forbidenCharacterSet=[[NSCharacterSet characterSetWithCharactersInString:allowedString] invertedSet];
    NSArray *filteredArray=[string componentsSeparatedByCharactersInSet:forbidenCharacterSet];
    NSString *filteredString=[filteredArray componentsJoinedByString:@""];
    
    if (![string isEqualToString:filteredString]) {
        NSLog(@"The character 【%@】 is not allowed!",string);
    }
    
    return [string isEqualToString:filteredString];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender{
    [self changY:NO];
    _yIsChangeed=YES;
}

-(void)textFieldDidEndEditing:(UITextField *)sender{
    if (_yIsChangeed) {
        [self changY:YES];
        _yIsChangeed=NO;
    }
}

-(void)changY:(BOOL)isRecovery{
    CGFloat yOffset=0;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        if (_viewIdentifier==2) {
            //是第二个View，上移superView来防止遮挡输入框
            yOffset=120;
            if(isRecovery)
                yOffset=-yOffset;
            CGRect bounds=self.view.superview.bounds;
            bounds.origin.y+=yOffset;
            self.view.superview.bounds=bounds;
        }
    }
    else if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        yOffset=30;
        if(isRecovery)
            yOffset=-yOffset;
        CGRect bounds=self.view.superview.bounds;
        bounds.origin.y+=yOffset;
        self.view.superview.bounds=bounds;
    }
    
    CGRect bounds=self.view.superview.bounds;
    _yOffsetOfSV=bounds.origin.y;
    //NSLog(@"%0.f",_yOffsetOfSV);
}

#pragma - Custom Methods

-(NSString *)yearInfo:(int)nMonthCounts{
    NSString *yearInfo=[NSString new];
    NSString *sMonth=@"";
    NSString *sYear=@"";
    
    int yearCounts=nMonthCounts/12;//整数商
    int monthCounts=nMonthCounts%12;//余数
    
    if (monthCounts>=1&&monthCounts<=11) {
        sMonth=[[NSString alloc]initWithFormat:@"%d月",monthCounts];
    }
    if (monthCounts==0||monthCounts==12) {
        if (yearCounts!=0) {
            sMonth=@"整";
        }
    }
    
    if (yearCounts==0) {
        yearInfo=sMonth;
    }
    else{
        sYear=[[NSString alloc]initWithFormat:@"%d年",yearCounts];
        yearInfo=[sYear stringByAppendingString:sMonth];
    }
    
    return yearInfo;
}

#pragma - Getter&Setter
-(void)setLoanType:(int)loanType{
    if (_loanType!=loanType) {
        _loanType=loanType;
        switch (_loanType) {
            case 0:
                [_repayTypeSeg setTitle:@"等额本金" forSegmentAtIndex:0];
                [_repayTypeSeg setTitle:@"等额本息" forSegmentAtIndex:1];
                _iRateLabel.text=@"贷款利率";
                _iRateForYearTextField.placeholder=@"%";
                break;
            case 1:
                [_repayTypeSeg setTitle:@"等额本金" forSegmentAtIndex:0];
                [_repayTypeSeg setTitle:@"等额本息" forSegmentAtIndex:1];
                _iRateLabel.text=@"贷款利率";
                _iRateForYearTextField.placeholder=@"%";
                break;
            case 2:
                [_repayTypeSeg setTitle:@"手续费率" forSegmentAtIndex:0];
                [_repayTypeSeg setTitle:@"手 续 费" forSegmentAtIndex:1];
                [self segmentedChanged:_repayTypeSeg];
                break;
                
            default:
                break;
        }
    }
    [_aTotalTextField resignFirstResponder];
    [_iRateForYearTextField resignFirstResponder];
    [_nMonthCountsTextField resignFirstResponder];
}

@end
