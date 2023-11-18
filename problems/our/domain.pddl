(define (domain first_world)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable - object
	agent block item - locatable
	bedrock destructible-block - block
	diamond oak-log log obsidian - item
	grass_block-block log-block - destructible-block
)
(:predicates
	(agent-alive ?ag - agent)
	(item-present ?i - item)
	(goal-achieved ?ag - agent)
	(block-present ?b - block)
)
(:functions
	(agent-num-grass_block ?ag - agent )
	(agent-num-log ?ag - agent )
	(x ?l - locatable )
	(agent-num-oak-log ?ag - agent )
	(block-hits ?b - destructible-block )
	(agent-num-obsidian ?ag - agent )
	(z ?l - locatable )
	(y ?l - locatable )
	(agent-num-diamond ?ag - agent )
)

(:action move-north
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (and 
(not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1)))))))
	:effect (and 
(decrease (z ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jump-down
	:parameters (?ag - agent)
	:precondition (and 
(not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action break-log-north
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-log ?ag) 1))
)


(:action place-log-north
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-log ?ag) 1))
)


(:action move-south
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (and 
(not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1)))))))
	:effect (and 
(increase (z ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jump-down
	:parameters (?ag - agent)
	:precondition (and 
(not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action break-log-south
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-log ?ag) 1))
)


(:action place-log-south
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-log ?ag) 1))
)


(:action move-east
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (and 
(not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) 1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and 
(= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and 
(increase (x ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jump-down
	:parameters (?ag - agent)
	:precondition (and 
(not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action break-log-east
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-log ?ag) 1))
)


(:action place-log-east
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-log ?ag) 1))
)


(:action move-west
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (and 
(not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) -1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and 
(= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and 
(decrease (x ?ag) 1))
)


(:action jump-up
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jump-down
	:parameters (?ag - agent)
	:precondition (and 
(not (exists (?bl - block) (and 
(= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action break-log-west
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-log ?ag) 1))
)


(:action place-log-west
	:parameters (?ag - agent ?b - log-block)
	:precondition (and 
(exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-log ?ag) 1))
)


(:action move-north-and-pickup-diamond-north
	:parameters (?ag - agent ?i - diamond)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(increase (agent-num-diamond ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-diamond-south
	:parameters (?ag - agent ?i - diamond)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(increase (agent-num-diamond ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-diamond-east
	:parameters (?ag - agent ?i - diamond)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-diamond ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-diamond-west
	:parameters (?ag - agent ?i - diamond)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-diamond ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action move-north-and-pickup-oak-log-north
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(increase (agent-num-oak-log ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-oak-log-south
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(increase (agent-num-oak-log ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-oak-log-east
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-oak-log ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-oak-log-west
	:parameters (?ag - agent ?i - oak-log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-oak-log ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action move-north-and-pickup-log-north
	:parameters (?ag - agent ?i - log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(increase (agent-num-log ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-log-south
	:parameters (?ag - agent ?i - log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(increase (agent-num-log ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-log-east
	:parameters (?ag - agent ?i - log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-log ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-log-west
	:parameters (?ag - agent ?i - log)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-log ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action move-north-and-pickup-obsidian-north
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action move-south-and-pickup-obsidian-south
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action move-east-and-pickup-obsidian-east
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action move-west-and-pickup-obsidian-west
	:parameters (?ag - agent ?i - obsidian)
	:precondition (and 
(and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(increase (agent-num-obsidian ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action check-goal
	:parameters (?ag - agent)
	:precondition (and 
(exists (?b - log-block) (and 
(= (x ?b) 0) (= (y ?b) 4) (= (z ?b) -2)))
	 (>= (agent-num-log ?ag) 1))
	:effect (and 
(goal-achieved ?ag))
)


)