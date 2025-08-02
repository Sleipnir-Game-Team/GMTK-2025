extends Node

func damage(target: Node, dealer: Node, ammount: int) -> void:
	GameManager.find_node("Life", target).damage(ammount)
	#print(target, " recebeu ", str(ammount), " de dano de ", dealer)
	
	var dealerSig: Node = GameManager.find_node("Signalizer", dealer)
	var targetSig: Node = GameManager.find_node("Signalizer", target)
	
	dealerSig.damage_dealt.emit(target, ammount)
	targetSig.damage_received.emit(dealer, ammount)

func heal(target: Node, dealer: Node, ammount: int) -> void:
	#target.champion.stats.hp = min(target.champion.stats.hp + ammount, target.champion.stats.getHpMax())
	
	var dealerSig: Node = GameManager.find_node("Signalizer", dealer)
	var targetSig: Node = GameManager.find_node("Signalizer", target)
	
	dealerSig.cure_dealt.emit(target, ammount)
	targetSig.cure_received.emit(dealer, ammount)

func add_hp(target: Node, _source, ammount: int) -> void:
	GameManager.find_node("Life", target).max_life += ammount
	GameManager.find_node("Life", target).entity_life += ammount
	
