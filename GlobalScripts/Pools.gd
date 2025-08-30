extends Node
var poolBaseEnemy: Array[EnemyResource]
var poolChessEnemy: Array[EnemyResource]

func _ready() -> void:
	poolBaseEnemy = BaseCardEnemyPool.duplicate()
	poolChessEnemy = BaseChessEnemyPool.duplicate()

var BaseCardEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/enemy1.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy2.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy3.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy4.tres") as EnemyResource,
	]


var BaseChessEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/enemy5.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy6.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy7.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy8.tres") as EnemyResource,
]
var MiniBossEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/minibossenemy1.tres") as EnemyResource,
]
var BossEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/bossenemy1.tres") as EnemyResource,
]


var RewardPool: Array[CardResource] = [
	load("res://Cards/Resources/Alfajor.tres") as CardResource,
	load("res://Cards/Resources/Bourbon.tres") as CardResource,
	load("res://Cards/Resources/ButterCoockie.tres") as CardResource,
	load("res://Cards/Resources/Shortbread.tres") as CardResource,
	load("res://Cards/Resources/Crinkie.tres") as CardResource,
	load("res://Cards/Resources/Pizelle.tres") as CardResource,
]


var ClickDragCoocky: Array[String] = [
	"res://Assets/SFX/SFX/ClickDragCokie1Final.mp3",
	"res://Assets/SFX/SFX/ClickDragCokie2Final.mp3",
	"res://Assets/SFX/SFX/ClickDragCokie3Final.mp3",
	"res://Assets/SFX/SFX/ClickDragCokie4Final.mp3",
	"res://Assets/SFX/SFX/ClickDragCokie5Final.mp3",
]

var PutCoocky: Array[String] = [
	"res://Assets/SFX/SFX/PutDownCookie1Final.mp3",
	"res://Assets/SFX/SFX/PutDownCookie2Final.mp3",
	"res://Assets/SFX/SFX/PutDownCookie3Final.mp3",
	"res://Assets/SFX/SFX/PutDownCookie4Final.mp3",
]

var BookmarksPageFlip: Array[String] = [
	"res://Assets/SFX/SFX/Page1Final.mp3",
	"res://Assets/SFX/SFX/Page2Final.mp3",
]

var GetCocky: Array[String] = [
	"res://Assets/SFX/SFX/GetCookie1Final.mp3",
	"res://Assets/SFX/SFX/GetCookie2Final.mp3",
]
