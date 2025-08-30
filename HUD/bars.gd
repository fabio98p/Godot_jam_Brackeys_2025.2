extends Control
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var max_health: float:
	set(value):
		max_health = value
		texture_progress_bar.max_value = value
		texture_progress_bar.value = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_progress_bar.max_value = max_health
	texture_progress_bar.value =  max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func minus_progress_bars(value: float) -> void:
	var start_value: float = texture_progress_bar.value
	var target_value: float = clamp(value, 0, texture_progress_bar.max_value)

	var duration: float = 0.5
	var elapsed: float = 0.0

	while elapsed < duration:
		var t: float = elapsed / duration
		texture_progress_bar.value = lerp(start_value, target_value, t)
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	texture_progress_bar.value = target_value
