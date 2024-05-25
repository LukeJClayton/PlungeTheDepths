class_name HitboxComponent
extends Area3D


signal weapon_hit(weapon: Weapon)

@export var debug: bool = false
@export var entity: CharacterBody3D
@export var enabled: bool = true
@export var groups: Array[String]

var _weapons_in_hitbox: Array[Weapon] = []

func _process(_delta: float) -> void:
#	if debug: print(_weapons_in_hitbox)
	
	if not enabled:
		return
	
	if len(_weapons_in_hitbox) == 0:
		return
	
	for weapon in _weapons_in_hitbox:
		if not weapon.can_damage:
			continue
		
		if weapon.get_entity() == entity:
			continue
		
		var weapon_entity_in_groups: bool = false
		for group in groups:
			if weapon_entity_in_groups:
				break
			elif weapon.get_entity().is_in_group(group):
				weapon_entity_in_groups = true
		
		if not weapon_entity_in_groups:
			continue
		
#		prints("HIT", entity)

		weapon_hit.emit(weapon)
		_weapons_in_hitbox.erase(weapon)


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("weapon") and area.get_parent() not in _weapons_in_hitbox:
		var weapon: Weapon = area.get_parent()
		_weapons_in_hitbox.append(weapon)


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("weapon"):
		var weapon: Weapon = area.get_parent()
		if weapon in _weapons_in_hitbox:
			_weapons_in_hitbox.erase(weapon)
