extends BaseState
class_name PlayerState

var player: MainPlayer

func initActor(actor: BaseActor):
	super.initActor(actor)
	player = actor as MainPlayer
