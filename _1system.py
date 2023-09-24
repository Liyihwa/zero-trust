import platform
import windows

def system_info():
    os_type=platform.system()
    if os_type=="Windows":
        return windows.windows_type(),windows.windows_version(),windows.windows_patch_count()

print(windows.get_score())

