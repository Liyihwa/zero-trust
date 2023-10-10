<#
# Author: tangjie
# Add_time: 2020/12/28
# V2.0_time：2021/03/26
# Windows安全配置策略基线检测脚本
#>
#$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
#@{} 创建一个哈希表
#@() 创建一个数组
$data = @{"project"=@()}
secedit /export /cfg config.cfg /quiet

#需求：
#扫描结束后，输出扫描结果。
#扫描总条目数、正确条目数、错误条目数、需要手工检查条目数。

#设置变量
#初始化总条目变量
$all = 0
#初始化正确条目变量
$t = 0
#初始化错误条目变量
$f = 0
#初始化需要手工检查变量
$m = 0



#3.1 检查是否已正确配置密码最长使用期限策略
$all = $all +1
$MaximumPasswordAge = Get-content -path config.cfg | findstr MaximumPasswordAge
if($MaximumPasswordAge -ne $null){
	$config = Get-Content -path config.cfg

	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "MaximumPasswordAge "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test = $config_line[1]
			if($config_line[1] -le "90")
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.1 检查是否已正确配置密码最长使用期限策略 <=90 $test TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				$projectdata = @{"fail"="3.1 检查是否已正确配置密码最长使用期限策略 FAIL";}
				$data['project']+=$projectdata
			}
		}
	}
}

else{
	$projectdata = @{"manual"="3.1 检查是否已正确配置密码最长使用期限策略 >=8  MANUAL";}
	$data['project']+=$projectdata
}
#3.2 检查是否已配置密码长度最小值
$all = $all +1
$MinimumPasswordLength = Get-content -path config.cfg | findstr MinimumPasswordLength
if($MinimumPasswordLength -ne $null){

	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "MinimumPasswordLength "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test32 = $config_line[1]
			if($config_line[1] -ge "8")
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.2 检查是否已配置密码长度最小值 >=8 $test32 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				$projectdata = @{"fail"="3.2 检查是否已配置密码长度最小值 >=8 $test32 FAIL";}
				$data['project']+=$projectdata
			}
		}
	}
}
else{
	$projectdata = @{"manual"="3.2 检查是否已配置密码长度最小值 >=8 $test32 MANUAL";}
	$data['project']+=$projectdata
}
#3.3 检查是否已正确配置“强制密码历史"
$all = $all +1
$PasswordHistorySize = Get-content -path config.cfg | findstr PasswordHistorySize
if($PasswordHistorySize -ne $null){



	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "PasswordHistorySize "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test33 = $config_line[1]
			if($config_line[1] -ge "2")
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.3 检查是否已正确配置`强制密码历史` >=2 $test33 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				$projectdata = @{"fail"="3.3 检查是否已正确配置`强制密码历史` >=2 $test33 FAIL";}
				$data['project']+=$projectdata
			}
		}
	}
}
else{
	$projectdata = @{"manual"="3.3 检查是否已正确配置`强制密码历史` >=2 $test33 MANUAL";}
	$data['project']+=$projectdata
}

#3.4 检查是否已正确配置帐户锁定时间

$all = $all +1
$ResetLockoutCount = Get-Content -path config.cfg | findstr ResetLockoutCount
if($ResetLockoutCount -ne $null){

	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "ResetLockoutCount "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test34 = $config_line[1]
			#2021/04/28 修改标准值为[5,8]
			if(($config_line[1] -ge "5") -and ($config_line[1] -le "8"))
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.4 检查是否已正确配置帐户锁定时间 >=1  $test34 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				$projectdata = @{"fail"="3.4 检查是否已正确配置帐户锁定时间 >=1 $test34 FAIL";}
				$data['project']+=$projectdata
			}
		}

	}

}
else{
	$projectdata = @{"manual"="3.4 检查是否已正确配置帐户锁定时间 >=1 $test34 MANUAL";}
	$data['project']+=$projectdata
}





#3.5 检查是否已正确配置帐户锁定阈值
$all = $all +1
$LockoutBadCount = Get-Content -path config.cfg | findstr LockoutBadCount
if($LockoutBadCount -ne $null){

	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "LockoutBadCount "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test35 = $config_line[1]
			#2021/04/28修改标准值为5
			if(($config_line[1] -eq "5"))
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.5 检查是否已正确配置帐户锁定阈值 5 $test35 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				#$data.code = "0"
				$projectdata = @{"fail"="3.5 检查是否已正确配置帐户锁定阈值 5 $test35 FAIL";}
				$data['project']+=$projectdata
			}
		}

	}

}
else{
	$projectdata = @{"manual"="3.5 检查是否已正确配置帐户锁定阈值 5 $test35 MANUAL";}
	$data['project']+=$projectdata
}



#3.6 检查是否已正确配置“复位帐户锁定计数器”时间
$all = $all +1
$LockoutDuration = Get-Content -path config.cfg | findstr LockoutDuration
if($LockoutDuration -ne $null){

	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "LockoutDuration "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			$test36 = $config_line[1]
			#2021/04/28修改标准值为5
			if(($config_line[1] -eq "5"))
			{
				#$data.code = "1"
				$projectdata = @{"true"="3.6 检查是否已正确配置复位帐户锁定计数器 5 $test36 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{
				#$data.code = "0"
				$projectdata = @{"fail"="3.6 检查是否已正确配置复位帐户锁定计数器 5 $test36 FAIL";}
				$data['project']+=$projectdata
			}
		}

	}

}
else{
	$projectdata = @{"manual"="3.6 检查是否已正确配置复位帐户锁定计数器 5 $test36 MANUAL";}
	$data['project']+=$projectdata
}


##3.7 检查是否按照权限、责任创建、使用用户帐户
#$all = $all +1
##检查已启用的本地用户的个数
#$config = get-wmiobject -class win32_userAccount | select-object * | findstr /i "OK"
##get-wmiobject -class win32_userAccount | select-object * | findstr /i "Status Name" | findstr /v "__ Full Path"
##$config = get-wmiobject -class win32_userAccount | select-object *
##$config1 = get-content -path config.cfg
#$length = $config.Length
#if(($length -ne "23") -and ($length -ge "2")){
#	$projectdata = @{"true"="3.7 (非域环境)检查是否按照权限、责任创建、使用用户帐户 TRUE";}
#	$data['project']+=$projectdata
#}else{
#	$projectdata = @{"fail"="3.7 (非域环境)检查是否按照权限、责任创建、使用用户帐户 FAIL";}
#	$data['project']+=$projectdata
#}

##3.8 检查是否已更改管理员帐户名称
#$all = $all +1
#$NewAdministratorName = Get-Content -path config.cfg | findstr NewAdministratorName
#if($NewAdministratorName -ne $null){

#	$config = Get-Content -path config.cfg
#	for ($i=0; $i -lt $config.Length; $i++)
#	{
#		$config_line = $config[$i] -split "="
#		if(($config_line[0] -eq "NewAdministratorName "))
#		{
#			$config_line[1] = $config_line[1].Trim(' ').Trim('""')
#			#$a = $config_line[1].Trim(' ').Trim('""')
#			if(($config_line[1] -ne "Administrator"))
#			{

#				#$data.code = "1"
#				$projectdata = @{"true"="3.8 检查是否已更改管理员帐户名称 TRUE";}
#				$data['project']+=$projectdata
#			}
#			else
#			{

#				#$data.code = "0"
#				$projectdata = @{"fail"="3.8 检查是否已更改管理员帐户名称 FAIL";}
#				$data['project']+=$projectdata
#			}
#		}

#	}

#}
#else{
#	$projectdata = @{"manual"="3.8 检查是否已更改管理员帐户名称 MANUAL";}
#	$data['project']+=$projectdata
#}

#4 认证授权

#4.1 检查是否已删除可远程访问的注册表路径和子路经
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg\AllowedPaths'
$name = 'Machine'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction stop).$name
$test41 = $config
if ($config -ne $null){
	$projectdata = @{"fail"="4.1 检查是否已删除可远程访问的注册表路径和子路经 null $test41 FAIL";}
	$data['project']+=$projectdata
}
else{
	$projectdata = @{"true"="4.1 检查是否已删除可远程访问的注册表路径和子路经 null $test41 TRUE";}
	$data['project']+=$projectdata
	
}




#4.2 检查是否已限制SAM匿名用户连接
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
$name = 'restrictanonymous'
$name2 = 'restrictanonymoussam'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
$config2 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name2

if (($config -eq "1") -and ($config2 -eq "1")){
	$projectdata = @{"true"="4.2 检查是否已限制SAM匿名用户连接 restrictanonymous:$config/restrictanonymoussam:$config2 TRUE";}

	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="4.2 检查是否已限制SAM匿名用户连接 restrictanonymous:$config/restrictanonymoussam:$config2 FAIL";}
	$data['project']+=$projectdata
}


#4.3 检查是否已限制可关闭系统的帐户和组
$all = $all +1
$shutdownPrivilege = Get-Content -path config.cfg | findstr SeShutdownPrivilege
if($shutdownPrivilege -ne $null){

	$config = Get-Content -path config.cfg
	for ($i=0; $i -lt $config.Length; $i++)
	{
		$config_line = $config[$i] -split "="
		if(($config_line[0] -eq "SeShutdownPrivilege "))
		{
			$config_line[1] = $config_line[1].Trim(' ')
			#$a = $config_line[1]
			$test43 = $config_line[1]
			if((($config_line[1] -eq "Administrator")) -or (($config_line[1] -eq "administrators")) -or (($config_line[1] -eq "S-1-5-32-544")) -or (($config_line[1] -eq "*S-1-5-32-544")) )
			{

				#$data.code = "1"
				$projectdata = @{"true"="4.3 检查是否已限制可关闭系统的帐户和组 Administrator/administrators/S-1-5-32-544 $test43 TRUE";}
				$data['project']+=$projectdata
			}
			else
			{

				#$data.code = "0"
				$projectdata = @{"fail"="4.3 检查是否已限制可关闭系统的帐户和组 Administrator/administrators/S-1-5-32-544 $test43 FAIL";}
				$data['project']+=$projectdata
			}
		}

	}

}
else{
	$projectdata = @{"manual"="3.8 检查是否已更改管理员帐户名称 Administrator/administrators/S-1-5-32-544 $test43 MANUAL";}
	$data['project']+=$projectdata
}


#4.4 检查是否已限制可从远端关闭系统的帐户和组
$all = $all +1

$config = Get-Content -path config.cfg

 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "SeRemoteShutdownPrivilege "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test44 = $config_line[1]
        if($config_line[1] -eq "*S-1-5-32-544")
        {
            $projectdata = @{"true"="4.4 检查是否已限制可从远端关闭系统的帐户和组 S-1-5-32-544 $test44 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
			$projectdata = @{"fail"="4.4 检查是否已限制可从远端关闭系统的帐户和组 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
#4.5 检查是否已限制“取得文件或其他对象的所有权”的帐户和组
$all = $all +1
  $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "SeProfileSingleProcessPrivilege "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test45 = $config_line[1]
        if($config_line[1] -eq "*S-1-5-32-544")
        {
			$projectdata = @{"true"="4.5 检查是否已限制取得文件或其他对象的所有权的帐户和组 S-1-5-32-544 $test45 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="4.5 检查是否已限制取得文件或其他对象的所有权的帐户和组 S-1-5-32-544 $test45 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }


#4.6 检查是否已正确配置“允许本地登陆”策略
$all = $all +1

$projectdata = @{"manual"="4.6 检查是否已正确配置允许本地登陆策略(请管理员自查) MANUAL";}
$data['project']+=$projectdata


#4.7 检查是否已正确配置“从网络访问此计算机”策略
$all = $all +1
$projectdata = @{"manual"="4.7 检查是否已正确配置从网络访问此计算机策略(请管理员自查) MANUAL";}
$data['project']+=$projectdata
<#  $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "SeNetworkLogonRight "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
        if($config_line[1] -eq "*S-1-5-32-544,*S-1-5-32-545,*S-1-5-32-551")
        {
            $projectdata = @{"true"="4.7 检查是否已正确配置从网络访问此计算机策略  TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="4.7 检查是否已正确配置从网络访问此计算机策略  FAIL";}
			$data['project']+=$projectdata
        }
    }
  } #>

#4.8 检查是否已删除可匿名访问的共享和命名管道
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\LanmanServer\Parameters'
#可匿名访问的命名管道
$name = 'NullSessionPipes'
#可匿名访问的共享
$name2 = 'NullSessionShares'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
$config2 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name2


if (($config.Length -eq 0) -and ($config2.Length -eq 0)){
	$projectdata = @{"true"="4.8 检查是否已删除可匿名访问的共享和命名管道 0，0	$test48,$test48_1 TRUE";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="4.8 检查是否已删除可匿名访问的共享和命名管道 0，0	$test48,$test48_1 FAIL";}
	$data['project']+=$projectdata
}
#5 日至审计
#5.1 检查是否已正确配置审核（日志记录策略）
$all = $all +1
#审核策略更改
 $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditSystemEvents "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test511 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.1 检查审核策略更改 3 $test511 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.1 检查审核策略更改 3 $test511 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
#审核登陆事件
 $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditLogonEvents "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test512 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.2 检查审核登陆事件  3 $test512 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.2 检查审核登陆事件  3 $test512 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
 #审核对象访问
  $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditObjectAccess "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test513 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.3 检查审核对象访问  3 $test513 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.3 检查审核对象访问  3 $test513 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }

 #审核进程跟踪
  $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditProcessTracking "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test514 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.4 检查审核进程跟踪  3 $test514 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.4 检查审核进程跟踪  3 $test514 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
  #审核目录服务访问
   $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditDSAccess "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test515 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.5 检查审核目录服务访问 3 $test515 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.5 检查审核目录服务访问 3 $test515 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
 #审核特权使用
  $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditPrivilegeUse "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test516 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.6 检查审核特权使用 3 $test516 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.6 检查审核特权使用 3 $test516 FAIL";}
			$data['project']+=$projectdata
        }
    }
  }
  #审核系统事件
   $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditSystemEvents "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test517 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.7 检查审核系统事件 3 $test517 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.7 检查审核系统事件 3 $test517 FAIL";}
			$data['project']+=$projectdata
        }
    }
}
#审核帐户登陆事件
 $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditAccountLogon "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test518 = $config_line[1]
		#“2”是windows2016，改为“3”尝试
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.8 检查审核帐户登陆事件 3 $test518 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.8 检查审核帐户登陆事件 3 $test518 FAIL";}
			$data['project']+=$projectdata
        }
    }
}
#审核帐户管理
 $config = Get-Content -path config.cfg
 for ($i=0; $i -lt $config.Length; $i++)
 {
    $config_line = $config[$i] -split "="
    if(($config_line[0] -eq "AuditAccountManage "))
    {
        $config_line[1] = $config_line[1].Trim(' ')
		$test519 = $config_line[1]
        if($config_line[1] -eq "3")
        {
            $projectdata = @{"true"="5.1.9 检查审核帐户管理 3  $test519 TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="5.1.9 检查审核帐户管理 3 $test519 FAIL";}
			$data['project']+=$projectdata
        }
    }
}
#5.2 检查是否已正确配置应用程序日志
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\eventlog\Application'
#按需要覆盖事件
$name = 'Retention'
#日志最大大小
$name1 = 'MaxSize'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
$config1 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name1
if (($config -eq 0) -and ($config1 -ge 8388608)){
	$projectdata = @{"true"="5.2 检查是否已正确配置应用程序日志 0,>=8388608 $config,$config1  TRUE";}
	echo "True"
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="5.2 检查是否已正确配置应用程序日志 0,>=8388608 $config,$config1 FAIL";}
	echo "False"
	$data['project']+=$projectdata
}
#5.3 检查是否已正确配置系统日志
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\eventlog\System'
#按需要覆盖事件
$name = 'Retention'
#日志最大大小
$name1 = 'MaxSize'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
$config1 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name1
if (($config -eq 0) -and ($config1 -ge 8388608)){
	$projectdata = @{"true"="5.3 检查是否已正确配置系统日志 0,>=8388608 $config,$config1 TRUE";}
	echo "True"
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="5.3 检查是否已正确配置系统日志 0,>=8388608 $config,$config1 FAIL";}
	echo "False"
	$data['project']+=$projectdata
}

#5.4 检查是否已正确配置安全日志
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\eventlog\Security'
#按需要覆盖事件
$name = 'Retention'
#日志最大大小
$name1 = 'MaxSize'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
$config1 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name1
if (($config -eq 0) -and ($config1 -ge 8388608)){
	$projectdata = @{"true"="5.4 检查是否已正确配置安全日志 0,>=8388608 $config,$config1 TRUE";}
	echo "True"
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="5.4 检查是否已正确配置安全日志 0,>=8388608 $config,$config1 FAIL";}
	echo "False"
	$data['project']+=$projectdata
}

#6 协议安全
#6.1 检查是否已修改默认的远程rdp服务端口
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'

$name = 'PortNumber'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
if ($config -ne 3389){
	$projectdata = @{"true"="6.1 检查是否已修改默认的远程rdp服务端口 !=3389 $config TRUE";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="6.1 检查是否已修改默认的远程rdp服务端口 !=3389 $config FAIL";}

	$data['project']+=$projectdata
}
#6.2 检查是否已启用并正确配置源路由攻击保护
$all = $all +1
$dsr = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr DisableIPSourceRouting
if ($dsr -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'DisableIPSourceRouting'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 2){
		$projectdata = @{"true"="6.2 检查是否已启用并正确配置源路由攻击保护 2 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.2 检查是否已启用并正确配置源路由攻击保护 2 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.2 检查是否已启用并正确配置源路由攻击保护(请按照基线文档执行用例) 2 $dsr FAIL";}

	$data['project']+=$projectdata
}
#6.3 检查是否已开启Windows防火墙
$all = $all +1
$projectdata = @{"manual"="6.3 检查是否已开启Windows防火墙(请管理员自查)  MANUAL";}
$data['project']+=$projectdata

#6.4 检查是否已启用并正确配置SYN攻击保护
$all = $all +1
#检查是否已启用SYN攻击保护
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr SynAttackProtect
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'SynAttackProtect'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 1){
		$projectdata = @{"true"="6.4.1 检查是否已启用SYN攻击保护 1 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.4.1 检查是否已启用SYN攻击保护 1 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.4.1 检查是否已启用SYN攻击保护(请按照基线文档执行用例) 1 $syn FAIL";}
	$data['project']+=$projectdata
}

#检查TCP连接请求阈值

$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr TcpMaxPortsExhausted
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'TcpMaxPortsExhausted'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 5){
		$projectdata = @{"true"="6.4.2 检查TCP连接请求阈值 5 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.4.2 检查TCP连接请求阈值 5 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.4.2 检查TCP连接请求阈值(请按照基线文档执行用例) 5 $syn FAIL";}
	$data['project']+=$projectdata
}
#检查取消尝试响应 SYN 请求之前要重新传输 SYN-ACK 的次数
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr TcpMaxConnectResponseRetransmissions
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'TcpMaxConnectResponseRetransmissions'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 2){
	
		$projectdata = @{"true"="6.4.3 检查取消尝试响应SYN请求之前要重新传输SYN-ACK的次数 2 $config TRUE";}

		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.4.3 检查取消尝试响应SYN请求之前要重新传输SYN-ACK的次数 2 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.4.3 检查取消尝试响应SYN请求之前要重新传输SYN-ACK的次数(请按照基线文档执行用例) 2 $syn FAIL";}
	$data['project']+=$projectdata
}

#检查处于SYN_RCVD 状态下的 TCP 连接阈值
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr TcpMaxHalfOpen
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'TcpMaxHalfOpen'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 500){
		$projectdata = @{"true"="6.4.4 检查处于SYN_RCVD状态下的TCP连接阈值 500 $config TRUE";}

		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.4.4 检查处于SYN_RCVD状态下的TCP连接阈值 500 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.4.4 检查处于SYN_RCVD状态下的TCP连接阈值(请按照基线文档执行用例) 500 $syn FAIL";}
	$data['project']+=$projectdata
}


# 检查处于SYN_RCVD 状态下，且至少已经进行了一次重新传输的TCP连接阈值
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr TcpMaxHalfOpenRetried
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'TcpMaxHalfOpenRetried'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 400){
		$projectdata = @{"true"="6.4.5 检查处于SYN_RCVD状态下,且至少已经进行了一次重新传输的TCP连接阈值 400 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.4.5 检查处于SYN_RCVD状态下,且至少已经进行了一次重新传输的TCP连接阈值  FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.4.5 检查处于SYN_RCVD状态下，且至少已经进行了一次重新传输的TCP连接阈值(请按照基线文档执行用例) 400 $syn FAIL";}
	$data['project']+=$projectdata
}

#6.5 检查是否已启用并正确配置ICMP攻击保护
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr EnableICMPRedirect
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'EnableICMPRedirect'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 0){
		$projectdata = @{"true"="6.5 检查是否已启用并正确配置ICMP攻击保护 0 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.5 检查是否已启用并正确配置ICMP攻击保护 0 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.5 检查是否已启用并正确配置ICMP攻击保护(请按照基线文档执行用例) 0 $syn FAIL";}
	$data['project']+=$projectdata
}
#6.6 检查是否已禁用失效网关检测
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr EnableDeadGWDetect
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'EnableDeadGWDetect'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 0){
		$projectdata = @{"true"="6.6 检查是否已禁用失效网关检测 0 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.6 检查是否已禁用失效网关检测 0 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.6 检查是否已禁用失效网关检测(请按照基线文档执行用例) 0 $syn FAIL";}
	$data['project']+=$projectdata
}
#6.7 检查是否已正确配置重传单独数据片段的次数
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr TcpMaxDataRetransmissions
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'TcpMaxDataRetransmissions'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 2){
		$projectdata = @{"true"="6.7 检查是否已正确配置重传单独数据片段的次数  2 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.7 检查是否已正确配置重传单独数据片段的次数  2 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.7 检查是否已正确配置重传单独数据片段的次数(请按照基线文档执行用例) 2 $syn FAIL";}
	$data['project']+=$projectdata
}
#6.8 检查是否已禁用路由发现功能
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr PerformRouterDiscovery
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'PerformRouterDiscovery'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 0){
		$projectdata = @{"true"="6.8 检查是否已禁用路由发现功能 0 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.8 检查是否已禁用路由发现功能 0 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.8 检查是否已禁用路由发现功能(请按照基线文档执行用例) 0 $syn FAIL";}
	$data['project']+=$projectdata
}
#6.9 检查是否已正确配置TCP“连接存活时间”
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | findstr KeepAliveTime
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'

	$name = 'KeepAliveTime'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -le 300000){
		$projectdata = @{"true"="6.9 检查是否已正确配置TCP连接存活时间 300000 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.9 检查是否已正确配置TCP连接存活时间 300000 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.9 检查是否已正确配置TCP连接存活时间(请按照基线文档执行用例) 300000 $syn FAIL";}
	$data['project']+=$projectdata
}

#6.10 检查是否已启用并正确配置TCP碎片攻击保护
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" | findstr EnablePMTUDiscovery
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters'

	$name = 'EnablePMTUDiscovery'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 0){
		$projectdata = @{"true"="6.10 检查是否已启用并正确配置TCP碎片攻击保护  0 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="6.10 检查是否已启用并正确配置TCP碎片攻击保护 0 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="6.10 检查是否已启用并正确配置TCP碎片攻击保护(请按照基线文档执行用例) 0 $syn FAIL";}
	$data['project']+=$projectdata
}
##6.11 检查是否已启用TCP/IP筛选功能
#$all = $all +1
#$projectdata = @{"manual"="6.11 检查是否已启用TCP/IP筛选功能(请管理员自查,此项配置支持windows2000\windowsXP\windwos2003\windows2003r2)  MANUAL";}
#$data['project']+=$projectdata



#6.11 检查是否已删除SNMP服务的默认public团体
$all = $all +1
$snmp = get-service | findstr /c:'SNMP Service'
if($snmp -eq $null){

	$projectdata = @{"true"="6.11 检查是否已删除SNMP服务的默认public团体 null $snmp TRUE";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"manual"="6.11 检查是否已删除SNMP服务的默认public团体(请管理员自查) null $snmp MANUAL";}
	$data['project']+=$projectdata
}




#7 其他配置操作
#7.1 检查是否已安装防病毒软件
$all = $all +1
$projectdata = @{"manual"="7.1 检查是否已安装防病毒软件(请管理员自查)  MANUAL";}
$data['project']+=$projectdata
#7.2 检查是否已启用并正确配置Windows自动更新
$all = $all +1
$projectdata = @{"manual"="7.２ 检查是否已启用并正确配置Windows自动更新(请管理员自查)  MANUAL";}
$data['project']+=$projectdata


#7.3 检查是否已启用“不显示最后的用户名”策略
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$name = 'dontdisplaylastusername'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
if ($config -eq 1){
	$projectdata = @{"true"="7.3 检查是否已启用不显示最后的用户名 1 $config TRUE";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="7.3 检查是否已启用不显示最后的用户名 1 $config FAIL";}
	$data['project']+=$projectdata
}
#7.4 检查是否已正确配置“提示用户在密码过期之前进行更改”策略
$all = $all +1
$reg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$name = 'PasswordExpiryWarning'
$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
if ($config -ge 14){
	$projectdata = @{"true"="7.4 检查是否已正确配置`提示用户在密码过期之前进行更改`策略 14 $config TRUE";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"fail"="7.4 检查是否已正确配置`提示用户在密码过期之前进行更改`策略 14 $config FAIL";}
	$data['project']+=$projectdata
}
#7.5 检查是否已正确配置“锁定会话时显示用户信息”策略
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | findstr DontDisplayLockedUserId
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'

	$name = 'DontDisplayLockedUserId'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	if ($config -eq 3){
		$projectdata = @{"true"="7.5 检查是否已启用并正确配置锁定会话时显示用户信息 3 $config TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="7.5 检查是否已启用并正确配置锁定会话时显示用户信息 3 $config FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="7.5 检查是否已启用并正确配置锁定会话时显示用户信息(请按照基线文档执行用例) 3 $syn FAIL";}
	$data['project']+=$projectdata
}
#7.6 检查是否已禁用Windows硬盘默认共享
$all = $all +1
$syn = get-itemproperty -path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" | findstr DontDisplayLockedUserId
if ($syn -ne $null){
	$reg = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters'

	$name = 'AutoShareServer'
	$name1 = 'AutoShareWks'
	$config = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name
	$config1 = (Get-ItemProperty -Path "Registry::$reg" -ErrorAction Stop).$name1
	if (($config -eq 0) -and ($config1 -eq 0)){
		$projectdata = @{"true"="7.6 检查是否已禁用Windows硬盘默认共享  0,0 $congif,$config1 TRUE";}
		$data['project']+=$projectdata
	}else{
		$projectdata = @{"fail"="7.6 检查是否已禁用Windows硬盘默认共享 0,0 $congif,$config1 FAIL";}
		$data['project']+=$projectdata
	}

}
else{
	$projectdata = @{"fail"="7.6 检查是否已禁用Windows硬盘默认共享(请按照基线文档执行用例) 0,0 $syn FAIL";}
	$data['project']+=$projectdata
}
#7.7 检查是否已启用并正确配置屏幕保护程序
$all = $all +1
#屏幕自动保护程序
$Key = 'HKEY_CURRENT_USER\Control Panel\Desktop'
$name = "ScreenSaveActive"
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$name
if($config -eq "1"){
    $projectdata = @{"true"="7.7.1 检查是否已启用并正确配置屏幕保护程序 1 $config TRUE";}
	$data['project']+=$projectdata
}
else{
    $projectdata = @{"fail"="7.7.1 检查是否已启用并正确配置屏幕保护程序 1 $config FAIL";}
	$data['project']+=$projectdata
}
#检查屏幕保护程序等待时间

$Key = 'HKEY_CURRENT_USER\Control Panel\Desktop'
$name = "ScreenSaveTimeOut"
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$name
if($config -le 300) {
            $projectdata = @{"true"="7.7.2 检查屏幕保护程序等待时间  <=300 $config TRUE";}
			echo "True"
			$data['project']+=$projectdata
}else{
            $projectdata = @{"fail"="7.7.2 检查屏幕保护程序等待时间 <=300 $config FAIL";}
			echo "False"
			$data['project']+=$projectdata
        }
#检查是否已启用在恢复时显示登陆界面
$Key = 'HKEY_CURRENT_USER\Control Panel\Desktop'
$name = "ScreenSaverIsSecure"
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$name
if($config -eq "1")
        {
            $projectdata = @{"true"="7.7.3 检查是否已启用在恢复时显示登陆界面  TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.7.3 检查是否已启用在恢复时显示登陆界面  FAIL";}
			$data['project']+=$projectdata
        }


#7.8 检查是否已启用并正确配置Windows网络时间同步服务(NTP)
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer'
$Name = 'Enabled'
 $config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq "0")
        {
            $projectdata = @{"true"="7.8 检查是否已启用并正确配置Windows网络时间同步服务 0 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.8 检查是否已启用并正确配置Windows网络时间同步服务 0 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.9 检查是否已关闭Windows自动播放
$all = $all +1
$projectdata = @{"manual"="7.9 检查是否已关闭Windows自动播放(请管理员自查)  MANUAL";}
$data['project']+=$projectdata
#7.10 检查是否已关闭不必要的服务-DHCP Client
$all = $all +1
$dhcp = get-service | findstr /c:'DHCP Client' | findstr Running
if($dhcp -eq $null){
	$projectdata = @{"true"="7.10 检查是否已关闭不必要的服务-DHCPClient null $dhcp TRUE";}
	$data['project']+=$projectdata
}
else{
	$projectdata = @{"true"="7.10 检查是否已关闭不必要的服务-DHCPClient null $dhcp FAIL";}
	$data['project']+=$projectdata
}
#7.11 检查系统是否已安装最新补丁包和补丁
$all = $all +1
$projectdata = @{"manual"="7.11 检查系统是否已安装最新补丁包和补丁(请管理员自查)  MANUAL";}
$data['project']+=$projectdata
##7.12 检查所有磁盘分区的文件系统格式
#$all = $all +1

#$projectdata = @{"manual"="7.12 检查所有磁盘分区的文件系统格式(请管理员自查)  MANUAL";}
#$data['project']+=$projectdata

#7.12 检查是否已正确配置服务器在暂停会话前所需的空闲时间量
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\LanmanServer\Parameters'
$Name = 'autodisconnect'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 15)
        {
            $projectdata = @{"true"="7.12 检查是否已正确配置服务器在暂停会话前所需的空闲时间量 15 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.13 检查是否已正确配置服务器在暂停会话前所需的空闲时间量 15 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.14 检查是否已启用“当登录时间用完时自动注销用户”策略
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\LanmanServer\Parameters'
$Name = 'enableforcedlogoff'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 1)
        {
            $projectdata = @{"true"="7.13 检查是否已启用当登录时间用完时自动注销用户量 1 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.14 检查是否已启用当登录时间用完时自动注销用户量 1 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.15 域环境：检查是否已启用“需要域控制器身份验证以解锁工作站”策略
#$all = $all +1
#$Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
#$Name = 'ForceUnlockLogon'
#$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
#   if($config -eq 1)
#        {
 #           $projectdata = @{"true"="7.14 检查是否已启需要域控制器身份验证以解锁工作站 1 $config TRUE";}
	#		$data['project']+=$projectdata
     #   }
      #  else
       # {
        #    $projectdata = @{"fail"="7.14 检查是否已启用需要域控制器身份验证以解锁工作站 1 $config FAIL";}
		#	$data['project']+=$projectdata
        #}
#7.16 检查是否已禁用“登录时无须按 Ctrl+Alt+Del”策略
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Name = 'disablecad'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 0)
        {
            $projectdata = @{"true"="7.14 检查是否已禁用登录时无须按Ctrl+Alt+Del 0 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.14 检查是否已禁用登录时无须按Ctrl+Alt+Del 0 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.17 域环境：检查是否已正确配置“可被缓存保存的登录的个数”策略
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$Name = 'CachedLogonsCount'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -le 5)
        {
            $projectdata = @{"true"="7.15 域环境：检查是否已正确配置`可被缓存保存的登录的个数`策略 <=5 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.15 域环境：检查是否已正确配置`可被缓存保存的登录的个数`策略 <=5 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.18 域环境：检查是否已正确配置域环境下安全通道数据的安全设置
$all = $all +1
#7.18.1 检查是否已启用“域环境下对安全通道数据进行数字加密或数字签名”策略
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\Netlogon\Parameters'
$Name = 'RequireSignOrSeal'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 1)
        {
            $projectdata = @{"true"="7.16.1 检查是否已启`域环境下对安全通道数据进行数字加密或数字签名`策略 1 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.16.1 检查是否已启`域环境下对安全通道数据进行数字加密或数字签名`策略  1 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.18.2 检查是否已启用`域环境下对安全通道数据进行数字签名`策略
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\Netlogon\Parameters'
$Name = 'SignSecureChannel'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 1)
        {
            $projectdata = @{"true"="7.16.2 检查是否已启用`域环境下对安全通道数据进行数字签名`策略 1 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.16.2 检查是否已启用`域环境下对安全通道数据进行数字签名`策略 1 $config FAIL";}
			$data['project']+=$projectdata
        }

#7.18.3 检查是否已启用`域环境下对安全通道数据进行数字加密`策略
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\Netlogon\Parameters'
$Name = 'SealSecureChannel'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 1)
        {
            $projectdata = @{"true"="7.17.3 检查是否已启用`域环境下对安全通道数据进行数字加密`策略 1 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.17.3 检查是否已启用`域环境下对安全通道数据进行数字加密`策略 1 $config  FAIL";}
			$data['project']+=$projectdata
        }

#7.19 域环境：检查是否已启用`域环境下需要强会话密钥`策略
$all = $all +1
$Key = 'HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\Netlogon\Parameters'
$Name = 'RequireStrongKey'
$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
   if($config -eq 1)
        {
            $projectdata = @{"true"="7.17 域环境：检查是否已启用`域环境下需要强会话密钥`策略 1 $config TRUE";}
			$data['project']+=$projectdata
        }
        else
        {
            $projectdata = @{"fail"="7.17 域环境：检查是否已启用`域环境下需要强会话密钥`策略 1 $config FAIL";}
			$data['project']+=$projectdata
        }
#7.20 检查共享文件夹的权限设置是否安全
$all = $all +1
$projectdata = @{"manual"="7.18 检查共享文件夹的权限设置是否安全(请管理员自查)  MANUAL";}
$data['project']+=$projectdata



#7.21 检查是否已启用Windows数据执行保护(DEP)
$all = $all +1
$dep = wmic OS get DataExecutionPrevention_SupportPolicy | findstr "[0-9]"

if ($dep.trim(" ") -eq 2){
	$config = $dep.trim("")
	$projectdata = @{"true"="7.19 检查是否已启用Windows数据执行保护(DEP) 3 $config TRUE";}
	
	$data['project']+=$projectdata
}
else{
	$projectdata = @{"fail"="7.19 检查是否已启用Windows数据执行保护(DEP) 3 $config FAIL";}
	$data['project']+=$projectdata
}

##7.22 检查是否已创建多个磁盘分区
#$all = $all +1
#$projectdata = @{"manual"="7.21 检查是否已创建多个磁盘分区(请管理员自查)  MANUAL";}
#$data['project']+=$projectdata


#7.23 检查是否已禁止Windows自动登录
$all = $all +1
$flag = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | findstr AutoAdminLogon
if ($flag -ne $null){
	$Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
	$Name = 'AutoAdminLogon'
	$config = (Get-ItemProperty -Path "Registry::$Key" -ErrorAction Stop).$Name
		if($config -eq 0)
			{
				$projectdata = @{"true"="7.2 0 检查是否已禁止Windows自动登录 0 $config TRUE";}
				echo "True"
				$data['project']+=$projectdata
			}
			else
			{
				$projectdata = @{"fail"="7.2 0 检查是否已禁止Windows自动登录 0 $cofnig FAIL";}
				echo "False"
				$data['project']+=$projectdata
			}

}else{
	$projectdata = @{"manual"="7.2 0 检查是否已禁止Windows自动登录(请管理员自查) 0 $flag MANUAL";}
	echo "False"
	$data['project']+=$projectdata
}


#7.24 检查是否已关闭不必要的服务-Simple TCP/IP Services
$all = $all +1
$sti = get-service | find /c:'Simple TCP/IP' | findstr Running
if($sti -ne $null){
	$projectdata = @{"fail"="7.21 检查是否已关闭不必要的服务-SimpleTCP/IPServices null $sti FAIL";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"true"="7.21 检查是否已关闭不必要的服务-SimpleTCP/IPServices null $sti TRUE";}
	$data['project']+=$projectdata
}


#7.25 检查是否已关闭不必要的服务-Simple Mail Transport Protocol (SMTP)
$all = $all +1
$sti = get-service | find /c:'Simple Mail Transport Protocol (SMTP)' | findstr Running
if($sti -ne $null){
	$projectdata = @{"fail"="7.22 检查是否已关闭不必要的服务-SimpleMailTransportProtocol(SMTP) null $sti FAIL";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"true"="7.22 检查是否已关闭不必要的服务-SimpleMailTransportProtocol(SMTP) null $sti TRUE";}
	$data['project']+=$projectdata
}


#7.26 检查是否已关闭不必要的服务-Windows Internet Name Service (WINS)
$all = $all +1
$sti = get-service | find /c:'Windows Internet Name Service (WINS)' | findstr Running
if($sti -ne $null){
	$projectdata = @{"fail"="7.23 检查是否已关闭不必要的服务-WindowsInternetNameService(WINS) null $sti FAIL";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"true"="7.23 检查是否已关闭不必要的服务-WindowsInternetNameService(WINS) null $sti TRUE";}
	$data['project']+=$projectdata
}


#7.27 检查是否已关闭不必要的服务-DHCP Server
$all = $all +1
$sti = get-service | find /c:'DHCP Server' | findstr Running
if($sti -ne $null){
	$projectdata = @{"fail"="7.24 检查是否已关闭不必要的服务-DHCPServer null $sti FAIL";}
	$data['project']+=$projectdata
}else{
	$projectdata = @{"true"="7.24 检查是否已关闭不必要的服务-DHCPServer null $sti TRUE";}
	$data['project']+=$projectdata
}


##7.28 检查是否已关闭不必要的服务-Remote Access Connection Manager
#$all = $all +1
#$sti = get-service | find /c:'Remote Access Connection Manager' | findstr Running
#if($sti -ne $null){
#	$projectdata = @{"fail"="7.28 检查是否已关闭不必要的服务-RemoteAccessConnectionManager  FAIL";}
#	$data['project']+=$projectdata
#}else{
#	$projectdata = @{"true"="7.28 检查是否已关闭不必要的服务-RemoteAccessConnectionManager  TRUE";}
#	$data['project']+=$projectdata
#}


#7.29 检查是否已关闭不必要的服务-Message Queuing
$all = $all +1

$sti = get-service | find /c:'Message Queuing' | findstr Running
if($sti -ne $null){
	$projectdata = @{"fail"="7.25 检查是否已关闭不必要的服务-MessageQueuing null $sti FAIL";}
	
	$data['project']+=$projectdata
}else{
	$projectdata = @{"true"="7.25 检查是否已关闭不必要的服务-MessageQueuing null $sti TRUE";}
	$data['project']+=$projectdata
}

foreach ($i in $data.project){

	if ($($i.true) -ne $null){
		$t = $t + 1
	}
	if  ($($i.fail) -ne $null){
		$f = $f + 1

	}
	if ($($i.manual) -ne $null){
		$m = $m + 1
	}

}
$allin = $t + $f + $m

echo $allin
echo $t
echo $f

Remove-Item -Path "config.cfg"














