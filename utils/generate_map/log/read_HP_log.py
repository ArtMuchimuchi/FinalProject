import matplotlib.pyplot as plt
import numpy as np
import json
import os

# List to store all player HP data
allPlayerHP = []

# Directory where the JSON files are located
directory = 'C:\\Users\\chisa\\Downloads\\Project\\utils\\generate_map\\log\\'

# Loop to read multiple JSON files
for i in range(1, 11):  # Adjust the range as needed
    file_path = os.path.join(directory, f'PlayerHP{i}.json')
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            dictPlayerHP = json.load(file)
            allPlayerHP.append(dictPlayerHP)

# Combine all data into single x and y lists for plotting
xAxis = []
yHP = []

for dictPlayerHP in allPlayerHP:
    xAxis.extend([key for key, value in dictPlayerHP.items()])
    yHP.extend([value for key, value in dictPlayerHP.items()])
    
plt.plot(xAxis,yHP, label="Player HP Percentage")

plt.legend()

plt.yticks(np.arange(0,110,step=10))

plt.ylabel("HP Percentage")
plt.xlabel("time")


plt.show()