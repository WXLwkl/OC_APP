//
//  SpeechViewController.m
//  OC_APP
//
//  Created by xingl on 2017/8/18.
//  Copyright © 2017年 兴林. All rights reserved.
//

#import "SpeechViewController.h"
#import <Speech/Speech.h>
@interface SpeechViewController ()<SFSpeechRecognizerDelegate>

@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) AVAudioEngine *audioEngine;

@property (nonatomic, weak) UIButton *recordButton;
@property (nonatomic, weak) UILabel *resultStringLabel;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"省市区三级联动";
    [self initSubviews];
}

- (void)initSubviews {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 20, kScreenWidth - 40, 200);
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_resultStringLabel = label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, kScreenHeight - 250, kScreenWidth, 44);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"开始录音" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton = button];
    
    _recordButton.enabled = NO;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, kScreenHeight - 150, kScreenWidth, 44);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"识别本地音频文件" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(recognizeLocalAudioFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) wealSelf = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    wealSelf.recordButton.enabled = NO;
                    [wealSelf.recordButton setTitle:@"语音识别未授权" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    wealSelf.recordButton.enabled = NO;
                    [wealSelf.recordButton setTitle:@"用户未授权使用语音识别" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    wealSelf.recordButton.enabled = NO;
                    [wealSelf.recordButton setTitle:@"语音识别在这台设备上受到限制" forState:UIControlStateDisabled];
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    wealSelf.recordButton.enabled = YES;
                    [wealSelf.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        });
    }];
}


- (void)recordButtonClicked:(UIButton *)sender {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        if (_recognitionRequest) {
            [_recognitionRequest endAudio];
        }
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"正在停止" forState:UIControlStateDisabled];
    } else {
        [self startRecording];
        [self.recordButton setTitle:@"停止录音" forState:UIControlStateNormal];
    }
}

- (void)startRecording {
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession  setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录音设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
    _recognitionTask = [self.recognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isFinial = NO;
        if (result) {
            strongSelf.resultStringLabel.text = result.bestTranscription.formattedString;
            isFinial = result.isFinal;
        }
        if (error ||  isFinial) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionTask = nil;
            strongSelf.recognitionRequest = nil;
            strongSelf.recordButton.enabled = YES;
            [strongSelf.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
    self.resultStringLabel.text = @"正在录音";
}

- (void)recognizeLocalAudioFile:(UIButton *)sender {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    SFSpeechRecognizer *localRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"aa" withExtension:@"wav"];
    if (!url) return;
    SFSpeechURLRecognitionRequest *req = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    __weak typeof(self) weakSelf = self;
    [localRecognizer recognitionTaskWithRequest:req resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"语音识别解析失败:%@", error.localizedDescription);
        } else {
            weakSelf.resultStringLabel.text = result.bestTranscription.formattedString;
        }
    }];
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if (available) {
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    }
    else{
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"语音识别不可用" forState:UIControlStateDisabled];
    }
}

#pragma mark - setter & getter
- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}

- (SFSpeechRecognizer *)recognizer {
    if (!_recognizer) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
        _recognizer.delegate = self;
    }
    return _recognizer;
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
