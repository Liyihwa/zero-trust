import utils
import entity
# 获取当前所有运行的安全软件的名称
def __get_id():
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
    id=__get_id()
    if id ==entity.antivirus.Type.HuoRong:
        huorong=entity.antivirus.HuoRong()
        return "火绒",False,huorong.is_autorun(),huorong.get_version(),huorong.get_viruslib_version(),huorong.get_malicious_detected_count()



print(antivirus_info())


