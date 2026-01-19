extends Node
class_name CubicVoxelTerrainGenerator

@export var blocks_infos : Array[BlockInfo]
@export var collision_shape_target : CollisionShape3D

var cube_map : Dictionary[Vector3i,BlockEstate]
func cube_map_has(pos : Vector3i) -> bool:
	return cube_map.has(pos)

func cube_map_get(pos : Vector3i) -> BlockEstate:
	var ret : BlockEstate
	if cube_map.has(pos):
		ret = cube_map[pos]
	return ret

func cube_map_set(pos : Vector3i,value : BlockEstate) -> void:
	cube_map.set(pos,value)

func cube_map_erase(pos : Vector3i) -> void:
	cube_map.erase(pos)

var mesh_instance : MeshInstance3D
func _ready() -> void:
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)

static var plane_up : Array[Vector3] = [
	Vector3(-.5,.5, .5),
	Vector3(-.5,.5, -.5),
	Vector3(.5,.5, .5),
	
	Vector3(.5,.5, .5),
	Vector3(-.5,.5, -.5),
	Vector3(.5,.5, -.5),
]

static var plane_down : Array[Vector3] = [
	Vector3(-.5,-.5, .5),
	Vector3(.5,-.5, .5),
	Vector3(-.5,-.5, -.5),
	
	Vector3(.5,-.5, .5),
	Vector3(.5,-.5, -.5),
	Vector3(-.5,-.5, -.5),
]

static var plane_back : Array[Vector3] = [
	Vector3(-.5, .5,.5),
	Vector3(.5, .5,.5),
	Vector3(-.5, -.5,.5),
	
	Vector3(.5, .5,.5),
	Vector3(.5, -.5,.5),
	Vector3(-.5, -.5,.5),
]

static var plane_foward : Array[Vector3] = [
	Vector3(-.5, .5,-.5),
	Vector3(-.5, -.5,-.5),
	Vector3(.5, .5,-.5),
	
	Vector3(.5, .5,-.5),
	Vector3(-.5, -.5,-.5),
	Vector3(.5, -.5,-.5),
]

static var plane_right : Array[Vector3] = [
	Vector3(.5,-.5, .5),
	Vector3(.5,.5, .5),
	Vector3(.5,-.5, -.5),
	
	Vector3(.5,.5, .5),
	Vector3(.5,.5, -.5),
	Vector3(.5,-.5, -.5),
]

static var plane_left : Array[Vector3] = [
	Vector3(-.5, .5,-.5),
	Vector3(-.5, .5,.5),
	Vector3(-.5, -.5,-.5),
	
	Vector3(-.5, .5,.5),
	Vector3(-.5, -.5,.5),
	Vector3(-.5, -.5,-.5),
]

func is_transparent(id:int) -> bool:
	return blocks_infos[id].is_transparent

func should_generate_wall_between(pos_a : Vector3i,pos_b : Vector3i) -> bool:
	
	if cube_map_has(pos_a) and not cube_map_has(pos_b):
		return true
	
	if (cube_map_has(pos_a) and cube_map_has(pos_b)) and (is_transparent(cube_map_get(pos_a).id) or is_transparent(cube_map_get(pos_b).id)) and (cube_map_get(pos_a).id != cube_map_get(pos_b).id) :
		return true
	
	return false

func adjust_uv(uv:Vector2,plane_normal : Vector3i,block_direction : BlockEstate.Directions = BlockEstate.Directions.UP) -> Vector2:
	return uv

func generate_mesh_to(st : SurfaceTool,block : Vector3i) -> void:
	
	if should_generate_wall_between(block,block+Vector3i.UP):
		for v : Vector3 in plane_up:
			st.set_normal(Vector3.UP)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.x,vp.z) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)
	
	if should_generate_wall_between(block,block+Vector3i.DOWN):
		for v : Vector3 in plane_down:
			st.set_normal(Vector3.DOWN)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.x,vp.z) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)
	
	if should_generate_wall_between(block,block+Vector3i.FORWARD):
		for v : Vector3 in plane_foward:
			st.set_normal(Vector3.FORWARD)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.x,-vp.y) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)
	
	if should_generate_wall_between(block,block+Vector3i.BACK):
		for v : Vector3 in plane_back:
			st.set_normal(Vector3.BACK)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.x,-vp.y) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)
	
	if should_generate_wall_between(block,block+Vector3i.LEFT):
		for v : Vector3 in plane_left:
			st.set_normal(Vector3.LEFT)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.z,-vp.y) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)
	
	if should_generate_wall_between(block,block+Vector3i.RIGHT):
		for v : Vector3 in plane_right:
			st.set_normal(Vector3.RIGHT)
			var vp : Vector3 = Vector3(v.x + block.x, v.y + block.y, v.z + block.z)
			var uv : Vector2 = Vector2(vp.z,-vp.y) - Vector2(.5,.5)
			st.set_uv(uv)
			st.add_vertex(vp)


func generate_mesh() -> void:
	var mesh : ArrayMesh = ArrayMesh.new()
	var st : SurfaceTool = SurfaceTool.new()
	
	for i : int in blocks_infos.size():
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		for k : Vector3i in cube_map:
			if cube_map_get(k).id == i:
				generate_mesh_to(st,k)
				st.set_material(blocks_infos[i].matrial)
		
		st.index()
		st.commit(mesh)
	
	mesh_instance.mesh = mesh
	if collision_shape_target:
		collision_shape_target.shape = mesh.create_trimesh_shape()
	 
	
	
