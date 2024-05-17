import matplotlib.pyplot as plt
import numpy as np
import json
import os

# List to store all player HP data
allPlayerHPeasy = []
allPlayerHPnormal = []
allPlayerHPhard = []
# Directory where the JSON files are located
directory = 'C:\\Users\\chisa\\Downloads\\Project\\utils\\generate_map\\log\\'

# Loop to read multiple JSON files
for i in range(1, 4):  # Adjust the range as needed
    file_path = os.path.join(directory, f'PlayerHPeasy{i}.json')
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            dictPlayerHP = json.load(file)
            allPlayerHPeasy.append(dictPlayerHP)

for i in range(1, 4):  # Adjust the range as needed
    file_path = os.path.join(directory, f'PlayerHPnormal{i}.json')
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            dictPlayerHP = json.load(file)
            allPlayerHPnormal.append(dictPlayerHP)

for i in range(1, 4):  # Adjust the range as needed
    file_path = os.path.join(directory, f'PlayerHPhard{i}.json')
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            dictPlayerHP = json.load(file)
            allPlayerHPhard.append(dictPlayerHP)

# Combine all data into single x and y lists for plotting
xAxisEasy = []
yHPEasy = []
xAxisNormal = []
yHPNormal = []
xAxisHard = []
yHPHard = []

for dictPlayerHP in allPlayerHPeasy:
    xAxisEasy.extend([key for key, value in dictPlayerHP.items()])
    yHPEasy.extend([value for key, value in dictPlayerHP.items()])

for dictPlayerHP in allPlayerHPnormal:
    xAxisNormal.extend([key for key, value in dictPlayerHP.items()])
    yHPNormal.extend([value for key, value in dictPlayerHP.items()])

for dictPlayerHP in allPlayerHPhard:
    xAxisHard.extend([key for key, value in dictPlayerHP.items()])
    yHPHard.extend([value for key, value in dictPlayerHP.items()])
    
plt.plot(xAxisEasy,yHPEasy, label="Player HP Percentage on Easy Mode")
plt.plot(xAxisNormal,yHPNormal, label="Player HP Percentage on Normal Mode")
plt.plot(xAxisHard,yHPHard, label="Player HP Percentage on Hard Mode")

plt.legend()

plt.yticks(np.arange(0,110,step=10))
plt.xticks(np.arange(0,110,step=10))

plt.ylabel("HP Percentage")
plt.xlabel("time")


plt.show()