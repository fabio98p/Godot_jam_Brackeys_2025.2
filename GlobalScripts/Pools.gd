extends Node

var BaseEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/enemy1.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy2.tres") as EnemyResource,
	load("res://Enemy/Resources/enemy3.tres") as EnemyResource,
]
var MiniBossEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/minibossenemy1.tres") as EnemyResource,
	load("res://Enemy/Resources/minibossenemy2.tres") as EnemyResource,
]
var BossEnemyPool: Array[EnemyResource] = [
	load("res://Enemy/Resources/bossenemy1.tres") as EnemyResource,
]


var RewardPool: Array[CardResource] = [
	load("res://Cards/Resources/buff3.tres") as CardResource,
	load("res://Cards/Resources/shield.tres") as CardResource,
	load("res://Cards/Resources/attack+heal.tres") as CardResource,
	load("res://Cards/Resources/heal.tres") as CardResource,
	load("res://Cards/Resources/attack.tres") as CardResource,
]
