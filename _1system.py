import platform

import logwa
import utils.windows as windows


def system_info():
    os_type = platform.system()
    logwa.line()
    logwa.info("System info collecting.....")
    if os_type == "Windows":
        total = 7  # Windows下总共有7项需要检查
        p = logwa.progressbar.ProgressBar(total)

        typ = windows.type()  # 获取系统类型: 专业版/教育版等
        p.update()
        p.infof("OS类型:{::ux}", typ)

        ver = windows.version()  # 获取系统小版本: 22621.2283
        p.update()
        p.infof("OS版本:{::ux}", ver)

        patch_count = windows.patch_count()  # 获取系统版本数
        p.update()
        p.infof("OS补丁数:{::ux}", patch_count)

        au = windows.au_isopen()  # 获取系统自动更新是否开启以及开启等级
        au_level = windows.au_level()
        p.update()
        p.update()
        if au == True:
            p.infof("自动更新{::gx},自动更新等级:{::ux}", "已开启", au_level)
        else:
            p.infof("自动更新{::rx}", "未开启")

        firewall = windows.firewall_level()  # 获取防火墙开启等级
        p.update()
        p.infof("防火墙等级:{::ux}", firewall)

        base_line = windows.base_line()  # 获取基线检查结果
        p.update()
        p.infof("Baseline检查:\n应用程序日志开启:{::ux}\n系统日志开启:{::ux}\n安全日志开启:{::ux}\n锁屏时间:{::ux}\nWindows自动登录:{"
                "::ux}\n基线检查总条目数:{::ux},符号要求的条目数:{::gx},不符号要求的条目数:{::rx}", *base_line)
        return typ, ver, patch_count, au, au_level, firewall, base_line


system_info()
