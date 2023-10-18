import utils
from configs import global_config,antivirus_config
import entity
# 获取当前所有运行的安全软件的名称
def __running_antivirus():
    '''
    HipsDaemon.exe  火绒安全服务模块
    PopBlock.exe    火绒弹窗拦截程序
    HipsTray.exe    火绒软件托盘程序
    wsctrlsvc.exe   火绒安全中心模块
    '''
    huorong=["HipsDaemon.exe","PopBlock.exe","HipsTray.exe","wsctrlsvc.exe"]
    qihoo360=["ZhuDongFangYu.exe","360Safe.exe","360.exe"]
    if len(utils.query_process(huorong))!=0:
       return entity.antivirus.Type.HuoRong
    if len(utils.query_process(qihoo360))!=0:
        return entity.antivirus.Type.QiHoo360

    return None

def antivirus_info():

    logger=global_config.Logger
    id=__running_antivirus()
    name_list=["杀毒软件名称","杀毒软件开机自动启动是否开启","杀入软件自动扫描是否开启",
               "杀毒软件版本","杀毒软件病毒库版本","杀毒软件检测不安全行为的次数"]
    logger.line()
    logger.info("杀毒软件信息收集中...")
    if id ==entity.antivirus.Type.HuoRong:
        huorong=entity.antivirus.HuoRong()
        res_list=["火绒", huorong.is_autorun(), huorong.is_autoscan(), huorong.get_version(), huorong.get_viruslib_version(),
                  huorong.get_unsafe_count()]
        for k, v in zip(name_list, res_list):
            logger.infof("{}: {::gx}", k, v)
            logger.update()
        return name_list,res_list
    if id==entity.antivirus.Type.QiHoo360:
        qihoo360=entity.antivirus.QiHoo360()
        res_list=["360安全卫士", qihoo360.is_autorun(), qihoo360.is_autoscan(), qihoo360.get_version(), qihoo360.get_viruslib_version(),
                  qihoo360.get_unsafe_count()]
        for k, v in zip(name_list, res_list):
            logger.infof("{}: {::gx}", k, v)
            logger.update()
        return name_list,res_list
    return name_list,[None]*len(name_list)





