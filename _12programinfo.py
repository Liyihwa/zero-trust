import win32com.client
import winreg
import psutil
import os
import winshell

from configs import global_config
from safewa.logwa import logger


def get_installed_software_info():
    software_list = []
    wmi = win32com.client.GetObject("winmgmts:\\\\.\\root\\cimv2")
    software_items = wmi.ExecQuery("SELECT Name, Vendor FROM Win32_Product")

    for software in software_items:
        software_name = software.Properties_("Name").Value
        software_vendor = software.Properties_("Vendor").Value
        software_list.append({"Name": software_name, "Vendor": software_vendor})

    return software_list

def is_remote_desktop_enabled():
    try:
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Terminal Server") as key:
            fDenyTSConnections, _ = winreg.QueryValueEx(key, "fDenyTSConnections")
            if fDenyTSConnections == 0:
                return True  # 远程桌面已启用
            else:
                return False  # 远程桌面已禁用
    except Exception as e:
        return f"无法确定远程桌面状态: {e}"

def count_remote_ssh_connections():
    ssh_connections = [conn for conn in psutil.net_connections(kind='tcp') if len(conn.raddr) == 2 and conn.raddr[1] == 22]
    return len(ssh_connections)



def is_shortcut_valid(shortcut_path):
    if os.path.exists(shortcut_path):
        try:
            with winshell.shortcut(shortcut_path) as shortcut:
                target_path = shortcut.path
                if os.path.exists(target_path):
                    return True
        except Exception as e:
            return False
    return False

def check_desktop_shortcuts():
    desktop_path = os.path.expanduser("~/Desktop")
    invalid_shortcuts = []

    for root, _, files in os.walk(desktop_path):
        for file in files:
            if file.endswith(".lnk"):
                shortcut_path = os.path.join(root, file)
                if not is_shortcut_valid(shortcut_path):
                    invalid_shortcuts.append(shortcut_path)

    return invalid_shortcuts

def program_info():
    logger = global_config.Logger
    logger.line()
    logger.info("软件信息收集中...")
    name_list = []
    res_list = []
    name_list.append("安装软件数量")
    installed_software = get_installed_software_info()
    res_list.append(len(installed_software))
    # for software in installed_software:
    #     print(f"名称: {software['Name']}, 供应商: {software['Vendor']}")

    remote_desktop_enabled = is_remote_desktop_enabled()
    name_list.append("远程桌面是否启用")
    res_list.append(remote_desktop_enabled)
    # if remote_desktop_enabled:
    #     print("远程桌面已启用")
    # else:
    #     print("远程桌面已禁用")
    invalid_shortcuts = check_desktop_shortcuts()
    ssh_count = count_remote_ssh_connections()
    name_list.append("远程SSH连接数量")
    res_list.append(ssh_count)
    name_list.append("桌面图标快捷方式是否正常")
    # print(f"远程SSH连接数量: {ssh_count}")
    if invalid_shortcuts:
        res_list.append(False)
        # print("以下桌面图标快捷方式不正常或目标不存在：")
        # for shortcut in invalid_shortcuts:
        #     print(shortcut)
    else:
        res_list.append(True)
        # print("所有桌面图标快捷方式正常。")
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()
    return name_list,res_list

if __name__ == "__main__":
    logger.info("程序信息收集中.....")
    program_info()