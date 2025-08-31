extends Node2D

func _ready() -> void:
	GC.player_actually_health = -1
	GC.player_actually_sanity = -1
	GC.audioStop()
	GC.resetDeck()
	GC.numberOfFight = 0
	GC.willingAudio(preload("res://Assets/Music/Music/GoodEnding.mp3"), 0.1)
	Pools.poolBaseEnemy = Pools.BaseCardEnemyPool.duplicate()
	Pools.poolChessEnemy = Pools.BaseChessEnemyPool.duplicate()
