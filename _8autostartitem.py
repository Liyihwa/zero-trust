import os
import time
import winreg
from virustotal_python import Virustotal
from win32com.client import Dispatch

from configs import global_config
from safewa.logwa import logger


def get_startup_items():
    startup_items = []
    run_key = r"Software\Microsoft\Windows\CurrentVersion\Run"
    try:
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, run_key) as hkey:
            for i in range(winreg.QueryInfoKey(hkey)[1]):
                name, value, type = winreg.EnumValue(hkey, i)
                if (type == 2):
                    continue
                path = extract_file_path(value)
                # virus_total_info = get_virustotal_info(path)
                file_info = os.stat(path)
                startup_items.append({
                    "Name": name,
                    "Value": value,
                    "Create Time": time.ctime(file_info.st_ctime),
                    "Modify Time": time.ctime(file_info.st_mtime),
                    "Path": path,
                    # "VirusTotal": virus_total_info
                })
    except Exception as e:
        print(f"Error: {str(e)}")

    # 查询 HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
    current_user_key = r"Software\Microsoft\Windows\CurrentVersion\Run"
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, current_user_key) as hkey:
            for i in range(winreg.QueryInfoKey(hkey)[1]):
                name, value, type = winreg.EnumValue(hkey, i)
                if (type == 2):
                    continue
                path = extract_file_path(value)
                # virus_total_info = get_virustotal_info(path)
                file_info = os.stat(path)
                startup_items.append({
                    "Name": name,
                    "Value": value,
                    "Create Time": time.ctime(file_info.st_ctime),
                    "Modify Time": time.ctime(file_info.st_mtime),
                    "Path": path,
                    # "VirusTotal": virus_total_info
                })
    except Exception as e:
        print(f"Error: {str(e)}")

    return startup_items


def extract_file_path(value):
    if value.startswith('"'):
        value = value[1:]  # 从索引 1 开始，去除开头的双引号
    # 从注册表值中提取文件路径
    # 这里的示例是根据参数格式提取
    index = value.find(".exe")
    if index != -1:
        return value[:index + 4]  # +4 是为了包括 ".exe"
    else:
        return None


def autoitem_info():
    logger = global_config.Logger
    logger.line()
    logger.info("自启动信息收集中...")
    startup_items = get_startup_items()
    ver_parser = Dispatch('Scripting.FileSystemObject')
    # for item in startup_items:
    #     print("Name:", item["Name"])
    #     print("Value:", item["Value"])
    #     # print("Publisher:", item["Publisher"])
    #     print("Create Time:",item["Create Time"])
    #     print("Modify Time:",item["Modify Time"])
    #     print("Path:", item["Path"])
    #     print("Version:",ver_parser.GetFileVersion(item["Path"]))
    #     # print("Timestamp:", item["Timestamp"])
    #     # print("VirusTotal:", item["VirusTotal"])
    #     print("=" * 50)
    # print(len(startup_items))
    name_list = ["自启动项数量"]
    res_list = []
    res_list.append(len(startup_items))
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
    return name_list, res_list

if __name__ == "__main__":
    autoitem_info()
