import platform
import subprocess
import utils


def type():
    c = r'systeminfo | findstr /B /C:"OS 名称"'
    output = utils.cmd(c).split(':')[-1].strip().split(' ')[-1]
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
    with open('windows版本.txt') as f:
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


'''
1 - 自动更新已禁用。
2 - 只显示通知，但不自动下载或安装更新。
3 - 自动下载更新，但需要用户确认后才能安装。
4 - 启用自动下载和安装更新。
'''


def au_level():
    return int(utils.powershell(utils.readall("windows/ps_code/autoupdate.ps1")))

def firewall_isopen():
    return bool(utils.powershell(utils.readall("windows/ps_code/firewall.ps1")))
