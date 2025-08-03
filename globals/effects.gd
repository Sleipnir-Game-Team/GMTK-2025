extends Node

func damage(target: Node, dealer: Node, ammount: int) -> void:
	#print(target, " recebeu ", str(ammount), " de dano de ", dealer)
	
	var dealerSig: Node = GameManager.find_node("Signalizer", dealer)
	var targetSig: Node = GameManager.find_node("Signalizer", target)
	dealerSig.damage_dealt.emit(target, ammount)
	targetSig.damage_received.emit(dealer, ammount)
	
	GameManager.find_node("Life", target).damage(ammount)

func heal(target: Node, dealer: Node, ammount: int) -> void:
	#target.champion.stats.hp = min(target.champion.stats.hp + ammount, target.champion.stats.getHpMax())
	
	var dealerSig: Node = GameManager.find_node("Signalizer", dealer)
	var targetSig: Node = GameManager.find_node("Signalizer", target)
	
	dealerSig.cure_dealt.emit(target, ammount)
	targetSig.cure_received.emit(dealer, ammount)

func add_hp(target: Node, _source: Item, ammount: int) -> void:
	var target_life := GameManager.find_node("Life", target)
	target_life.max_life += ammount
	target_life.entity_life += ammount

func overheal(target: Node, _source: Item, ammount: float) -> void:
	var target_life := GameManager.find_node("Life", target)
	target_life.can_exceed_max = true
	target_life.entity_life = int(ammount * target_life.entity_life)

func add_double_jump(target: Node, _source: Item, ammount: int) -> void:
	target.jump_double_count += ammount
	
func trigger_invicibility(target: Node, _source: Item, ammount: float) -> void:
	var target_life := GameManager.find_node("Life", target)
	target_life.invicibility_frames(ammount)

func increase_speed(target: Node, _source: Item, ammount: float) -> void:
	target.movement_walking_speed += ammount

func extra_dash(target: Node, _source: Item, ammount: float) -> void:
	target.dash(ammount)

func hold(target: Node, _source: Item) -> void:
	target.hold()
