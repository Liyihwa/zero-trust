import platform
import string
import subprocess
from safewa import oswa
import clr  # 导入 pythonnet 模块
import utils


# 操作系统类型:
# Pro
def type():
    c = r'systeminfo | findstr /B /C:"OS 名称"'
    output = utils.cmd(c).split(':')[-1].strip().split(" ")[-1]
    return output


def version():
    output = utils.cmd('ver')
    version = ".".join(output.split(" ")[-1].split('.')[2:])[:-1]
    return version


def patch_count():
    output = utils.cmd('ver')
    patch_count = output.split(" ")[-1].split('.')[-1][:-1]
    return patch_count


def get_score():
    versions = []
    # 得分=版本名次得分*系统类型比例
    # 版本名次得分=(总长度-名次)/总长度*100

    with open('windows\windows版本.txt') as f:
        line = f.readline()
        while line:
            versions.append(line.strip())
            line = f.readline()
    if version() in versions:
        version_idx = versions.index(version())
    else:
        version_idx = len(versions) - 1
    version_score = (len(versions) - version_idx) / len(versions) * 100

    types = {
        '家庭普通版': 1,
        '家庭中文版': 1,
        'IoT': 1,
        '教育版': 1.15,
        '企业版': 1.3,
        '专业版': 1.2,
        '工作站版': 1.1
    }

    typ = type()
    for k in types.keys():
        if typ in k or k in typ:
            return types[typ] * version_score
    else:
        print("No type as {}".format(typ))
        return 0.9 * version_score


# 获取是否自动更新以及自动更新等级
def au_isopen():
    return au_level() != 1


# 检查自动更新的通知等级,越高代表越安全
# 1 - 自动更新已禁用。
# 2 - 只显示通知，但不自动下载或安装更新。
# 3 - 自动下载更新，但需要用户确认后才能安装。
# 4 - 启用自动下载和安装更新。
def au_level():
    return utils.powershellf("utils/windows/ps_code/autoupdate.ps1")


# 检查防火墙是否开启
# Windows对于域网络,专用网络,公用网络有三种防火墙,firewall_level返回的是有多少个防火墙开启了
def firewall_level():
    return utils.powershellf("utils/windows/ps_code/firewall.ps1")


# 基线检查
# 返回结果分别为:
# 是否已正确配置应用程序日志,是否已正确配置系统日志,是否已正确配置安全日志,屏幕保护程序等待时间<=300s/
# 是否开启Windows自动登录,基线检测总条目数,基线检测符合要求条目数,基线检测不符合要求条目数
def base_line():
    res = utils.powershellf("utils/windows/ps_code/baseline.ps1").split('\n')
    return res


def hosts_info():
    # 读取hosts文件,存入字典
    # 1.逐行读取hosts文件
    # 2.对于每行字符串,先检查其是否是注释行,跳过注释行
    # 3.若不是注释行,则这行字符串符合如下格式:
    # 1.1.1.1 a.com
    # 将a.com作为key,1.1.1.1作为value存入字典
    # 同时需要注意,出现同一个域名不同ip时,会以最先出现的为准,因此存入字典时要先检查有无key
    hosts_items = {}
    try:
        f = open(r'C:\Windows\System32\drivers\etc\hosts')
    except FileNotFoundError:
        return -1, -1, -1
    while True:
        line = f.readline()
        if not line:
            break
        line = line.strip()
        if line.startswith("#") or len(line) == 0:
            continue
        ip, host = line.split()
        if host not in hosts_items:
            hosts_items[host] = ip
    f.close()

    private_ip_count = 0
    # 检查所有ip中非内网条目的数量
    for k, v in hosts_items.items():
        if utils.is_private_ip(v):
            private_ip_count += 1

    return len(hosts_items),private_ip_count,len(hosts_items)-private_ip_count


def cpu_temper():
    dllpath = oswa.pwd() + r"OpenHardwareMonitor\OpenHardwareMonitorLib.dll"
    # OpenHardwareMonitorLib 路径
    clr.AddReference(dllpath)
    from OpenHardwareMonitor.Hardware import Computer

    c = Computer()

    c.CPUEnabled = True  # 获取 CPU 相关信息
    c.GPUEnabled = False  # 获取 GPU 相关信息
    c.Open()
    temperature = []
    for a in range(0, len(c.Hardware[0].Sensors)):
        if "/temperature" in str(c.Hardware[0].Sensors[a].Identifier):
            temperature.append(c.Hardware[0].Sensors[a].get_Value())
    return temperature
