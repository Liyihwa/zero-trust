import time
import pynvml

import psutil
import threading

from safewa import logwa, utilwa
from utils import windows
import os

# 配置 ===========================
config = utilwa.Configer()
config.cpu_full_use_threshold = 85  # cpu满载阈值,大于该值时认为是满载
config.pre_sampling_time = 10  # 每次采样10s
config.sampling_count = 1  # 共采样次数

# 全局变量========================
cpu_percentage_avg = 0
cpu_full_use_rate = 0
cpu_temper = 0

memory_percent_avg = 0

disk_write_avg = 0
disk_read_avg = 0
disk_available_size = 0
disk_available_rate = 0

net_write_average = 0
net_read_average = 0

gpu_total_memory = 0
gpu_used_memory = 0
gpu_power = 0
gpu_temper = 0

u_disk_count = 0


def cpu():
    cpu_full_use_count = 0
    temp_cpu_percents = []
    for i in range(config.sampling_count):
        temp_cpu_percent = psutil.cpu_percent(interval=config.pre_sampling_time) * 10
        if temp_cpu_percent > 100:
            temp_cpu_percent = 100
        if temp_cpu_percent > config.cpu_full_use_threshold:
            cpu_full_use_count += 1
        temp_cpu_percents.append(temp_cpu_percent)

    global cpu_percentage_avg, cpu_full_use_rate, cpu_temper
    cpu_percentage_avg = sum(temp_cpu_percents) / len(temp_cpu_percents)
    temperatures = windows.cpu_temper()
    cpu_temper = sum(temperatures) / len(temperatures)
    cpu_full_use_rate = cpu_full_use_count / config.sampling_count



def memory():
    temp_memory_percents = []
    for i in range(config.sampling_count):
        temp_memory_percents.append(psutil.virtual_memory().percent)
        time.sleep(config.pre_sampling_time)

    global memory_percent_avg
    memory_percent_avg = sum(temp_memory_percents) / len(temp_memory_percents)


def disk():
    # 在启动时采样一次,结束时采样一次即可算出利用率均值
    interval = config.sampling_count * config.pre_sampling_time
    start = psutil.disk_io_counters()
    time.sleep(interval)
    end = psutil.disk_io_counters()
    read_bytes = end.read_bytes - start.read_bytes
    write_bytes = end.write_bytes - start.write_bytes

    global disk_write_avg, disk_read_avg, disk_available_rate, disk_available_size
    disk_read_avg = read_bytes / interval
    disk_write_avg = write_bytes / interval

    total = 0
    used = 0

    for p in psutil.disk_partitions(all=True):
        dsk = psutil.disk_usage(p.mountpoint)
        total += dsk.total
        used += dsk.used
    disk_available_size = total - used
    disk_available_rate = used / total




def gpu():
    # 初始化nvml库
    pynvml.nvmlInit()

    # 获取可用的GPU数量
    num_gpu = pynvml.nvmlDeviceGetCount()
    gpus_total_mm = []
    gpus_used_mm = []
    gpus_temperature = []
    gpus_power = []

    for i in range(num_gpu):
        handle = pynvml.nvmlDeviceGetHandleByIndex(i)

        # 内存信息
        memory_info = pynvml.nvmlDeviceGetMemoryInfo(handle)
        gpus_total_mm.append(memory_info.total)
        gpus_used_mm.append(memory_info.used)

        # 温度和功耗
        temperature = pynvml.nvmlDeviceGetTemperature(handle, pynvml.NVML_TEMPERATURE_GPU)
        gpus_temperature.append(temperature)
        power = pynvml.nvmlDeviceGetPowerUsage(handle) / 1000.0  # 单位：瓦特
        gpus_power.append(power)

    global gpu_power, gpu_temper, gpu_total_memory, gpu_used_memory
    gpu_power = sum(gpus_power) / len(gpus_power)
    gpu_temper = sum(gpus_temperature) / len(gpus_temperature)
    gpu_used_memory = sum(gpus_used_mm) / len(gpus_used_mm)
    gpu_total_memory = sum(gpus_total_mm) / len(gpus_total_mm)
    pynvml.nvmlShutdown()



def net_interface():
    # 在启动时采样一次,结束时采样一次即可算出利用率均值
    interval = config.sampling_count * config.pre_sampling_time
    start = psutil.net_io_counters()
    time.sleep(interval)
    end = psutil.net_io_counters()

    bytes_recv = end.bytes_recv - start.bytes_recv
    bytes_sent = end.bytes_sent - start.bytes_sent

    global net_write_average, net_read_average
    net_read_average = bytes_recv / interval
    net_write_average = bytes_sent / interval




def u_disk():
    drives = psutil.disk_partitions()
    count = 0

    for drive in drives:
        drive_type = drive.opts

        if 'removable' in drive_type:
            mount_point = drive.mountpoint
            if os.path.exists(mount_point):
                count += 1

    global u_disk_count
    u_disk_count = count


# =====================================

def pc_status_info():
    logwa.line()
    logwa.infof("PC状态信息收集中...")
    threads = [
        threading.Thread(target=disk),
        threading.Thread(target=cpu),
        threading.Thread(target=gpu),
        threading.Thread(target=memory),
        threading.Thread(target=net_interface)
    ]

    for t in threads:
        t.start()
    for t in threads:
        t.join()

    res_list=[cpu_percentage_avg, cpu_full_use_rate, cpu_temper, memory_percent_avg,
              disk_write_avg, disk_read_avg, disk_available_size, disk_available_rate,
              net_write_average, net_read_average, gpu_total_memory, gpu_used_memory,
              gpu_power, gpu_temper, u_disk_count]
    name_list=["10min内CPU使用率均值", "CPU满载时间比例", "CPU当前温度", "10min内内存使用率均值",
               "10min内磁盘写入均值", "10min内磁盘读取均值", "磁盘当前可用容量", "磁盘当前占用率",
               "10min网速上传均值", "10min网速下载均值", "GPU总容量(内存)", "GPU已占用容量",
               "GPU当前功率", "GPU当前温度", "当前插入U盘数量"]
    for name,res in zip(name_list,res_list):
        logwa.infof("{}: {::gx}",name,res)
    return name_list,res_list

