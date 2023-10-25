import sys

from _10userinfo import user_info
from _11networkinfo import network_info
from _12programinfo import program_info
from _8autostartitem import autoitem_info
from _9process import process_info
from safewa import oswa
from safewa import logwa
from _1system import system_info
from _2hosts import hosts_info
from _3pc_status import pc_status_info
from _4antivirus import antivirus_info
from _5registry import registry_info
from _6password import password_info
from _7driver import driver_info
from openpyxl import Workbook
from configs import global_config
if __name__ == '__main__':
    if not oswa.is_admin():
        logwa.errof("{::rx}", "Please open as an administrator")
        sys.exit()

    name_list = []
    res_list = []
    func_list = [system_info, hosts_info, pc_status_info, antivirus_info, registry_info, password_info, driver_info, autoitem_info, process_info, user_info, network_info, program_info]
    wb = Workbook()
    ws = wb.active

    for func in func_list:
        name, res = func()
        name_list.extend(name)
        res_list.extend(res)
    ws.append(name_list)
    ws.append(res_list)
    wb.save(global_config.OutputFileName)
