(define (domain gripper-painting-strips)
   (:predicates (room ?r)
		(ball ?b)
        (color ?col)
        (ball-color ?b ?col)
		(gripper ?g)
		(at-robby ?r)
		(at ?b ?r)
		(free ?g)
		(carry ?o ?g))

   (:action move
       :parameters  (?from ?to)
       :precondition (and  (room ?from) (room ?to) (at-robby ?from))
       :effect (and  (at-robby ?to)
		     (not (at-robby ?from))))


   (:action pick
       :parameters (?obj ?room ?gripper)
       :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
			    (at ?obj ?room) (at-robby ?room) (free ?gripper))
       :effect (and (carry ?obj ?gripper)
		    (not (at ?obj ?room)) 
		    (not (free ?gripper))))


   (:action drop
       :parameters  (?obj  ?room ?gripper)
       :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
			    (carry ?obj ?gripper) (at-robby ?room))
       :effect (and (at ?obj ?room)
		    (free ?gripper)
		    (not (carry ?obj ?gripper))))


    (:action paint-ball
        :parameters (?ball ?col1 ?col2)
        :precondition (and (ball ?ball) (ball-color ?ball ?col1) (color ?col1) (color ?col2))
        :effect (and (not (ball-color ?ball ?col1))
                     (ball-color ?ball ?col2)
                )
    )


    (:action drop-and-paint
       :parameters  (?obj  ?room ?gripper ?col1 ?col2)
       :precondition  (and  (ball ?obj) (room ?room) (gripper ?gripper)
			    (carry ?obj ?gripper) (at-robby ?room) (ball-color ?obj ?col1) (color ?col1) (color ?col2))
       :effect (and (at ?obj ?room)
		    (free ?gripper)
		    (not (carry ?obj ?gripper))
            (not (ball-color ?obj ?col1))
            (ball-color ?obj ?col2))
    )
)

