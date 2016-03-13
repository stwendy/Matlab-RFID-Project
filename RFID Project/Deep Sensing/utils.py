__author__ = 'zhangyanyi'
def transferNumToBinaryArray(num,size,a):

    for i in range(0,size):
        if i==num:
            a.append(1)
        else:
            a.append(0)
