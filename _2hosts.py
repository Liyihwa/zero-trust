from utils import windows
from configs import global_config

def hosts_info():
    logger=global_config.Logger
    logger.line()
    logger.info("Hosts文件信息收集中...")
    name_list = ["Hosts文件总条目数", "Hosts文件内网项目数", "Hosts文件非内网项目数"]
    res_list = windows.hosts_info()
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()

    return name_list, res_list
