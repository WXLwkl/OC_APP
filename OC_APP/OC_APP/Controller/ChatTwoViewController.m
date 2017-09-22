//
//  ChatTwoViewController.m
//  OC_APP
//
//  Created by xingl on 2017/9/5.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "ChatTwoViewController.h"
#import "ChatKeyBoard.h"

@interface ChatTwoViewController ()<ChatKeyBoardDelegate>
/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (weak, nonatomic) IBOutlet UILabel *voiceState;
@property (weak, nonatomic) IBOutlet UILabel *sendText;

@end

@implementation ChatTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论键盘";
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    
    self.chatKeyBoard.delegate = self;
    //    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    self.chatKeyBoard.placeHolder = @"评论";
    [self.view addSubview:self.chatKeyBoard];
}

- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didChangeChatKeyBoardMinY:(CGFloat)minY {
    
    NSLog(@"%.2f", minY);
}


- (IBAction)switchBar:(UISwitch *)sender {
    self.chatKeyBoard.allowSwitchBar = sender.on;
}
- (IBAction)switchVoice:(UISwitch *)sender {
    self.chatKeyBoard.allowVoice = sender.on;
}

- (IBAction)switchFace:(UISwitch *)sender {
    self.chatKeyBoard.allowFace = sender.on;
}

- (IBAction)switchMore:(UISwitch *)sender {
    self.chatKeyBoard.allowMore = sender.on;
}
//开始评论
- (IBAction)beginComment:(id)sender {
    StartTime;
    
    
    [self.chatKeyBoard beginComment];
    EndTime;
}
//评论结束
- (IBAction)closekeyboard:(id)sender {
    
    [self.chatKeyBoard endComment];
}



#pragma mark -- 语音状态
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard {
    
    self.voiceState.text = @"正在录音";
}
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard {
    self.voiceState.text = @"已经取消录音";
}
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard {
    self.voiceState.text = @"已经完成录音";
}
- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard {
    self.voiceState.text = @"将要取消录音";
}
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard {
    self.voiceState.text = @"继续录音";
}


#pragma mark -- 表情

- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete {
    
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard {
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.navigationItem.title = @"表情商店";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard {
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.navigationItem.title = @"我的表情";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 更多
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index {
    NSString *message = [NSString stringWithFormat:@"选择的ItemIndex %zd", index];
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"ItemIndex" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertV show];
}

#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text {
    
    self.sendText.text = text;
}


@end
