extends Reference
class_name CardData

# Raw card data. Everything of a card is found here, as an individual card. 

var id: Dictionary = {"000": ""}
var attributes: Dictionary = {}
var card_name: String = "Nothing"
var text_name: String = "Nothing"
var type: String = "None" 
var cost: int = 0
var desc: String = "Nothing to see here."
var sprite_path: String = ""
var components: Array = []

func _init(card_id: Dictionary):
	self.id = card_id
	self.attributes = card_id["attributes"]
	self.card_name = str(self.get_instance_id())
	self.text_name = card_id["attributes"]["name"]
	self.type = card_id["attributes"]["type"]
	self.cost = card_id["attributes"]["cost"]
	self.desc = card_id["attributes"]["desc"]
	self.sprite_path = card_id["attributes"]["sprite_path"]
	self.components = card_id["components"]

func duplicate() -> CardData:
	var copy = get_script().new(id)
	copy.attributes = self.attributes
	copy.card_name = self.card_name
	copy.type = self.type
	copy.cost = self.cost
	copy.desc = self.desc
	copy.components = self.components
	return copy

func get_attributes() -> Dictionary:
	return self.attributes

func set_attributes(new_attributes: Dictionary) -> void:
	self.attributes = new_attributes 

func get_components() -> Array:
	return components

func set_components(new_components: Array) -> void:
	self.components = new_components

func subtract_cost(value: int) -> void:
	self.cost = cost - value

func add_cost(value: int) -> void:
	self.cost = cost + value

