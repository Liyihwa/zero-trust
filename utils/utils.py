import subprocess
import winreg
import psutil
import sqlite3
from safewa import oswa

def cmd(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        output = result.stdout.strip()
        return output
    else:
        error = result.stderr.strip()
        return error


def powershell(command):
    result = subprocess.run(['powershell', '-c', command], capture_output=True, text=True)
    if result.returncode == 0:
        output = result.stdout
    else:
        output = result.stderr
    return output.strip()


# 从cmd中执行文件
def cmdf(filepath):
    result = subprocess.run("cmd {}".format(filepath), shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        output = result.stdout.strip()
        return output
    else:
        error = result.stderr.strip()
        return error


# 从powershell中执行文件
def powershellf(filepath):
    result = subprocess.run("powershell {}".format(filepath), shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        output = result.stdout.strip()
        return output
    else:
        error = result.stderr.strip()
        return error


def readall(filepath):
    with open(filepath, encoding="utf8") as f:
        res = f.read()
    return res


def is_private_ip(ip_address):
    # 将 IP 地址转换成整数形式方便比较
    ip_parts = ip_address.split('.')
    ip = int(ip_parts[0]) * 256 ** 3 + int(ip_parts[1]) * 256 ** 2 + int(ip_parts[2]) * 256 + int(ip_parts[3])

    # 检查是否属于私有IP地址范围
    private_ranges = [
        {'start': '10.0.0.0', 'end': '10.255.255.255'},
        {'start': '172.16.0.0', 'end': '172.31.255.255'},
        {'start': '192.168.0.0', 'end': '192.168.255.255'}
    ]

    for private_range in private_ranges:
        start_parts = private_range['start'].split('.')
        start = int(start_parts[0]) * 256 ** 3 + int(start_parts[1]) * 256 ** 2 + int(start_parts[2]) * 256 + int(
            start_parts[3])

        end_parts = private_range['end'].split('.')
        end = int(end_parts[0]) * 256 ** 3 + int(end_parts[1]) * 256 ** 2 + int(end_parts[2]) * 256 + int(end_parts[3])

        if start <= ip <= end:
            return True

    return False


def __registry_path_split(path):
    path = path.strip("\\")
    split = path.split("\\")
    path_prefix = split[0]
    path_suffix = split[-1]
    path_middle = "\\".join(split[1:-1])
    paths_prefix = {
        "HKEY_CLASSES_ROOT": winreg.HKEY_CLASSES_ROOT,
        "HKEY_CURRENT_USER": winreg.HKEY_CURRENT_USER,
        "HKEY_USERS": winreg.HKEY_USERS,
        "HKEY_CURRENT_CONFIG": winreg.HKEY_CURRENT_CONFIG,
        "HKEY_DYN_DATA": winreg.HKEY_DYN_DATA,
        "HKEY_LOCAL_MACHINE": winreg.HKEY_LOCAL_MACHINE
    }
    return paths_prefix[path_prefix], path_middle, path_suffix


def get_registry_info(key):
    root_key, path, key = __registry_path_split(key)
    try:
        registry_key = winreg.OpenKey(root_key, path, 0, winreg.KEY_READ)
        res = winreg.QueryValueEx(registry_key, key)
        winreg.CloseKey(registry_key)
        return res
    except FileNotFoundError as e:
        return None


def get_registry_value(key):
    root_key, path, key = __registry_path_split(key)
    try:
        path = winreg.OpenKey(root_key, path)
        # 获取注册表项的值
        value, data_type = winreg.QueryValueEx(path, key)
        winreg.CloseKey(path)
    except FileNotFoundError:
        return None, None

    return value, data_type


# 查询name位于names中且pid位于pids中的进程
def query_process(names=None, pids=None):
    if pids is None:
        pids = []
    if names is None:
        names = []
    res = []
    procs = []
    bool_list = []

    for p in psutil.process_iter():
        bool_list.append(True)
        procs.append(p)

    for i, p in zip(range(len(bool_list)), procs):
        try:
            if not bool_list[i] or len(names) == 0:
                continue
            if p.name() not in names:
                bool_list[i] = False
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            bool_list[i] = False

    for i, p in zip(range(len(bool_list)), procs):
        try:
            if not bool_list[i] or len(pids) == 0:
                continue
            if p.pid not in pids:
                bool_list[i] = False
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            bool_list[i] = False
    for b, p in zip(bool_list, procs):
        if b:
            res.append(p)
    return res


def query_db(db_path, sql):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # 执行查询语句
    cursor.execute(sql)

    res = cursor.fetchall()
    cursor.close()
    conn.close()
    return res


def merge_dict(dic1, dic2):
    dic3 = {}
    for k, v in dic1:
        dic3[k] = v
    for k, v in dic2:
        dic3[k] = v
    return dic3
'''
深度优先搜索
xml.dom.minidom 的节点
callback函数需要返回继续向下搜索的节点的迭代器
'''
def dfs_domNode(etNode,callback):
    search_nodes=callback(etNode)
    if search_nodes is not None:
        for node in search_nodes:
            dfs_domNode(node,callback)
'''
    删除xml.dom.minidom的node中的所有空行子节点
'''
def remove_empty_lines(node):
    children = node.childNodes
    for child in children:
        if child.nodeType == child.TEXT_NODE and child.nodeValue.strip() == "":
            node.removeChild(child)
    for child in node.childNodes:
        if child.nodeType == child.ELEMENT_NODE:
            remove_empty_lines(child)

def sysinspector_caller():
    base_dir=r".\utils\windows\sysinspector"
    # 运行前先清理其他报告
    for f in oswa.ls(base_dir):
        if f.endswith(".xml"):
            oswa.rm(f)
    powershellf(r"utils\windows\ps_code\sysinspector_caller.ps1")

def get_sysinspector_report_path():
    for f in oswa.ls(r".\utils\windows\sysinspector"):
            if f.endswith(".xml"):
                return f
    return None