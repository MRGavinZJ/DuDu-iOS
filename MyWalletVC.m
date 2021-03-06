//
//  MyWalletVC.m
//  DuDu
//
//  Created by 教路浩 on 15/12/2.
//  Copyright © 2015年 i-chou. All rights reserved.
//

#import "MyWalletVC.h"
#import "WalletCell.h"
#import "InvoiceVC.h"
#import "CouponVC.h"

@interface MyWalletVC ()
{
    UITableView *_tableView;
}

@end

@implementation MyWalletVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLORRGB(0xf0f0f0);
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:ccr(0,
                                                        NAV_BAR_HEIGHT_IOS7+50,
                                                        SCREEN_WIDTH,
                                                        120)];
    _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _tableView.backgroundColor = COLORRGB(0xffffff);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"walletCell";
    WalletCell *walletCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!walletCell) {
        walletCell = [[WalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        walletCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        walletCell.iconImage.image = IMG(@"tiny_bill");
        walletCell.title = @"发票";
    } else if (indexPath.row == 1) {
        walletCell.iconImage.image = IMG(@"tiny_coupon");
        walletCell.title = @"优惠券";
    }
    else {
//        walletCell.iconImage.image = IMG(@"tiny_shared");
//        walletCell.title = @"余额";
    }
    return walletCell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        InvoiceVC *invoiceVC = [[InvoiceVC alloc] init];
        invoiceVC.title = @"按行程开票";
        [self.navigationController pushViewController:invoiceVC animated:YES];
    } else if (indexPath.row==1) {
        CouponVC *couponVC = [[CouponVC alloc] init];
        couponVC.coupons = [CouponStore sharedCouponStore].info;
        couponVC.title = @"我的优惠券";
        [self.navigationController pushViewController:couponVC animated:YES];
    } else {
        
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
