import xml.dom.minidom as md

import utils
from configs import driver_config,global_config


def driver_info():
    logger=global_config.Logger
    logger.line()
    logger.info("驱动信息收集中...")
    # 只有当UsePreviousReport为True且有报告时才使用原先的报告
    fpath = utils.get_sysinspector_report_path()
    if not(driver_config.UsePreviousReport and fpath is not None):
        logger.info("等待Sysinspector导出报告")
        utils.sysinspector_caller()
        fpath = utils.get_sysinspector_report_path()

    root = md.parse(fpath).documentElement
    utils.remove_empty_lines(root)
    driver = root.childNodes[4]
    scores = [0] * 9  # 风险等级从1~9

    def callback(node):
        if node.getAttribute("NAME") == "SECTION":
            return node.childNodes
        else:
            scores[int(node.getAttribute("EVAL")) - 1] += 1

    utils.dfs_domNode(driver, callback)
    name_list, res_list = ["驱动项风险等级为{}的项目个数".format(x) for x in range(1, 10)], scores
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()
    return name_list, res_list
