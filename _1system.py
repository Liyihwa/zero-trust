import platform
import windows


def system_info():
    os_type = platform.system()
    if os_type == "Windows":
        return windows.type(), \
            windows.version(), \
            windows.patch_count(), \
            windows.au_isopen(), \
            windows.au_level(), \
            windows.firewall_isopen(), \
            *windows.base_line()


print(system_info())
