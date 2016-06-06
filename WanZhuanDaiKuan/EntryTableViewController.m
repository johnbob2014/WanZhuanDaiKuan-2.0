//
//  EntryTableViewController.m
//  WanZhuanDaiKuan
//
//  Created by 张保国 on 15/7/25.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "EntryTableViewController.h"
#import "InAppPurchaseViewController.h"

@interface EntryTableViewController ()

@end

@implementation EntryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    UIBarButtonItem *backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    
    UIBarButtonItem *calculateBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"请点击项目进行购买或恢复购买" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *flexibleSpaceBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    calculateBarButtonItem.enabled=NO;
    [self setToolbarItems:@[flexibleSpaceBarButtonItem,calculateBarButtonItem,flexibleSpaceBarButtonItem]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"1.将还款信息添加到日历 ¥6.0";
            break;
        case 1:
            cell.textLabel.text=@"";
            break;
        case 2:
            cell.textLabel.text=@"";
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
//    inApp.title=@"应用程序内购买信息";
//    switch (indexPath.row) {
//        case 0:
//            [self.navigationController pushViewController:inApp animated:NO];
//            break;
//        case 1:
//            //cell.textLabel.text=@"分期付款";
//            break;
//        case 2:
//            //cell.textLabel.text=@"分期付款";
//            break;
//            
//        default:
//            break;
//    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您将要购买“将还款信息添加到日历”功能，价格¥6.0，是否继续？" delegate:self cancelButtonTitle:@"不需要此功能" otherButtonTitles:@"购买",@"恢复",nil];
    alert.tag=15;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        if (alertView.tag==15) {
            if (buttonIndex==alertView.firstOtherButtonIndex) {
                //用户点击”购买“
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"购买！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [alert show];
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
                inApp.title=@"应用程序内购买信息";
                inApp.transactionType=TransactionTypePurchase;
                [self.navigationController pushViewController:inApp animated:YES];
            }
            
            if (buttonIndex==alertView.firstOtherButtonIndex+1) {
                //用户点击”恢复“
                InAppPurchaseViewController *inApp=[InAppPurchaseViewController new];
                inApp.title=@"应用程序内购买信息";
                inApp.transactionType=TransactionTypeRestore;
                [self.navigationController pushViewController:inApp animated:YES];
            }
            //
            //            if (buttonIndex==alertView.firstOtherButtonIndex+2) {
            //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"查看功能介绍！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                [alert show];
            //            }
            //
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
