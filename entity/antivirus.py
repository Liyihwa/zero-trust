import abc
from abc import abstractmethod
from enum import Enum
import json

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
    def get_exepath(self):
        pass

    @abstractmethod
    def get_version(self):
        pass

    @abstractmethod
    def get_viruslib_version(self):
        pass

    @abstractmethod
    def get_malicious_detected_count(self):
        pass

    @abstractmethod
    def is_autorun(self):
        pass


class HuoRong(Antivirus):
    def __init__(self):
        super().__init__()
        self.type = Type.HuoRong
        process_names = ["HipsDaemon.exe"]
        self.version = None
        self.viruslib_version = None
        self.malicious_detected_count = 0

        # 目前写死
        db_path = "C:\ProgramData\Huorong\Sysdiag\log.db"
        sql = "SELECT * FROM HrLogV3"
        rows = utils.query_db(db_path, sql)
        for r in rows:
            if r[2] == "filemon":  # r[2]为fname列,代表本条日志意义
                self.malicious_detected_count += 1
            elif r[2] == "update":
                # 转为json
                obj = json.loads(r[4])
                self.viruslib_version = obj["detail"]["db_time"]

        # 查询火绒版本
        path = psutil.Process(utils.query_process(names=process_names)[0].pid).exe()
        # xxxx\Sysdiag\bin\HipsDaemon.exe 取出Sysdiag及以前的部分,目前直接写死
        path = path[:-19] + r"\VERSION"
        with open(path) as f:
            self.version = f.read()

    def get_version(self):
        return self.version

    def get_viruslib_version(self):
        return self.viruslib_version

    def get_malicious_detected_count(self):
        return self.malicious_detected_count

    def get_exepath(self):
        # todo
        pass

    def is_autorun(self):
        val = utils.get_registry_value(r"\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Sysdiag", "")
        return val != ""


