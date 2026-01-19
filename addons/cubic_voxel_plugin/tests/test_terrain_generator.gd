extends Node

func test() -> void:
	var p : CubicVoxelTerrainGenerator = get_parent()
	if p != null:
		
		for i : int in p.blocks_infos.size():
			p.cube_map_set(Vector3i(i,0,0),BlockEstate.new(i))
		
		for x : int in range(2,4):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),BlockEstate.new(0))
		
		for x : int in range(4,6):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),BlockEstate.new(1))
		
		for x : int in range(6,8):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),BlockEstate.new(2))
					
		for x : int in range(8,10):
			for y : int in range(2,4):
				for z : int in range(2,4):
					p.cube_map_set(Vector3i(x,y,z),BlockEstate.new(3))
		
		for x : int in range(2,10):
			for y : int in range(2,4):
				p.cube_map_set(Vector3i(x,y,4),BlockEstate.new(4))
		
		for x : int in range(2,10):
			for y : int in range(2,4):
				p.cube_map_set(Vector3i(x,y,5),BlockEstate.new(5))
		
		var directions : Array[BlockEstate.Directions] = [
			BlockEstate.Directions.UP,
			BlockEstate.Directions.DOWN,
			BlockEstate.Directions.LEFT,
			BlockEstate.Directions.RIGHT,
			BlockEstate.Directions.FOWARD,
			BlockEstate.Directions.BACK
			]
		for i : int in range(0,directions.size()):
			p.cube_map_set(Vector3i(i * 2,2,0),BlockEstate.new(6,directions[i]))
		
		p.generate_mesh()

func _ready() -> void:
	call_deferred("test")
