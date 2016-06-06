//
//  ShareRETVC.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/9/30.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//
#define AppID 1023990204
#define WS(ws) __typeof (&*self) __weak weakSelf=self

#import "ShareRETVC.h"
#import "UIImage+CTPMethods.h"
#import "AboutVC.h"

@interface ShareRETVC ()
@property (strong,nonatomic) RETableViewManager *manager;
@property (strong,nonatomic) NSString *downloadUrl;
@property (strong,nonatomic) NSString *niceUrl;
@end

@implementation ShareRETVC{
    
    NSString *lsTitle;
    NSString *lsDescription;
    NSString *lsClickToDownload;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=NSLocalizedString(@"分享",@"");
    
    WS(weakSelf);
    
    RETableViewSection *section1=[RETableViewSection section];
    [self.manager addSection:section1];
    
    NSString *t1=[[NSString alloc]initWithFormat:@"🍀 %@",NSLocalizedString(@"微信朋友圈",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t1 accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [weakSelf sendToWXscene:WXSceneTimeline];
    }]];
    
    NSString *t2=[[NSString alloc]initWithFormat:@"💠 %@",NSLocalizedString(@"微信好友",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t2 accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [weakSelf sendToWXscene:WXSceneSession];
    }]];
    
    NSString *t3=[[NSString alloc]initWithFormat:@"✉️ %@",NSLocalizedString(@"短信",@"")];
    [section1 addItem:[RETableViewItem itemWithTitle:t3 accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [weakSelf sendSMS];
    }]];
    
    RETableViewSection *section2=[RETableViewSection section];
    [self.manager addSection:section2];
    
    NSString *t4=[[NSString alloc]initWithFormat:@"💖 %@",NSLocalizedString(@"给个好评", @"")];
    [section2 addItem:[RETableViewItem itemWithTitle:t4 accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_niceUrl]];
    }]];
    
    NSString *t5=[[NSString alloc]initWithFormat:@"🎉 %@",NSLocalizedString(@"关于", @"")];
    [section2 addItem:[RETableViewItem itemWithTitle:t5 accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        AboutVC *aboutVC=[[AboutVC alloc]initWithNibName:@"AboutVC" bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }]];
    
    //设置下一页返回按钮的标题
    UIBarButtonItem *backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"返回","") style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
        
    lsTitle=NSLocalizedString(@"《玩转贷款》,贷款信息一手掌控，爱不释手！", @"");
    lsDescription=NSLocalizedString(@"功能特色：1.分期付款、房贷、车贷，贷贷精通 2.分期付款计算实际利率 3.将还款信息添加到日历 4.翔实清晰的贷款明细 5.内置计算器方便实用 6.体积小，无广告，无插件", @"");
    lsClickToDownload=NSLocalizedString(@"点击下载", @"");
    
    self.downloadUrl=[[NSString alloc]initWithFormat:@"https://itunes.apple.com/app/id%d",AppID];
    self.niceUrl=[[NSString alloc]initWithFormat:@"https://itunes.apple.com/app/id%d",AppID];
}

#pragma mark - Getter & Setter
-(RETableViewManager *)manager{
    if (!_manager) {
        _manager=[[RETableViewManager alloc]initWithTableView:self.tableView delegate:self];
    }
    return _manager;
    
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

-(void)sendSMS{
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
