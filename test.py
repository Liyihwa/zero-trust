import winreg

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
