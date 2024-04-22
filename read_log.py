import matplotlib.pyplot as plt
import numpy as np
import json

dictPlayable = json.load(open('PlayableScore.json', 'r'))
dictExit = json.load(open('ExitTileScore.json', 'r'))
dictOverall = json.load(open('OverAllScore.json', 'r'))
dictExitExplore = json.load(open('ExitExploreScore.json', 'r'))
xAxis = [key for key, value in dictOverall.items()]
yPlayable = [value for key, value in dictPlayable.items()]
yExit = [value for key, value in dictExit.items()]
yExitExplore = [value for key, value in dictExitExplore.items()]
yOverall = [value for key, value in dictOverall.items()]

plt.plot(xAxis,yPlayable, label="Playable Score")
plt.plot(xAxis,yExit, label="Exit Tile Score")
plt.plot(xAxis,yExitExplore, label="Exit Explore Tile Score")
plt.plot(xAxis,yOverall, label="Overall Score")

plt.xticks(np.arange(9,110,step=10))

plt.legend()

plt.ylabel("score")
plt.xlabel("generation")


plt.show()