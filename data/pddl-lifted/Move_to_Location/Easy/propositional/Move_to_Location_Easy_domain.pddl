(define (domain Move_to_Location_Easy)
(:requirements :typing :negative-preconditions :universal-preconditions :existential-preconditions)
(:constants
	position-7 position-6 position-5 position-4 position-3 position-2 position-1 position0 position1 position2 position3 position4 position5 position6 position7 position8 position9 - position
	count0 count1 count2 count3 count4 count5 count6 count7 count8 count9 count10 count11 count12 count13 count14 count15 count16 count17 count18 count19 count20 count21 count22 count23 count24 count25 count26 count27 count28 count29 count30 count31 count32 count33 count34 count35 count36 count37 count38 count39 count40 count41 count42 count43 count44 count45 count46 count47 count48 count49 count50 count51 count52 count53 count54 count55 count56 count57 count58 count59 count60 count61 count62 count63 count64 - count
)
(:types
	locatable int - object
	agent block item - locatable
	count position - int
	bedrock destructible-block - block
	grass_block - item
	grass_block-block - destructible-block
)
(:predicates
	(at-y ?l - locatable ?y - position)
	(agent-has-n-grass_block ?ag - agent ?n - count)
	(agent-alive ?ag - agent)
	(are-seq ?x1 - int ?x2 - int)
	(not-equal ?x1 - int ?x2 - int)
	(at-z ?l - locatable ?z - position)
	(is-any-item-at-position ?x - position ?y - position ?z - position)
	(is-any-block-at-position ?x - position ?y - position ?z - position)
	(goal-achieved ?ag - agent)
	(block-present ?b - block)
	(item-present ?i - item)
	(at-x ?l - locatable ?x - position)
)

(:action move-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-item-at-position ?x ?y_down ?z_end)
))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
)
)


(:action jumpup-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (is-any-block-at-position ?x ?y_up_up ?z_start)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up_up ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_end)
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-north
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-block-at-position ?x ?y_2_down ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z_end)
) (not (is-any-item-at-position ?x ?y_2_down ?z_end)
))
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
 (block-present ?b) (not (is-any-item-at-position ?x ?y_up ?z_front)
) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (is-any-block-at-position ?x ?y ?z_front)
))
)


(:action place-grass_block-north
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_front)
) (not (is-any-block-at-position ?x ?y ?z_front)
) (not (is-any-item-at-position ?x ?y ?z_front)
) (are-seq ?y_down ?y)
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
 (is-any-block-at-position ?x ?y ?z_front)
)
)


(:action move_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (and 
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
 (not (item-present ?i)) (not (is-any-item-at-position ?x ?y_down ?z_end)
))
)


(:action jumpup_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_end ?z_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_start)
) (not (is-any-block-at-position ?x ?y_up_up ?z_start)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_end)
) (and 
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
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
)


(:action jumpdown_and_pickup-grass_block-north
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
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
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-block-at-position ?x ?y_2_down ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z_end)
) (and 
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
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
)


(:action move-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-item-at-position ?x ?y_down ?z_end)
))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
)
)


(:action jumpup-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (is-any-block-at-position ?x ?y_up_up ?z_start)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up_up ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_end)
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
	:effect (and 
(not (at-z ?ag ?z_start)
) (at-z ?ag ?z_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-south
	:parameters (?ag - agent ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-block-at-position ?x ?y_2_down ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z_end)
) (not (is-any-item-at-position ?x ?y_2_down ?z_end)
))
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
 (block-present ?b) (not (is-any-item-at-position ?x ?y_up ?z_front)
) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z_front)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (is-any-block-at-position ?x ?y ?z_front)
))
)


(:action place-grass_block-south
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?y - position ?y_down - position ?z - position ?z_front - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_front)
) (not (is-any-block-at-position ?x ?y ?z_front)
) (not (is-any-item-at-position ?x ?y ?z_front)
) (are-seq ?y_down ?y)
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
 (is-any-block-at-position ?x ?y ?z_front)
)
)


(:action move_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (and 
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
 (not (item-present ?i)) (not (is-any-item-at-position ?x ?y_down ?z_end)
))
)


(:action jumpup_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_up_up - position ?y_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z_start)
 (are-seq ?z_start ?z_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up_up ?z_end)
) (not (is-any-block-at-position ?x ?y_up ?z_start)
) (not (is-any-block-at-position ?x ?y_up_up ?z_start)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z_end)
) (and 
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
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
)


(:action jumpdown_and_pickup-grass_block-south
	:parameters (?ag - agent ?i - grass_block ?x - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?z_start - position ?z_end - position ?n_start - count ?n_end - count ?b1 - block)
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
 (not (is-any-block-at-position ?x ?y_up ?z_end)
) (not (is-any-block-at-position ?x ?y_down ?z_end)
) (not (is-any-block-at-position ?x ?y_2_down ?z_end)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z_end)
) (and 
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
) (not (is-any-item-at-position ?x ?y_up ?z_end)
))
)


(:action move-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-item-at-position ?x_end ?y_down ?z)
))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
)
)


(:action jumpup-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (is-any-block-at-position ?x_start ?y_up_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up_up ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-east
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-block-at-position ?x_end ?y_2_down ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z)
) (not (is-any-item-at-position ?x_end ?y_2_down ?z)
))
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
 (block-present ?b) (not (is-any-item-at-position ?x_front ?y_up ?z)
) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (is-any-block-at-position ?x_front ?y ?z)
))
)


(:action place-grass_block-east
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (and 
(block-present ?b1)
 (at-x ?b1 ?x_front)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_front ?y ?z)
) (not (is-any-item-at-position ?x_front ?y ?z)
) (are-seq ?y_down ?y)
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
 (is-any-block-at-position ?x_front ?y ?z)
)
)


(:action move_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (and 
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
 (not (item-present ?i)) (not (is-any-item-at-position ?x_end ?y_down ?z)
))
)


(:action jumpup_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_start ?x_end)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up_up ?z)
) (not (is-any-block-at-position ?x_start ?y_up ?z)
) (not (is-any-block-at-position ?x_start ?y_up_up ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (and 
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
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
)


(:action jumpdown_and_pickup-grass_block-east
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?n_start - count ?n_end - count ?b1 - block)
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
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-block-at-position ?x_end ?y_2_down ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z)
) (and 
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
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
)


(:action move-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-item-at-position ?x_end ?y_down ?z)
))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
)
)


(:action jumpup-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (not (is-any-block-at-position ?x_start ?y_up_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up_up ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
	:effect (and 
(not (at-x ?ag ?x_start)
) (at-x ?ag ?x_end)
 (not (at-y ?ag ?y_down)
) (at-y ?ag ?y_up)
)
)


(:action jumpdown-west
	:parameters (?ag - agent ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_3_down ?y_2_down)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?y_down ?y_up)
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-block-at-position ?x_end ?y_2_down ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z)
) (not (is-any-item-at-position ?x_end ?y_2_down ?z)
))
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
 (block-present ?b) (not (is-any-item-at-position ?x_front ?y_up ?z)
) (are-seq ?n_start ?n_end)
 (agent-has-n-grass_block ?ag ?n_start)
)
	:effect (and 
(not (block-present ?b)) (not (at-x ?b ?x_front)
) (not (at-y ?b ?y)
) (not (at-z ?b ?z)
) (not (agent-has-n-grass_block ?ag ?n_start)
) (agent-has-n-grass_block ?ag ?n_end)
 (not (is-any-block-at-position ?x_front ?y ?z)
))
)


(:action place-grass_block-west
	:parameters (?ag - agent ?b - grass_block-block ?x - position ?x_front - position ?y - position ?y_down - position ?z - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x)
 (at-y ?ag ?y)
 (at-z ?ag ?z)
 (not (block-present ?b)) (and 
(block-present ?b1)
 (at-x ?b1 ?x_front)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_front ?y ?z)
) (not (is-any-item-at-position ?x_front ?y ?z)
) (are-seq ?y_down ?y)
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
 (is-any-block-at-position ?x_front ?y ?z)
)
)


(:action move_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_2_down ?y_down)
 (are-seq ?n_start ?n_end)
 (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_2_down)
 (at-z ?b1 ?z)
) (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (and 
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
 (not (item-present ?i)) (not (is-any-item-at-position ?x_end ?y_down ?z)
))
)


(:action jumpup_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_up_up - position ?y_down - position ?n_start - count ?n_end - count ?b1 - block)
	:precondition (and 
(agent-alive ?ag)
 (at-x ?ag ?x_start)
 (at-y ?ag ?y_down)
 (at-z ?ag ?z)
 (are-seq ?x_end ?x_start)
 (are-seq ?y_down ?y_up)
 (are-seq ?y_up ?y_up_up)
 (are-seq ?n_start ?n_end)
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_up_up ?z)
) (not (is-any-block-at-position ?x_start ?y_up ?z)
) (not (is-any-block-at-position ?x_start ?y_up_up ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_down)
 (at-z ?b1 ?z)
) (and 
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
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
)


(:action jumpdown_and_pickup-grass_block-west
	:parameters (?ag - agent ?i - grass_block ?z - position ?x_start - position ?x_end - position ?y_up - position ?y_down - position ?y_2_down - position ?y_3_down - position ?n_start - count ?n_end - count ?b1 - block)
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
 (not (is-any-block-at-position ?x_end ?y_up ?z)
) (not (is-any-block-at-position ?x_end ?y_down ?z)
) (not (is-any-block-at-position ?x_end ?y_2_down ?z)
) (and 
(block-present ?b1)
 (at-x ?b1 ?x_end)
 (at-y ?b1 ?y_3_down)
 (at-z ?b1 ?z)
) (and 
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
) (not (is-any-item-at-position ?x_end ?y_up ?z)
))
)


(:action checkgoal
	:parameters (?ag - agent)
	:precondition (and 
(agent-alive ?ag)
 (and 
(at-x ?ag position-2)
 (at-y ?ag position4)
 (at-z ?ag position3)
))
	:effect (and 
(goal-achieved ?ag))
)


)