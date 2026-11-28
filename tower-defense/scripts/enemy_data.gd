extends Node
const STATS={
	'goblin':{'max_hp':100,'speed':100,'damage':10,'coin':20},
	'blood':{'max_hp':300,'speed':60,'damage':20,'coin':30},
	'devil':{'max_hp':150,'speed':250,'damage':30,'coin':40}
}

const WAVES={
	'1':['goblin'],
	'2':['goblin','goblin','goblin'],
	'3':['goblin','goblin','goblin','blood'],
	'4':['blood','blood','blood'],
	'5':['goblin','goblin','goblin','goblin','goblin','blood','blood'],
	'6':['devil','devil'],
	'7':['devil','devil','devil','blood','blood'],
	'8':['blood','blood','blood','blood','blood','blood','blood','blood','blood','blood','blood','blood','blood','blood'],
	'9':['devil','devil','devil','devil','devil','blood','blood','blood','blood','blood'],
	'10':['devil']
}
