//
//  Header.h
//  ChatKeyBoard
//
//  Created by xingl on 2017/8/24.
//  Copyright © 2017年 xingl. All rights reserved.
//

#ifndef Header_h
#define Header_h



//ChatKeyBoard背景颜色
#define kChatKeyBoardColor              [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0f]

//键盘上面的工具条
#define kChatToolBarHeight              49

//表情、更多模块高度
#define kbottomCotainerHeight           224
//表情
#define kFacePanelBottomToolBarWidth    45
#define kFacePanelBottomHeight          40
#define kUIPageControllerHeight         25
//更多
#define kMoreItemH                      80
#define kMoreItemIconSize               60

//整个聊天工具的高度
#define kChatKeyBoardHeight     kChatToolBarHeight + kbottomCotainerHeight

#define isIPhone4_5                (kScreenWidth == 320)
#define isIPhone6_6s               (kScreenWidth == 375)
#define isIPhone6p_6sp             (kScreenWidth == 414)

#endif /* Header_h */
