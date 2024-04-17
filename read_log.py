import matplotlib.pyplot as plt
import numpy as np
import json

dictionary = json.load(open('PlayableScore.json', 'r'))
dictionary1 = json.load(open('ExitTileScore.json', 'r'))
dictionary2 = json.load(open('OverAllScore.json', 'r'))
xAxis = [key for key, value in dictionary.items()]
yAxis1 = [value for key, value in dictionary1.items()]
yAxis2 = [value for key, value in dictionary2.items()]
yAxis = [value for key, value in dictionary.items()]

plt.plot(xAxis,yAxis, label="Playable Score")
plt.plot(xAxis,yAxis1, label="Exit Tile Score")
plt.plot(xAxis,yAxis2, label="Overall Score")

plt.xticks(np.arange(9,110,step=10))

plt.legend()

plt.ylabel("score")
plt.xlabel("generation")


plt.show()