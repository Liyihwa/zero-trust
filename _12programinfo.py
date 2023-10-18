import win32com.client
import winreg
import psutil
import os
import winshell

def get_installed_software_info():
    software_list = []
    wmi = win32com.client.GetObject("winmgmts:\\\\.\\root\\cimv2")
    software_items = wmi.ExecQuery("SELECT Name, Vendor FROM Win32_Product")

    for software in software_items:
        software_name = software.Properties_("Name").Value
        software_vendor = software.Properties_("Vendor").Value
        software_list.append({"Name": software_name, "Vendor": software_vendor})

    return software_list


installed_software = get_installed_software_info()
for software in installed_software:
    print(f"名称: {software['Name']}, 供应商: {software['Vendor']}")

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

remote_desktop_enabled = is_remote_desktop_enabled()

if remote_desktop_enabled:
    print("远程桌面已启用")
else:
    print("远程桌面已禁用")

def count_remote_ssh_connections():
    ssh_connections = [conn for conn in psutil.net_connections(kind='tcp') if len(conn.raddr) == 2 and conn.raddr[1] == 22]
    return len(ssh_connections)

ssh_count = count_remote_ssh_connections()
print(f"远程SSH连接数量: {ssh_count}")

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

invalid_shortcuts = check_desktop_shortcuts()

if invalid_shortcuts:
    print("以下桌面图标快捷方式不正常或目标不存在：")
    for shortcut in invalid_shortcuts:
        print(shortcut)
else:
    print("所有桌面图标快捷方式正常。")