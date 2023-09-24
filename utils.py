import subprocess

def cmd(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        output = result.stdout.strip()
        return output
    else:
        error = result.stderr.strip()
        return error

def powershell(command):
    result = subprocess.run(['powershell', '-c', command], capture_output=True, text=True)
    if result.returncode == 0:
        output = result.stdout
    else:
        output = result.stderr
    return output

def readall(filepath):
    with open(filepath,encoding="utf8") as f:
        res=f.read()
    return res

print(powershell(readall("ps_code/autoupdate.ps1")))