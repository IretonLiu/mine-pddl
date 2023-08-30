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
	(at-x ?l - locatable ?x - position)
	(at-z ?l - locatable ?z - position)
	(agent-alive ?ag - agent)
	(goal-achieved ?ag - agent)
	(agent-has-n-obsidian ?ag - agent ?n - count)
	(block-present ?b - block)
	(not-equal ?x1 - int ?x2 - int)
	(at-y ?l - locatable ?y - position)
	(agent-has-n-log ?ag - agent ?n - count)
	(are-seq ?x1 - int ?x2 - int)
	(item-present ?i - item)
)
(:functions
	(agent-num-obsidian ?ag - agent )
	(block-hits ?b - destructible-block )
	(x ?l - locatable )
	(y ?l - locatable )
	(agent-num-log ?ag - agent )
	(z ?l - locatable )
)

(:action move-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and (agent-alive ?ag) (at-x ?ag ?x) (at-y ?ag ?y_down) (at-z ?ag ?z_start) (are-seq ?z_end ?z_start) (not (exists (?b - block) (and (block-present ?b) (at-x ?b ?x) (or (at-y ?b ?y_up) (at-y ?b ?y_down)) (at-z ?b ?z_end)))) (not (exists (?i - item) (and (item-present ?i) (at-x ?i ?x) (at-y ?i ?y_down) (at-z ?i ?z_end)))))
	:effect (and (not (at-z ?ag ?z_start)) (at-z ?ag ?z_end))
)


(:action move-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?z_start - position ?z_end - position)
	:precondition (and (agent-alive ?ag) (at-x ?ag ?x) (at-y ?ag ?y_down) (at-z ?ag ?z_start) (are-seq ?z_start ?z_end) (not (exists (?b - block) (and (block-present ?b) (at-x ?b ?x) (or (at-y ?b ?y_up) (at-y ?b ?y_down)) (at-z ?b ?z_end)))) (not (exists (?i - item) (and (item-present ?i) (at-x ?i ?x) (at-y ?i ?y_down) (at-z ?i ?z_end)))))
	:effect (and (not (at-z ?ag ?z_start)) (at-z ?ag ?z_end))
)


(:action move-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position)
	:precondition (and (agent-alive ?ag) (at-x ?ag ?x_start) (at-y ?ag ?y_down) (at-z ?ag ?z) (are-seq ?x_start ?x_end) (not (exists (?b - block) (and (block-present ?b) (at-x ?b ?x_end) (or (at-y ?b ?y_up) (at-y ?b ?y_down)) (at-z ?b ?z)))) (not (exists (?i - item) (and (item-present ?i) (at-x ?i ?x_end) (at-y ?i ?y_down) (at-z ?i ?z)))))
	:effect (and (not (at-x ?ag ?x_start)) (at-x ?ag ?x_end))
)


(:action move-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position)
	:precondition (and (agent-alive ?ag) (at-x ?ag ?x_start) (at-y ?ag ?y_down) (at-z ?ag ?z) (are-seq ?x_end ?x_start) (not (exists (?b - block) (and (block-present ?b) (at-x ?b ?x_end) (or (at-y ?b ?y_up) (at-y ?b ?y_down)) (at-z ?b ?z)))) (not (exists (?i - item) (and (item-present ?i) (at-x ?i ?x_end) (at-y ?i ?y_down) (at-z ?i ?z)))))
	:effect (and (not (at-x ?ag ?x_start)) (at-x ?ag ?x_end))
)


)