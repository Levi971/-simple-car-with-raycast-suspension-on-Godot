extends RayCast3D

@onready var physbod = get_parent()
@export var dampness = 0.025
@export var stiffness = 0.25
@export var relaxedlength = -1
var prev_compression = 0
var y_force = 0

func _ready():
	target_position.y = relaxedlength

func _physics_process(delta):
	if is_colliding() and physbod is RigidBody3D:
		#print("Collide")
		#calculate the compression ratio -0 means spring is fully relaxed, 1 means its fully compressed
		var compression = 1 - (global_transform.origin.distance_to(get_collision_point()) / abs(relaxedlength))
		
		#calculate forces and apply them
		y_force = (stiffness * physbod.mass) * compression 
		y_force += (dampness * physbod.mass) * (compression - prev_compression) / delta
		
		
		var pos = (get_collision_point() - physbod.global_position)
		
		physbod.apply_force((get_collision_normal() * y_force), pos )
		
		
		prev_compression = compression
		
	else:
		prev_compression = 0
