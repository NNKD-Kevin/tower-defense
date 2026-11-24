extends Node
const STATS={
	'goblin':{'max_hp':100,'speed':100,'damage':10},
	'blood':{'max_hp':300,'speed':60,'damage':25}
}

const WAVES={
	'1':['goblin'],
	'2':['goblin','goblin','goblin'],
	'3':['goblin','goblin','goblin','blood'],
	'4':['blood','blood','blood'],
	'5':['goblin','goblin','goblin','goblin','goblin','blood','blood']
}
