import sys

from safewa import oswa
from safewa import logwa
from _1system import system_info
from _2hosts import hosts_info
from _3pc_status import pc_status_info
from _4antivirus import antivirus_info

from openpyxl import Workbook


if __name__=='__main__':
    if not oswa.is_admin():
        logwa.errof("{::rx}","Please open as an administrator")
        sys.exit()

    name_list=[]
    res_list=[]
    func_list=[system_info,hosts_info,pc_status_info,antivirus_info]

    wb = Workbook()
    ws = wb.active

    for f in func_list:
        name,res=f()
        name_list.extend(name)
        res_list.extend(res)


    ws.append(name_list)
    ws.append(res_list)
    wb.save('信息汇总.xlsx')




