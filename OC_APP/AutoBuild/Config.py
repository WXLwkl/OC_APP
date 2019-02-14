#!/usr/bin/env python3
# -*- coding: utf-8 -*-


#注意：如果在项目中用到 pod 设置为True 否则False
isPod = False


#蒲公英上传
OPEN_PYUPLOAD = False   #是否开启蒲公英上传功能  True  False
PGYER_UPLOAD_URL = "http://www.pgyer.com/apiv1/app/upload"
DOWNLOAD_BASE_URL = "http://www.pgyer.com"
USER_KEY = "db2c63823682f794f1184cbba312e6c0"
API_KEY = "b687beef47faf66bb619a7072285b973"
#设置从蒲公英下载应用时的密码
PYGER_PASSWORD = "xl"


#AppStore上传
OPEN_APPSTORE_UPLOAD = False  #是否开启AppStore上传上传功能  True  False
APPLEID              = "****************"
APPLEPWD             = "****************"


#项目信息 -- 可以改动的部分

target        = "MVVM"     # 对应的target
configuration = 'Release'       # 编译配置 (可不修改)  Release环境  Debug环境
profile       = "Dev"           # 配置文件分为四种AdHoc、Dev、AppStore、Ent、分别对应四种配置文件

development_team = 'SEX9UQR699'
code_sign_identity = "iPhone Developer"

targets = {
    '9117D4DC21900586003C9F9B': {
        'DEVELOPMENT_TEAM': development_team,
        'CODE_SIGN_IDENTITY': code_sign_identity,
        'PRODUCT_BUNDLE_IDENTIFIER': "com.xingl.xl",
        'CODE_SIGN_STYLE': 'Manual', # 设置为手动管理证书
        'PROVISIONING_PROFILE': "", # c6a13109-6512-465e-b7a2-2ad5d0547e9c
        'PROVISIONING_PROFILE_SPECIFIER': "APP_Debug" # iPhone Developer: Leyi Xu (RFQ2UK8W2B)
    },
    '9117D4F421900588003C9F9B': {
        'DEVELOPMENT_TEAM': development_team,
        'CODE_SIGN_IDENTITY': code_sign_identity,
        'PRODUCT_BUNDLE_IDENTIFIER': "com.xingl.xl",
        'CODE_SIGN_STYLE': 'Manual',
        'PROVISIONING_PROFILE': "",
        'PROVISIONING_PROFILE_SPECIFIER': "APP_Debug"
    },
    '911DC9FC2215557D00549949': {
        'DEVELOPMENT_TEAM': development_team,
        'CODE_SIGN_IDENTITY': code_sign_identity,
        'PRODUCT_BUNDLE_IDENTIFIER': "com.xingl.xlt",
        'CODE_SIGN_STYLE': 'Manual',
        'PROVISIONING_PROFILE': "",
        'PROVISIONING_PROFILE_SPECIFIER': "APP_Debug"
    },
    '911DCA1722155B6000549949': {
        'DEVELOPMENT_TEAM': development_team,
        'CODE_SIGN_IDENTITY': code_sign_identity,
        'PRODUCT_BUNDLE_IDENTIFIER': "com.xingl.xlt",
        'CODE_SIGN_STYLE': 'Manual',
        'PROVISIONING_PROFILE': "",
        'PROVISIONING_PROFILE_SPECIFIER': "APP_Debug"
    },
    '9100500821DF418700CA8DAD': {
        'DEVELOPMENT_TEAM': development_team,
        'CODE_SIGN_IDENTITY': code_sign_identity,
        'PRODUCT_BUNDLE_IDENTIFIER': "com.xingl.xlt",
        'CODE_SIGN_STYLE': 'Manual',
        'PROVISIONING_PROFILE': "",
        'PROVISIONING_PROFILE_SPECIFIER': "APP_Debug"
    }


}


# 替换图片的路径
image_paths = [
    'SysResource/Assets.xcassets/AppIcon.appiconset/',
    # 'SysResource/Assets.xcassets/home/banner1.imageset/'
]