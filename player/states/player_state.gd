extends BaseState
class_name PlayerState

var player: MainPlayer

func initActor(main_player: BaseActor):
	super.initActor(main_player)
	player = main_player as MainPlayer
