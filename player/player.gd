extends CharacterBody2D

##################################################
const MOVING_SPEED = 50.0

""" Detector 영역 내에 들어온 상호작용 대상들을 저장 """
var interactable_list: Array[Interactable] = []

""" 주변 상호작용 대상을 감지하는 Area2D """
@onready var detector: Area2D = $Detector

##################################################
func _ready() -> void:
	""" Detector를 통해 Interactable의 진입/이탈을 감지 """
	detector.area_entered.connect(_on_detector_area_entered)
	detector.area_exited.connect(_on_detector_area_exited)

##################################################
func _physics_process(delta: float) -> void:
	var x_direction: float = Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * MOVING_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVING_SPEED)
	var y_direction: float = Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * MOVING_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, MOVING_SPEED)
	
	""" 상호작용 입력 시, 가장 가까운 대상과 상호작용 """
	if Input.is_action_just_pressed("ui_interact"):
		var current_target: Interactable = get_closest_target()
		if current_target:
			current_target.interact()

	move_and_slide()

##################################################
""" Detector 영역에 들어온 Interactable을 리스트에 추가 """
func _on_detector_area_entered(area: Area2D) -> void:
	if area is Interactable:
		if not interactable_list.has(area):
			interactable_list.append(area)
	
	# 디버깅용
	print(interactable_list)

##################################################
""" Detector 영역에서 벗어난 Interactable을 리스트에서 제거 """
func _on_detector_area_exited(area: Area2D) -> void:
	if area is Interactable:
		if interactable_list.has(area):
			interactable_list.erase(area)
	
	# 디버깅용
	print(interactable_list)

##################################################
""" 감지된 대상 중 가장 가까운 Interactable을 반환 """
func get_closest_target() -> Interactable:
	var closest_target: Interactable = null
	var min_distance: float = INF
	
	for i in range(interactable_list.size() - 1, -1, -1):
		var target: Interactable = interactable_list[i]

		""" 삭제된 객체는 리스트에서 제거 """
		if not is_instance_valid(target):
			interactable_list.remove_at(i)
			continue
		
		""" 플레이어와 대상 간 거리 계산 """
		var distance: float = global_position.distance_to(target.global_position)
		
		""" 가장 가까운 대상 갱신 """
		if distance < min_distance:
			min_distance = distance
			closest_target = target
	
	return closest_target
