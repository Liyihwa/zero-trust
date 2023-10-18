import psutil

# 遍历系统中的所有进程
num=0
for process in psutil.process_iter(attrs=['pid', 'name', 'cmdline', 'create_time', 'cpu_times', 'memory_info', 'num_threads', 'nice', 'status', 'ppid']):
    try:
        num+=1
        # 获取进程信息
        process_info = process.info
        # print(process_info)
        # 进程名称
        process_name = process_info['name']

        process_path = process.exe()

        # 进程启动时间
        create_time = process_info['create_time']

        # 进程PID
        process_pid = process_info['pid']

        # 进程大小
        process_memory = process_info['memory_info'].rss

        # 进程线程数
        num_threads = process_info['num_threads']

        # 进程权限级别
        process_nice = process_info['nice']

        # 子进程数量
        ppid = process_info['ppid']

        # 在这里可以添加数字签名验证的代码，这将依赖于具体的数字签名验证库

        # 打印进程信息
        print(f"进程名称: {process_name}")
        print(f"进程路径: {process_path}")
        print(f"进程启动时间: {create_time}")
        print(f"进程PID: {process_pid}")
        print(f"进程大小: {process_memory}")
        # 打印数字签名验证结果
        # 打印进程线程数
        print(f"进程线程数: {num_threads}")
        print(f"进程权限级别: {process_nice}")
        print(f"父进程ID: {ppid}")
        print("="*50)


    except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
        pass
print(f"进程总数：{num}")
# 获取所有网络连接信息
network_connections = psutil.net_connections(kind='tcp')

# 筛选已建立连接（状态为ESTABLISHED）的连接
established_connections = [conn for conn in network_connections if conn.status == psutil.CONN_ESTABLISHED]

# 获取已建立连接的数量
num_established_connections = len(established_connections)

print(f"当前已建立的 TCP 连接数量: {num_established_connections}")
