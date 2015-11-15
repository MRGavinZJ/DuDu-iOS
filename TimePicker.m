//
//  TimePicker.m
//  DuDu
//
//  Created by i-chou on 11/15/15.
//  Copyright © 2015 i-chou. All rights reserved.
//

#import "TimePicker.h"

@implementation TimePicker
{
    BOOL _isToday;
    BOOL _isNow;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _isToday = YES;
        _isNow = YES;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:ccr(0, 0, SCREEN_WIDTH, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        
        UIButton *cancelBtn = [UIButton buttonWithFrame:ccr(5, 0, 80, toolBar.height)
                                        backgroundColor:[UIColor clearColor]
                                      hlBackgroundColor:[UIColor clearColor]
                                                  title:@"取消"
                                                   font:HSFONT(16)
                                             titleColor:[UIColor blackColor]
                                             onTapBlock:^(UIButton *btn){
            if ([self.delegate respondsToSelector:@selector(timePickerViewDidCancel)]) {
                [self.delegate timePickerViewDidCancel];
                                                 }
        }];
        cancelBtn.showsTouchWhenHighlighted = YES;
        [toolBar addSubview:cancelBtn];
        
        UIButton *okBtn = [UIButton buttonWithFrame:ccr(toolBar.width-80-5, 0, 80, toolBar.height)
                                    backgroundColor:[UIColor clearColor]
                                  hlBackgroundColor:[UIColor clearColor]
                                              title:@"确定" font:HSFONT(16)
                                         titleColor:[UIColor blackColor]
                                         onTapBlock:^(UIButton *btn){
            if ([self.delegate respondsToSelector:@selector(timePickerView:didSelectTime:)]) {
                [self.delegate timePickerView:self didSelectTime:self.pickedTime];
            }
        }];
        okBtn.showsTouchWhenHighlighted = YES;
        [toolBar addSubview:okBtn];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:ccr(0, toolBar.height, SCREEN_WIDTH, 220)];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        [self addSubview:toolBar];
        [self addSubview:self.pickerView];
    }
    return self;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    if (component == 0) { // day
        return 3;
    } else if (component == 1){  // hour
        if (_isToday) {
            NSInteger left_hour = 24 - dateComponent.hour;
            return left_hour;
        } else {
            return 24;
        }
    } else { //minute
        if (_isNow) {
            return 0;
        } else {
            if ([pickerView selectedRowInComponent:1] == 1  && _isToday) {
                NSInteger left_minute = 6 - dateComponent.minute;
                return left_minute;
            } else {
                return 6;
            }
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH/3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.backgroundColor = [UIColor clearColor];
        tView.font = HSFONT(16);
        tView.textAlignment = NSTextAlignmentCenter;
        tView.textColor = [UIColor blackColor];
    }
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    if (component == 0) {
        if (row == 0) {
            tView.text = @"今天";
        } else if (row == 1) {
            tView.text = @"明天";
        } else {
            tView.text = @"后天";
        }
    } else if (component == 1){
        if (_isToday) {
            if (row == 0) {
                tView.text = @"现在";
            } else {
                tView.text = [NSString stringWithFormat:@"%ld点",(long)(dateComponent.hour+row)];
            }
        } else {
            tView.text = [NSString stringWithFormat:@"%ld点",(long)row];
        }
    } else {
        if (_isNow) {
            tView.text = @"";
        } else {
            if ([pickerView selectedRowInComponent:1] == 1 && _isToday) {
                tView.text = [NSString stringWithFormat:@"%ld分",(long)(dateComponent.minute+row)*10];
            } else {
                tView.text = [NSString stringWithFormat:@"%ld分",(long)row*10];
            }
        }
    }
    
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _isToday = ![pickerView selectedRowInComponent:0];
    _isNow = (![pickerView selectedRowInComponent:0] && ![pickerView selectedRowInComponent:1]);
    [pickerView reloadComponent:1];
    [pickerView reloadComponent:2];
    
    self.pickedTime = [self getTime];
}

- (NSInteger)getTime
{
    if (_isNow) {
        NSDate *now = [NSDate date];
        return [now timeIntervalSince1970];
    }
    NSInteger today = [[NSDate date] day];
    NSInteger day  = [self.pickerView selectedRowInComponent:0] + today;
    NSInteger hour = [self.pickerView selectedRowInComponent:1];
    NSInteger minute = [self.pickerView selectedRowInComponent:2] * 10;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[[NSDate date] year]];
    [components setMonth:[[NSDate date] month]];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    
    NSDate *selectedTime = [calendar dateFromComponents:components];
    NSInteger timeStamp = [selectedTime timeIntervalSince1970];
    
    return timeStamp;
}



@end
