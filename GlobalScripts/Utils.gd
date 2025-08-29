extends Node

func play_sfx(path: String, bus: String = "Master") -> void:
	var player := AudioStreamPlayer.new()
	add_child(player)

	# imposto lo stream e il bus
	player.stream = load(path)
	player.bus = bus

	# riproduci
	player.play()

	# quando finisce il suono, libera il nodo
	player.finished.connect(player.queue_free)
