extends Node

static func createMap(arrayMap: Array[Array], gridMap: GridMap, meshLib: MeshLibrary):
	gridMap.mesh_library = meshLib
	gridMap.cell_size = Vector3(1,1,1)
	
	for i in  range(arrayMap.size()):
		for j in range(arrayMap[0].size()):
			print(str(arrayMap[i][j]))
			if arrayMap[i][j] == 3:
				gridMap.set_cell_item(Vector3(i, 0, j), -1)
			else:
				gridMap.set_cell_item(Vector3(i, 0, j), 0)
	
	
