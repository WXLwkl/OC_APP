//
//  HeaderCell.h
//  OC_APP
//
//  Created by xingl on 2017/8/21.
//  Copyright © 2017年 兴林. All rights reserved.
//

#ifndef HeaderCell_h
#define HeaderCell_h



//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define kScreenWidthRatio  (kScreenWidth / 320.0)
#define kScreenHeightRatio (kScreenHeight / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))

#define COLOR_WORD_BLACK  ColorWithHex(0x333333)
#define COLOR_WORD_GRAY_1 ColorWithHex(0x666666)
#define COLOR_WORD_GRAY_2 ColorWithHex(0x999999)

#define COLOR_UNDER_LINE RGBColor(198, 198, 198)

#endif /* HeaderCell_h */
