import paramiko
yuan_passwd = ["huaweixxx", "huawei"]
#如果密码中包含$字符，使用反斜线（\）进行转义 如:newpwd123\$
new_passwd = 'huaweiaaaxxx'
def sh_linux(ip):
    print('执行脚本：', ip)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    for pd in yuan_passwd:
        try:
            cmd = 'f' 'echo root:{new_passwd}|chpasswd'
            ssh.connect(hostname=ip, port=22, username="root", password=pd)
            print(cmd)
            _, std, srderr = ssh.exec_command(cmd)
            # print(std.read(), srderr.read(), ip)
            ssh.close()
            print("{0} 执行成功".format(ip))
            break
        except:
            continue
    else:
        print("{0} 执行失败".format(ip))


def iplist_read():
    iplist = []
    with open('./Linux_passwd_list.txt','r') as r:
        ret = r.readlines()
    for i in ret:
        iplist.append(i[0:-1])
    return iplist

if __name__ == "__main__":
    iplist = iplist_read()
    for ip in iplist:
        sh_linux(ip)

