import socket
import psutil
import winreg
import wmi

from configs import global_config,network_config
from safewa.logwa import logger

def check_port(host, port):
    try:
        # 创建套接字对象
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)  # 设置连接超时时间

        # 尝试连接到端口
        result = s.connect_ex((host, port))

        if result == 0:
            # print(f"端口 {port} 已开启")
            return True
        else:
            # print(f"端口 {port} 未开启")
            return False
        s.close()
    except Exception as e:
        print(f"无法检查端口 {port}: {e}")




def get_network_type():
    try:
        for interface, addrs in psutil.net_if_addrs().items():
            for addr in addrs:
                if addr.family == psutil.AF_LINK:  # 以太网接口
                    return "有线网络"
                elif addr.family == psutil.AF_INET and interface.lower().startswith("wlan"):  # 无线接口
                    return "WiFi"
        return "未连接网络"
    except Exception as e:
        return f"无法获取网络接入方式: {e}"



def is_windows_firewall_enabled():
    try:
        with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile") as key:
            enable_firewall, _ = winreg.QueryValueEx(key, "EnableFirewall")
            if enable_firewall == 1:
                return True  # Windows防火墙已启用
            else:
                return False  # Windows防火墙已禁用
    except Exception as e:
        return f"无法确定Windows防火墙状态: {e}"

def network_info():
    logger = global_config.Logger
    logger.line()
    logger.info("网络信息收集中...")
    # 主机名或IP地址
    host = "localhost"  # 将 "example.com" 替换为您要检查的主机名或IP地址
    name_list = []
    res_list = []
    # 要检查的端口列表
    ports = network_config.PortsChecked


    for port in ports:
        # check_port(host, port)
        name_list.append(str(port)+"是否开启")
        res_list.append(check_port(host, port))
    name_list.append("网络接入方式")
    res_list.append(get_network_type())
    # print(f"网络接入方式: {get_network_type()}")
    firewall_enabled = is_windows_firewall_enabled()
    name_list.append("Windows防火墙是否启用")
    res_list.append(firewall_enabled)
    # if firewall_enabled:
    #     print("Windows防火墙已启用")
    # else:
    #     print("Windows防火墙已禁用")
    name_list.append("Wifi是否开启")
    if is_wifi_enabled():
        res_list.append(True)
    else:
        res_list.append(False)
    name_list.append("蓝牙是否开启")
    if is_bluetooth_enabled():
        res_list.append(True)
    else:
        res_list.append(False)
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()
    return name_list, res_list

def is_wifi_enabled():
    wifi_interfaces = [interface for interface, addrs in psutil.net_if_addrs().items() if 'Wi-Fi' in interface]
    return len(wifi_interfaces) > 0

def is_bluetooth_enabled():
    try:
        c = wmi.WMI()
        for controller in c.Win32_PnPEntity():
            if "Bluetooth" in str(controller.Caption):
                if controller.Status == "OK":
                    return True  # 蓝牙已启用
        return False  # 蓝牙未启用
    except Exception as e:
        return f"无法确定蓝牙状态: {e}"



if __name__ == "__main__":
    network_info()