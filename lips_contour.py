
# coding: utf-8

# In[2]:

import cv2
from PIL import Image
import numpy as np 
from matplotlib import pyplot as plt 
from skimage import measure
import colorsys



# In[3]:

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

# chart = chart*255
cr = min
# while(cr>=min and cr<=max):
for j in range(x1):
    for k in range(y1):
        if(chart[j][k] < 0.027):
            chart[j][k] = 0
        else:
            chart[i][j] = 1
chart = chart*255


# In[4]:

chart = chart.astype(np.uint8)
chart = cv2.morphologyEx(chart, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5)))
chart = cv2.morphologyEx(chart, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15,15)))


# In[5]:

ret,thresh = cv2.threshold(chart,1,255,0)
immm,contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
print(contours)
listx = []
boxes = np.zeros(chart.shape,np.uint8)
for c in contours:
    area = cv2.contourArea(c)
#     hull = cv2.convexHull(c)
    if (area>40000):
        listx.append(c)
for c in listx:
    cv2.drawContours(img1, [c], -1, (0,255,120), 1)

cv2.imwrite("hh.jpg",img1)
cv2.imshow("Image",img1)


# In[ ]:


