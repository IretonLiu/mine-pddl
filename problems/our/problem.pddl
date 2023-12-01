(define (problem first_world_problem)
	(:domain first_world)
(:objects
	steve - agent
	grass_block-block0 grass_block-block1 grass_block-block2 grass_block-block3 grass_block-block4 grass_block-block5 grass_block-block6 grass_block-block7 grass_block-block8 grass_block-block9 grass_block-block10 grass_block-block11 grass_block-block12 grass_block-block13 grass_block-block14 grass_block-block15 grass_block-block16 grass_block-block17 grass_block-block18 grass_block-block19 grass_block-block20 grass_block-block21 grass_block-block22 grass_block-block23 grass_block-block24 grass_block-block25 grass_block-block26 grass_block-block27 grass_block-block28 grass_block-block29 grass_block-block30 grass_block-block31 grass_block-block32 grass_block-block33 grass_block-block34 grass_block-block35 grass_block-block36 grass_block-block37 grass_block-block38 grass_block-block39 grass_block-block40 grass_block-block41 grass_block-block42 grass_block-block43 grass_block-block44 grass_block-block45 grass_block-block46 grass_block-block47 grass_block-block48 grass_block-block49 grass_block-block50 grass_block-block51 grass_block-block52 grass_block-block53 grass_block-block54 grass_block-block55 grass_block-block56 grass_block-block57 grass_block-block58 grass_block-block59 grass_block-block60 grass_block-block61 grass_block-block62 grass_block-block63 grass_block-block64 grass_block-block65 grass_block-block66 grass_block-block67 grass_block-block68 grass_block-block69 grass_block-block70 grass_block-block71 grass_block-block72 grass_block-block73 grass_block-block74 grass_block-block75 grass_block-block76 grass_block-block77 grass_block-block78 grass_block-block79 grass_block-block80 - grass_block-block
	log-block0 - log-block
	diamond0 - diamond
	oak-log0 - oak-log
	log0 - log
	obsidian0 - obsidian
	position-5 position-4 position-3 position-2 position-1 position0 position1 position2 position3 position4 position5 - position
	count0 count1 count2 count3 count4 count5 count6 count7 count8 count9 count10 count11 count12 count13 count14 count15 count16 count17 count18 count19 count20 count21 count22 count23 count24 count25 count26 count27 count28 count29 count30 count31 count32 count33 count34 count35 count36 count37 count38 count39 count40 count41 count42 count43 count44 count45 count46 count47 count48 count49 count50 count51 count52 count53 count54 count55 count56 count57 count58 count59 count60 count61 count62 count63 count64 - count
)
(:init
	(are-seq position-5 position-4)

	(are-seq position-4 position-3)

	(are-seq position-3 position-2)

	(are-seq position-2 position-1)

	(are-seq position-1 position0)

	(are-seq position0 position1)

	(are-seq position1 position2)

	(are-seq position2 position3)

	(are-seq position3 position4)

	(are-seq position4 position5)

	(are-seq count0 count1)

	(are-seq count1 count2)

	(are-seq count2 count3)

	(are-seq count3 count4)

	(are-seq count4 count5)

	(are-seq count5 count6)

	(are-seq count6 count7)

	(are-seq count7 count8)

	(are-seq count8 count9)

	(are-seq count9 count10)

	(are-seq count10 count11)

	(are-seq count11 count12)

	(are-seq count12 count13)

	(are-seq count13 count14)

	(are-seq count14 count15)

	(are-seq count15 count16)

	(are-seq count16 count17)

	(are-seq count17 count18)

	(are-seq count18 count19)

	(are-seq count19 count20)

	(are-seq count20 count21)

	(are-seq count21 count22)

	(are-seq count22 count23)

	(are-seq count23 count24)

	(are-seq count24 count25)

	(are-seq count25 count26)

	(are-seq count26 count27)

	(are-seq count27 count28)

	(are-seq count28 count29)

	(are-seq count29 count30)

	(are-seq count30 count31)

	(are-seq count31 count32)

	(are-seq count32 count33)

	(are-seq count33 count34)

	(are-seq count34 count35)

	(are-seq count35 count36)

	(are-seq count36 count37)

	(are-seq count37 count38)

	(are-seq count38 count39)

	(are-seq count39 count40)

	(are-seq count40 count41)

	(are-seq count41 count42)

	(are-seq count42 count43)

	(are-seq count43 count44)

	(are-seq count44 count45)

	(are-seq count45 count46)

	(are-seq count46 count47)

	(are-seq count47 count48)

	(are-seq count48 count49)

	(are-seq count49 count50)

	(are-seq count50 count51)

	(are-seq count51 count52)

	(are-seq count52 count53)

	(are-seq count53 count54)

	(are-seq count54 count55)

	(are-seq count55 count56)

	(are-seq count56 count57)

	(are-seq count57 count58)

	(are-seq count58 count59)

	(are-seq count59 count60)

	(are-seq count60 count61)

	(are-seq count61 count62)

	(are-seq count62 count63)

	(are-seq count63 count64)

	(at-x steve position0)

	(at-y steve position4)

	(at-z steve position0)

	(agent-alive steve)
	(goal-achieved steve)
	(agent-has-n-diamond steve count0)

	(agent-has-n-oak-log steve count0)

	(agent-has-n-log steve count64)

	(agent-has-n-obsidian steve count64)

	(at-x grass_block-block0 position-3)

	(at-y grass_block-block0 position3)

	(at-z grass_block-block0 position-3)

	(block-present grass_block-block0)
	(at-x grass_block-block1 position-3)

	(at-y grass_block-block1 position3)

	(at-z grass_block-block1 position-2)

	(block-present grass_block-block1)
	(at-x grass_block-block2 position-3)

	(at-y grass_block-block2 position3)

	(at-z grass_block-block2 position-1)

	(block-present grass_block-block2)
	(at-x grass_block-block3 position-3)

	(at-y grass_block-block3 position3)

	(at-z grass_block-block3 position0)

	(block-present grass_block-block3)
	(at-x grass_block-block4 position-3)

	(at-y grass_block-block4 position3)

	(at-z grass_block-block4 position0)

	(block-present grass_block-block4)
	(at-x grass_block-block5 position-3)

	(at-y grass_block-block5 position3)

	(at-z grass_block-block5 position1)

	(block-present grass_block-block5)
	(at-x grass_block-block6 position-3)

	(at-y grass_block-block6 position3)

	(at-z grass_block-block6 position2)

	(block-present grass_block-block6)
	(at-x grass_block-block7 position-3)

	(at-y grass_block-block7 position3)

	(at-z grass_block-block7 position3)

	(block-present grass_block-block7)
	(at-x grass_block-block8 position-3)

	(at-y grass_block-block8 position3)

	(at-z grass_block-block8 position4)

	(block-present grass_block-block8)
	(at-x grass_block-block9 position-2)

	(at-y grass_block-block9 position3)

	(at-z grass_block-block9 position-3)

	(block-present grass_block-block9)
	(at-x grass_block-block10 position-2)

	(at-y grass_block-block10 position3)

	(at-z grass_block-block10 position-2)

	(block-present grass_block-block10)
	(at-x grass_block-block11 position-2)

	(at-y grass_block-block11 position3)

	(at-z grass_block-block11 position-1)

	(block-present grass_block-block11)
	(at-x grass_block-block12 position-2)

	(at-y grass_block-block12 position3)

	(at-z grass_block-block12 position0)

	(block-present grass_block-block12)
	(at-x grass_block-block13 position-2)

	(at-y grass_block-block13 position3)

	(at-z grass_block-block13 position0)

	(block-present grass_block-block13)
	(at-x grass_block-block14 position-2)

	(at-y grass_block-block14 position3)

	(at-z grass_block-block14 position1)

	(block-present grass_block-block14)
	(at-x grass_block-block15 position-2)

	(at-y grass_block-block15 position3)

	(at-z grass_block-block15 position2)

	(block-present grass_block-block15)
	(at-x grass_block-block16 position-2)

	(at-y grass_block-block16 position3)

	(at-z grass_block-block16 position3)

	(block-present grass_block-block16)
	(at-x grass_block-block17 position-2)

	(at-y grass_block-block17 position3)

	(at-z grass_block-block17 position4)

	(block-present grass_block-block17)
	(at-x grass_block-block18 position-1)

	(at-y grass_block-block18 position3)

	(at-z grass_block-block18 position-3)

	(block-present grass_block-block18)
	(at-x grass_block-block19 position-1)

	(at-y grass_block-block19 position3)

	(at-z grass_block-block19 position-2)

	(block-present grass_block-block19)
	(at-x grass_block-block20 position-1)

	(at-y grass_block-block20 position3)

	(at-z grass_block-block20 position-1)

	(block-present grass_block-block20)
	(at-x grass_block-block21 position-1)

	(at-y grass_block-block21 position3)

	(at-z grass_block-block21 position0)

	(block-present grass_block-block21)
	(at-x grass_block-block22 position-1)

	(at-y grass_block-block22 position3)

	(at-z grass_block-block22 position0)

	(block-present grass_block-block22)
	(at-x grass_block-block23 position-1)

	(at-y grass_block-block23 position3)

	(at-z grass_block-block23 position1)

	(block-present grass_block-block23)
	(at-x grass_block-block24 position-1)

	(at-y grass_block-block24 position3)

	(at-z grass_block-block24 position2)

	(block-present grass_block-block24)
	(at-x grass_block-block25 position-1)

	(at-y grass_block-block25 position3)

	(at-z grass_block-block25 position3)

	(block-present grass_block-block25)
	(at-x grass_block-block26 position-1)

	(at-y grass_block-block26 position3)

	(at-z grass_block-block26 position4)

	(block-present grass_block-block26)
	(at-x grass_block-block27 position0)

	(at-y grass_block-block27 position3)

	(at-z grass_block-block27 position-3)

	(block-present grass_block-block27)
	(at-x grass_block-block28 position0)

	(at-y grass_block-block28 position3)

	(at-z grass_block-block28 position-2)

	(block-present grass_block-block28)
	(at-x grass_block-block29 position0)

	(at-y grass_block-block29 position3)

	(at-z grass_block-block29 position-1)

	(block-present grass_block-block29)
	(at-x grass_block-block30 position0)

	(at-y grass_block-block30 position3)

	(at-z grass_block-block30 position0)

	(block-present grass_block-block30)
	(at-x grass_block-block31 position0)

	(at-y grass_block-block31 position3)

	(at-z grass_block-block31 position0)

	(block-present grass_block-block31)
	(at-x grass_block-block32 position0)

	(at-y grass_block-block32 position3)

	(at-z grass_block-block32 position1)

	(block-present grass_block-block32)
	(at-x grass_block-block33 position0)

	(at-y grass_block-block33 position3)

	(at-z grass_block-block33 position2)

	(block-present grass_block-block33)
	(at-x grass_block-block34 position0)

	(at-y grass_block-block34 position3)

	(at-z grass_block-block34 position3)

	(block-present grass_block-block34)
	(at-x grass_block-block35 position0)

	(at-y grass_block-block35 position3)

	(at-z grass_block-block35 position4)

	(block-present grass_block-block35)
	(at-x grass_block-block36 position0)

	(at-y grass_block-block36 position3)

	(at-z grass_block-block36 position-3)

	(block-present grass_block-block36)
	(at-x grass_block-block37 position0)

	(at-y grass_block-block37 position3)

	(at-z grass_block-block37 position-2)

	(block-present grass_block-block37)
	(at-x grass_block-block38 position0)

	(at-y grass_block-block38 position3)

	(at-z grass_block-block38 position-1)

	(block-present grass_block-block38)
	(at-x grass_block-block39 position0)

	(at-y grass_block-block39 position3)

	(at-z grass_block-block39 position0)

	(block-present grass_block-block39)
	(at-x grass_block-block40 position0)

	(at-y grass_block-block40 position3)

	(at-z grass_block-block40 position0)

	(block-present grass_block-block40)
	(at-x grass_block-block41 position0)

	(at-y grass_block-block41 position3)

	(at-z grass_block-block41 position1)

	(block-present grass_block-block41)
	(at-x grass_block-block42 position0)

	(at-y grass_block-block42 position3)

	(at-z grass_block-block42 position2)

	(block-present grass_block-block42)
	(at-x grass_block-block43 position0)

	(at-y grass_block-block43 position3)

	(at-z grass_block-block43 position3)

	(block-present grass_block-block43)
	(at-x grass_block-block44 position0)

	(at-y grass_block-block44 position3)

	(at-z grass_block-block44 position4)

	(block-present grass_block-block44)
	(at-x grass_block-block45 position1)

	(at-y grass_block-block45 position3)

	(at-z grass_block-block45 position-3)

	(block-present grass_block-block45)
	(at-x grass_block-block46 position1)

	(at-y grass_block-block46 position3)

	(at-z grass_block-block46 position-2)

	(block-present grass_block-block46)
	(at-x grass_block-block47 position1)

	(at-y grass_block-block47 position3)

	(at-z grass_block-block47 position-1)

	(block-present grass_block-block47)
	(at-x grass_block-block48 position1)

	(at-y grass_block-block48 position3)

	(at-z grass_block-block48 position0)

	(block-present grass_block-block48)
	(at-x grass_block-block49 position1)

	(at-y grass_block-block49 position3)

	(at-z grass_block-block49 position0)

	(block-present grass_block-block49)
	(at-x grass_block-block50 position1)

	(at-y grass_block-block50 position3)

	(at-z grass_block-block50 position1)

	(block-present grass_block-block50)
	(at-x grass_block-block51 position1)

	(at-y grass_block-block51 position3)

	(at-z grass_block-block51 position2)

	(block-present grass_block-block51)
	(at-x grass_block-block52 position1)

	(at-y grass_block-block52 position3)

	(at-z grass_block-block52 position3)

	(block-present grass_block-block52)
	(at-x grass_block-block53 position1)

	(at-y grass_block-block53 position3)

	(at-z grass_block-block53 position4)

	(block-present grass_block-block53)
	(at-x grass_block-block54 position2)

	(at-y grass_block-block54 position3)

	(at-z grass_block-block54 position-3)

	(block-present grass_block-block54)
	(at-x grass_block-block55 position2)

	(at-y grass_block-block55 position3)

	(at-z grass_block-block55 position-2)

	(block-present grass_block-block55)
	(at-x grass_block-block56 position2)

	(at-y grass_block-block56 position3)

	(at-z grass_block-block56 position-1)

	(block-present grass_block-block56)
	(at-x grass_block-block57 position2)

	(at-y grass_block-block57 position3)

	(at-z grass_block-block57 position0)

	(block-present grass_block-block57)
	(at-x grass_block-block58 position2)

	(at-y grass_block-block58 position3)

	(at-z grass_block-block58 position0)

	(block-present grass_block-block58)
	(at-x grass_block-block59 position2)

	(at-y grass_block-block59 position3)

	(at-z grass_block-block59 position1)

	(block-present grass_block-block59)
	(at-x grass_block-block60 position2)

	(at-y grass_block-block60 position3)

	(at-z grass_block-block60 position2)

	(block-present grass_block-block60)
	(at-x grass_block-block61 position2)

	(at-y grass_block-block61 position3)

	(at-z grass_block-block61 position3)

	(block-present grass_block-block61)
	(at-x grass_block-block62 position2)

	(at-y grass_block-block62 position3)

	(at-z grass_block-block62 position4)

	(block-present grass_block-block62)
	(at-x grass_block-block63 position3)

	(at-y grass_block-block63 position3)

	(at-z grass_block-block63 position-3)

	(block-present grass_block-block63)
	(at-x grass_block-block64 position3)

	(at-y grass_block-block64 position3)

	(at-z grass_block-block64 position-2)

	(block-present grass_block-block64)
	(at-x grass_block-block65 position3)

	(at-y grass_block-block65 position3)

	(at-z grass_block-block65 position-1)

	(block-present grass_block-block65)
	(at-x grass_block-block66 position3)

	(at-y grass_block-block66 position3)

	(at-z grass_block-block66 position0)

	(block-present grass_block-block66)
	(at-x grass_block-block67 position3)

	(at-y grass_block-block67 position3)

	(at-z grass_block-block67 position0)

	(block-present grass_block-block67)
	(at-x grass_block-block68 position3)

	(at-y grass_block-block68 position3)

	(at-z grass_block-block68 position1)

	(block-present grass_block-block68)
	(at-x grass_block-block69 position3)

	(at-y grass_block-block69 position3)

	(at-z grass_block-block69 position2)

	(block-present grass_block-block69)
	(at-x grass_block-block70 position3)

	(at-y grass_block-block70 position3)

	(at-z grass_block-block70 position3)

	(block-present grass_block-block70)
	(at-x grass_block-block71 position3)

	(at-y grass_block-block71 position3)

	(at-z grass_block-block71 position4)

	(block-present grass_block-block71)
	(at-x grass_block-block72 position4)

	(at-y grass_block-block72 position3)

	(at-z grass_block-block72 position-3)

	(block-present grass_block-block72)
	(at-x grass_block-block73 position4)

	(at-y grass_block-block73 position3)

	(at-z grass_block-block73 position-2)

	(block-present grass_block-block73)
	(at-x grass_block-block74 position4)

	(at-y grass_block-block74 position3)

	(at-z grass_block-block74 position-1)

	(block-present grass_block-block74)
	(at-x grass_block-block75 position4)

	(at-y grass_block-block75 position3)

	(at-z grass_block-block75 position0)

	(block-present grass_block-block75)
	(at-x grass_block-block76 position4)

	(at-y grass_block-block76 position3)

	(at-z grass_block-block76 position0)

	(block-present grass_block-block76)
	(at-x grass_block-block77 position4)

	(at-y grass_block-block77 position3)

	(at-z grass_block-block77 position1)

	(block-present grass_block-block77)
	(at-x grass_block-block78 position4)

	(at-y grass_block-block78 position3)

	(at-z grass_block-block78 position2)

	(block-present grass_block-block78)
	(at-x grass_block-block79 position4)

	(at-y grass_block-block79 position3)

	(at-z grass_block-block79 position3)

	(block-present grass_block-block79)
	(at-x grass_block-block80 position4)

	(at-y grass_block-block80 position3)

	(at-z grass_block-block80 position4)

	(block-present grass_block-block80)
	(at-x log-block0 position4)

	(at-y log-block0 position5)

	(at-z log-block0 position-3)

	(block-present log-block0)
	(at-x diamond0 position1)

	(at-y diamond0 position4)

	(at-z diamond0 position5)

	(item-present diamond0)
	(at-x oak-log0 position0)

	(at-y oak-log0 position4)

	(at-z oak-log0 position5)

	(item-present oak-log0)
	(at-x log0 position0)

	(at-y log0 position4)

	(at-z log0 position0)

	(not (item-present log0))
	(at-x obsidian0 position0)

	(at-y obsidian0 position4)

	(at-z obsidian0 position0)

	(not (item-present obsidian0))
)
(:goal
	(and (goal-achieved steve))
		
))
)