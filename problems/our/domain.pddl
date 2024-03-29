(define (domain first_world)
(:requirements :typing  :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable int - object
	agent block item - locatable
	count position - int
	bedrock destructible-block - block
	diamond oak-log log obsidian - item
	grass_block-block obsidian-block log-block - destructible-block
)
(:predicates
	(at-z ?l - locatable ?z - position)
	(are-seq ?x1 - int ?x2 - int)
	(not-equal ?x1 - int ?x2 - int)
	(agent-alive ?ag - agent)
	(at-x ?l - locatable ?x - position)
	(item-present ?i - item)
	(at-y ?l - locatable ?y - position)
	(goal-achieved ?ag - agent)
	(agent-has-n-obsidian ?ag - agent ?n - count)
	(agent-has-n-oak-log ?ag - agent ?n - count)
	(agent-has-n-diamond ?ag - agent ?n - count)
	(agent-has-n-grass_block ?ag - agent ?n - count)
	(agent-has-n-log ?ag - agent ?n - count)
	(block-present ?b - block)
)

(:action move-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
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
 (or (at-y ?i ?y_down)
 (at-y ?i ?y_up)
) (at-z ?i ?z_end)
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
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z_front ?z)
 (block-present ?b) (are-seq ?n_start ?n_end)
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
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
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


(:action break-obsidian-north
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z_front ?z)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action place-obsidian-north
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z_front ?z)
 (are-seq ?n_end ?n_start)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action break-log-north
	:parameters (?ag - agent ?b - log-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z_front ?z)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action place-log-north
	:parameters (?ag - agent ?b - log-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z_front ?z)
 (are-seq ?n_end ?n_start)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action move-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
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
 (or (at-y ?i ?y_down)
 (at-y ?i ?y_up)
) (at-z ?i ?z_end)
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
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z ?z_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
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
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
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


(:action break-obsidian-south
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z ?z_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action place-obsidian-south
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z ?z_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action break-log-south
	:parameters (?ag - agent ?b - log-block ?x - position ?y - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (are-seq ?z ?z_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action place-log-south
	:parameters (?ag - agent ?b - log-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z_front)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x)
 (at-y ?bl ?y)
 (at-z ?bl ?z_front)
))) (are-seq ?y_down ?y)
 (are-seq ?z ?z_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x)
 (at-y ?b ?y)
 (at-z ?b ?z_front)
 (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action move-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
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
 (or (at-y ?i ?y_down)
 (at-y ?i ?y_up)
) (at-z ?i ?z)
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
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x ?x_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
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
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
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


(:action break-obsidian-east
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x ?x_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action place-obsidian-east
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x ?x_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action break-log-east
	:parameters (?ag - agent ?b - log-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x ?x_front)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action place-log-east
	:parameters (?ag - agent ?b - log-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x ?x_front)
 (are-seq ?n_end ?n_start)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action move-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
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
 (or (at-y ?i ?y_down)
 (at-y ?i ?y_up)
) (at-z ?i ?z)
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
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x_front ?x)
 (block-present ?b) (are-seq ?n_start ?n_end)
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
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
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


(:action break-obsidian-west
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x_front ?x)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action place-obsidian-west
	:parameters (?ag - agent ?b - obsidian-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x_front ?x)
 (are-seq ?n_end ?n_start)
 (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (agent-has-n-obsidian ?ag ?n_end)
)
)


(:action break-log-west
	:parameters (?ag - agent ?b - log-block ?x - position ?x_front - position ?y - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (are-seq ?x_front ?x)
 (block-present ?b) (are-seq ?n_start ?n_end)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action place-log-west
	:parameters (?ag - agent ?b - log-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count)
	:precondition (and 
(exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y_down)
 (at-z ?bl ?z)
)) (not (exists (?bl - block) (and 
(at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (at-x ?bl ?x_front)
 (at-y ?bl ?y)
 (at-z ?bl ?z)
))) (are-seq ?y_down ?y)
 (are-seq ?x_front ?x)
 (are-seq ?n_end ?n_start)
 (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(block-present ?b) (at-x ?b ?x_front)
 (at-y ?b ?y)
 (at-z ?b ?z)
 (not (agent-has-n-log ?ag ?n_start)
) (agent-has-n-log ?ag ?n_end)
)
)


(:action move_and_pickup-diamond-north
	:parameters (?ag - agent ?i - diamond ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-diamond ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-diamond ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-diamond ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-diamond-south
	:parameters (?ag - agent ?i - diamond ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-diamond ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-diamond ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-diamond ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-diamond-east
	:parameters (?ag - agent ?i - diamond ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-diamond ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-diamond ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-diamond ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-diamond-west
	:parameters (?ag - agent ?i - diamond ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-diamond ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-diamond ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-diamond ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-oak-log-north
	:parameters (?ag - agent ?i - oak-log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-oak-log ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-oak-log ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-oak-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-oak-log-south
	:parameters (?ag - agent ?i - oak-log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-oak-log ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-oak-log ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-oak-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-oak-log-east
	:parameters (?ag - agent ?i - oak-log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-oak-log ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-oak-log ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-oak-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-oak-log-west
	:parameters (?ag - agent ?i - oak-log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-oak-log ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-oak-log ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-oak-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-log-north
	:parameters (?ag - agent ?i - log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-log ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-log-south
	:parameters (?ag - agent ?i - log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-log ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-log-east
	:parameters (?ag - agent ?i - log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-log ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-log-west
	:parameters (?ag - agent ?i - log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-log ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-log ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-log ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-obsidian-north
	:parameters (?ag - agent ?i - obsidian ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-obsidian ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-obsidian-south
	:parameters (?ag - agent ?i - obsidian ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z_end)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x)
 (at-y ?i ?y_down)
 (at-z ?i ?z_end)
)) (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (not (at-x ?i ?x)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z_end)
) (agent-has-n-obsidian ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-obsidian-east
	:parameters (?ag - agent ?i - obsidian ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-obsidian ?ag ?n_end)
 (not (item-present ?i)))
)


(:action move_and_pickup-obsidian-west
	:parameters (?ag - agent ?i - obsidian ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (not (exists (?b - block) (and 
(block-present ?b)
 (at-x ?b ?x_end)
 (or (at-y ?b ?y_up)
 (at-y ?b ?y_down)
) (at-z ?b ?z)
))) (exists (?i - item) (and 
(item-present ?i)
 (at-x ?i ?x_end)
 (at-y ?i ?y_down)
 (at-z ?i ?z)
)) (agent-has-n-obsidian ?ag ?n_start)
)
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (agent-has-n-obsidian ?ag ?n_start)
) (not (at-x ?i ?x_end)
) (not (at-y ?i ?y_down)
) (not (at-z ?i ?z)
) (agent-has-n-obsidian ?ag ?n_end)
 (not (item-present ?i)))
)


(:action checkgoal
	:parameters (?ag - agent)
	:precondition (and 
(exists (?b - log-block) (and 
(at-x ?b position0)
 (at-y ?b position4)
 (at-z ?b position-2)
))
	 (or (agent-has-n-log ?ag count1)
 (agent-has-n-log ?ag count2)
 (agent-has-n-log ?ag count3)
 (agent-has-n-log ?ag count4)
 (agent-has-n-log ?ag count5)
 (agent-has-n-log ?ag count6)
 (agent-has-n-log ?ag count7)
 (agent-has-n-log ?ag count8)
 (agent-has-n-log ?ag count9)
 (agent-has-n-log ?ag count10)
 (agent-has-n-log ?ag count11)
 (agent-has-n-log ?ag count12)
 (agent-has-n-log ?ag count13)
 (agent-has-n-log ?ag count14)
 (agent-has-n-log ?ag count15)
 (agent-has-n-log ?ag count16)
 (agent-has-n-log ?ag count17)
 (agent-has-n-log ?ag count18)
 (agent-has-n-log ?ag count19)
 (agent-has-n-log ?ag count20)
 (agent-has-n-log ?ag count21)
 (agent-has-n-log ?ag count22)
 (agent-has-n-log ?ag count23)
 (agent-has-n-log ?ag count24)
 (agent-has-n-log ?ag count25)
 (agent-has-n-log ?ag count26)
 (agent-has-n-log ?ag count27)
 (agent-has-n-log ?ag count28)
 (agent-has-n-log ?ag count29)
 (agent-has-n-log ?ag count30)
 (agent-has-n-log ?ag count31)
 (agent-has-n-log ?ag count32)
 (agent-has-n-log ?ag count33)
 (agent-has-n-log ?ag count34)
 (agent-has-n-log ?ag count35)
 (agent-has-n-log ?ag count36)
 (agent-has-n-log ?ag count37)
 (agent-has-n-log ?ag count38)
 (agent-has-n-log ?ag count39)
 (agent-has-n-log ?ag count40)
 (agent-has-n-log ?ag count41)
 (agent-has-n-log ?ag count42)
 (agent-has-n-log ?ag count43)
 (agent-has-n-log ?ag count44)
 (agent-has-n-log ?ag count45)
 (agent-has-n-log ?ag count46)
 (agent-has-n-log ?ag count47)
 (agent-has-n-log ?ag count48)
 (agent-has-n-log ?ag count49)
 (agent-has-n-log ?ag count50)
 (agent-has-n-log ?ag count51)
 (agent-has-n-log ?ag count52)
 (agent-has-n-log ?ag count53)
 (agent-has-n-log ?ag count54)
 (agent-has-n-log ?ag count55)
 (agent-has-n-log ?ag count56)
 (agent-has-n-log ?ag count57)
 (agent-has-n-log ?ag count58)
 (agent-has-n-log ?ag count59)
 (agent-has-n-log ?ag count60)
 (agent-has-n-log ?ag count61)
 (agent-has-n-log ?ag count62)
 (agent-has-n-log ?ag count63)
))
	:effect (and 
(goal-achieved ?ag))
)


)