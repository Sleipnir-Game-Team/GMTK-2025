extends Node

func damage(target, dealer, ammount):
	#target.champion.stats.hp = max(0, target.champion.stats.hp - ammount)
	print(target, " recebeu ", str(ammount), " de dano de ", dealer)
	
	var dealerSig = GameManager.find_node("Signalizer", dealer)
	var targetSig = GameManager.find_node("Signalizer", target)
	
	dealerSig.damage_dealt.emit(target, ammount)
	targetSig.damage_recieved.emit(dealer, ammount)

func heal(target, dealer, ammount):
	#target.champion.stats.hp = min(target.champion.stats.hp + ammount, target.champion.stats.getHpMax())
	
	var dealerSig = GameManager.find_node("Signalizer", dealer)
	var targetSig = GameManager.find_node("Signalizer", target)
	
	dealerSig.cure_dealt.emit(target, ammount)
	targetSig.cure_recieved.emit(dealer, ammount)
