//
//  HomeViewController.m
//  OC_APP
//
//  Created by xingl on 2017/6/7.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "HomeViewController.h"


#import "ViewController.h"

#import "FirstView.h"

#import "ActivityAlert.h"

#import <LocalAuthentication/LocalAuthentication.h>

//popup
#import "QRMainViewController.h"
#import "CalendarViewController.h"


#import "XLPopMenuView.h"
#import "popMenvTopView.h"

#import "SharePopView.h"


#import "RequestManager.h"


#import "UserManager.h"







#import "LeftViewController.h"
#import "RightViewController.h"






#import "LoginViewController.h"





#define TITLES @[@"日历", @"扫一扫", @"删除",@"付款",@"加好友",@"查找好友"]
#define ICONS  @[@"calendar",@"saoyisao",@"delete",@"pay",@"delete",@"delete"]

@interface HomeViewController ()<PopoverMenuDelegate>


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    if (IOS_Foundation_Later_8) {
        [self loadLateralSlide];
    }
    
}

/****    侧滑  start       ******/
- (void)loadLateralSlide {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftClick)];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self xl_registerShowIntractiveWithEdgeGesture:NO direction:DrawerTransitionDirectionLeft transitionBlock:^{
        [weakSelf leftClick];
    }];
}
- (void)leftClick {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    // 调用这个方法
    [self xl_showDrawerViewController:vc animationType:DrawerAnimationTypeDefault configuration:nil];
}
- (void)rightClick {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    LateralSlideConfiguration *conf = [LateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:DrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"0.jpg"]];
    
    [self xl_showDrawerViewController:vc animationType:0 configuration:conf];
    
}

- (void)drawerDefaultAnimationRight {
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    LateralSlideConfiguration *conf = [LateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0 direction:DrawerTransitionDirectionRight backImage:nil];
    
    [self xl_showDrawerViewController:vc animationType:DrawerAnimationTypeDefault configuration:conf];
}


- (void)drawerDefaultAnimationleftScaleY {
    RightViewController *vc = [[RightViewController alloc] init];
    
    LateralSlideConfiguration *conf = [LateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:DrawerTransitionDirectionLeft backImage:[UIImage imageNamed:@"0.jpg"]];
    
    [self xl_showDrawerViewController:vc animationType:0 configuration:conf];
}
- (void)drawerMaskAnimationLeft {
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    // 调用这个方法
    [self xl_showDrawerViewController:vc animationType:DrawerAnimationTypeMask configuration:nil];
}
- (void)drawerMaskAnimationRight {
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    LateralSlideConfiguration *conf = [LateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0 direction:DrawerTransitionDirectionRight backImage:nil];
    
    [self xl_showDrawerViewController:vc animationType:DrawerAnimationTypeMask configuration:conf];
}
/****     侧滑  end       ******/

- (void)initSubViews {
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor xl_colorWithHexString:@"0x1FB5EC"];
    
    
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:1523240963];
    NSLog(@"year:%ld",[NSDate xl_year:dd]);
    NSLog(@"--->>%ld", [NSDate xl_daysInYear:dd]);
    
    LogBool([dd xl_isToday]);
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightItem sizeToFit];
    [rightItem addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 30, 130, 50);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(180, 30, 130, 50);
    share.backgroundColor = [UIColor grayColor];
    [share setTitle:@"share" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    
    //条形码
    UIImage *barImage = [UIImage xl_barCodeImageWithContent:@"123456"
                                              codeImageSize:CGSizeMake(300, 90)
                                                        red:0.4
                                                      green:0.4
                                                       blue:0.6];
    
    
    CGRect barImageView_Frame = CGRectMake(self.view.bounds.size.width/2-300/2, 100, 300, 90);
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:barImageView_Frame];
    barImageView.image = barImage;
    barImageView.backgroundColor = [UIColor clearColor];
    //    阴影
    barImageView.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    barImageView.layer.shadowRadius = 0.5;
    barImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    barImageView.layer.shadowOpacity = 0.2;
    
    [self.view addSubview:barImageView];
    
    FirstView *firstView = [[FirstView alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    firstView.backgroundColor = [UIColor redColor];
    firstView.center = self.view.center;
    [self.view addSubview:firstView];
    
    [firstView xl_setBorderWithDashLineWidth:2 lineColor:[UIColor grayColor]];

}

- (void)add:(UIButton *)button {
    [PopoverMenu showRelyOnView:button titles:TITLES icons:ICONS menuWidth:150 delegate:self];
}
- (void)share {
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    return;
    
/*
 
 2017-08-17 16:19:48.647 OC_APP[2170:60b] -[HomeViewController share]_block_invoke [Line 117] ----{
	videoList = [
	{
	topicDesc = 最有意思的篮球自媒体，发布关于篮球的一切新闻，一切好玩的事，一切好玩的视频，一切好玩的图片。,
	sectiontitle = ,
	topicImg = http://vimg2.ws.126.net/image/snapshot/2017/6/C/K/VCLIP25CK.jpg,
	sizeSD = 13875,
	topicSid = VCLIP25C4,
	sizeSHD = 27750,
	vid = VBR4DARA6,
	mp4Hd_url = http://flv3.bn.netease.com/videolib3/1708/17/AchwC6056/HD/AchwC6056-mobile.mp4,
	sizeHD = 18500,
	videoTopic = {
	alias = 最有意思的篮球自媒体,
	ename = T1493964191080,
	tname = 篮球斯基,
	topic_icons = http://dingyue.nosdn.127.net/boV1tYqcBI8KRMWXtZthtkkYKfiyX6gQlz7h58kPF02d41493964190379.jpg,
	tid = T1493964191080
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/AchwC6056/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/AchwC6056/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv1.bn.netease.com/videolib3/1708/17/AchwC6056/SD/AchwC6056-mobile.mp4,
	length = 185,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/A/7/VBR4DARA7.jpg,
	topicName = 篮球斯基,
	votecount = 0,
	ptime = 2017-08-17 15:48:14,
	title = 哈登与球迷1V1，示范绝技“声东击西冲天炮”，完虐对手,
	videosource = 新媒体,
	replyid = BR4DARA6050835RB,
	description = 哈登与球迷1V1，示范绝技“声东击西冲天炮”，完虐对手,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 每日为大家分享有趣的文章以及视频，娱乐大家，也娱乐自己，将自己所了解的新鲜事分享给大家,
	sectiontitle = ,
	topicImg = http://vimg1.ws.126.net/image/snapshot/2017/3/O/5/VCDUNMGO5.jpg,
	sizeSD = 7425,
	topicSid = VCDUNMGNR,
	sizeSHD = 0,
	vid = VAR4DAIT8,
	mp4Hd_url = http://flv1.bn.netease.com/videolib3/1708/17/dKUQB6071/HD/dKUQB6071-mobile.mp4,
	sizeHD = 9900,
	videoTopic = {
	alias = 娱乐大家娱乐自己开心每一天,
	ename = T1488806835541,
	tname = 爆料e站,
	topic_icons = http://dingyue.nosdn.127.net/qp5PmMUiM8LMeEogUqMYvgw3XSwsZiJgNrYc0dhQ9a6=G1488806835161.jpg,
	tid = T1488806835541
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/dKUQB6071/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/dKUQB6071/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv3.bn.netease.com/videolib3/1708/17/dKUQB6071/SD/dKUQB6071-mobile.mp4,
	length = 99,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/T/9/VAR4DAIT9.jpg,
	topicName = 爆料e站,
	votecount = 0,
	ptime = 2017-08-17 15:48:05,
	title = 大鹏也是能耐的，愣是把一堂数学课上成了音乐课,
	videosource = 新媒体,
	replyid = AR4DAIT8050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 三分靠长相，七分靠打扮第一时间通过网易平台发布社会领域精彩原创文章。希望通过网易打造一个独一无二的自媒体,
	sectiontitle = ,
	topicImg = http://vimg2.ws.126.net/image/snapshot/2017/7/L/F/VCOFHAILF.jpg,
	sizeSD = 5325,
	topicSid = VCOFHAILD,
	sizeSHD = 10650,
	vid = VNR4DAF2Q,
	mp4Hd_url = http://flv1.bn.netease.com/videolib3/1708/17/UGzxb6052/HD/UGzxb6052-mobile.mp4,
	sizeHD = 7100,
	videoTopic = {
	alias = 分享时尚穿搭站,
	ename = T1494257417980,
	tname = 时尚穿搭站,
	topic_icons = http://dingyue.nosdn.127.net/COiLBhEZbsjPfq4wRMZEA9VBSrHaw536AGhHoxTM=bpgc1494257417456.jpg,
	tid = T1494257417980
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/UGzxb6052/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/UGzxb6052/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv1.bn.netease.com/videolib3/1708/17/UGzxb6052/SD/UGzxb6052-mobile.mp4,
	length = 71,
	cover = http://vimg3.ws.126.net/image/snapshot/2017/8/2/R/VNR4DAF2R.jpg,
	topicName = 时尚穿搭站,
	votecount = 0,
	ptime = 2017-08-17 15:48:02,
	title = 终于有人玩超级马里奥干了我一直想干的事，哈哈！,
	videosource = 新媒体,
	replyid = NR4DAF2Q050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 娱乐资讯的交流互动的自媒体平台，以客观冷静的姿态去分享自我心得体会,
	sectiontitle = ,
	topicImg = http://vimg3.ws.126.net/image/snapshot/2017/7/K/G/VCNEJEDKG.jpg,
	sizeSD = 4350,
	topicSid = VCNEJEDJP,
	sizeSHD = 0,
	vid = VTR4DAF5L,
	mp4Hd_url = http://flv1.bn.netease.com/videolib3/1708/17/lofNW5981/HD/lofNW5981-mobile.mp4,
	sizeHD = 5800,
	videoTopic = {
	alias = 明星娱乐咨询的分享与互动,
	ename = T1498118983953,
	tname = 苇语,
	topic_icons = http://dingyue.nosdn.127.net/lRgXduGuXfQ6dgo6f4r98Wb=q1rURtOxoTLV=a0nsyG5P1498409323961.jpg,
	tid = T1498118983953
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/lofNW5981/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/lofNW5981/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv1.bn.netease.com/videolib3/1708/17/lofNW5981/SD/lofNW5981-mobile.mp4,
	length = 58,
	cover = http://vimg1.ws.126.net/image/snapshot/2017/8/5/M/VTR4DAF5M.jpg,
	topicName = 苇语,
	votecount = 0,
	ptime = 2017-08-17 15:48:02,
	title = 赵丽颖《新还珠格格》开始了集体大逃亡,
	videosource = 新媒体,
	replyid = TR4DAF5L050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = http://v.163.com/paike/VCHMNM4HL/VNKU0L6HO.html,
	sectiontitle = ,
	topicImg = http://vimg1.ws.126.net/image/snapshot/2017/6/O/C/VCL402BOC.jpg,
	sizeSD = 44850,
	topicSid = VCL402BNQ,
	sizeSHD = 0,
	vid = VMR4DA3JJ,
	mp4Hd_url = http://flv1.bn.netease.com/videolib3/1708/17/NGAkF5388/HD/NGAkF5388-mobile.mp4,
	sizeHD = 59800,
	videoTopic = {
	alias = 娱乐你我他,
	ename = T1496333333500,
	tname = 娱乐大卡卡,
	topic_icons = http://dingyue.nosdn.127.net/HVerMD2Ya2n=reNel9sEME=wImJcb7pFexBT4WS5KhkuM1496333332872.jpg,
	tid = T1496333333500
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/NGAkF5388/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/NGAkF5388/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv3.bn.netease.com/videolib3/1708/17/NGAkF5388/SD/NGAkF5388-mobile.mp4,
	length = 598,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/R/K/VCR4F2MRK.jpg,
	topicName = 娱乐大卡卡,
	votecount = 0,
	ptime = 2017-08-17 15:47:50,
	title = 盲约：蒋欣怒怼陆毅，强行要陆毅付各种费用！,
	videosource = 新媒体,
	replyid = MR4DA3JJ050835RB,
	description = 盲约：蒋欣怒对陆毅，强行要陆毅付各种费用，陆毅无奈！,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 奇葩空间，为你带来大自然不一样的视频，实用、搞笑、有趣新闻，总会让你喜欢,
	sectiontitle = ,
	topicImg = http://vimg2.ws.126.net/image/snapshot/2017/5/K/9/VCIO5EUK9.jpg,
	sizeSD = 8550,
	topicSid = VCIO5EUJR,
	sizeSHD = 0,
	vid = VPR4D9VFI,
	mp4Hd_url = http://flv3.bn.netease.com/videolib3/1708/17/lYBQk5746/HD/lYBQk5746-mobile.mp4,
	sizeHD = 11400,
	videoTopic = {
	alias = 为你带来大自然不一样的视频,
	ename = T1493823028024,
	tname = 奇葩空间,
	topic_icons = http://dingyue.nosdn.127.net/nEXoWfI=MnuuX4T1BFD5LigeIxWqWdJ4RQ1VU6WEsNyg11493823027146.jpg,
	tid = T1493823028024
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/lYBQk5746/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/lYBQk5746/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv1.bn.netease.com/videolib3/1708/17/lYBQk5746/SD/lYBQk5746-mobile.mp4,
	length = 114,
	cover = http://vimg3.ws.126.net/image/snapshot/2017/8/F/J/VPR4D9VFJ.jpg,
	topicName = 奇葩空间,
	votecount = 0,
	ptime = 2017-08-17 15:47:46,
	title = 黑猩猩一根接一根的抽烟，看样子早已是个老烟枪了,
	videosource = 新媒体,
	replyid = PR4D9VFI050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 总想写点什么，那就写点什么吧。放不下，要带她一起走.每日更新精彩故事 品世间百态,
	sectiontitle = ,
	topicImg = http://vimg1.ws.126.net/image/snapshot/2017/6/U/5/VCN147CU5.jpg,
	sizeSD = 2250,
	topicSid = VCN147CTH,
	sizeSHD = 0,
	vid = VOR4D9I1T,
	mp4Hd_url = <null>,
	sizeHD = 0,
	videoTopic = {
	alias = 每日更新精彩故事 品世间百态,
	ename = T1493015744132,
	tname = 带她走吧,
	topic_icons = http://dingyue.nosdn.127.net/Nsf7nq=KMlqsk1ma8Los8LEtXeHFAmKopX2MWVZ1PQOtC1493015742909.png,
	tid = T1493015744132
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/rogkS6043/SD/movie_index.m3u8,
	m3u8Hd_url = <null>,
	replyBoard = video_bbs,
	mp4_url = http://flv3.bn.netease.com/videolib3/1708/17/rogkS6043/SD/rogkS6043-mobile.mp4,
	length = 30,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/5/8/VCR4F2158.jpg,
	topicName = 带她走吧,
	votecount = 0,
	ptime = 2017-08-17 15:47:32,
	title = 谢楠医院生孩子，沈凌和大左抢着陪产，吴京：我才是老公,
	videosource = 新媒体,
	replyid = OR4D9I1T050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 每日为大家分享有趣的文章以及视频，娱乐大家，也娱乐自己，将自己所了解的新鲜事分享给大家,
	sectiontitle = ,
	topicImg = http://vimg3.ws.126.net/image/snapshot/2017/3/O/5/VCDUNMGO5.jpg,
	sizeSD = 4875,
	topicSid = VCDUNMGNR,
	sizeSHD = 0,
	vid = VAR4D90JP,
	mp4Hd_url = http://flv3.bn.netease.com/videolib3/1708/17/SDFTw5978/HD/SDFTw5978-mobile.mp4,
	sizeHD = 6500,
	videoTopic = {
	alias = 娱乐大家娱乐自己开心每一天,
	ename = T1488806835541,
	tname = 爆料e站,
	topic_icons = http://dingyue.nosdn.127.net/qp5PmMUiM8LMeEogUqMYvgw3XSwsZiJgNrYc0dhQ9a6=G1488806835161.jpg,
	tid = T1488806835541
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/SDFTw5978/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/SDFTw5978/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv1.bn.netease.com/videolib3/1708/17/SDFTw5978/SD/SDFTw5978-mobile.mp4,
	length = 65,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/J/Q/VAR4D90JQ.jpg,
	topicName = 爆料e站,
	votecount = 0,
	ptime = 2017-08-17 15:47:14,
	title = 大鹏开公交车带柳岩去看《煎饼侠》，结果引起了公愤,
	videosource = 新媒体,
	replyid = AR4D90JP050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 美食制作，分享，国外美食解说
 
 在新媒体平台上，都注册有来吧吃货君，今日头条、UC大鱼、百度百家、一点号、企鹅媒体、播放量累计30万，这些平台刚做一个月不到。,
	sectiontitle = ,
	topicImg = http://vimg2.ws.126.net/image/snapshot/2017/7/M/P/VCPE91NMP.jpg,
	sizeSD = 7275,
	topicSid = VCPE91NMM,
	sizeSHD = 14550,
	vid = VER4D8J4V,
	mp4Hd_url = http://flv3.bn.netease.com/videolib3/1708/17/fDLxG5824/HD/fDLxG5824-mobile.mp4,
	sizeHD = 9700,
	videoTopic = {
	alias = 美食制作，分享，国外美食解说,
	ename = T1501139146040,
	tname = 来吧吃货君,
	topic_icons = http://dingyue.nosdn.127.net/DmQdt=mQKKbGh2eLRkj0lmHlmMtot99i3ZCXDQ23YaPHx1502432157898.png,
	tid = T1501139146040
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/fDLxG5824/SD/movie_index.m3u8,
	m3u8Hd_url = http://flv.bn.netease.com/videolib3/1708/17/fDLxG5824/HD/movie_index.m3u8,
	replyBoard = video_bbs,
	mp4_url = http://flv3.bn.netease.com/videolib3/1708/17/fDLxG5824/SD/fDLxG5824-mobile.mp4,
	length = 97,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/5/0/VER4D8J50.jpg,
	topicName = 来吧吃货君,
	votecount = 0,
	ptime = 2017-08-17 15:47:00,
	title = 看着就心动，吃了根本停不下来的素食鱼子酱，想试试吗？,
	videosource = 新媒体,
	replyid = ER4D8J4V050835RB,
	description = ,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 },
	{
	topicDesc = 团队原创搞笑视频，坚持每一段搞笑视频维持一分钟以内，我们的口号是：拒绝黄、拒绝赌、拒绝毒，立志于好市民奖！,
	sectiontitle = ,
	topicImg = http://vimg1.ws.126.net/image/snapshot/2017/6/U/6/VCN1B8LU6.jpg,
	sizeSD = 2475,
	topicSid = VCN1B8LTE,
	sizeSHD = 0,
	vid = VNR4D87EU,
	mp4Hd_url = <null>,
	sizeHD = 0,
	videoTopic = {
	alias = 搞笑我们是认真的！,
	ename = T1498470337673,
	tname = 一分钟短视频,
	topic_icons = http://dingyue.nosdn.127.net/6th8KRnhUhgezf=Ck2dAAJJsCGo=zSJbaakNQLwQJsk2F1498470337294.jpg,
	tid = T1498470337673
 },
	m3u8_url = http://flv.bn.netease.com/videolib3/1708/17/MexFZ5993/SD/movie_index.m3u8,
	m3u8Hd_url = <null>,
	replyBoard = video_bbs,
	mp4_url = http://flv3.bn.netease.com/videolib3/1708/17/MexFZ5993/SD/MexFZ5993-mobile.mp4,
	length = 33,
	cover = http://vimg2.ws.126.net/image/snapshot/2017/8/E/V/VNR4D87EV.jpg,
	topicName = 一分钟短视频,
	votecount = 0,
	ptime = 2017-08-17 15:46:48,
	title = 小水勾引霸道总裁不惜手段，还叫他女友来看,
	videosource = 新媒体,
	replyid = NR4D87EU050835RB,
	description = 《初恋这件小事》小水勾引霸道总裁不惜手段，还叫他女友来看,
	playersize = 1,
	playCount = 0,
	replyCount = 0
 }
 ],
	videoSidList = [
	{
	sid = VAP4BFE3U,
	title = 奇葩,
	imgsrc = http://img2.cache.netease.com/m/3g/qipa.png
 },
	{
	sid = VAP4BFR16,
	title = 萌物,
	imgsrc = http://img2.cache.netease.com/m/3g/mengchong.png
 },
	{
	sid = VAP4BG6DL,
	title = 美女,
	imgsrc = http://img2.cache.netease.com/m/3g/meinv.png
 },
	{
	sid = VAP4BGTVD,
	title = 精品,
	imgsrc = http://img2.cache.netease.com/m/3g/jingpin.png
 }
 ],
	videoHomeSid = VBJ4L28O7
 }
 
 */
    
    [RequestManager GET:@"http://c.m.163.com/nc/video/home/1-10.html" isNeedCache:YES parameters:nil successBlock:^(id response) {
        
        NSLog(@"----%@",response);
        
    } failureBlock:^(NSError *error) {
        NSLog(@"----%@",error);
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        NSLog(@"%lld--%lld", bytesProgress, totalBytesProgress);
    }];
    
    
    
    return;
    SharePopView *popView = [[SharePopView alloc]initWithTitleArray:@[@"QQ",@"空间",@"微信",@"朋友圈",@"微信收藏"] picarray:@[@"qqIcon",@"zoneIcon",@"wechatIcon",@"pyqIcon",@"favoritesIcon"]];
    [popView selectedItem:^(NSInteger index) {
        NSLog(@"你好啊--------%ld", (long)index);
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [popView show];
}
- (void)btnClick {
    
//    XLPopMenuView *menu = [[XLPopMenuView alloc] init];
//    
//    PopMenuModel* model = [PopMenuModel
//                           allocPopMenuModelWithImageNameString:@"tabbar_compose_idea"
//                           AtTitleString:@"文字/头条"
//                           AtTextColor:[UIColor grayColor]
//                           AtTransitionType:PopMenuTransitionTypeCustomizeApi
//                           AtTransitionRenderingColor:nil];
//    
//    PopMenuModel* model1 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_photo"
//                            AtTitleString:@"相册/视频"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeSystemApi
//                            AtTransitionRenderingColor:nil];
//    
//    PopMenuModel* model2 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_camera"
//                            AtTitleString:@"拍摄/短视频"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
//                            AtTransitionRenderingColor:nil];
//    
//    PopMenuModel* model3 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_lbs"
//                            AtTitleString:@"签到"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeSystemApi
//                            AtTransitionRenderingColor:nil];
//    
//    PopMenuModel* model4 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_review"
//                            AtTitleString:@"点评"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
//                            AtTransitionRenderingColor:nil];
//    
//    PopMenuModel* model5 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_more"
//                            AtTitleString:@"更多"
//                            AtTextColor:[UIColor redColor]
//                            AtTransitionType:PopMenuTransitionTypeSystemApi
//                            AtTransitionRenderingColor:nil];
//    
//    menu.items = @[ model, model1, model2, model3, model4, model5 ];
//    menu.delegate = self;
//    menu.popMenuSpeed = 12.0f;
//    menu.automaticIdentificationColor = false;
//    menu.animationType = PopAnimationTypeViscous;
//    
//    popMenvTopView* topView = [popMenvTopView popMenvTopView];
//    topView.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 92);
//    menu.topView = topView;
//    
//    menu.backgroundType = PopBackgroundTypeLightBlur;
//    [menu openMenu];
//    
//    return;
    
    [ActivityAlert showWithView:self.view.window trueAction:^{
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return;
    
    
    
//    [MBProgressHUD showAutoMessage:@"nihao hoaho " ToView:self.view];
}

- (void)popMenuView:(XLPopMenuView*)popMenuView
didSelectItemAtIndex:(NSUInteger)index {
   
    NSLog(@"%ld", index);
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PopoverMenuDelegate
- (void)popupMenuDidSelectedAtIndex:(NSInteger)index popupMenu:(PopoverMenu *)popupMenu {
    NSLog(@"点击了 %@ 选项",TITLES[index]);
    if (index == 0) {
        CalendarViewController *vc = [[CalendarViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {
        QRMainViewController *vc = [[QRMainViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
