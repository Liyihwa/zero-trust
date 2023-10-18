from safewa.logwa import progressbar
from safewa.utilwa.configer import Configer

# 目前为7个检查项目都定义config
global_config, system_config, hosts_config, \
    pc_status_configs, antivirus_config, registry_config, \
    password_config, driver_config = Configer(), Configer(), Configer(), Configer(), Configer(), Configer(), Configer(), Configer()

# 全局配置


# system配置
system_config.CheckedItemsCount = 14  # 系统类中被检查的条目数的个数

# hosts配置
hosts_config.CheckedItemsCount = 3

# pc_status配置
pc_status_configs.CheckedItemsCount = 15

# antivirus配置
antivirus_config.CheckedItemsCount = 6

# registry配置
registry_config.CheckedItemsCount = 9
registry_config.UsePreviousReport = True  # 是否使用原先报告,为True时程序不会调用Sysinspector,而是使用原有报告

# password配置
password_config.CheckedItemsCount = 5
password_config.Password = "testPassword!123"  # 密码字符串

# driver配置
driver_config.CheckedItemsCount = 9
driver_config.UsePreviousReport = True  # 使用原先的报告(这是registry生成的报告)

# 全局配置
global_config.set_default("CheckedItemsCount", 0)
for config in [system_config, hosts_config, pc_status_configs, antivirus_config, registry_config, password_config,
               driver_config]:
    global_config.CheckedItemsCount = global_config.CheckedItemsCount + config.CheckedItemsCount
global_config.Logger = progressbar.ProgressBar(global_config.CheckedItemsCount)