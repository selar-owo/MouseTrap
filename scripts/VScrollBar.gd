extends VScrollBar

@export var scroll_speed := 30.0

func _process(delta):
	if Input.is_action_just_released("scroll_up"): value -= scroll_speed
	if Input.is_action_just_released("scroll_down"): value += scroll_speed
#	var input = Input.get_axis("scroll_down","scroll_up")
#	print(input)
#	value += input * scroll_speed
