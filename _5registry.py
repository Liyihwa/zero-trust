import xml.dom.minidom as md

import utils
from configs import global_config,registry_config
# 唤起sysinspector程序,生成报告
# 该函数会返回报告地址

def registry_info():
    logger=global_config.Logger

    logger.line()
    logger.info("注册表信息收集中...")

    # 只有当UsePreviousReport为True且有报告时才使用原先的报告
    fpath=utils.get_sysinspector_report_path()
    if not(registry_config.UsePreviousReport and fpath is not None):
        logger.info("等待Sysinspector导出报告")
        utils.sysinspector_caller()
        fpath=utils.get_sysinspector_report_path()
    root = md.parse(fpath).documentElement
    utils.remove_empty_lines(root)
    reg = root.childNodes[2]
    scores = [0] * 9  # 风险等级从1~9

    def callback(node):
        # 根据attribute判断是否搜索到了对应节点
        if node.getAttribute("NAME") == "Key":
            scores[int(node.getAttribute("EVAL")) - 1] += 1
        else:
            return node.childNodes

    utils.dfs_domNode(reg, callback)
    name_list,res_list=["注册表项风险等级为{}的项目个数".format(x) for x in range(1, 10)], scores
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()
    return name_list,res_list

