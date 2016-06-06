//
//  ShareViewController.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/24.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "ShareViewController.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "UIImage+CTPMethods.h"

#define AppID 1023990204

@interface ShareViewController ()
@property (strong,nonatomic) NSString *downloadUrl;
@property (strong,nonatomic) NSString *niceUrl;

- (IBAction)wxSessionButton:(UIButton *)sender;
- (IBAction)wxTimelineButton:(UIButton *)sender;
- (IBAction)smsButton:(UIButton *)sender;


- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)thankButton:(UIButton *)sender;
- (IBAction)niceButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonCollection;

@end

@implementation ShareViewController{
    NSString *lsTitle;
    NSString *lsDescription;
    NSString *lsClickToDownload;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lsTitle=NSLocalizedString(@"《玩转贷款》,贷款信息一手掌控，爱不释手！", @"");
    lsDescription=NSLocalizedString(@"功能特色：1.分期付款、房贷、车贷，贷贷精通 2.分期付款计算实际利率 3.将还款信息添加到日历 4.翔实清晰的贷款明细 5.内置计算器方便实用 6.体积小，无广告，无插件", @"");
    lsClickToDownload=NSLocalizedString(@"点击下载", @"");
    
    _downloadUrl=[[NSString alloc]initWithFormat:@"https://itunes.apple.com/app/id%d",AppID];
    _niceUrl=[[NSString alloc]initWithFormat:@"https://itunes.apple.com/app/id%d",AppID];
    
    // Do any additional setup after loading the view from its nib.
    for (UIButton *btn in _buttonCollection) {
        
        [btn.layer setCornerRadius:0];
        [btn.layer setBorderWidth:1];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        [btn setBackgroundColor:[UIColor whiteColor]];
    }

    
    //设置背景半透明
    //self.view.opaque=NO;
    self.view.alpha=1;
    self.view.backgroundColor=nil;
    //[self.view setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO];
    //隐藏工具栏
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - Event
- (IBAction)wxSessionButton:(UIButton *)sender {
    [self sendToWXscene:WXSceneSession];
}

- (IBAction)wxTimelineButton:(UIButton *)sender {
    [self sendToWXscene:WXSceneTimeline];
}

- (IBAction)smsButton:(UIButton *)sender {
    //MFMessageComposeViewController提供了操作界面使用前必须检查canSendText方法,若返回NO则不应将这个controller展现出来,而应该提示用户不支持发送短信功能.
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *smsController=[MFMessageComposeViewController new];
        smsController.recipients=[NSArray arrayWithObjects:@"",nil];
        smsController.body=[[NSString alloc]initWithFormat:@"%@%@:%@",lsTitle,lsClickToDownload,_downloadUrl];
        smsController.messageComposeDelegate=self;
        
        [self presentViewController:smsController animated:YES completion:nil];
        [[[[smsController viewControllers]lastObject]navigationItem]setTitle:NSLocalizedString(@"短信分享",@"")];
    }
}

-(void)sendToWXscene:(enum WXScene)scene{
    if([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        //NSLog(@"Session or Timeline");
        WXWebpageObject *webpageObject=[WXWebpageObject alloc];
        webpageObject.webpageUrl=_downloadUrl;
        
        //UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
        UIImage *sourceImage=[UIImage imageNamed:@"65"];
        UIImage *thumbImage = [UIImage thumbImageFromImage:sourceImage limitSize:CGSizeMake(150, 150)];
        NSData *imageData=UIImagePNGRepresentation(thumbImage);
        
        WXMediaMessage *mediaMessage=[WXMediaMessage alloc];
        mediaMessage.title=lsTitle;
        mediaMessage.description=lsDescription;
        mediaMessage.mediaObject=webpageObject;
        mediaMessage.thumbData=imageData;
        
        SendMessageToWXReq *req=[SendMessageToWXReq new];
        req.message=mediaMessage;
        req.bText=NO;
        req.scene=scene;
        [WXApi sendReq:req];
    }
    //纯文本消息
    //    if([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
    //        NSLog(@"Timeline");
    //        SendMessageToWXReq *req=[SendMessageToWXReq new];
    //        req.text=@"玩转贷款";
    //        req.bText=YES;
    //        req.scene=WXSceneTimeline;
    //        [WXApi sendReq:req];
    //    }
    //

}

- (IBAction)cancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
    //NSLog(@"取消分享");
}

- (IBAction)thankButton:(UIButton *)sender {
    //NSLog(@"分享说明");
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"欢迎使用《玩转贷款》",@"") message:NSLocalizedString(@"目前仅支持分享到微信好友、朋友圈、短信，感谢您的分享！\n如有空闲，请奖励个好评！",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"好的",@"") otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)niceButton:(UIButton *)sender {
    //NSLog(@"给个好评");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_niceUrl]];
}


#pragma - Delegate
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        //NSLog(@"%@,%@",strTitle,strMsg);
    }
}

-(void)messageComposeViewController:(nonnull MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            NSLog(@"分享短信发送取消");
            break;
        case MessageComposeResultFailed:
            NSLog(@"分享短信发送失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"分享短信发送成功");
            break;
        default:
            break;
    }
}

@end
