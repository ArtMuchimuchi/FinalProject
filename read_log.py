import matplotlib.pyplot as plt
import json

dictionary = json.load(open('log1.json', 'r'))
xAxis = [key for key, value in dictionary.items()]
yAxis = [value for key, value in dictionary.items()]

plt.plot(xAxis,yAxis)

plt.xlim(1,110)

plt.ylabel("score")
plt.xlabel("generation")


plt.show()