extends Node

@warning_ignore_start("unused_signal")

signal damage_dealt(target: Node, ammount: int)
signal damage_received(dealer: Node, ammount: int)

signal cure_dealt(target: Node, ammount: int)
signal cure_received(dealer: Node, ammount: int)
