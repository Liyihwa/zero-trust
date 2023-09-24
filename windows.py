import platform
import subprocess
import utils


def windows_type():
    c = r'systeminfo | findstr /B /C:"OS 名称"'
    output = utils.cmd(c).split(':')[-1].strip().split(' ')[-1]
    return output


def windows_version():
    output = utils.cmd('ver')

    version = ".".join(output.split(" ")[-1].split('.')[2:])[:-1]
    return version


def windows_patch_count():
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
    if windows_version() in versions:
        version_idx = versions.index(windows_version())
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

    typ = windows_type()
    for k in types.keys():
        if typ in k or k in typ:
        return types[typ] * version_score
    else:
        print("No type as {}".format(typ))
        return 0.9 * version_score
