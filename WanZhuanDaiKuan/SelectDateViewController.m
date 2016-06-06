//
//  SelectDateViewController.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/10.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "SelectDateViewController.h"
#import "EntryViewController.h"
#import "DataModelObject.h"
#import "UIView+AEBHandyAutoLayout.h"

//static NSString * const kStartDate=@"kStartDate";
//static NSString * const kLoanName=@"LoanName";

@interface SelectDateViewController ()
@property (strong,nonatomic) UILabel *inforLabel;
@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UITextField *nameTextField;
@end

@implementation SelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController setToolbarHidden:YES];
    
    _inforLabel=[UILabel new];
    _inforLabel.numberOfLines=0;
    _inforLabel.text=@"如果您想把还款信息添加到日历中，请在此处设置首次还款的日期。同时，您也可以为还款信息添加一个标签，比如“房款”、“车贷”、“iMac分期”等。如您无需添加还款信息，请直接返回。";
    _inforLabel.textAlignment=NSTextAlignmentNatural;
    
    _datePicker=[UIDatePicker new];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.date=self.entryViewController.dataModelObject.startDate;
    //NSLog(@"%@",[NSLocale availableLocaleIdentifiers]);
    _datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.timeZone=[NSTimeZone defaultTimeZone];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _nameTextField=[UITextField new];
    _nameTextField.text=self.entryViewController.dataModelObject.loanName;
    _nameTextField.placeholder=@"请在此处填写一个备忘标签";
    _nameTextField.clearButtonMode=UITextFieldViewModeAlways;
    _nameTextField.returnKeyType=UIReturnKeyDone;
    _nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    _nameTextField.textAlignment=NSTextAlignmentCenter;
    _nameTextField.keyboardType=UIKeyboardTypeDefault;
    [_nameTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_nameTextField addTarget:self action:@selector(textfieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:_inforLabel];
    _inforLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addSubview:_datePicker];
    _datePicker.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.view addSubview:_nameTextField];
    _nameTextField.translatesAutoresizingMaskIntoConstraints=NO;
    
    id topLG=self.topLayoutGuide;
    id buttomLG=self.bottomLayoutGuide;
    
    NSArray *n1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLG]-(<=10)-[_nameTextField(<=30)]-[_datePicker(<=200)]-[_inforLabel]-(>=0)-[buttomLG]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_inforLabel,_datePicker,_nameTextField,topLG,buttomLG)];
    NSArray *n2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_inforLabel(_datePicker)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_inforLabel,_datePicker)];
    NSArray *n3=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nameTextField(_datePicker)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_datePicker,_nameTextField)];
    
    NSLayoutConstraint *s1=[_inforLabel constraintCenterXEqualToView:self.view];
    NSLayoutConstraint *s2=[_datePicker constraintCenterXEqualToView:self.view];
    NSLayoutConstraint *s3=[_nameTextField constraintCenterXEqualToView:self.view];
    NSArray *ss=[NSArray arrayWithObjects:s1,s2,s3,nil];
    
    
    [self.view addConstraints:n1];
    [self.view addConstraints:n2];
    [self.view addConstraints:n3];
    [self.view addConstraints:ss];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Events
-(void)datePickerValueChanged:(id)sender{
    self.entryViewController.dataModelObject.startDate=_datePicker.date;
    [self showInfo];
    [_nameTextField resignFirstResponder];
}

-(void)textFieldValueChanged:(id)sender{
    self.entryViewController.dataModelObject.loanName=_nameTextField.text;
    [self showInfo];
}

-(void)textfieldEditingDidEndOnExit:(id)sender{
    [sender resignFirstResponder];
}

#pragma - Custom Methods
-(void)showInfo{
    _inforLabel.textAlignment=NSTextAlignmentCenter;
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[dateFormatter stringFromDate:self.entryViewController.dataModelObject.startDate];
    _inforLabel.text=[[NSString alloc]initWithFormat:@"\n首次还款日期:%@\n您设置的标签:%@",date,_nameTextField.text];
}

-(void)setInforLabel:(UILabel *)inforLabel{
    inforLabel.textAlignment=NSTextAlignmentCenter;
}

@end
