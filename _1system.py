import platform

from safewa import logwa
import utils.windows as windows


def system_info():
    os_type = platform.system()
    logwa.line()
    logwa.info("系统信息收集中.....")
    if os_type == "Windows":
        name_list = ["操作系统类型", "操作系统版本", "系统补丁数量", "是否开启自动更新",
                     "自动更新等级", "防火墙开启等级", "程序日志是否配置正确", "系统日志是否配置正确",
                     "安全日志是否配置正确", "屏保程序等待时间是否小于300秒", "是否开启Windows自动登录",
                     "基线检测总条目数", "基线检测符合要求条目数", "基线检测不符合要求条目数"]
        func_list = [windows.type, windows.version, windows.patch_count, windows.au_isopen, windows.au_level,
                     windows.firewall_level, windows.base_line]
        total = len(name_list)

        res_list = []

        # ProgressBar用于显示进度条
        p = logwa.progressbar.ProgressBar(total)

        index = 0
        while index < total:
            res = func_list[index]()
            if type(res) != list:
                p.infof("{}: {::gx}",name_list[index], res)
                p.update()  # 控制进度条更新
                res_list.append(res)
                index+=1
            else:   # 调用base_line方法时,返回的是一个列表,要用此方式进行处理
                for r in res:
                    p.infof("{}: {::gx}",name_list[index],r)
                    p.update()
                    res_list.append(r)
                    index+=1

        # 以双列表的形式返回,方便导入excel
        return name_list,res_list


