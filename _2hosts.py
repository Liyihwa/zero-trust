import logwa
from utils import windows


def hosts_info():
    logwa.line()
    logwa.info("Hosts文件信息收集中...")
    name_list = ["Hosts文件总条目数", "Hosts文件内网项目数", "Hosts文件非内网项目数"]
    res_list = windows.hosts_info()
    for k, v in zip(name_list, res_list):
        logwa.infof("{}: {::gx}", k, v)

    return name_list, res_list
