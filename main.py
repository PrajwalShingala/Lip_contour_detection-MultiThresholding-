import cv2
from PIL import Image
import numpy as np 
from matplotlib import pyplot as plt 
import colorsys


img = cv2.imread('mouth.jpg',1)
img1 = cv2.imread('mouth.jpg',1)
img = img.astype(np.float64)/255
x1, y1, z1 = img.shape
chart = np.zeros((x1,y1), dtype = float)
min = 8
max = -8
for i in range(x1):
    for j in range(y1):
        x2 = img[i][j]
        yt, it, qt = colorsys.rgb_to_yiq(x2[0], x2[1], x2[2])
        chart[i][j] = qt
        
        if(qt<min):
            min = qt
        if(qt>max):
            max = qt           
# cv2.imshow("ch",chart)
# cv2.waitKey(0)
# chart = chart*255
# std = np.std(chart, axis = 0)
# std = np.round(std, decimals=)
# bb = std.shape[0]
# for i in range(0,bb):
#     print(std[i])
cr = min
rr = []
for i in range(20):
    cp = 0.017
    rr.append(cp)
    cp = cp+0.001
# while(cr>=min and cr<=max):
chart11 = chart
th = 0
max11 = 0
for ee in rr:
    for j in range(x1):
        for k in range(y1):
            if(chart[j][k] < ee):
                chart[j][k] = 0
            else:
                chart[j][k] = 1
    chart = chart*255
    chart = chart.astype(np.uint8)
    chart = cv2.morphologyEx(chart, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5)))
    chart = cv2.morphologyEx(chart, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15,15)))

    ret,thresh = cv2.threshold(chart,1,255,0)
    immm,contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
    print(contours)
    listx = []
    boxes = np.zeros(chart.shape,np.uint8)
    for c in contours:
        area = cv2.contourArea(c)
        if (area>30000 and area<60000):
            listx.append(c)
    for c in listx:
        cv2.drawContours(img1, [c], -1, (0,255,120), 1)
    # listx1 = np.zeros(listx.length)
    len1 = (listx[0].shape)
    # print(listx.copy())
    x1a = []
    x2a = []
    sum1 = 0
    for hh in range(0,len1[0]):
        x1a.append(listx[0][hh][0]+[0,4])
        x2a.append(listx[0][hh][0]+[0,-4])
        if(x1a[hh][0]<x1 and x2a[hh][0]<x1 and x1a[hh][1]<y1 and x2a[hh][1]<y1):
            d = chart11[x1a[hh][0]][x1a[hh][1]]- chart11[x2a[hh][0]][x2a[hh][1]]
            sum1 = sum1 + d*d
    sum1 = sum1/len1[0]
    if(sum1 > max11):
        max11 = sum1
        th = ee
print(max11)


for j in range(x1):
        for k in range(y1):
            if(chart11[j][k] < th):
                chart11[j][k] = 0
            else:
                chart11[i][k] = 1
chart = chart11*255
chart = chart.astype(np.uint8)
chart = cv2.morphologyEx(chart, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5)))
chart = cv2.morphologyEx(chart, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15,15)))

ret,thresh = cv2.threshold(chart,1,255,0)
immm,contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
    # print(contours)
listx = []
boxes = np.zeros(chart.shape,np.uint8)
for c in contours:
    area = cv2.contourArea(c)
    if (area>60000):
        listx.append(c)
for c in listx:
    cv2.drawContours(img1, [c], -1, (0,255,120), 1)

    
cv2.imwrite("hh.jpg",img1)
cv2.imshow("Image",img1)
cv2.waitKey(0)
cv2.destroyAllWindows()
