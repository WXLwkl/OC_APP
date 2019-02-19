#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#  Created by xingl on 2018/1/25.
__author__ = 'xingl'

import time, os, sys,subprocess, shutil

from pbxproj import XcodeProject
from PIL import Image

import Config
import requests

# 操作主地址
def _work_dir():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# 项目名称
def project_name():
    return os.path.basename(_work_dir())

# 输出ipa文件的路径
def export_ipa_path(timeStr):
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Packge", Config.configuration, "%s-%s"%(Config.target,timeStr))
    return path

# archive文件的路径
def archive_path():
    # xcarchive文件路径（含有dsym），后续查找BUG用途
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Packge", Config.configuration, "%s.xcarchive"%(Config.target))
    return path

# 过滤非图片文件
def _find_images(path):
    list_files = os.listdir(path)
    images = [image for image in list_files if os.path.splitext(image)[-1] == ".png"]
    return images

# 替换图片资源文件
def replace_images():
    print("============================ 替换图片 ===============================")
    for x in Config.image_paths:

        des_path_dir = os.path.join(_work_dir(), Config.target, x)
        src_path_dir = os.path.join(_work_dir(), "AutoBuild/customization", x)

        assert(os.path.isdir(des_path_dir))
        assert(os.path.isdir(src_path_dir))

        src_images = _find_images(src_path_dir)
        des_images = _find_images(des_path_dir)

        if len(src_images) != len(des_images):
            print('图片的数量不对！！！')
            sys.exit()

        for image in src_images:
            src_image_path = os.path.join(src_path_dir, image)
            des_image_path = os.path.join(des_path_dir, image)

            if not os.path.exists(des_image_path):                   # 比较文件名
                print("image name mistake : %s" % src_image_path)
                sys.exit()

            try:
                # 如果目标文件存在，会替换原来的文件
                shutil.copyfile(src_image_path, des_image_path)
            except Exception as e:
                print("!!!!!!!!!!! 替换图片失败 !!!!!!!!!! ", e)
                sys.exit()

    print("👍👍👍👍👍👍 替换图片成功  👍👍👍👍👍👍👍👍👍👍👍")


#结束打印函数
def End():
    print("*****************************************************************")
    print("                       结束打包                             ")
    print("  项目名称：%s" %(project_name()))
    print("  Target：%s" %(Config.target))
    print("  编译环境：%s" %(Config.configuration))
    print("  证书配置：%s" %(Config.profile))
    print("  是否上传蒲公英：%s" %(Config.OPEN_PYUPLOAD))
    print("  是否上传AppStore：%s\n" %(Config.OPEN_APPSTORE_UPLOAD))
    print("*****************************************************************")


def cleanArchiveFile(path):
	cleanCmd = "rm -r %s" %(path)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	print("cleaned archiveFile: %s" %(path))

def uploadIpaToAppStore(path):
    print("----------- ipa上传中 --------------")
    altoolPath = "/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
    exportCmd = exportCmd = "%s --validate-app -f %s -u %s -p %s -t ios --output-format xml" % (altoolPath, path, Config.APPLEID, Config.APPLEPWD)
    process = subprocess.Popen(exportCmd, shell=True)
    (stdoutdata, stderrdata) = process.communicate()

    validateResult = process.returncode
    if validateResult == 0:
        print("~~~~~~~~~~~~~~ ipa验证通过 ~~~~~~~~~~~")
        exportCmd = "%s --upload-app -f %s -u %s -p %s -t ios --output-format normal" % (
            altoolPath, path, Config.APPLEID, Config.APPLEPWD)
        process = subprocess.Popen(exportCmd, shell=True)
        (stdoutdata, stderrdata) = process.communicate()

        uploadresult = process.returncode
        if uploadresult == 0:
            print("-------- ipa 上传成功")
        else:
            print('-------- ipa 上传失败')
    else:
        print("--------- ipa 验证失败")


def uploadIpaToPgyer(ipaPath):
    ipaPath = os.path.expanduser(ipaPath)
    # ipaPath = unicode(ipaPath,"utf-8")
    files = {'file': open(ipaPath, 'rb')}
    headers = {'enctype': 'multipart/form-data'}
    payload = {'uKey':Config.USER_KEY, '_api_key':Config.API_KEY, 'installType':'2','password':Config.PYGER_PASSWORD, 'updateDescription':''}
    print("uploading....")
    r = requests.post("http://www.pgyer.com/apiv1/app/upload", data=payload, files=files, headers=headers)
    if r.status_code == requests.codes.ok:
        result = r.json()
        parserUploadResult(result)
    else:
        print('HTTPError,Code:' + r.status_code)


def parserUploadResult(jsonResult):
    resultCode = jsonResult['code']
    if resultCode == 0:
        downUrl = "http://www.pgyer.com" + "/" + jsonResult["data"]["appShortcutUrl"]
        print("Upload Success!!")
        print("DownUrl is:" + downUrl)
    else:
        print("Upload Fail!")
        print("Reason:" + jsonResult['message'])

def archiveProject(project):

    print("\n===========开始clean && archive操作===========")
    start = time.time()

    if Config.isPod:
        archiveCmd = 'xcodebuild -workspace %s -scheme %s -configuration %s -archivePath %s clean archive -destination generic/platform=iOS' % (
            project, Config.target, Config.configuration, archive_path())
    else:
        archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s -archivePath %s clean archive -destination generic/platform=iOS' % (
        project, Config.target, Config.configuration, archive_path())

    process = subprocess.Popen(archiveCmd, shell=True)
    process.wait()

    end = time.time()

    # Code码
    archive_result_code = process.returncode
    if archive_result_code != 0:
        print("=======archive失败,用时:%.2f秒=======" % (end - start))
        sys.exit()
    else:
        print("=======archive成功,用时:%.2f秒=======" % (end - start))

# 导出ipa
def exportArchive(exportPath):

    print("\n\n===========开始export操作===========")
    print("\n==========请你耐心等待一会~===========")
    start = time.time()

    plist_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "plist", "%s.plist"%(Config.profile))

    exportCmd = "xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s" %(archive_path(), exportPath, plist_path)
    process = subprocess.Popen(exportCmd, shell=True)
    process.wait()

    end = time.time()

    # Code码
    export_result_code = process.returncode
    if export_result_code != 0:
        print("=======导出IPA失败,用时:%.2f秒=======" % (end - start))
        sys.exit()
    else:
        print("=======导出IPA成功,用时:%.2f秒=======" % (end - start))
        return exportPath


def configProject():
    """编译打包"""
    print("============================ 编译打包 ===============================")
    path = os.path.join(_work_dir(), "%s.xcodeproj/project.pbxproj"%(project_name()))
    project = XcodeProject.load(path)

    rootObject = project["rootObject"]
    projects = project["objects"]
    attributes = projects[rootObject]["attributes"]["TargetAttributes"]
    targetsObject = projects[rootObject]["targets"]

    for target in targetsObject:

        # attributes[target]["DevelopmentTeam"] = Config.targets[target]["DEVELOPMENT_TEAM"]  # 修改 team
        # attributes[target]["ProvisioningStyle"] = "Manual"  # 设置为手动管理证书

        buildConfigurationListObject = projects[target]["buildConfigurationList"]
        buildConfigurationsObject = projects[buildConfigurationListObject]["buildConfigurations"]

        for buildConfig in buildConfigurationsObject:

            buildSettings = projects[buildConfig]["buildSettings"]
            # 修改签名类型
            buildSettings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = Config.targets[target]["CODE_SIGN_IDENTITY"]

            for k, v in Config.targets[target].items():  # 根据配置修改证书等
                buildSettings[k] = v
    project.save()


def xcbuild():

    if Config.isPod:
        workspace = os.path.join(_work_dir(), "%s.xcworkspace" %(project_name()))
        archiveProject(workspace)
    else:
        project = os.path.join(_work_dir(), "%s.xcodeproj" %(project_name()))
        archiveProject(project)

    """" 输出路径 """
    timeStr = time.strftime("%Y-%m-%d_%H:%M:%S", time.localtime())
    export_path = export_ipa_path(timeStr)

    """ 导出ipa文件 """
    ipa_dir = exportArchive(export_path)
    ipa = os.path.join(ipa_dir, "%s.ipa" % (Config.target))

    # 蒲公英上传
    if Config.OPEN_PYUPLOAD == True and ipa_dir != "" :
        uploadIpaToPgyer(ipa)
    #AppStore上传
    if Config.OPEN_APPSTORE_UPLOAD == True:
        uploadIpaToAppStore(ipa)
    else:
        cleanArchiveFile(archive_path())

    End()
    time.sleep(8)


if __name__ == '__main__':

    # replace_images()
    configProject()
    xcbuild()
