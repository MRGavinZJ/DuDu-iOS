//
//  InvoiceVC.m
//  DuDu
//
//  Created by 教路浩 on 15/12/2.
//  Copyright © 2015年 i-chou. All rights reserved.
//

#import "InvoiceVC.h"
#import "InvoiceCell.h"
#import "InvoiceDetailVC.h"

@interface InvoiceVC ()
{
    UITableView *_tableView;
}

@end

@implementation InvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLORRGB(0xffffff);
    [self createTableView];
    [self.view addSubview:[self loadFooterView]];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:ccr(0,
                                                        NAV_BAR_HEIGHT_IOS7,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT-NAV_BAR_HEIGHT_IOS7)];
    _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLORRGB(0xffffff);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self loadHeaderView];
    [self.view addSubview:_tableView];
}

- (UIView *)loadHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:ccr(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = COLORRGB(0xf0f0f0);
    
    UILabel *introLabel = [UILabel labelWithFrame:CGRectZero
                                            color:COLORRGB(0x000000)
                                             font:HSFONT(12)
                                             text:@"开票说明 | 开票历史"
                                        alignment:NSTextAlignmentRight
                                    numberOfLines:1];
    CGSize introSize = [introLabel.text sizeWithAttributes:@{NSFontAttributeName:introLabel.font}];
    [introLabel sizeToFit];
    introLabel.frame = ccr(SCREEN_WIDTH-5-introSize.width,
                           (50-introSize.height)/2,
                           introSize.width,
                           introSize.height);
    [headerView addSubview:introLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:ccr(0, 50-0.5, SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor = COLORRGB(0xd7d7d7);
    [headerView addSubview:lineImage];
    return headerView;
}

- (UIView *)loadFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = COLORRGB(0xf0f0f0);
    
    UIImageView *selectAllImage = [[UIImageView alloc] initWithFrame:ccr(20, 10, 16, 16)];
    selectAllImage.backgroundColor = COLORRGB(0xedad49);
    selectAllImage.userInteractionEnabled = YES;
    [footerView addSubview:selectAllImage];
    
    UIButton *selectAllButton = [UIButton buttonWithImageName:@""
                                                  hlImageName:@""
                                                   onTapBlock:^(UIButton *btn) {
                                                       
                                                   }];
    selectAllButton.frame = selectAllImage.frame;
    [footerView addSubview:selectAllButton];
    
    UILabel *selectAllLabel = [UILabel labelWithFrame:CGRectZero
                                                color:COLORRGB(0x000000)
                                                 font:HSFONT(12)
                                                 text:@"全选"
                                            alignment:NSTextAlignmentLeft
                                        numberOfLines:1];
    CGSize allSize = [selectAllLabel.text sizeWithAttributes:@{NSFontAttributeName:selectAllLabel.font}];
    [selectAllLabel sizeToFit];
    selectAllLabel.frame = ccr(CGRectGetMaxX(selectAllImage.frame)+10,
                               selectAllImage.origin.y,
                               allSize.width,
                               allSize.height);
    [footerView addSubview:selectAllLabel];
    
    UILabel *introdceLabel = [UILabel labelWithFrame:CGRectZero
                                               color:COLORRGB(0xd7d7d7)
                                                font:HSFONT(11)
                                                text:@"可开额度50.50元,满200.00元包邮"
                                           alignment:NSTextAlignmentRight
                                       numberOfLines:1];
    CGSize introSize = [self getTextFromLabel:introdceLabel];
    introdceLabel.frame = ccr(SCREEN_WIDTH-20-introSize.width,
                              selectAllLabel.origin.y,
                              introSize.width,
                              introSize.height);
    [footerView addSubview:introdceLabel];
    
    UIButton *nextButton = [UIButton buttonWithImageName:@""
                                             hlImageName:@""
                                                   title:@"下一步"
                                              titleColor:COLORRGB(0xffffff)
                                                    font:HSFONT(15)
                                              onTapBlock:^(UIButton *btn) {
                                                  [self didClickNextButtonAction];
                                              }];
    nextButton.frame = ccr(SCREEN_WIDTH-20-150,
                           CGRectGetMaxY(introdceLabel.frame)+10,
                           150,
                           50);
    nextButton.backgroundColor = COLORRGB(0xedad49);
    [footerView addSubview:nextButton];
    
    NSString *price = @"50.50";
    NSString *number = @"3";
    NSString *total = [NSString stringWithFormat:@"合计:%@元 共%@个行程",price,number];
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectZero
                                            color:COLORRGB(0x000000)
                                             font:HSFONT(12)
                                             text:total
                                        alignment:NSTextAlignmentLeft
                                    numberOfLines:1];
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:total];
    NSUInteger priceLength = price.length;
    NSUInteger numberLength = number.length;
    NSUInteger numberLocation = total.length-3-numberLength;
    [totalString addAttributes:@{NSForegroundColorAttributeName:COLORRGB(0xedad49)}
                         range:NSMakeRange(3, priceLength)];
    [totalString addAttributes:@{NSForegroundColorAttributeName:COLORRGB(0xedad49)}
                                 range:NSMakeRange(numberLocation, numberLength)];
    totalLabel.attributedText = totalString;
    CGSize totalSize = [self getTextFromLabel:totalLabel];
    totalLabel.frame = ccr(selectAllImage.origin.x,
                           nextButton.origin.y+(nextButton.height-totalSize.height)/2,
                           SCREEN_WIDTH-selectAllImage.origin.x-nextButton.width-10-20,
                           totalSize.height);
    [footerView addSubview:totalLabel];
    CGFloat footHeight = CGRectGetMaxY(nextButton.frame)+10;
    footerView.frame = ccr(0,
                           SCREEN_HEIGHT-footHeight,
                           SCREEN_WIDTH,
                           footHeight);
    return footerView;
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"invoiceCell";
    InvoiceCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!invoiceCell) {
        invoiceCell = [[InvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:invoiceCell atIndexPath:indexPath];
    CGRect frame = [invoiceCell calculateFrame];
    return frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"invoiveCell";
    InvoiceCell *invoiceCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!invoiceCell) {
        invoiceCell = [[InvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:invoiceCell atIndexPath:indexPath];
    return invoiceCell;
}

- (void)configureCell:(InvoiceCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.date = @"10月27日";
    cell.startTime = @"11:03";
    cell.endTime = @"11:26";
    cell.price = @"20.90";
    cell.startSite = @"沙河口区春柳河公交站";
    cell.endSite = @"大连软件园15号楼";
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)getTextFromLabel:(UILabel *)label
{
    CGSize textSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label sizeToFit];
    return textSize;
}

- (void)didClickNextButtonAction
{
    InvoiceDetailVC *detailVC = [[InvoiceDetailVC alloc] init];
    detailVC.title = @"按行程开票";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end