extends Node

var runDeck: Array[CardResource]
var numberOfFight = 0

var initialDeck: Array[CardResource] = [
load("res://Cards/Resources/attack.tres") as CardResource,
load("res://Cards/Resources/shield.tres") as CardResource,
load("res://Cards/Resources/shield.tres") as CardResource,
load("res://Cards/Resources/attack+heal.tres") as CardResource,
load("res://Cards/Resources/heal.tres") as CardResource,
load("res://Cards/Resources/attack.tres") as CardResource,
load("res://Cards/Resources/attack.tres") as CardResource,
]

func _init() -> void:
	print("a caso")
	resetDeck()

func resetDeck():
	runDeck = initialDeck.duplicate()


#func audioLoad(audio: AudioStreamMP3):
	#AudioEnding.stream = audio
	#AudioEnding.play()

func audioStop():
	AudioEnding.stop()
	AudioInit.stop()

func willingAudio(audio: AudioStreamMP3, durationWilling: float = 5.0):
	var tween = get_tree().create_tween()
	
	if AudioInit.playing == false:
		AudioInit.stream = audio
		AudioInit.play()
		AudioInit.volume_db = -40.0
		tween.tween_property(AudioInit, "volume_db", 0, durationWilling)
		tween.parallel().tween_property(AudioEnding, "volume_db", -40.0, durationWilling)
		await get_tree().create_timer(durationWilling).timeout
		AudioEnding.stop()
	else:
		AudioEnding.stream = audio
		AudioEnding.play()
		AudioEnding.volume_db = -40.0
		tween.tween_property(AudioEnding, "volume_db", 0, durationWilling)
		tween.parallel().tween_property(AudioInit, "volume_db", -40.0, durationWilling)
		await get_tree().create_timer(durationWilling).timeout
		AudioInit.stop()
		

func pickenemy():
	numberOfFight += 1
	print(numberOfFight)
	if numberOfFight <= 3:
		return Pools.BaseEnemyPool[randi_range(0, Pools.BaseEnemyPool.size()-1)]
	if numberOfFight == 4:
		print("resitng 4")
		return
	if numberOfFight == 5:
		return Pools.MiniBossEnemyPool[randi_range(0, Pools.MiniBossEnemyPool.size()-1)]
	if numberOfFight > 5 and numberOfFight <= 8:
		return Pools.BaseEnemyPool[randi_range(0, Pools.BaseEnemyPool.size()-1)]
	if numberOfFight == 9:
		print("resitng 9")
		return
	if numberOfFight == 10:
		#numberOfFight = 0
		return Pools.BossEnemyPool[randi_range(0, Pools.BossEnemyPool.size()-1)]
