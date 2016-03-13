import csv
import tensorflow as tf
import numpy as np
import utils
import gc
import math


def find(satisfied,test,label):
    a={"TP":0,"TN":0,"FP":0,"FN":0}
    for i in range(0,len(test)):
        if label[i]==satisfied and test[i]==satisfied:
            a["TP"]+=1
        elif label[i]!=satisfied and test[i]!=satisfied:
            a["TN"]+=1
        elif label[i]!=satisfied and test[i]==satisfied:
            a["FP"]+=1
        elif label[i]==satisfied and test[i]!=satisfied:
            a["FN"]+=1
    return a

testSize=50000

label=[]

with open("data5secondwindows_40_24_AIM3_all.csv") as f:
    f_csv=csv.reader(f)

    headers=next(f_csv)

    counter=0
    for row in f_csv:
        counter+=1
        label.append(float(row[0]))
        if counter>=testSize:
            break
test=[]
file=open("output.txt")
while(True):
    c=file.readline()
    if not c:
        break
    test.append(float(c))

# print len(label)
#
# print len(test)
# test_counter=0
# for i in range(0,len(test)):
#     print str(test[i])+","+str(label[i])
#     if test[i]==label[i]:
#         test_counter+=1
# # print counter
# print float(test_counter)/float(testSize)

fileOut=open("accuracy","w+")

for i in range(0,5):
    a=find(float(i),test,label)
    TP=float(a["TP"])
    TN=float(a["TN"])
    FP=float(a["FP"])
    FN=float(a["FN"])

    NTotal=TP+TN+FP+FN

    Accuracy=(TP+TN)/NTotal

    Precision=TP/(TP+FP)
    Recall=TP/(TP+FN)
    FScore=2*Precision*Recall/(Precision+Recall)

    S=(TP+FN)/NTotal
    P=(TP+FP)/NTotal

    MCC=(TP/NTotal-S*P)/math.sqrt(P*S*(1-P)*(1-S))


    TPR=TP/(TP+FN)
    SPC=TN/(FP+TN)
    PPV=TP/(TP+FP)
    NPV=TN/(TN+FN)

    Informedness=TPR+SPC-1
    Markedness=PPV+NPV-1

    acc=[]
    acc.append(Accuracy)
    acc.append(Precision)
    acc.append(Recall)
    acc.append(FScore)
    acc.append(Informedness)
    acc.append(Markedness)
    acc.append(MCC)

    acc2={}
    acc2["Accuracy"]=Accuracy
    acc2["Precision"]=Precision
    acc2["Recall"]=Recall
    acc2["FScore"]=FScore
    acc2["Informedness"]=Informedness
    acc2["Markedness"]=Markedness
    acc2["MCC"]=MCC

    print acc2

    fileOut.write("phase"+str(i)+"\n")
    for key,value in acc2.iteritems():

        fileOut.write(key)
        fileOut.write(", ")
        fileOut.write(str(value))
        fileOut.write("\n")
    fileOut.write("\n\n")

fileOut.close()