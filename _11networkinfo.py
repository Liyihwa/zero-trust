import socket
import psutil
import winreg

def check_port(host, port):
    try:
        # 创建套接字对象
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(1)  # 设置连接超时时间

        # 尝试连接到端口
        result = s.connect_ex((host, port))

        if result == 0:
            print(f"端口 {port} 已开启")
        else:
            print(f"端口 {port} 未开启")
        s.close()
    except Exception as e:
        print(f"无法检查端口 {port}: {e}")


# 主机名或IP地址
host = "localhost"  # 将 "example.com" 替换为您要检查的主机名或IP地址

# 要检查的端口列表
ports = [3389, 22, 5900, 5901, 23, 3306, 3309]

for port in ports:
    check_port(host, port)

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

print(f"网络接入方式: {get_network_type()}")

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

firewall_enabled = is_windows_firewall_enabled()

if firewall_enabled:
    print("Windows防火墙已启用")
else:
    print("Windows防火墙已禁用")