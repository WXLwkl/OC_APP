//
//  ReduceTimeCell.m
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ReduceTimeCell.h"

#import "HeaderCell.h"

@interface ReduceTimeCell()
@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UILabel *myNameLabel,*myTimeLabel;
@end


@implementation ReduceTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self LayoutLayoutCell];
    }
    return self;
}
- (void)LayoutLayoutCell {
    
    if (!self.myImageView) {
        self.myImageView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.myImageView];
        MASAttachKeys(self.myImageView);
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(self.myImageView.mas_height);
        }];
    }
    
    if (!self.myNameLabel) {
        self.myNameLabel = [[UILabel alloc]init];
        self.myNameLabel.font = AdaptedFontSize(14);
        self.myNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.myNameLabel];
        MASAttachKeys(self.myNameLabel);
        [self.myNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myImageView.mas_top).offset(0);
            make.left.mas_equalTo(self.myImageView.mas_right).offset(10);
            make.right.mas_equalTo(self).offset(-15);
            make.height.mas_equalTo(AdaptedHeight(15));
        }];
    }
    
    if (!self.myTimeLabel) {
        self.myTimeLabel = [[UILabel alloc]init];
        self.myTimeLabel.font = AdaptedFontSize(12);
        [self.contentView addSubview:self.myTimeLabel];
        MASAttachKeys(self.myTimeLabel);
        [self.myTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.myImageView.mas_right).offset(10);
            make.bottom.mas_equalTo(self.myImageView.mas_bottom).offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(AdaptedHeight(13));
        }];
    }
}

-(void)configCellWithImage:(NSString *)imageName name:(NSString *)name {
    
    if (imageName.length>0) {
        self.myImageView.image = [UIImage imageNamed:imageName];
    }
    
    if (name.length > 0) {
        self.myNameLabel.text=name;
    }
}

- (void)configCellState:(ReduceTimeState)reduceTimeState currentTime:(NSString *)currentTime {
    switch (reduceTimeState) {
        case ReduceTimeStateNotStart: {
            self.myTimeLabel.text=@"当前产品还未有秒拍";
            self.myTimeLabel.textColor=[UIColor blackColor];
            break;
        }
        case ReduceTimeStateIng: {
            self.myTimeLabel.text=[NSString stringWithFormat:@"倒计时：%@",currentTime];
            self.myTimeLabel.textColor=[UIColor redColor];
            break;
        }
        case ReduceTimeStateEnd: {
            self.myTimeLabel.text=@"当前产品秒拍结束";
            self.myTimeLabel.textColor=[UIColor blueColor];
            break;
        }
    }
}

@end
