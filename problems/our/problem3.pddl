(define (problem problem)
	(:domain first_world)
(:objects
	steve - agent
	grass_block0 - grass_block
	oak-log0 - oak-log
	diamond0 - diamond
)
(:init
	(agent-alive steve)
	(= (x steve) 0)
	(= (y steve) 4)
	(= (z steve) 0)
	(= (agent-num-oak-log steve) 0)
	(= (agent-num-diamond steve) 1)
	(item-present oak-log0)
	(= (x oak-log0) 5)
	(= (y oak-log0) 4)
	(= (z oak-log0) 5)
	(not (item-present diamond0))
	(= (x diamond0) 0)
	(= (y diamond0) 4)
	(= (z diamond0) 0)
	(block-present grass_block0)
	(= (x grass_block0) 4.0)
	(= (y grass_block0) 2.0)
	(= (z grass_block0) 4.0)
	(= (block-hits grass_block0) 0)
)
(:goal (>= (agent-num-oak-log steve) 1)))