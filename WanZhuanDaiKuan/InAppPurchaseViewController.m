//
//  InAppPurchaseViewController.m
//  贷款计算器
//
//  Created by 张保国 on 15/7/19.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import "UIView+AEBHandyAutoLayout.h"

#define ProductID_CNY @"com.ZhangBaoGuo.WanZhuanDaiKuan2015.CNY"
#define ProductID_CNY12 @"com.ZhangBaoGuo.WanZhuanDaiKuan2015.CNY"

@interface InAppPurchaseViewController ()
@property (strong,nonatomic) UITextView *textView;
//@property (strong,nonatomic) UIButton *okButton;
@property (copy,nonatomic) NSString *infoString;
@property (strong,nonatomic) UIBarButtonItem *barButtonItem;
@end

@implementation InAppPurchaseViewController

-(void)viewWillLayoutSubviews{
    NSArray *n1=[_textView constraintsFill];
    [self.view addConstraints:n1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加UITextView显示信息
    _productIndex=0;
    
    _textView=[UITextView new];
    [_textView.layer setBorderColor:[UIColor grayColor].CGColor];
    _textView.editable=NO;
    _textView.selectable=NO;
    _textView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_textView];
    
    //添加工具栏按钮，主要用于失败后再次重新尝试
    _barButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemPressed:)];
    _barButtonItem.enabled=NO;
    UIBarButtonItem *flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array=[NSArray arrayWithObjects:flexibleSpace,_barButtonItem,flexibleSpace, nil];
    [self setToolbarItems:array];
    
    //监听结果
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
    //购买还是恢复
    switch (_transactionType) {
        case TransactionTypePurchase:
            _barButtonItem.title=NSLocalizedString(@"正在购买...",@"");
            [self startProductRequest];
            break;
        case TransactionTypeRestore:
            _barButtonItem.title=NSLocalizedString(@"正在恢复...",@"");
            _infoString=NSLocalizedString(@"-----向iTunes Store请求恢复产品-----\n-----请耐心等待-----\n",@"");
            _textView.text=[_textView.text stringByAppendingString:_infoString];
            [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
            break;
        default:
            break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Custom Methods

//发出产品请求
-(void)startProductRequest{
    if ([SKPaymentQueue canMakePayments]) {
        //允许程序内付费购买
        _infoString=NSLocalizedString(@"-----向iTunes Store请求产品信息-----\n-----请耐心等待-----\n",@"");
        _textView.text=[_textView.text stringByAppendingString:_infoString];
        
        NSString *ProductID=nil;
        switch (_productIndex) {
            case 0:
                ProductID=ProductID_CNY;
                break;
            case 1:
                ProductID=ProductID_CNY12;
                
                break;
                
            default:
                break;
        }
        
        NSSet *productSet=[NSSet setWithObject:ProductID];
        //NSSet *productSet=[NSSet setWithObjects:ProductID,ProductID_CNY6,ProductID_CNY12,nil];
        SKProductsRequest *productRequest=[[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
        productRequest.delegate=self;
        [productRequest start];
    }
    else{
        //NSLog(@"不允许程序内付费购买");
        _infoString=NSLocalizedString(@"-----不允许程序内付费购买-----\n",@"");
        _textView.text=[_textView.text stringByAppendingString:_infoString];
    }

}

//交易成功
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    //禁用重新尝试按钮
    _barButtonItem.enabled=NO;
    
    //提供相关功能
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isVIP"];
    [defaults synchronize];
    
    //显示提示信息
    NSString *typeString=[NSString new];
    
    switch (_transactionType) {
        case TransactionTypePurchase:
            typeString=NSLocalizedString(@"购买",@"");
            _barButtonItem.title=NSLocalizedString(@"购买成功",@"");
            break;
        case TransactionTypeRestore:
            typeString=NSLocalizedString(@"恢复",@"");
            _barButtonItem.title=NSLocalizedString(@"恢复成功",@"");
            break;
            
        default:
            break;
    }
    
    NSLog(@"处理成功:%@",transaction.payment.productIdentifier);
    _infoString=[[NSString alloc]initWithFormat:NSLocalizedString(@"-----产品%@成功，请返回使用!-----\n",@""),typeString];
    _textView.text=[_textView.text stringByAppendingString:_infoString];
    
    //关闭成功的交易
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}


#pragma - Event
-(void)barButtonItemPressed:(id *)sender{
    _textView.text=@"";
    [self startProductRequest];
}


#pragma - Delegate
//代理方法：收到产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    //NSLog(@"未识别的产品信息:%@",response.invalidProductIdentifiers);
    
    NSArray *products=response.products;
    _infoString=NSLocalizedString(@"-----收到iTunes Store的反馈信息-----\n",@"");
    _textView.text=[_textView.text stringByAppendingString:_infoString];
    //NSLog(@"能识别的产品种类数: %lu\n",(unsigned long)[products count]);
                 
    if ([products count]>0) {
        SKProduct *product=products[0];
        SKPayment *payment=[SKPayment paymentWithProduct:product];
        
        [[SKPaymentQueue defaultQueue]addPayment:payment];
        
        NSString *lst1=NSLocalizedString(@"产品名称", @"");
        NSString *lst2=NSLocalizedString(@"产品描述信息", @"");
        NSString *lst3=NSLocalizedString(@"产品价格", @"");
        
        _infoString=[[NSString alloc]initWithFormat:@"\n-----%@:%@-----\n-----%@:%@-----\n-----%@:%@-----\n\n",lst1,product.localizedTitle,lst2,product.localizedDescription,lst3,product.price];
        _textView.text=[_textView.text stringByAppendingString:_infoString];
        _infoString=NSLocalizedString(@"-----向iTunes Store发送交易请求-----\n",@"");
        _textView.text=[_textView.text stringByAppendingString:_infoString];
        
//        for (SKProduct *product in products){
//            NSLog(@"产品ID %@\n",product.productIdentifier);
//            _infoString=[[NSString alloc]initWithFormat:@"SKProduct 描述信息%@\n产品名称 %@\n产品描述信息 %@\n产品价格 %@\n",product.description,product.localizedTitle,product.localizedDescription,product.price];
//            _textView.text=[_textView.text stringByAppendingString:_infoString];
//        }
//        
//        SKProduct *product=[SKProduct new];
//        SKPayment *payment=nil;
//        switch (_productIndex) {
//            case 0:
//                product=response.products[0];
//                payment=[SKPayment paymentWithProduct:product];
//                break;
//                
//            default:
//                break;
//        }
//        _infoString=@"-发送购买请求\n";
//        _textView.text=[_textView.text stringByAppendingString:_infoString];
//        
//        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        _infoString=NSLocalizedString(@"-----iTunes Store没有相关产品信息-----\n",@"");
        _textView.text=[_textView.text stringByAppendingString:_infoString];
        [request cancel];
    }
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSString *lst1=NSLocalizedString(@"-----向iTunes Store请求信息失败-----", @"");
    NSString *lst2=NSLocalizedString(@"错误信息", @"");
    _infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n",lst1,lst2,error.localizedDescription];
    _textView.text=[_textView.text stringByAppendingString:_infoString];
}

-(void)requestDidFinish:(SKRequest *)request{
    _infoString=NSLocalizedString(@"-----iTunes Store反馈信息结束-----\n",@"");
    _textView.text=[_textView.text stringByAppendingString:_infoString];
    
}

//代理方法：收到交易结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    //交易结果<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
    //监听购买结果
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    _infoString=NSLocalizedString(@"-----收到iTunes Store反馈的交易结果-----\n",@"");
    _textView.text=[_textView.text stringByAppendingString:_infoString];
    //NSLog(@"交易数量:%lu",(unsigned long)[transactions count]);
    if (_transactionType==TransactionTypeRestore&&[transactions count]==0) {
        _infoString=NSLocalizedString(@"-----您没有可供恢复的项目！-----\n",@"");
        _textView.text=[_textView.text stringByAppendingString:_infoString];
    }
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                //交易完成,调用自定义方法，提供相应内容、记录交易记录等
                NSLog(@"SKPaymentTransactionStatePurchased");
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"SKPaymentTransactionStateRestored");
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:{
                NSLog(@"SKPaymentTransactionStateFailed");
                
                NSString *lst1=NSLocalizedString(@"-----交易失败，请重新尝试-----", @"");
                NSString *lst2=NSLocalizedString(@"错误信息", @"");
                _infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n\n",lst1,lst2,[self showTransactionErrorCode:transaction]];
                _barButtonItem.title=NSLocalizedString(@"重新尝试",@"");
                _barButtonItem.enabled=YES;
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
            default:
                break;
        }
    }
    
    _textView.text=[_textView.text stringByAppendingString:_infoString];
}

-(NSString *)showTransactionErrorCode:(SKPaymentTransaction *)transaction{
    NSString *code=[NSString new];
    switch (transaction.error.code) {
        case SKErrorPaymentCancelled:
            code=NSLocalizedString(@"用户取消",@"");
            break;
        case SKErrorPaymentNotAllowed:
            code=NSLocalizedString(@"用户不允许购买",@"");
            break;
        case SKErrorPaymentInvalid:
            code=NSLocalizedString(@"参数未识别",@"");
            break;
        case SKErrorStoreProductNotAvailable:
            code=NSLocalizedString(@"没有相关产品信息",@"");
            break;
        case SKErrorClientInvalid:
            code=NSLocalizedString(@"客户端禁止购买",@"");
            break;
        case SKErrorUnknown:
            code=NSLocalizedString(@"未知错误",@"");
            break;
            
        default:
            break;
    }
    return code;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    //NSLog(@"paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads");
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    //NSLog(@"paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions");
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    //NSLog(@"paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue");
    
    _infoString=NSLocalizedString(@"-----iTunes Store恢复结束-----",@"");
    _textView.text=[_textView.text stringByAppendingString:_infoString];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error");
    
    NSString *lst1=NSLocalizedString(@"-----iTunes Store恢复失败，请重新尝试-----", @"");
    NSString *lst2=NSLocalizedString(@"错误信息", @"");
    _infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n",lst1,lst2,error.localizedDescription];
    _textView.text=[_textView.text stringByAppendingString:_infoString];
}
         //custom
         //-(void)PurchasedTransaction: (SKPaymentTransaction *)transaction{
         //    //NSLog(@"-PurchasedTransaction");
         //    _textView.text=[_textView.text stringByAppendingString:_infoString];
         //    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
         //    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
         //}
@end
