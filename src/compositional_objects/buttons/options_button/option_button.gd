extends OptionButton

# Basemost option button. Set up as a compositional piece for ease of 
# integration between different types of options.  

# You can change this between different instances to reflect what options you would like.
export var new_options: Array = [ 
	"option_1",
	"option_2", 
	"option_3"
] 

func _ready():
	_add_options(new_options)


func _add_options(new_set: Array) -> void: 
	for option in new_set:
		self.add_item(option)