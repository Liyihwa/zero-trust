import abc
import os.path
from abc import abstractmethod
from enum import Enum
import json
from safewa import oswa
import psutil
import utils


class Type(Enum):
    Default = 0
    HuoRong = 1
    QiHoo360 = 2  # python中不能直接用数字命名变量,并且名称_360会被python视为protect变量,这里只能用奇虎360命名了


class Antivirus():
    __name = {
        Type.HuoRong: "HuoRong",
        Type.QiHoo360: "360"
    }

    def __init__(self):
        self.type = Type(0)

    def name(self):
        return Antivirus.__name[self.type]

    @abstractmethod
    def get_version(self):
        pass

    @abstractmethod
    def get_viruslib_version(self):
        pass

    @abstractmethod
    def get_unsafe_count(self):
        pass

    @abstractmethod
    def is_autorun(self):
        pass

    @abstractmethod
    def is_autoscan(self):
        pass

    @abstractmethod
    def time_not_scan(self):    #有多久没进行扫描了
        pass


class HuoRong(Antivirus):
    def __init__(self):
        super().__init__()
        self.type = Type.HuoRong
        process_names = ["HipsDaemon.exe"]
        self.version = None
        self.viruslib_version = None
        self.unsafe_count = 0
        self.last_scan_time=0

        # 火绒日志位置,目前写死
        db_path = "C:\ProgramData\Huorong\Sysdiag\log.db"
        sql = "SELECT * FROM HrLogV3"
        rows = utils.query_db(db_path, sql)
        for r in rows:
            # r[2]为fname列,代表本条日志意义
            if r[2]=="update":
                # 转为json
                obj = json.loads(r[4])
                self.viruslib_version = obj["detail"]["db_time"]    # 获取病毒库
            elif r[2]=="scan":
                self.last_scan_time=r[3]    # r[3]为日志时间
            elif r[2] in ["rlogin","filemon"]:
                self.unsafe_count += 1


        # 查询火绒版本
        path = psutil.Process(utils.query_process(names=process_names)[0].pid).exe()
        # 路径一般为: xxxx\Sysdiag\bin\HipsDaemon.exe 我们需要的是 xxxx\VERSION
        path = path[:-19] + r"\VERSION"
        with open(path) as f:
            self.version = f.read()

    def get_version(self):
        return self.version

    def get_viruslib_version(self):
        return self.viruslib_version

    def get_unsafe_count(self):
        return self.unsafe_count

    def is_autoscan(self):
        return False  # 火绒目前版本(5.0.74.1)不支持自动扫描

    def is_autorun(self):
        # 只要存在该键值对就说明是自启动的

        val = utils.get_registry_value(r"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Sysdiag")
        return val != ""


class QiHoo360(Antivirus):
    def __init__(self):
        super().__init__()
        self.type = Type.QiHoo360
        self.version = None
        self.viruslib_version = None    # todo
        self.unsafe_count = 0   # todo
        self.last_scan_time=0

        # 查询360版本
        self.version= utils.get_registry_value(r"\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\360Safe\LiveUp\UpdateCfg\360ver.dll\ver")
        dir_=utils.windows.user_maindir()+r"\AppData\Roaming\360Safe\360ScanLog";
        print(dir)
        for f in oswa.ls(dir_):
            self.last_scan_time=max(self.last_scan_time,int(os.path.getctime(f)))

    def get_version(self):
        return self.version

    def get_viruslib_version(self):
        return self.viruslib_version

    def get_unsafe_count(self):
        return self.unsafe_count

    def is_autoscan(self):
        return False  # 火绒目前版本(5.0.74.1)不支持自动扫描

    def is_autorun(self):
        # 只要存在该键值对就说明是自启动的
        val = utils.get_registry_value(r"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Sysdiag")
        return val != ""
