(define (domain first_world)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable - object
	agent block item - locatable
	bedrock destructible-block - block
	diamond log - item
	dirt-block grass_block-block obsidian-block log-block - destructible-block
)
(:predicates
	(agent-alive ?ag - agent)
	(item-present ?i - item)
	(block-present ?b - block)
)
(:functions
	(x ?l - locatable )
	(agent-num-log ?ag - agent )
	(agent-num-diamond ?ag - agent )
	(block-hits ?b - destructible-block )
	(y ?l - locatable )
	(z ?l - locatable )
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


(:action break-dirt
	:parameters (?ag - agent ?b - dirt-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-dirt ?ag) 1))
)


(:action place-dirt
	:parameters (?ag - agent ?b - dirt-block)
	:precondition (and (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (+ (y ?bl) 1)) (= (z ?b) (z ?bl)))) (not (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (y ?bl)) (= (z ?b) (z ?bl))))) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (+ (y ?ag) 1)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-dirt ?ag) 1))
)


(:action break-grass_block
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (+ (y ?bl) 1)) (= (z ?b) (z ?bl)))) (not (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (y ?bl)) (= (z ?b) (z ?bl))))) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (+ (y ?ag) 1)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action break-obsidian
	:parameters (?ag - agent ?b - obsidian-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-obsidian ?ag) 1))
)


(:action place-obsidian
	:parameters (?ag - agent ?b - obsidian-block)
	:precondition (and (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (+ (y ?bl) 1)) (= (z ?b) (z ?bl)))) (not (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (y ?bl)) (= (z ?b) (z ?bl))))) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (+ (y ?ag) 1)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-obsidian ?ag) 1))
)


(:action break-log
	:parameters (?ag - agent ?b - log-block)
	:precondition (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and (not (block-present ?b)) (increase (agent-num-log ?ag) 1))
)


(:action place-log
	:parameters (?ag - agent ?b - log-block)
	:precondition (and (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (+ (y ?bl) 1)) (= (z ?b) (z ?bl)))) (not (exists (?bl - block) (and (= (x ?b) (x ?bl)) (= (y ?b) (y ?bl)) (= (z ?b) (z ?bl))))) (and (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))
	:effect (and (block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (+ (y ?ag) 1)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-log ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and (exists (?bl - block) (and (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and (assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


)