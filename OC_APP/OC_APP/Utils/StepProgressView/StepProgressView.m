//
//  StepProgressView.m
//  OC_APP
//
//  Created by xingl on 2017/6/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "StepProgressView.h"


static const float imgBtnWidth = 14;

@interface StepProgressView ()

@property (nonatomic, strong) UIProgressView *progressView;
//用button防止以后添加点击事件
@property (nonatomic, strong) NSMutableArray *imgBtnArray;

@end

@implementation StepProgressView


+(instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray
{
    StepProgressView *stepProgressView=[[StepProgressView alloc]initWithFrame:frame];
    //进度条
    stepProgressView.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, 5)];
    stepProgressView.progressView.progressViewStyle=UIProgressViewStyleBar;
    stepProgressView.progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    stepProgressView.progressView.progressTintColor=[UIColor redColor];
    stepProgressView.progressView.trackTintColor=[UIColor blueColor];
    stepProgressView.progressView.progress=0.5;
    [stepProgressView addSubview:stepProgressView.progressView];
    
    
    stepProgressView.imgBtnArray=[[NSMutableArray alloc]init];
    float _btnWidth=frame.size.width/(titleArray.count);
    for (int i=0; i<titleArray.count; i++) {
        //图片按钮
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *norImage = [UIImage xl_imageWithClipImage:[UIImage imageNamed:@"0.png"] borderWidth:1 borderColor:[UIColor grayColor]];
        UIImage *heiImage = [UIImage xl_imageWithClipImage:[UIImage imageNamed:@"1.png"] borderWidth:1 borderColor:[UIColor grayColor]];
        [btn setImage:norImage forState:UIControlStateNormal];
        [btn setImage:heiImage forState:UIControlStateSelected];
        btn.frame=CGRectMake(_btnWidth/2+_btnWidth*i-imgBtnWidth/2, 0, imgBtnWidth, imgBtnWidth);
        btn.selected=YES;
        
        [stepProgressView addSubview:btn];
        [stepProgressView.imgBtnArray addObject:btn];
        
        //文字
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn.center.x-_btnWidth/2, frame.size.height-20, _btnWidth, 20)];
        titleLabel.text=[titleArray objectAtIndex:i];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:18];
        [stepProgressView addSubview:titleLabel];
    }
    stepProgressView.stepIndex=-1;
    return stepProgressView;
    
}
-(void)setStepIndex:(NSInteger)stepIndex
{
    //  默认为－1 小于－1为－1 大于总数为总数
    _stepIndex=stepIndex<-1?-1:stepIndex;
    _stepIndex=stepIndex >=_imgBtnArray.count-1?_imgBtnArray.count-1:stepIndex;
    float _btnWidth=self.bounds.size.width/(_imgBtnArray.count);
    for (int i=0; i<_imgBtnArray.count; i++) {
        UIButton *btn=[_imgBtnArray objectAtIndex:i];
        if (i<=_stepIndex) {
            btn.selected=YES;
        }
        else{
            btn.selected=NO;
        }
    }
    if (_stepIndex==-1) {
        self.progressView.progress=0.0;
    }
    else if (_stepIndex==_imgBtnArray.count-1)
    {
        self.progressView.progress=1.0;
    }
    else
    {
        self.progressView.progress=(0.5+_stepIndex)*_btnWidth/self.frame.size.width;
    }
}



@end
