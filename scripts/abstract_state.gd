extends Node
class_name BaseState

@export var animation_name: String;

var state_machine: StateMachine;
var actor: BaseActor;
var animation_manager: StateAnimationManager;

func initActor(actor: BaseActor):
	self.actor = actor

func onEnter():
	pass

func onExit():
	pass

func update(_delta: float) -> void:
	pass

func updatePhysics(_delta: float) -> void:
	pass

func handleInput(_input: InputEvent) -> void:
	pass
