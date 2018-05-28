#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#  Created by xingl on 2018/1/25.
__author__ = 'xingl'


'''
该脚本有点问题
不能用 python3 + 路径  运行
原因 os.path 获取到的路径有问题。
可以把该文件变成可执行文件 chmod a+x 文件名.py 这样直接拖到终端 回车
'''

import os
import subprocess,requests

#项目信息 -- 可以改动的部分

PROJECT_NAME  = "OC_APP"  #项目名称
VERSION       = "1.1.1"             #打包版本号，（与项目本身的版本号无关）
TARGET        = "%s" % PROJECT_NAME #对应的target
CONFIGURATION = "Release"           #Release环境  Debug环境
profile       = "Dev"               #配置文件分为四种AdHoc、Dev、AppStore、Ent、分别对应四种配置文件

#会在桌面创建输出ipa文件的目录
EXPORT_MAIN_DIRECTORY = "./Packge" + "/" + CONFIGURATION + "/" + "%s-%s" %(PROJECT_NAME,VERSION)
#xcarchive文件路径（含有dsym），后续查找BUG用途  export_main_directory
ARCHIVEPATH = EXPORT_MAIN_DIRECTORY + "/%s%s.xcarchive" %(TARGET,VERSION)
#ipa路径 export_main_directory
ipaPATH = EXPORT_MAIN_DIRECTORY + "/%s.ipa" %(TARGET)

WORKSPACE     = "%s.xcworkspace" %(PROJECT_NAME)
PROJECT       = "%s.xcodeproj" %(PROJECT_NAME)
SDK           = "iphoneos"
#注意：如果在项目中用到 pod 请启用此行！！！！！！
PROJECT = None

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




#启动打印函数
def printStart():
    print("*****************************************************************")
    print("**                       开始打包                              ")
    print("**               项目名称:%s" %(PROJECT_NAME))
    print("**               Target：%s" %(TARGET))
    print("**               版 本 号：%s" %(VERSION))
    print("**               编译环境：%s" %(CONFIGURATION))
    print("**               证书配置：%s" %(profile))
    print("**               是否上传蒲公英：%s" %(OPEN_PYUPLOAD))
    print("**               是否上传AppStore：%s\n" %(OPEN_APPSTORE_UPLOAD))
    print("*****************************************************************")

#结束打印函数
def printEnd():
    print("*****************************************************************")
    print("                       结束打包                             ")
    print("  项目名称：%s" %(PROJECT_NAME))
    print("  Target：%s" %(TARGET))
    print("  版 本 号：%s" %(VERSION))
    print("  编译环境：%s" %(CONFIGURATION))
    print("  证书配置：%s" %(profile))
    print("  是否上传蒲公英：%s" %(OPEN_PYUPLOAD))
    print("  是否上传AppStore：%s\n" %(OPEN_APPSTORE_UPLOAD))
    print("*****************************************************************")

def cleanArchiveFile():
	cleanCmd = "rm -r %s" %(ARCHIVEPATH)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	print("cleaned archiveFile: %s" %(ARCHIVEPATH))

def uploadIpaToAppStore():
    print("----------- ipa上传中 --------------")
    altoolPath = "/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
    exportCmd = exportCmd = "%s --validate-app -f %s -u %s -p %s -t ios --output-format xml" % (altoolPath, ipaPATH, APPLEID,APPLEPWD)
    process = subprocess.Popen(exportCmd, shell=True)
    (stdoutdata, stderrdata) = process.communicate()

    validateResult = process.returncode
    if validateResult == 0:
        print("~~~~~~~~~~~~~~ ipa验证通过 ~~~~~~~~~~~")
        exportCmd = "%s --upload-app -f %s -u %s -p %s -t ios --output-format normal" % (
            altoolPath, ipaPATH, APPLEID, APPLEPWD)
        process = subprocess.Popen(exportCmd, shell=True)
        (stdoutdata, stderrdata) = process.communicate()

        uploadresult = process.returncode
        if uploadresult == 0:
            print("-------- ipa 上传成功")
        else:
            print('-------- ipa 上传失败')
    else:
        print("--------- ipa 验证失败")


def parserUploadResult(jsonResult):

    print("jsonResult:" + str(jsonResult))

    resultCode = jsonResult['code']
    if resultCode == 0:
        downUrl = DOWNLOAD_BASE_URL + "/" + jsonResult["data"]["appShortcutUrl"]
        print("Upload Success!!")
        print("DownUrl is:" + downUrl)
    else:
        print("Upload Fail!")
        print("Reason:" + jsonResult['message'])

def uploadIpaToPgyer(ipaPath):
    print("ipaPath:"+ipaPath)
    ipaPath = os.path.expanduser(ipaPath)
    ipaPath = unicode(ipaPath,"utf-8")
    files = {'file': open(ipaPath, 'rb')}
    headers = {'enctype': 'multipart/form-data'}
    payload = {'uKey':USER_KEY, '_api_key':API_KEY, 'installType':'2','password':PYGER_PASSWORD, 'updateDescription':''}
    print("uploading....")
    r = requests.post(PGYER_UPLOAD_URL, data=payload, files=files, headers=headers)
    if r.status_code == requests.codes.ok:
        result = r.json()
        parserUploadResult(result)
    else:
        print('HTTPError,Code:' + r.status_code)

# 导出ipa
def exportArchive():
    exportCmd = "xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist ./AutoBuild/plist/%s.plist" % (
    ARCHIVEPATH, EXPORT_MAIN_DIRECTORY, profile)
    process = subprocess.Popen(exportCmd, shell=True)
    (stdoutdata, stderrdata) = process.communicate()

    signReturnCode = process.returncode
    if signReturnCode != 0:
        print("export %s faild!!" % TARGET)
        return ""
    else:
        return EXPORT_MAIN_DIRECTORY


def buildProject(project):
    archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(project, TARGET, CONFIGURATION, ARCHIVEPATH)
    process = subprocess.Popen(archiveCmd, shell=True)
    process.wait()

    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print("archive project %s failed" %(project))
        cleanArchiveFile()

def buildWorkspace(workspace):
    archiveCmd = 'xcodebuild -workspace %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(workspace, TARGET, CONFIGURATION, ARCHIVEPATH)
    process = subprocess.Popen(archiveCmd, shell=True)
    process.wait()
    archiveReturnCode = process.returncode
    if archiveReturnCode != 0:
        print("archive workspace %s failed" %(workspace))
        cleanArchiveFile()

def xcbuild():

    printStart()
    if PROJECT is None and WORKSPACE is None:
        pass
    elif PROJECT is not None:
        buildProject(PROJECT)
    elif WORKSPACE is not None:
        buildWorkspace(WORKSPACE)

    # 导出ipa文件
    exportarchive = exportArchive()

    # 蒲公英上传
    if OPEN_PYUPLOAD == True and exportarchive != "" :
        uploadIpaToPgyer(ipaPATH)

    #AppStore上传
    if OPEN_APPSTORE_UPLOAD == True:
        uploadAppStore(ipaPath)
    else:
        cleanArchiveFile()

    printEnd()

def main():
    xcbuild()

if __name__ == '__main__':
    main()