(define (domain first_world)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable int - object
	agent block item - locatable
	count position - int
	bedrock destructible-block - block
	log obsidian - item
	dirt-block grass_block-block - destructible-block
)
(:predicates
	(item-present ?i - item)
	(block-present ?b - block)
	(goal-achieved ?ag - agent)
	(agent-alive ?ag - agent)
)
(:functions
	(y ?l - locatable )
	(x ?l - locatable )
	(agent-num-obsidian ?ag - agent )
	(agent-num-log ?ag - agent )
	(z ?l - locatable )
	(block-hits ?b - destructible-block )
)

(:action move-north
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (and (not (exists (?b - block) (and (= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) -1))))) (not (exists (?i - item) (and (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1)))))))
	:effect (and (decrease (z ?ag) 1))
)


(:action move-south
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (and (not (exists (?b - block) (and (= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) 1))))) (not (exists (?i - item) (and (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1)))))))
	:effect (and (increase (z ?ag) 1))
)


(:action move-east
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (and (not (exists (?b - block) (and (= (x ?b) (+ (x ?ag) 1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and (increase (x ?ag) 1))
)


(:action move-west
	:parameters (?ag - agent)
	:precondition (and (agent-alive ?ag) (and (not (exists (?b - block) (and (= (x ?b) (+ (x ?ag) -1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and (decrease (x ?ag) 1))
)


(:action move-north-and-pickup-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and (increase (agent-num-log ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and (increase (agent-num-log ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (z ?ag))))))
	:effect (and (increase (agent-num-log ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (z ?ag))))))
	:effect (and (increase (agent-num-log ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action pickup-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))
	:effect (and (increase (agent-num-log ?ag) 1) (not (item-present ?i)))
)


(:action drop-log
	:parameters (?ag - agent ?i - log)
	:precondition (and (>= (agent-num-log ?ag) 1) (not (item-present ?i)))
	:effect (and (item-present ?i) (assign (x ?i) (x ?ag)) (assign (y ?i) (y ?ag)) (assign (z ?i) (+ (z ?ag) -1)) (decrease (agent-num-log ?ag) 1))
)


(:action move-north-and-pickup-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and (increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and (increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (z ?ag))))))
	:effect (and (increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (and (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1) (= (z ?b) (z ?ag))))))
	:effect (and (increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action pickup-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))
	:effect (and (increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)))
)


(:action drop-obsidian
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and (>= (agent-num-obsidian ?ag) 1) (not (item-present ?i)))
	:effect (and (item-present ?i) (assign (x ?i) (x ?ag)) (assign (y ?i) (y ?ag)) (assign (z ?i) (+ (z ?ag) -1)) (decrease (agent-num-obsidian ?ag) 1))
)


(:action break-dirt
	:parameters (?ag - agent ?b - dirt-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-dirt ?ag) 1))
)


(:action place-dirt
	:parameters (?ag - agent ?b - dirt-block)
	:precondition (and (exists (?bl - block) (and (= (x ?ag) (x ?bl)) (= (y ?ag) (+ (y ?bl) 1)) (= (z ?ag) (+ (z ?bl) 1)))) (not (exists (?bl - block) (and (= (x ?ag) (x ?bl)) (= (y ?ag) (y ?bl)) (= (z ?ag) (+ (z ?bl) 1))))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-dirt ?ag) 1))
)


(:action break-grass_block
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and (exists (?bl - block) (and (= (x ?ag) (x ?bl)) (= (y ?ag) (+ (y ?bl) 1)) (= (z ?ag) (+ (z ?bl) 1)))) (not (exists (?bl - block) (and (= (x ?ag) (x ?bl)) (= (y ?ag) (y ?bl)) (= (z ?ag) (+ (z ?bl) 1))))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and (exists (?bl - block) (and (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and (assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jump-down
	:parameters (?ag - agent)
	:precondition (and (not (exists (?bl - block) (and (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and (assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action check-goal
	:parameters (?ag - agent)
	:precondition (exists (?b - log-block) (and (= (x ?b) 0) (= (y ?b) 4) (= (z ?b) -2)))
	
	:effect (and (goal-achieved ?ag))
)


)