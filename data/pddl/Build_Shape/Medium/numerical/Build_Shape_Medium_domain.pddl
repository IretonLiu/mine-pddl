(define (domain Build_Shape_Medium)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable - object
	agent block item - locatable
	bedrock destructible-block - block
	glass stone_bricks grass_block stone cobblestone planks - item
	glass-block stone_bricks-block grass_block-block stone-block cobblestone-block planks-block - destructible-block
)
(:predicates
	(agent-alive ?ag - agent)
	(goal-achieved ?ag - agent)
	(block-present ?b - block)
	(item-present ?i - item)
)
(:functions
	(block-hits ?b - destructible-block )
	(agent-num-grass_block ?ag - agent )
	(agent-num-cobblestone ?ag - agent )
	(agent-num-stone ?ag - agent )
	(x ?l - locatable )
	(y ?l - locatable )
	(z ?l - locatable )
	(agent-num-glass ?ag - agent )
	(agent-num-planks ?ag - agent )
	(agent-num-stone_bricks ?ag - agent )
)

(:action move-north
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))) (and 
(not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1)))))))
	:effect (and 
(decrease (z ?ag) 1))
)


(:action jumpup-north
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jumpdown-north
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-stone_bricks-north
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone_bricks ?ag) 1))
)


(:action place-stone_bricks-north
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-stone_bricks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-stone_bricks ?ag) 1))
)


(:action move_and_pickup-stone_bricks-north
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-stone_bricks-north
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone_bricks-north
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action break-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-grass_block ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action move_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action break-glass-north
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-glass ?ag) 1))
)


(:action place-glass-north
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-glass ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-glass ?ag) 1))
)


(:action move_and_pickup-glass-north
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-glass ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-glass-north
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-glass-north
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action break-stone-north
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone ?ag) 1))
)


(:action place-stone-north
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-stone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-stone ?ag) 1))
)


(:action move_and_pickup-stone-north
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-stone ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-stone-north
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone-north
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action break-cobblestone-north
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-cobblestone ?ag) 1))
)


(:action place-cobblestone-north
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-cobblestone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-cobblestone ?ag) 1))
)


(:action move_and_pickup-cobblestone-north
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-cobblestone-north
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-cobblestone-north
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action break-planks-north
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) -1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-planks ?ag) 1))
)


(:action place-planks-north
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))))) (>= (agent-num-planks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) -1)) (decrease (agent-num-planks ?ag) 1))
)


(:action move_and_pickup-planks-north
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) -1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) -1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) -1)))))
	:effect (and 
(increase (agent-num-planks ?ag) 1) (not (item-present ?i)) (decrease (z ?ag) 1))
)


(:action jumpup_and_pickup-planks-north
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-planks-north
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) -1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) -1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) -1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) -1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action move-south
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))) (and 
(not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1)))))))
	:effect (and 
(increase (z ?ag) 1))
)


(:action jumpup-south
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jumpdown-south
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-stone_bricks-south
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone_bricks ?ag) 1))
)


(:action place-stone_bricks-south
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-stone_bricks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-stone_bricks ?ag) 1))
)


(:action move_and_pickup-stone_bricks-south
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-stone_bricks-south
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone_bricks-south
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action break-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-grass_block ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action move_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action break-glass-south
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-glass ?ag) 1))
)


(:action place-glass-south
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-glass ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-glass ?ag) 1))
)


(:action move_and_pickup-glass-south
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-glass ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-glass-south
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-glass-south
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action break-stone-south
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone ?ag) 1))
)


(:action place-stone-south
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-stone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-stone ?ag) 1))
)


(:action move_and_pickup-stone-south
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-stone ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-stone-south
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone-south
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action break-cobblestone-south
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-cobblestone ?ag) 1))
)


(:action place-cobblestone-south
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-cobblestone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-cobblestone ?ag) 1))
)


(:action move_and_pickup-cobblestone-south
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-cobblestone-south
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-cobblestone-south
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action break-planks-south
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(= (x ?b) (x ?ag)) (= (y ?b) (y ?ag)) (= (z ?b) (+ (z ?ag) 1)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-planks ?ag) 1))
)


(:action place-planks-south
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))))) (>= (agent-num-planks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (x ?ag)) (assign (y ?b) (y ?ag)) (assign (z ?b) (+ (z ?ag) 1)) (decrease (agent-num-planks ?ag) 1))
)


(:action move_and_pickup-planks-south
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (y ?ag)) (= (z ?i) (+ (z ?ag) 1))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (+ (z ?ag) 1))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (x ?ag)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (+ (z ?ag) 1)))))
	:effect (and 
(increase (agent-num-planks ?ag) 1) (not (item-present ?i)) (increase (z ?ag) 1))
)


(:action jumpup_and_pickup-planks-south
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-planks-south
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (+ (z ?ag) 1)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (y ?ag)) (= (z ?bl) (+ (z ?ag) 1)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (+ (z ?ag) 1)))))) (and 
(item-present ?i) (= (x ?i) (x ?ag)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (+ (z ?ag) 1))))
	:effect (and 
(assign (z ?ag) (+ (z ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action move-east
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))) (and 
(not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and 
(increase (x ?ag) 1))
)


(:action jumpup-east
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jumpdown-east
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-stone_bricks-east
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone_bricks ?ag) 1))
)


(:action place-stone_bricks-east
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-stone_bricks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-stone_bricks ?ag) 1))
)


(:action move_and_pickup-stone_bricks-east
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-stone_bricks-east
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone_bricks-east
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action break-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-grass_block ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action move_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action break-glass-east
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-glass ?ag) 1))
)


(:action place-glass-east
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-glass ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-glass ?ag) 1))
)


(:action move_and_pickup-glass-east
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-glass ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-glass-east
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-glass-east
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action break-stone-east
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone ?ag) 1))
)


(:action place-stone-east
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-stone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-stone ?ag) 1))
)


(:action move_and_pickup-stone-east
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-stone ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-stone-east
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone-east
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action break-cobblestone-east
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-cobblestone ?ag) 1))
)


(:action place-cobblestone-east
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-cobblestone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-cobblestone ?ag) 1))
)


(:action move_and_pickup-cobblestone-east
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-cobblestone-east
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-cobblestone-east
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action break-planks-east
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-planks ?ag) 1))
)


(:action place-planks-east
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-planks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) 1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-planks ?ag) 1))
)


(:action move_and_pickup-planks-east
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) 1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-planks ?ag) 1) (not (item-present ?i)) (increase (x ?ag) 1))
)


(:action jumpup_and_pickup-planks-east
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-planks-east
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) 1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) 1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) 1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action move-west
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))) (and 
(not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (or (= (y ?b) (+ (y ?ag) 1)) (= (y ?b) (y ?ag))) (= (z ?b) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag)))))))
	:effect (and 
(decrease (x ?ag) 1))
)


(:action jumpup-west
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)))
)


(:action jumpdown-west
	:parameters (?ag - agent)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)))
)


(:action break-stone_bricks-west
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone_bricks ?ag) 1))
)


(:action place-stone_bricks-west
	:parameters (?ag - agent ?b - stone_bricks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-stone_bricks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-stone_bricks ?ag) 1))
)


(:action move_and_pickup-stone_bricks-west
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-stone_bricks-west
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone_bricks-west
	:parameters (?ag - agent ?i - stone_bricks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone_bricks ?ag) 1) (not (item-present ?i)))
)


(:action break-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-grass_block ?ag) 1))
)


(:action place-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-grass_block ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-grass_block ?ag) 1))
)


(:action move_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-grass_block ?ag) 1) (not (item-present ?i)))
)


(:action break-glass-west
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-glass ?ag) 1))
)


(:action place-glass-west
	:parameters (?ag - agent ?b - glass-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-glass ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-glass ?ag) 1))
)


(:action move_and_pickup-glass-west
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-glass ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-glass-west
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-glass-west
	:parameters (?ag - agent ?i - glass)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-glass ?ag) 1) (not (item-present ?i)))
)


(:action break-stone-west
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-stone ?ag) 1))
)


(:action place-stone-west
	:parameters (?ag - agent ?b - stone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-stone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-stone ?ag) 1))
)


(:action move_and_pickup-stone-west
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-stone ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-stone-west
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-stone-west
	:parameters (?ag - agent ?i - stone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-stone ?ag) 1) (not (item-present ?i)))
)


(:action break-cobblestone-west
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-cobblestone ?ag) 1))
)


(:action place-cobblestone-west
	:parameters (?ag - agent ?b - cobblestone-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-cobblestone ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-cobblestone ?ag) 1))
)


(:action move_and_pickup-cobblestone-west
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-cobblestone-west
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-cobblestone-west
	:parameters (?ag - agent ?i - cobblestone)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-cobblestone ?ag) 1) (not (item-present ?i)))
)


(:action break-planks-west
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (y ?ag)) (= (z ?b) (z ?ag)) (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?b) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))))
	:effect (and 
(not (block-present ?b)) (increase (agent-num-planks ?ag) 1))
)


(:action place-planks-west
	:parameters (?ag - agent ?b - planks-block)
	:precondition (and 
(not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))) (not (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag))))) (not (exists (?i - item) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))))) (>= (agent-num-planks ?ag) 1))
	:effect (and 
(block-present ?b) (assign (x ?b) (+ (x ?ag) -1)) (assign (y ?b) (y ?ag)) (assign (z ?b) (z ?ag)) (decrease (agent-num-planks ?ag) 1))
)


(:action move_and_pickup-planks-west
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(agent-alive ?ag) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (y ?ag)) (= (z ?i) (z ?ag))) (not (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) 1)) (= (z ?b) (z ?ag))))) (exists (?b - block) (and 
(block-present ?b) (= (x ?b) (+ (x ?ag) -1)) (= (y ?b) (+ (y ?ag) -1)) (= (z ?b) (z ?ag)))))
	:effect (and 
(increase (agent-num-planks ?ag) 1) (not (item-present ?i)) (decrease (x ?ag) 1))
)


(:action jumpup_and_pickup-planks-west
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (x ?ag)) (= (y ?bl) (+ (y ?ag) 2)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) 1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) 1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action jumpdown_and_pickup-planks-west
	:parameters (?ag - agent ?i - planks)
	:precondition (and 
(exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -2)) (= (z ?bl) (z ?ag)))) (not (or (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) 1)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (y ?ag)) (= (z ?bl) (z ?ag)))) (exists (?bl - block) (and 
(block-present ?bl) (= (x ?bl) (+ (x ?ag) -1)) (= (y ?bl) (+ (y ?ag) -1)) (= (z ?bl) (z ?ag)))))) (and 
(item-present ?i) (= (x ?i) (+ (x ?ag) -1)) (= (y ?i) (+ (y ?ag) -1)) (= (z ?i) (z ?ag))))
	:effect (and 
(assign (x ?ag) (+ (x ?ag) -1)) (assign (y ?ag) (+ (y ?ag) -1)) (increase (agent-num-planks ?ag) 1) (not (item-present ?i)))
)


(:action checkgoal
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag)  (exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 0) (= (y ?b) 6) (= (z ?b) -7)))
	(exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 1) (= (y ?b) 6) (= (z ?b) -7)))
	(exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 2) (= (y ?b) 6) (= (z ?b) -7)))
	(exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 0) (= (y ?b) 4) (= (z ?b) -7)))
	(exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 1) (= (y ?b) 4) (= (z ?b) -7)))
	(exists (?b - cobblestone-block) (and 
(block-present ?b) (= (x ?b) 2) (= (y ?b) 4) (= (z ?b) -7)))
	(exists (?b - planks-block) (and 
(block-present ?b) (= (x ?b) 0) (= (y ?b) 5) (= (z ?b) -7)))
	(exists (?b - planks-block) (and 
(block-present ?b) (= (x ?b) 2) (= (y ?b) 5) (= (z ?b) -7)))
	(exists (?b - glass-block) (and 
(block-present ?b) (= (x ?b) 1) (= (y ?b) 5) (= (z ?b) -7)))
	 )
	:effect (and 
(goal-achieved ?ag))
)


)