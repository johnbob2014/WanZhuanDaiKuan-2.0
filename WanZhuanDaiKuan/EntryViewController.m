//
//  EntryViewController.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/3.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "EntryViewController.h"
#import "DetailsTableViewController.h"
#import "DataModelObject.h"
#import "SelectDateViewController.h"
#import "UIView+AEBHandyAutoLayout.h"
#import "LoanViewController.h"
#import "InAppCaculatorViewController.h"
#import "ShareViewController.h"

@interface EntryViewController ()

@property(strong, nonatomic) UISegmentedControl *loanTypeSeg;
@property(strong,nonatomic) LoanViewController *loanViewController;
@property(strong,nonatomic) LoanViewController *loanViewController2;
@property(strong,nonatomic) NSArray *allConstraints;

@property(assign,nonatomic) int loanTypeBeforeSegmentedChanged;

@property(assign,nonatomic) BOOL jsqIsAdded;
@property(strong,nonatomic) InAppCaculatorViewController *jsqViewController;

@end

@implementation EntryViewController
#pragma - Life Cycle
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [_loanViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_loanViewController2 willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear");
    
    //这一句保证返回主界面时仍然显示工具栏，但是放在ViewDidLoad里不管用，所有放在这里了。加在哪里更合适？
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear");
}
-(void)viewWillLayoutSubviews{
    //NSLog(@"EntryviewController viewWillLayoutSubviews");
    
    //删除原有的全部约束，否则会出现冲突导致崩溃
    if ([_allConstraints count]>0) {
        [self.view removeConstraints:_allConstraints];
    }
    _allConstraints=nil;
    
    CGFloat blankSpace=10;
    CGFloat top=15;
    id topLG=self.topLayoutGuide;
    id buttomLG=self.bottomLayoutGuide;
    UIView *v1=_loanViewController.view;
    UIView *v2=_loanViewController2.view;
    
    NSArray *n1=nil;
    NSArray *n2=nil;
    NSArray *n3=nil;
    NSArray *n4=nil;
    UIApplication *app=[UIApplication sharedApplication];
    UIInterfaceOrientation currentOrientation=app.statusBarOrientation;
    
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        //竖屏
        n1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(blank)-[_loanTypeSeg]-(blank)-|" options:0 metrics:@{@"blank":@(blankSpace)} views:NSDictionaryOfVariableBindings(_loanTypeSeg)];
        n2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v1(v2)]|" options:0 metrics:@{@"blank":@(blankSpace)} views:NSDictionaryOfVariableBindings(v1,v2)];
        n3=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v2(v1)]|" options:0 metrics:@{@"blank":@(blankSpace)} views:NSDictionaryOfVariableBindings(v1,v2)];
        n4=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLG]-(blank)-[_loanTypeSeg(>=20)]-[v1]-[v2(v1)]-[buttomLG]" options:0 metrics:@{@"blank":@(blankSpace),@"top":@(top)} views:NSDictionaryOfVariableBindings(topLG,_loanTypeSeg,v1,v2,buttomLG)];
        
    }else if (UIInterfaceOrientationIsLandscape(currentOrientation)){
        //横屏
        n1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(blank)-[_loanTypeSeg]-(blank)-|" options:0 metrics:@{@"blank":@(blankSpace)} views:NSDictionaryOfVariableBindings(_loanTypeSeg)];
        n2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v1(v2)]-[v2]|" options:0 metrics:@{@"blank":@(blankSpace)} views:NSDictionaryOfVariableBindings(v1,v2)];
        n3=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLG]-(blank)-[_loanTypeSeg(>=20)]-[v1]-[buttomLG]" options:0 metrics:@{@"blank":@(blankSpace),@"top":@(top)} views:NSDictionaryOfVariableBindings(topLG,_loanTypeSeg,v1,buttomLG)];
        n4=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLG]-(blank)-[_loanTypeSeg(<=30)]-[v2]-[buttomLG]" options:0 metrics:@{@"blank":@(blankSpace),@"top":@(top)} views:NSDictionaryOfVariableBindings(topLG,_loanTypeSeg,v2,buttomLG)];
        
    }
    
    NSMutableArray *all=[NSMutableArray new];
    [all addObjectsFromArray:n1];
    [all addObjectsFromArray:n2];
    [all addObjectsFromArray:n3];
    [all addObjectsFromArray:n4];
    _allConstraints=[NSArray arrayWithArray:all];
    [self.view addConstraints:_allConstraints];
//    
//    [_loanViewController viewWillLayoutSubviews];
//    [_loanViewController2 viewWillLayoutSubviews];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //NSLog(@"viewDidLayoutSubviews");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    
    //_jsqIsAdded=NO;
    //_jsqViewController=[[InAppCaculatorViewController alloc]initWithNibName:@"InAppCaculatorViewController" bundle:nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
     _allConstraints=[NSArray new];
    
    //设置导航栏
    UIBarButtonItem *shareBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(shareBarButtonItemPressed:)];
    
    NSArray *barButtonItemArray=[[NSArray alloc]initWithObjects:shareBarButtonItem,nil];
    self.navigationItem.rightBarButtonItems=barButtonItemArray;
    
    //设置工具栏Toolbar
    [self.navigationController setToolbarHidden:NO];
    //设置导航栏
    UIBarButtonItem *setDateBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"还款日期" style:UIBarButtonItemStyleDone target:self action:@selector(setDateBarButtonItemPressed:)];
    UIBarButtonItem *jsqBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"计算器" style:UIBarButtonItemStyleDone target:self action:@selector(jsqBarButtonItemPressed:)];
    UIBarButtonItem *calculateBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"马上计算" style:UIBarButtonItemStyleDone target:self action:@selector(calculateBarButtonItemPressed:)];
    UIBarButtonItem *flexibleSpaceBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //务必注意下面这一句，换成别的是不行的
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpaceBarButtonItem,setDateBarButtonItem,flexibleSpaceBarButtonItem,jsqBarButtonItem,flexibleSpaceBarButtonItem,calculateBarButtonItem,flexibleSpaceBarButtonItem,nil]];
    //设置下一页返回按钮的标题
    UIBarButtonItem *backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    
    //使用之前必须先分配好内存，并进行初始化！！注释掉此行，无法使用程序！
    _dataModelObject=[[DataModelObject alloc]init];
    _dataModelObject.startDate=[NSDate date];
    
    //获取上次计算之后停留在的功能上
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    _loanTypeSeg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"单一贷款",@"组合贷款",@"分期付款", nil]];
    
    _loanTypeBeforeSegmentedChanged=(int)[[defaults valueForKey:@"loanType"] integerValue];
    _loanTypeSeg.selectedSegmentIndex=_loanTypeBeforeSegmentedChanged;
    [_loanTypeSeg addTarget:self action:@selector(loanTypeSegValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_loanTypeSeg];
    _loanTypeSeg.translatesAutoresizingMaskIntoConstraints=NO;
    
    _loanViewController=[LoanViewController new];
    _loanViewController.viewIdentifier=1;
    [self.view addSubview:_loanViewController.view];
    _loanViewController.view.translatesAutoresizingMaskIntoConstraints=NO;
    
    _loanViewController2=[LoanViewController new];
    _loanViewController2.viewIdentifier=2;
    [self.view addSubview:_loanViewController2.view];
    _loanViewController2.view.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Event
-(void)shareBarButtonItemPressed:(id)sender{
    ShareViewController *shareViewController=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    [self.navigationController pushViewController:shareViewController animated:NO];
}

-(void)setDateBarButtonItemPressed:(id)sender{
    SelectDateViewController *selectDateViewController=[SelectDateViewController new];
    selectDateViewController.entryViewController=self;
    selectDateViewController.title=@"请设置首次还款日期";
    [self.navigationController pushViewController:selectDateViewController animated:NO];
}

-(void)jsqBarButtonItemPressed:(id)sender{
//    if (_jsqIsAdded) {
//        [self removeJsq];
//    }
//    else{
//        [self addJsq];
//    }
    //_jsqViewController=[[InAppCaculatorViewController alloc]initWithNibName:@"InAppCaculatorViewController" bundle:nil];
    _jsqViewController=[InAppCaculatorViewController new];
    [self.navigationController pushViewController:_jsqViewController animated:NO];
}

-(void)calculateBarButtonItemPressed:(id)sender{
    //刷新数据模型，获取计算数据
    [self refreshDataModel];
    //记录用户设置，根据数据模型记录的，所以先刷新数据模型再记录；切换视图的时候只记录用户设置，不刷新数据模型
    [self recordUserDefaultsWithLoanType:_dataModelObject.loanType];
    
    if ([self checkDataModelObject]) {
        DetailsTableViewController *detailsTableViewController=[DetailsTableViewController new];
        detailsTableViewController.dataModelObject=_dataModelObject;
        
        NSString *title=[NSString new];
        switch (_dataModelObject.loanType) {
            case 0:
                title=@"单一贷款";
                break;
            case 1:
                title=@"组合贷款";
                break;
            case 2:
                title=@"分期付款";
                break;
            default:
                break;
        }
        
        detailsTableViewController.title=title;
        [self.navigationController pushViewController:detailsTableViewController animated:NO];
    }
}

-(BOOL)checkDataModelObject{
    BOOL checkResult=YES;
    UIAlertView *alert0=[[UIAlertView alloc]initWithTitle:@"提示" message:@"贷款期次不能为0" delegate:nil cancelButtonTitle:@"返回修改" otherButtonTitles: nil];
    UIAlertView *alert1200=[[UIAlertView alloc]initWithTitle:@"提示" message:@"贷款期次不能大于1200" delegate:nil cancelButtonTitle:@"返回修改" otherButtonTitles: nil];
    switch (_dataModelObject.loanType) {
        case 0:
            if (_dataModelObject.nMonthCounts==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
        case 1:
            if (_dataModelObject.nMonthCounts1==0||_dataModelObject.nMonthCounts2==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts1>1200||_dataModelObject.nMonthCounts2>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
        case 2:
            if (_dataModelObject.nMonthCounts3==0) {
                checkResult=NO;
                [alert0 show];
            }
            if (_dataModelObject.nMonthCounts3>1200) {
                checkResult=NO;
                [alert1200 show];
            }
            break;
        
        default:
            break;
    }
    return checkResult;
}

- (void)loanTypeSegValueChanged:(UISegmentedControl *)sender {
    //记录用户设置，切换视图的时候只需记录用户设置，无需新数据模型
    [self recordUserDefaultsWithLoanType:_loanTypeBeforeSegmentedChanged];
    //刷新视图
    [self refreshView];
    _loanTypeBeforeSegmentedChanged=(int)sender.selectedSegmentIndex;
    
    [_loanViewController.aTotalTextField resignFirstResponder];
    [_loanViewController.iRateForYearTextField resignFirstResponder];
    [_loanViewController.nMonthCountsTextField resignFirstResponder];
    [_loanViewController2.aTotalTextField resignFirstResponder];
    [_loanViewController2.iRateForYearTextField resignFirstResponder];
    [_loanViewController2.nMonthCountsTextField resignFirstResponder];
}

#pragma - Custom Methods
//-(void)addJsq{
//    if (!_jsqIsAdded) {
//        _jsqViewController.view.frame=CGRectMake((self.view.frame.size.width-280)/2, (self.view.frame.size.height-285-44), 280, 285);
//        [self.view addSubview:_jsqViewController.view];
//        _jsqIsAdded=YES;
//
//    }
//}
//
//-(void)removeJsq{
//    if (_jsqIsAdded) {
//        [self.navigationController popoverPresentationController];
//        _jsqIsAdded=NO;
//    }
//}

-(void)refreshView{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if (_loanTypeSeg.selectedSegmentIndex==0) {
        _loanViewController.tileLabel.text=@"单一贷款";
        
        _loanViewController.view.hidden=NO;
        _loanViewController2.view.hidden=YES;
        _loanViewController.loanType=0;
        
        //加载以前保存的数据
        _loanViewController.aTotalTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"aTotal"]floatValue]];
        _loanViewController.nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%d",[[defaults valueForKey:@"nMonthCounts"]intValue]];
        _loanViewController.nMonthCountsStepper.value=[[defaults valueForKey:@"nMonthCounts"]intValue];
        _loanViewController.nMonthCountsSlider.value=[[defaults valueForKey:@"nMonthCounts"]intValue];
        _loanViewController.nInfoLabel.text=[_loanViewController yearInfo:[[defaults valueForKey:@"nMonthCounts"]intValue]];
        _loanViewController.iRateForYearTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"iRateForMonth"]floatValue]*12*100];
        _loanViewController.repayTypeSeg.selectedSegmentIndex=[[defaults valueForKey:@"repayType"]intValue];
        
    }
    
    if (_loanTypeSeg.selectedSegmentIndex==1) {
        _loanViewController.tileLabel.text=@"贷款方式一";
        _loanViewController2.tileLabel.text=@"贷款方式二";
        
        _loanViewController.view.hidden=NO;
        _loanViewController2.view.hidden=NO;
        _loanViewController.loanType=1;
        
        //加载以前保存的数据
        _loanViewController.aTotalTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"aTotal1"]floatValue]];
        _loanViewController.nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%d",[[defaults valueForKey:@"nMonthCounts1"]intValue]];
        _loanViewController.nMonthCountsStepper.value=[[defaults valueForKey:@"nMonthCounts1"]intValue];
        _loanViewController.nMonthCountsSlider.value=[[defaults valueForKey:@"nMonthCounts1"]intValue];
        _loanViewController.nInfoLabel.text=[_loanViewController yearInfo:[[defaults valueForKey:@"nMonthCounts1"]intValue]];
        _loanViewController.iRateForYearTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"iRateForMonth1"]floatValue]*12*100];
        _loanViewController.repayTypeSeg.selectedSegmentIndex=[[defaults valueForKey:@"repayType1"]intValue];
        
        _loanViewController2.aTotalTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"aTotal2"]floatValue]];
        _loanViewController2.nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%d",[[defaults valueForKey:@"nMonthCounts2"]intValue]];
        _loanViewController2.nMonthCountsStepper.value=[[defaults valueForKey:@"nMonthCounts2"]intValue];
        _loanViewController2.nMonthCountsSlider.value=[[defaults valueForKey:@"nMonthCounts2"]intValue];
        _loanViewController2.nInfoLabel.text=[_loanViewController yearInfo:[[defaults valueForKey:@"nMonthCounts2"]intValue]];
        _loanViewController2.iRateForYearTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"iRateForMonth2"]floatValue]*12*100];
        _loanViewController2.repayTypeSeg.selectedSegmentIndex=[[defaults valueForKey:@"repayType2"]intValue];
        
    }
    
    if (_loanTypeSeg.selectedSegmentIndex==2) {
        _loanViewController.tileLabel.text=@"分期付款";
        
        _loanViewController2.view.hidden=YES;
        _loanViewController.view.hidden=NO;
        _loanViewController.loanType=2;
        
        //加载以前保存的数据
        _loanViewController.aTotalTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"aTotal3"]floatValue]];
        _loanViewController.nMonthCountsTextField.text=[[NSString alloc]initWithFormat:@"%d",[[defaults valueForKey:@"nMonthCounts3"]intValue]];
        _loanViewController.nMonthCountsStepper.value=[[defaults valueForKey:@"nMonthCounts3"]intValue];
        _loanViewController.nMonthCountsSlider.value=[[defaults valueForKey:@"nMonthCounts3"]intValue];
        _loanViewController.nInfoLabel.text=[_loanViewController yearInfo:[[defaults valueForKey:@"nMonthCounts3"]intValue]];
        _loanViewController.iRateForYearTextField.text=[[NSString alloc]initWithFormat:@"%.2f",[[defaults valueForKey:@"iCommission"]floatValue]];//注意此处
        _loanViewController.repayTypeSeg.selectedSegmentIndex=[[defaults valueForKey:@"iCommissionType"]intValue];//注意此处
        
    }
}

-(void)refreshDataModel{
    _dataModelObject.loanType=(int)_loanTypeSeg.selectedSegmentIndex;
    
    if (_dataModelObject.loanType==0) {
        //单一贷款
        _dataModelObject.aTotal=[_loanViewController.aTotalTextField.text floatValue];
        _dataModelObject.nMonthCounts=[_loanViewController.nMonthCountsTextField.text intValue];
        _dataModelObject.iRateForMonth=[_loanViewController.iRateForYearTextField.text floatValue]/12/100;
        _dataModelObject.repayType=(int)_loanViewController.repayTypeSeg.selectedSegmentIndex;
    }
    if (_dataModelObject.loanType==1) {
        //组合贷款
        _dataModelObject.aTotal1=[_loanViewController.aTotalTextField.text floatValue];
        _dataModelObject.nMonthCounts1=[_loanViewController.nMonthCountsTextField.text intValue];
        _dataModelObject.iRateForMonth1=[_loanViewController.iRateForYearTextField.text floatValue]/12/100;
        _dataModelObject.repayType1=(int)_loanViewController.repayTypeSeg.selectedSegmentIndex;
        
        _dataModelObject.aTotal2=[_loanViewController2.aTotalTextField.text floatValue];
        _dataModelObject.nMonthCounts2=[_loanViewController2.nMonthCountsTextField.text intValue];
        _dataModelObject.iRateForMonth2=[_loanViewController2.iRateForYearTextField.text floatValue]/12/100;
        _dataModelObject.repayType2=(int)_loanViewController2.repayTypeSeg.selectedSegmentIndex;
    }
    if (_dataModelObject.loanType==2) {
        //分期付款
        _dataModelObject.aTotal3=[_loanViewController.aTotalTextField.text floatValue];
        _dataModelObject.nMonthCounts3=[_loanViewController.nMonthCountsTextField.text intValue];
        _dataModelObject.iCommission=[_loanViewController.iRateForYearTextField.text floatValue];//此处为手续费或手续费率 这个是原始数据，没有转换为利率
        _dataModelObject.repayType3=1;//分期付款的还款方式为等额本息
        _dataModelObject.iCommissionType=(int)[_loanViewController.repayTypeSeg selectedSegmentIndex];
    }
}

-(void)recordUserDefaultsWithLoanType:(int)loanType{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:loanType forKey:@"loanType"];
    
    if (loanType==0) {
        //单一贷款
        [defaults setFloat:[_loanViewController.aTotalTextField.text floatValue] forKey:@"aTotal"];
        [defaults setInteger:[_loanViewController.nMonthCountsTextField.text intValue] forKey:@"nMonthCounts"];
        [defaults setFloat:[_loanViewController.iRateForYearTextField.text floatValue]/12/100 forKey:@"iRateForMonth"];
        [defaults setInteger:(int)_loanViewController.repayTypeSeg.selectedSegmentIndex forKey:@"repayType"];
    }
    if (loanType==1) {
        //组合贷款
        [defaults setFloat:[_loanViewController.aTotalTextField.text floatValue] forKey:@"aTotal1"];
        [defaults setInteger:[_loanViewController.nMonthCountsTextField.text intValue] forKey:@"nMonthCounts1"];
        [defaults setFloat:[_loanViewController.iRateForYearTextField.text floatValue]/12/100 forKey:@"iRateForMonth1"];
        [defaults setInteger:(int)_loanViewController.repayTypeSeg.selectedSegmentIndex forKey:@"repayType1"];
        
        [defaults setFloat:[_loanViewController2.aTotalTextField.text floatValue] forKey:@"aTotal2"];
        [defaults setInteger:[_loanViewController2.nMonthCountsTextField.text intValue] forKey:@"nMonthCounts2"];
        [defaults setFloat:[_loanViewController2.iRateForYearTextField.text floatValue]/12/100 forKey:@"iRateForMonth2"];
        [defaults setInteger:(int)_loanViewController2.repayTypeSeg.selectedSegmentIndex forKey:@"repayType2"];
    }
    if (loanType==2) {
        //分期付款
        [defaults setFloat:[_loanViewController.aTotalTextField.text floatValue] forKey:@"aTotal3"];
        [defaults setInteger:[_loanViewController.nMonthCountsTextField.text intValue] forKey:@"nMonthCounts3"];
        [defaults setInteger:1 forKey:@"repayType3"];//分期付款的还款方式为等额本息
        
        [defaults setFloat:[_loanViewController.iRateForYearTextField.text floatValue] forKey:@"iCommission"];//这个是原始数据，没有转换为利率
        [defaults setInteger:(int)_loanViewController.repayTypeSeg.selectedSegmentIndex forKey:@"iCommissionType"];//记录手续费还是手续费率
    }
    [defaults synchronize];
}

@end
