import matplotlib.pyplot as plt
import numpy as np
import json

dictionary = json.load(open('Constrain1.json', 'r'))
xAxis = [key for key, value in dictionary.items()]
yAxis = [value for key, value in dictionary.items()]

plt.plot(xAxis,yAxis)

plt.xlim(1,110)

plt.xticks(np.arange(9,110,step=10))

plt.ylabel("score")
plt.xlabel("generation")


plt.show()