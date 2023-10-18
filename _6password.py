from zxcvbn import zxcvbn
from configs import password_config,global_config
def password_info():
    logger=global_config.Logger
    logger.line()
    logger.info("密码信息收集中...")

    password=password_config.Password
    l=len(password)
    litter,digit,char=0,0,0
    for c in password:
        if c.isdigit():
            digit+=1
        elif c.isupper() or c.islower():
            litter+=1
        else:
            char+=1
    score=zxcvbn(password)['score']
    name_list,res_list= ["密码长度","密码中字母个数","密码中数字个数","密码中字符个数","密码复杂程度"], \
        [l,litter,digit,char,score]
    for k, v in zip(name_list, res_list):
        logger.infof("{}: {::gx}", k, v)
        logger.update()
    return name_list,res_list

