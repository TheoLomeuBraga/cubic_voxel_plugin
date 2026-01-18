extends Node

func test() -> void:
	var p : CubicVoxelTerrainGenerator = get_parent()
	if p != null:
		p.cube_map_set(Vector3i.ZERO,0)
		p.cube_map_set(Vector3i(1,0,0),1)
		p.cube_map_set(Vector3i(2,0,0),2)
		p.cube_map_set(Vector3i(3,0,0),3)
		p.cube_map_set(Vector3i(4,0,0),4)
		
		for x : int in range(2,4):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),0)
		
		for x : int in range(4,6):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),1)
		
		for x : int in range(6,8):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),2)
					
		for x : int in range(8,10):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),3)
		
		for x : int in range(2,10):
			for y : int in range(2,4):
				p.cube_map_set(Vector3i(x,y,4),4)
		
		p.generate_mesh()

func _ready() -> void:
	call_deferred("test")
