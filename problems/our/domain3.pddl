(define (domain first_world)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable - object
	agent block item - locatable
	bedrock destructible-block - block
	oak-log diamond - item
	dirt grass_block obsidian - destructible-block
)
(:predicates
	(block-present ?b - block)
	(item-present ?i - item)
	(agent-alive ?ag - agent)
)
(:functions
	(x ?l - locatable )
	(agent-num-oak-log ?ag - agent )
	(y ?l - locatable )
	(agent-num-diamond ?ag - agent )
	(z ?l - locatable )
	(block-hits ?b - destructible-block )
)

(:action move-north
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (not (exists (?b - block) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and (decrease (z ?ag) 1))
)


(:action move-south
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (not (exists (?b - block) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and (increase (z ?ag) 1))
)


(:action move-east
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (not (exists (?b - block) (and (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and (increase (x ?ag) 1))
)


(:action move-west
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (not (exists (?b - block) (and (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and (decrease (x ?ag) 1))
)


(:action pickup-oak-log
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))
	:effect (and (increase (agent-num-oak-log ?ag) 1) (not (item-present ?i)))
)


(:action drop-oak-log
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and (>= (agent-num-oak-log ?ag) 1) (not (item-present ?i)))
	:effect (and (item-present ?i) (assign (x ?i) (x ?ag)) (assign (y ?i) (y ?ag)) (assign (z ?i) (+ (z ?ag) -1)) (decrease (agent-num-oak-log ?ag) 1))
)


(:action pickup-diamond
	:parameters (?ag - agent ?i - diamond)
	:precondition (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))
	:effect (and (increase (agent-num-diamond ?ag) 1) (not (item-present ?i)))
)


(:action drop-diamond
	:parameters (?ag - agent ?i - diamond)
	:precondition (and (>= (agent-num-diamond ?ag) 1) (not (item-present ?i)))
	:effect (and (item-present ?i) (assign (x ?i) (x ?ag)) (assign (y ?i) (y ?ag)) (assign (z ?i) (+ (z ?ag) -1)) (decrease (agent-num-diamond ?ag) 1))
)


)