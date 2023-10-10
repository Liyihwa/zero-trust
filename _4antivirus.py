import logwa
import utils
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
    qihoo360=[] #todo
    res=[]
    if len(utils.query_process(huorong))!=0:
       return entity.antivirus.Type.HuoRong

    return None

def antivirus_info():
    id=__running_antivirus()
    name_list=["杀毒软件名称","杀毒软件开机自动启动是否开启","杀入软件自动扫描是否开启",
               "杀毒软件版本","杀毒软件病毒库版本","杀毒软件检测出恶意软件的次数"]
    logwa.line()
    logwa.info("杀毒软件信息收集中...")
    if id ==entity.antivirus.Type.HuoRong:
        huorong=entity.antivirus.HuoRong()
        res_list=["火绒",False,huorong.is_autorun(),huorong.get_version(),huorong.get_viruslib_version(),
             huorong.get_malicious_detected_count()]
        for name,res in zip(name_list,res_list):
            logwa.infof("{}: {::gx}",name,res)
        return name_list,res_list





