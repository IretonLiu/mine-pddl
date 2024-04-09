(define (domain Scaled_Move_to_Location_126)
(:requirements :typing :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable int - object
	agent block item - locatable
	count position - int
	bedrock destructible-block - block
	grass_block - item
	grass_block-block - destructible-block
)
(:predicates
	(agent-has-n-grass_block ?ag - agent ?n - count)
	(not-equal ?x1 - int ?x2 - int)
	(at-z ?l - locatable ?z - position)
	(at-y ?l - locatable ?y - position)
	(item-present ?i - item)
	(block-present ?b - block)
	(are-seq ?x1 - int ?x2 - int)
	(agent-alive ?ag - agent)
	(at-x ?l - locatable ?x - position)
	(goal-achieved ?ag - agent)
)

(:action move-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z_end)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
)
)


(:action jumpup-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_up_up)
 (at-z ?b ?z_start)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_down)
 (at-z ?b ?z_end)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z_end)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (or (at-y ?i ?y_2_down)
) (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_2_down)
)
)


(:action break-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_up - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z_front ?z)
 (are-seq ?y ?y_up)
 (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_front)
))) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action place-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y)
 (at-z ?i ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z_front ?z)
 (are-seq ?n_end ?n_start)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action move_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z_end)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)))
)


(:action jumpup_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_end)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_start)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_down)
 (at-z ?b ?z_end)
)) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (not (at-y ?ag ?y_down)
) (at-z ?ag ?z_end)
 (at-y ?ag ?y_up)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z_end)
))
)


(:action jumpdown_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z_end)
)) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_2_down)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (not (at-y ?ag ?y_down)
) (at-z ?ag ?z_end)
 (at-y ?ag ?y_2_down)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z_end)
))
)


(:action move-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z_end)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
)
)


(:action jumpup-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_up_up)
 (at-z ?b ?z_start)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_down)
 (at-z ?b ?z_end)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z_end)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (or (at-y ?i ?y_2_down)
) (at-z ?i ?z_end)
))))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_2_down)
)
)


(:action break-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_up - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z ?z_front)
 (are-seq ?y ?y_up)
 (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_front)
))) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action place-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y)
 (at-z ?i ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z ?z_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action move_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z_end)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)))
)


(:action jumpup_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_end)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z_start)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_down)
 (at-z ?b ?z_end)
)) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_up)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (not (at-y ?ag ?y_down)
) (at-z ?ag ?z_end)
 (at-y ?ag ?y_up)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z_end)
))
)


(:action jumpdown_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z_end)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z_end)
)) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_2_down)
 (at-z ?i ?z_end)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (not (at-y ?ag ?y_down)
) (at-z ?ag ?z_end)
 (at-y ?ag ?y_2_down)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z_end)
))
)


(:action move-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
)
)


(:action jumpup-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_start)
 (at-y ?b ?y_up_up)
 (at-z ?b ?z)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_down)
 (at-z ?b ?z)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (or (at-y ?i ?y_2_down)
) (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_2_down)
)
)


(:action break-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_up - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x ?x_front)
 (are-seq ?y ?y_up)
 (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_front)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
))) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action place-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_front)
 (at-y ?i ?y)
 (at-z ?i ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x ?x_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action move_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)))
)


(:action jumpup_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_start)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_down)
 (at-z ?b ?z)
)) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (not (at-y ?ag ?y_down)
) (at-x ?ag ?x_end)
 (at-y ?ag ?y_up)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z)
))
)


(:action jumpdown_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z)
)) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_2_down)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (not (at-y ?ag ?y_down)
) (at-x ?ag ?x_end)
 (at-y ?ag ?y_2_down)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z)
))
)


(:action move-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
)
)


(:action jumpup-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_start)
 (at-y ?b ?y_up_up)
 (at-z ?b ?z)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_down)
 (at-z ?b ?z)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z)
)) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (or (at-y ?i ?y_2_down)
) (at-z ?i ?z)
))))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_2_down)
)
)


(:action break-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_up - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x_front ?x)
 (are-seq ?y ?y_up)
 (block-present ?b) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_front)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
))) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action place-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(block-present ?bl)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (not (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_front)
 (at-y ?i ?y)
 (at-z ?i ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x_front ?x)
 (are-seq ?n_end ?n_start)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
)
)


(:action move_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_2_down)
 (at-z ?b ?z)
)) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)))
)


(:action jumpup_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_start)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_up_up)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_down)
 (at-z ?b ?z)
)) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_up)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (not (at-y ?ag ?y_down)
) (at-x ?ag ?x_end)
 (at-y ?ag ?y_up)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z)
))
)


(:action jumpdown_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (are-seq ?n_start ?n_end)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
 (at-y ?b ?y_2_down)
) (at-z ?b ?z)
))) (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (at-y ?b ?y_3_down)
 (at-z ?b ?z)
)) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_2_down)
 (at-z ?i ?z)
) (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (not (at-y ?ag ?y_down)
) (at-x ?ag ?x_end)
 (at-y ?ag ?y_2_down)
 (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (item-present ?i)) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_up)
) (not (at-z ?i ?z)
))
)


(:action checkgoal
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag)
 (and 
(at-x ?ag position62)
 (at-y ?ag position4)
 (at-z ?ag position0)
)  )
	:effect (and 
(goal-achieved ?ag))
)


)