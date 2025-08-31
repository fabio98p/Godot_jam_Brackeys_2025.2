extends Node2D

@onready var player_health: TextureProgressBar = $Bars/PlayerHealth
@onready var player_shield: TextureProgressBar = $Bars/PlayerShield
@onready var enemy_health: TextureProgressBar = $Bars/EnemyHealth
@onready var enemy_shield: TextureProgressBar = $Bars/EnemyShield

@onready var player_health_value: Label = $Labels/PlayerHealthValue
@onready var player_shield_value: Label = $Labels/PlayerShieldValue
@onready var enemy_health_value: Label = $Labels/EnemyHealthValue
@onready var enemy_shield_value: Label = $Labels/EnemyShieldValue
@onready var sanity_value: Label = $Labels/SanityValue

# Variabili interne
var _player_max_health: float
var _player_current_health: float
var _player_max_shield: float
var _player_current_shield: float

var _enemy_max_health: float
var _enemy_current_health: float
var _enemy_max_shield: float
var _enemy_current_shield: float

# Mappa per associare variabili alle barre
var bar_map: Dictionary

func _ready():
	bar_map = {
		"player_health": player_health,
		"player_shield": player_shield,
		"enemy_health": enemy_health,
		"enemy_shield": enemy_shield
	}

# --- Inizializza stats player e nemico ---
func init_stats(player_max_h: float, player_max_s: float, enemy_max_h: float, enemy_max_s: float) -> void:
	# --- Player ---
	_player_max_health = player_max_h
	_player_current_health = player_max_h
	player_health.max_value = _player_max_health
	player_health.value = _player_current_health
	player_health_value.text = str(int(_player_current_health))

	_player_max_shield = player_max_s
	_player_current_shield = 0 # parte vuoto
	player_shield.max_value = _player_max_shield
	player_shield.value = _player_current_shield
	player_shield.visible = true
	player_shield_value.text = str(int(_player_current_shield))
	
	# --- Enemy ---
	_enemy_max_health = enemy_max_h
	_enemy_current_health = enemy_max_h
	enemy_health.max_value = _enemy_max_health
	enemy_health.value = _enemy_current_health
	enemy_health_value.text = str(int(_enemy_current_health))

	_enemy_max_shield = enemy_max_s
	_enemy_current_shield = 0 # parte vuoto
	enemy_shield.max_value = _enemy_max_shield
	enemy_shield.value = _enemy_current_shield
	enemy_shield.visible = true
	enemy_shield_value.text = str(int(_enemy_current_shield))
	
# --- Funzione generica per animare una barra ---
func animate_bar_by_name(name: String, target_value: float, duration: float = 0.5) -> void:
	if not bar_map.has(name):
		push_error("La barra '" + name + "' non esiste!")
		return
	
	var bar = bar_map[name]
	var start_value = bar.value
	var elapsed = 0.0
	while elapsed < duration:
		var t = elapsed / duration
		bar.value = lerp(start_value, target_value, t)
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	bar.value = target_value

# --- Aggiorna vita ---
func set_player_health(value: float) -> void:
	print("healt player")
	_player_current_health = clamp(value, 0, _player_max_health)
	animate_bar_by_name("player_health", _player_current_health)
	player_health_value.text = str(int(value))

func set_enemy_health(value: float) -> void:
	print("healtenemy")
	_enemy_current_health = clamp(value, 0, _enemy_max_health)
	animate_bar_by_name("enemy_health", _enemy_current_health)
	enemy_health_value.text = str(int(value))

# --- Aggiorna scudo (aggiunta o danno) ---
func set_player_shield(value: float, mode: String = "aggiunta") -> void:
	animate_bar_by_name("player_shield", value)
	player_shield_value.text = str(int(value))

func set_enemy_shield(value: float, mode: String = "aggiunta") -> void:
	print("shild enemy")
	animate_bar_by_name("enemy_shield", value)
	enemy_shield_value.text = str(int(value))

func set_player_sanity(value:int):
	sanity_value.text = str(int(value))
