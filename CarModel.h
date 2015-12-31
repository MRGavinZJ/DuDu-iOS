//
//  CarModel.h
//  DuDu
//
//  Created by i-chou on 12/31/15.
//  Copyright © 2015 i-chou. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CarModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *car_style_name;
@property (nonatomic, assign) NSInteger car_style_id;
@property (nonatomic, assign) CGFloat  per_kilometer_money;
@property (nonatomic, assign) CGFloat  per_max_kilometer;
@property (nonatomic, assign) CGFloat  per_max_kilometer_money;
@property (nonatomic, assign) CGFloat  wait_time_money;
@property (nonatomic, assign) CGFloat  start_money;

@end
