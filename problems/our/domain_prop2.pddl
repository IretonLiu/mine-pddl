(define (domain first_world)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)
(:types
	locatable int - object
	agent block item - locatable
	count position - int
	bedrock destructible-block - block
	log obsidian - item
	dirt-block grass_block-block log-block - destructible-block
)
(:predicates
	(agent-alive ?ag - agent)
	(agent-has-n-log ?ag - agent ?n - count)
	(at-x ?l - locatable ?x - position)
	(at-y ?l - locatable ?y - position)
	(item-present ?i - item)
	(are-seq ?x1 - int ?x2 - int)
	(at-z ?l - locatable ?z - position)
	(not-equal ?x1 - int ?x2 - int)
	(agent-has-n-obsidian ?ag - agent ?n - count)
	(block-present ?b - block)
	(goal-achieved ?ag - agent)
)
(:functions
	(x ?l - locatable )
	(z ?l - locatable )
	(y ?l - locatable )
	(agent-num-log ?ag - agent )
	(block-hits ?b - destructible-block )
	(agent-num-obsidian ?ag - agent )
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


(:action move-north-and-pickup-log
	:parameters ?ag - agent ?i - log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count
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
)))
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


(:action move-south-and-pickup-log
	:parameters ?ag - agent ?i - log ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count
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
)))
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


(:action move-east-and-pickup-log
	:parameters ?ag - agent ?i - log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count
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
)))
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


(:action move-west-and-pickup-log
	:parameters ?ag - agent ?i - log ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count
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
)))
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


(:action move-north-and-pickup-obsidian
	:parameters ?ag - agent ?i - obsidian ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count
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
)))
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


(:action move-south-and-pickup-obsidian
	:parameters ?ag - agent ?i - obsidian ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count
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
)))
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


(:action move-east-and-pickup-obsidian
	:parameters ?ag - agent ?i - obsidian ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count
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
)))
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


(:action move-west-and-pickup-obsidian
	:parameters ?ag - agent ?i - obsidian ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?n_start - count ?n_end - count
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
)))
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


)
