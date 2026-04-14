extends Area2D

##################################################
class_name Interactable

##################################################
func _ready() -> void:
	""" 부모 노드의 CollisionShape2D를 복제하여 Interactable의 충돌 영역으로 사용 """
	var parent_node := get_parent()
	if parent_node == null:
		return
	
	for child in parent_node.get_children():
		if child is CollisionShape2D:
			""" shape가 없는 경우는 제외 """
			if child.shape == null:
				continue
			
			""" 부모의 CollisionShape2D를 복제 """
			var new_collision_shape_node: CollisionShape2D = child.duplicate()
			
			""" shape Resource까지 복제하여 공유 문제 방지 """
			""" 만약 부모의 shape 수정을 따라가려면 아래 줄의 코드를 삭제 """
			new_collision_shape_node.shape = child.shape.duplicate()
			
			""" Interactable의 자식으로 추가하여 감지 영역으로 사용 """
			add_child(new_collision_shape_node)
			
			break

##################################################
""" 상호작용 호출 시 부모 노드의 interact() 실행 """
func interact() -> void:
	var parent_node := get_parent()
	if parent_node and parent_node.has_method("interact"):
		parent_node.interact()
