import win32net
import datetime
import win32api  # 确保导入win32api

import ctypes
import os

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False
def get_password_age(username):
    try:
        user_info = win32net.NetUserGetInfo(None, username, 3)  # 3 corresponds to USER_INFO_3
        password_last_set = user_info['password_age']
        return password_last_set
    except Exception as e:
        print(f"Error: {e}")
        return None

current_username = win32api.GetUserName()
last_password_change = get_password_age(current_username)

if last_password_change:
    print(f"距离上次更改密码过去了: {last_password_change}秒")
else:
    print("无法获取上次密码更改时间")

if is_admin():
    print("当前用户是管理员")
else:
    print("当前用户不是管理员")
