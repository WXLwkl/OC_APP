//
//  SwitchCell.h
//  shoushi
//
//  Created by xingl on 2017/7/18.
//  Copyright © 2017年 xingl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchBlock)(UISwitch *switchButton);

@interface SwitchCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

- (void)setupSwitchOn:(BOOL)isOn switchBlock:(SwitchBlock)block;

@end
