(define (domain minecraft-contrived)
(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)

(:types
	locatable - object
	agent item block - locatable
	bedrock destructible-block - block
	obsidian-block - destructible-block
	wool diamond stick diamond-pickaxe apple potato rabbit orchid-flower daisy-flower flint coal iron-ore iron-ingot netherportal flint-and-steel - item
)

(:predicates
	 (present ?i - item)
	 (block-present ?b - block)
	 (agent-alive ?ag - agent)
)

(:functions
	(block-hits ?b - destructible-block)
	(agent-num-wool ?ag - agent)
	(agent-num-diamond ?ag - agent)
	(agent-num-stick ?ag - agent)
	(agent-num-diamond-pickaxe ?ag - agent)
	(agent-num-apple ?ag - agent)
	(agent-num-potato ?ag - agent)
	(agent-num-rabbit ?ag - agent)
	(agent-num-orchid-flower ?ag - agent)
	(agent-num-daisy-flower ?ag - agent)
	(agent-num-flint ?ag - agent)
	(agent-num-coal ?ag - agent)
	(agent-num-iron-ore ?ag - agent)
	(agent-num-iron-ingot ?ag - agent)
	(agent-num-flint-and-steel ?ag - agent)
	(agent-num-obsidian-block ?ag - agent)
	(x ?l - locatable)
	(y ?l - locatable)
	(z ?l - locatable)
)

(:action move-north
 :parameters (?ag - agent)
 :precondition (and (agent-alive ?ag)
                    (not (exists (?bl - block) (and (= (x ?bl) (x ?ag))
                                                    (= (y ?bl) (+ (y ?ag) 1))
                                                    (= (z ?bl) (+ (z ?ag) 1))))))
 :effect (and (increase (y ?ag) 1))
)

(:action move-south
 :parameters (?ag - agent)
 :precondition (and (agent-alive ?ag)
                    (not (exists (?bl - block) (and (= (x ?bl) (x ?ag))
                                                    (= (y ?bl) (- (y ?ag) 1))
                                                    (= (z ?bl) (+ (z ?ag) 1))))))
 :effect (and (decrease (y ?ag) 1))
)

(:action move-east
 :parameters (?ag - agent)
 :precondition (and (agent-alive ?ag)
                    (not (exists (?bl - block) (and (= (x ?bl) (+ (x ?ag) 1))
                                                    (= (y ?bl) (y ?ag))
                                                    (= (z ?bl) (+ (z ?ag) 1))))))
 :effect (and (increase (x ?ag) 1))
)

(:action move-west
 :parameters (?ag - agent)
 :precondition (and (agent-alive ?ag)
                    (not (exists (?bl - block) (and (= (x ?bl) (- (x ?ag) 1))
                                                    (= (y ?bl) (y ?ag))
                                                    (= (z ?bl) (+ (z ?ag) 1))))))
 :effect (and (decrease (x ?ag) 1))
)

(:action pickup-wool
 :parameters (?ag - agent ?i - wool)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-wool ?ag) 1)
              (not (present ?i)))
)


(:action pickup-diamond
 :parameters (?ag - agent ?i - diamond)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-diamond ?ag) 1)
              (not (present ?i)))
)


(:action pickup-stick
 :parameters (?ag - agent ?i - stick)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-stick ?ag) 1)
              (not (present ?i)))
)


(:action pickup-diamond-pickaxe
 :parameters (?ag - agent ?i - diamond-pickaxe)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-diamond-pickaxe ?ag) 1)
              (not (present ?i)))
)


(:action pickup-apple
 :parameters (?ag - agent ?i - apple)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-apple ?ag) 1)
              (not (present ?i)))
)


(:action pickup-potato
 :parameters (?ag - agent ?i - potato)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-potato ?ag) 1)
              (not (present ?i)))
)


(:action pickup-rabbit
 :parameters (?ag - agent ?i - rabbit)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-rabbit ?ag) 1)
              (not (present ?i)))
)


(:action pickup-orchid-flower
 :parameters (?ag - agent ?i - orchid-flower)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-orchid-flower ?ag) 1)
              (not (present ?i)))
)


(:action pickup-daisy-flower
 :parameters (?ag - agent ?i - daisy-flower)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-daisy-flower ?ag) 1)
              (not (present ?i)))
)


(:action pickup-flint
 :parameters (?ag - agent ?i - flint)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-flint ?ag) 1)
              (not (present ?i)))
)


(:action pickup-coal
 :parameters (?ag - agent ?i - coal)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-coal ?ag) 1)
              (not (present ?i)))
)


(:action pickup-iron-ore
 :parameters (?ag - agent ?i - iron-ore)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-iron-ore ?ag) 1)
              (not (present ?i)))
)


(:action pickup-iron-ingot
 :parameters (?ag - agent ?i - iron-ingot)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-iron-ingot ?ag) 1)
              (not (present ?i)))
)


(:action pickup-flint-and-steel
 :parameters (?ag - agent ?i - flint-and-steel)
 :precondition (and (present ?i)
                    (= (x ?i) (x ?ag))
                    (= (y ?i) (y ?ag))
                    (= (z ?i) (z ?ag)))
 :effect (and (increase (agent-num-flint-and-steel ?ag) 1)
              (not (present ?i)))
)


(:action drop-wool
 :parameters (?ag - agent ?i - wool)
 :precondition (and (>= (agent-num-wool ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-wool ?ag) 1)
         )
)


(:action drop-diamond
 :parameters (?ag - agent ?i - diamond)
 :precondition (and (>= (agent-num-diamond ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-diamond ?ag) 1)
         )
)


(:action drop-stick
 :parameters (?ag - agent ?i - stick)
 :precondition (and (>= (agent-num-stick ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-stick ?ag) 1)
         )
)


(:action drop-apple
 :parameters (?ag - agent ?i - apple)
 :precondition (and (>= (agent-num-apple ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-apple ?ag) 1)
         )
)


(:action drop-potato
 :parameters (?ag - agent ?i - potato)
 :precondition (and (>= (agent-num-potato ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-potato ?ag) 1)
         )
)


(:action drop-rabbit
 :parameters (?ag - agent ?i - rabbit)
 :precondition (and (>= (agent-num-rabbit ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-rabbit ?ag) 1)
         )
)


(:action drop-orchid-flower
 :parameters (?ag - agent ?i - orchid-flower)
 :precondition (and (>= (agent-num-orchid-flower ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-orchid-flower ?ag) 1)
         )
)


(:action drop-daisy-flower
 :parameters (?ag - agent ?i - daisy-flower)
 :precondition (and (>= (agent-num-daisy-flower ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-daisy-flower ?ag) 1)
         )
)


(:action drop-flint
 :parameters (?ag - agent ?i - flint)
 :precondition (and (>= (agent-num-flint ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-flint ?ag) 1)
         )
)


(:action drop-coal
 :parameters (?ag - agent ?i - coal)
 :precondition (and (>= (agent-num-coal ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-coal ?ag) 1)
         )
)


(:action drop-iron-ore
 :parameters (?ag - agent ?i - iron-ore)
 :precondition (and (>= (agent-num-iron-ore ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-iron-ore ?ag) 1)
         )
)


(:action drop-iron-ingot
 :parameters (?ag - agent ?i - iron-ingot)
 :precondition (and (>= (agent-num-iron-ingot ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-iron-ingot ?ag) 1)
         )
)


(:action drop-flint-and-steel
 :parameters (?ag - agent ?i - flint-and-steel)
 :precondition (and (>= (agent-num-flint-and-steel ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-flint-and-steel ?ag) 1)
         )
)


(:action drop-obsidian-block
 :parameters (?ag - agent ?b - obsidian-block)
 :precondition (and (>= (agent-num-obsidian-block ?ag) 1)
                    (not (block-present ?b)))
 :effect (and (block-present ?b)
              (assign (x ?b) (x ?ag))
              (assign (y ?b) (+ (y ?ag) 1))
              (assign (z ?b) (z ?ag))
              (decrease (agent-num-obsidian-block ?ag) 1)
         )
)


(:action craft-diamond-pickaxe
    :parameters ( ?ag - agent )
    :precondition ( and
                      ( >= (agent-num-stick ?ag) 2 )
                      ( >= (agent-num-diamond ?ag) 3 )
                  )
    :effect (and (increase (agent-num-diamond-pickaxe ?ag) 1)
        (decrease (agent-num-stick ?ag) 2)
        (decrease (agent-num-diamond ?ag) 3))

)

(:action craft-iron-ingot
    :parameters ( ?ag - agent )
    :precondition ( and
                      ( >= (agent-num-iron-ore ?ag) 1 )
                      ( >= (agent-num-coal ?ag) 1 )
                  )
    :effect (and (increase (agent-num-iron-ingot ?ag) 1)
        (decrease (agent-num-iron-ore ?ag) 1)
        (decrease (agent-num-coal ?ag) 1))

)

(:action craft-flint-and-steel
    :parameters ( ?ag - agent )
    :precondition ( and
                      ( >= (agent-num-iron-ingot ?ag) 1 )
                      ( >= (agent-num-flint ?ag) 1 )
                  )
    :effect (and (increase (agent-num-flint-and-steel ?ag) 1)
        (decrease (agent-num-iron-ingot ?ag) 1)
        (decrease (agent-num-flint ?ag) 1))

)

(:action hit-obsidian-block
    :parameters (?ag - agent ?b - obsidian-block)
    :precondition (and (= (x ?b) (x ?ag))
                        (= (y ?b) (+ (y ?ag) 1))
                        (= (z ?b) (+ (z ?ag) 1))
                        (block-present ?b)
                        (< (block-hits ?b) 4)
                        ( >= ( agent-num-diamond-pickaxe ?ag ) 1 ))
    :effect (and (increase (block-hits ?b) 1))
    )

(:action destroy-obsidian-block
    :parameters (?ag - agent ?b - obsidian-block)
    :precondition (and (= (x ?b) (x ?ag))
                        (= (y ?b) (+ (y ?ag) 1))
                        (= (z ?b) (+ (z ?ag) 1))
                        (block-present ?b)
                        (= (block-hits ?b) 3)
                        ( >= ( agent-num-diamond-pickaxe ?ag ) 1 ))
    :effect (and (not (block-present ?b))
                 (increase (agent-num-obsidian-block ?ag) 1)
            )
    )

(:action open-netherportal
 :parameters (?ag - agent ?ob - obsidian-block ?np - netherportal)
 :precondition (and (>= (agent-num-flint-and-steel ?ag) 1)
                    (= (y ?ob) (+ (y ?ag) 1))
                    (= (z ?ob) (z ?ag))
                    (= (x ?ob) (x ?ag))
                    (block-present ?ob)
                    (not (present ?np))
                )
 :effect (and (present ?np)
              (assign (x ?np) (x ?ob))
              (assign (y ?np) (y ?ob))
              (assign (z ?np) (z ?ob))
         )
)


)
