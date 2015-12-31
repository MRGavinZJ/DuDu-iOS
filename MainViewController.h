//
//  MainViewController.h
//  DuDu
//
//  Created by i-chou on 11/4/15.
//  Copyright © 2015 i-chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopToolBar.h"
#import "BottomToolBar.h"
#import "AddressPickerViewController.h"
#import "TimePicker.h"
#import "MenuTableViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "OrderModel.h"

@interface MainViewController : BaseViewController <TopToolBarDelegate, BottomToolBarDelegate,TimePickerDelegate, MAMapViewDelegate, AMapSearchDelegate, AddressPickerViewControllerDelegate,LoginVCDelegate>

+ (instancetype)sharedMainViewController;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) TopToolBar *topToolBar;
@property (nonatomic, strong) NSArray *carStyles;

@end
