(define (problem Scaled_Move_to_Location_66_problem)
	(:domain Scaled_Move_to_Location_66)
(:objects
	steve - agent
	grass_block0 grass_block1 grass_block2 grass_block3 grass_block4 grass_block5 grass_block6 grass_block7 grass_block8 grass_block9 grass_block10 grass_block11 grass_block12 grass_block13 grass_block14 grass_block15 grass_block16 grass_block17 grass_block18 grass_block19 grass_block20 grass_block21 grass_block22 grass_block23 grass_block24 grass_block25 grass_block26 grass_block27 grass_block28 grass_block29 grass_block30 grass_block31 grass_block32 grass_block33 grass_block34 grass_block35 grass_block36 grass_block37 grass_block38 grass_block39 grass_block40 grass_block41 grass_block42 grass_block43 grass_block44 grass_block45 grass_block46 grass_block47 grass_block48 grass_block49 grass_block50 grass_block51 grass_block52 grass_block53 grass_block54 grass_block55 grass_block56 grass_block57 grass_block58 grass_block59 grass_block60 grass_block61 grass_block62 grass_block63 grass_block64 grass_block65 - grass_block
	grass_block-block0 grass_block-block1 grass_block-block2 grass_block-block3 grass_block-block4 grass_block-block5 grass_block-block6 grass_block-block7 grass_block-block8 grass_block-block9 grass_block-block10 grass_block-block11 grass_block-block12 grass_block-block13 grass_block-block14 grass_block-block15 grass_block-block16 grass_block-block17 grass_block-block18 grass_block-block19 grass_block-block20 grass_block-block21 grass_block-block22 grass_block-block23 grass_block-block24 grass_block-block25 grass_block-block26 grass_block-block27 grass_block-block28 grass_block-block29 grass_block-block30 grass_block-block31 grass_block-block32 grass_block-block33 grass_block-block34 grass_block-block35 grass_block-block36 grass_block-block37 grass_block-block38 grass_block-block39 grass_block-block40 grass_block-block41 grass_block-block42 grass_block-block43 grass_block-block44 grass_block-block45 grass_block-block46 grass_block-block47 grass_block-block48 grass_block-block49 grass_block-block50 grass_block-block51 grass_block-block52 grass_block-block53 grass_block-block54 grass_block-block55 grass_block-block56 grass_block-block57 grass_block-block58 grass_block-block59 grass_block-block60 grass_block-block61 grass_block-block62 grass_block-block63 grass_block-block64 grass_block-block65 - grass_block-block
)
(:init
	(agent-alive steve)
	(not (goal-achieved steve))
	(= (x steve) -33)
	(= (y steve) 4)
	(= (z steve) 0)
	(= (agent-num-grass_block steve) 0)
	(block-present grass_block-block0)
	(= (x grass_block-block0) -33)
	(= (y grass_block-block0) 3)
	(= (z grass_block-block0) 0)
	(= (block-hits grass_block-block0) 0)
	(block-present grass_block-block1)
	(= (x grass_block-block1) -32)
	(= (y grass_block-block1) 3)
	(= (z grass_block-block1) 0)
	(= (block-hits grass_block-block1) 0)
	(block-present grass_block-block2)
	(= (x grass_block-block2) -31)
	(= (y grass_block-block2) 3)
	(= (z grass_block-block2) 0)
	(= (block-hits grass_block-block2) 0)
	(block-present grass_block-block3)
	(= (x grass_block-block3) -30)
	(= (y grass_block-block3) 3)
	(= (z grass_block-block3) 0)
	(= (block-hits grass_block-block3) 0)
	(block-present grass_block-block4)
	(= (x grass_block-block4) -29)
	(= (y grass_block-block4) 3)
	(= (z grass_block-block4) 0)
	(= (block-hits grass_block-block4) 0)
	(block-present grass_block-block5)
	(= (x grass_block-block5) -28)
	(= (y grass_block-block5) 3)
	(= (z grass_block-block5) 0)
	(= (block-hits grass_block-block5) 0)
	(block-present grass_block-block6)
	(= (x grass_block-block6) -27)
	(= (y grass_block-block6) 3)
	(= (z grass_block-block6) 0)
	(= (block-hits grass_block-block6) 0)
	(block-present grass_block-block7)
	(= (x grass_block-block7) -26)
	(= (y grass_block-block7) 3)
	(= (z grass_block-block7) 0)
	(= (block-hits grass_block-block7) 0)
	(block-present grass_block-block8)
	(= (x grass_block-block8) -25)
	(= (y grass_block-block8) 3)
	(= (z grass_block-block8) 0)
	(= (block-hits grass_block-block8) 0)
	(block-present grass_block-block9)
	(= (x grass_block-block9) -24)
	(= (y grass_block-block9) 3)
	(= (z grass_block-block9) 0)
	(= (block-hits grass_block-block9) 0)
	(block-present grass_block-block10)
	(= (x grass_block-block10) -23)
	(= (y grass_block-block10) 3)
	(= (z grass_block-block10) 0)
	(= (block-hits grass_block-block10) 0)
	(block-present grass_block-block11)
	(= (x grass_block-block11) -22)
	(= (y grass_block-block11) 3)
	(= (z grass_block-block11) 0)
	(= (block-hits grass_block-block11) 0)
	(block-present grass_block-block12)
	(= (x grass_block-block12) -21)
	(= (y grass_block-block12) 3)
	(= (z grass_block-block12) 0)
	(= (block-hits grass_block-block12) 0)
	(block-present grass_block-block13)
	(= (x grass_block-block13) -20)
	(= (y grass_block-block13) 3)
	(= (z grass_block-block13) 0)
	(= (block-hits grass_block-block13) 0)
	(block-present grass_block-block14)
	(= (x grass_block-block14) -19)
	(= (y grass_block-block14) 3)
	(= (z grass_block-block14) 0)
	(= (block-hits grass_block-block14) 0)
	(block-present grass_block-block15)
	(= (x grass_block-block15) -18)
	(= (y grass_block-block15) 3)
	(= (z grass_block-block15) 0)
	(= (block-hits grass_block-block15) 0)
	(block-present grass_block-block16)
	(= (x grass_block-block16) -17)
	(= (y grass_block-block16) 3)
	(= (z grass_block-block16) 0)
	(= (block-hits grass_block-block16) 0)
	(block-present grass_block-block17)
	(= (x grass_block-block17) -16)
	(= (y grass_block-block17) 3)
	(= (z grass_block-block17) 0)
	(= (block-hits grass_block-block17) 0)
	(block-present grass_block-block18)
	(= (x grass_block-block18) -15)
	(= (y grass_block-block18) 3)
	(= (z grass_block-block18) 0)
	(= (block-hits grass_block-block18) 0)
	(block-present grass_block-block19)
	(= (x grass_block-block19) -14)
	(= (y grass_block-block19) 3)
	(= (z grass_block-block19) 0)
	(= (block-hits grass_block-block19) 0)
	(block-present grass_block-block20)
	(= (x grass_block-block20) -13)
	(= (y grass_block-block20) 3)
	(= (z grass_block-block20) 0)
	(= (block-hits grass_block-block20) 0)
	(block-present grass_block-block21)
	(= (x grass_block-block21) -12)
	(= (y grass_block-block21) 3)
	(= (z grass_block-block21) 0)
	(= (block-hits grass_block-block21) 0)
	(block-present grass_block-block22)
	(= (x grass_block-block22) -11)
	(= (y grass_block-block22) 3)
	(= (z grass_block-block22) 0)
	(= (block-hits grass_block-block22) 0)
	(block-present grass_block-block23)
	(= (x grass_block-block23) -10)
	(= (y grass_block-block23) 3)
	(= (z grass_block-block23) 0)
	(= (block-hits grass_block-block23) 0)
	(block-present grass_block-block24)
	(= (x grass_block-block24) -9)
	(= (y grass_block-block24) 3)
	(= (z grass_block-block24) 0)
	(= (block-hits grass_block-block24) 0)
	(block-present grass_block-block25)
	(= (x grass_block-block25) -8)
	(= (y grass_block-block25) 3)
	(= (z grass_block-block25) 0)
	(= (block-hits grass_block-block25) 0)
	(block-present grass_block-block26)
	(= (x grass_block-block26) -7)
	(= (y grass_block-block26) 3)
	(= (z grass_block-block26) 0)
	(= (block-hits grass_block-block26) 0)
	(block-present grass_block-block27)
	(= (x grass_block-block27) -6)
	(= (y grass_block-block27) 3)
	(= (z grass_block-block27) 0)
	(= (block-hits grass_block-block27) 0)
	(block-present grass_block-block28)
	(= (x grass_block-block28) -5)
	(= (y grass_block-block28) 3)
	(= (z grass_block-block28) 0)
	(= (block-hits grass_block-block28) 0)
	(block-present grass_block-block29)
	(= (x grass_block-block29) -4)
	(= (y grass_block-block29) 3)
	(= (z grass_block-block29) 0)
	(= (block-hits grass_block-block29) 0)
	(block-present grass_block-block30)
	(= (x grass_block-block30) -3)
	(= (y grass_block-block30) 3)
	(= (z grass_block-block30) 0)
	(= (block-hits grass_block-block30) 0)
	(block-present grass_block-block31)
	(= (x grass_block-block31) -2)
	(= (y grass_block-block31) 3)
	(= (z grass_block-block31) 0)
	(= (block-hits grass_block-block31) 0)
	(block-present grass_block-block32)
	(= (x grass_block-block32) -1)
	(= (y grass_block-block32) 3)
	(= (z grass_block-block32) 0)
	(= (block-hits grass_block-block32) 0)
	(block-present grass_block-block33)
	(= (x grass_block-block33) 0)
	(= (y grass_block-block33) 3)
	(= (z grass_block-block33) 0)
	(= (block-hits grass_block-block33) 0)
	(block-present grass_block-block34)
	(= (x grass_block-block34) 1)
	(= (y grass_block-block34) 3)
	(= (z grass_block-block34) 0)
	(= (block-hits grass_block-block34) 0)
	(block-present grass_block-block35)
	(= (x grass_block-block35) 2)
	(= (y grass_block-block35) 3)
	(= (z grass_block-block35) 0)
	(= (block-hits grass_block-block35) 0)
	(block-present grass_block-block36)
	(= (x grass_block-block36) 3)
	(= (y grass_block-block36) 3)
	(= (z grass_block-block36) 0)
	(= (block-hits grass_block-block36) 0)
	(block-present grass_block-block37)
	(= (x grass_block-block37) 4)
	(= (y grass_block-block37) 3)
	(= (z grass_block-block37) 0)
	(= (block-hits grass_block-block37) 0)
	(block-present grass_block-block38)
	(= (x grass_block-block38) 5)
	(= (y grass_block-block38) 3)
	(= (z grass_block-block38) 0)
	(= (block-hits grass_block-block38) 0)
	(block-present grass_block-block39)
	(= (x grass_block-block39) 6)
	(= (y grass_block-block39) 3)
	(= (z grass_block-block39) 0)
	(= (block-hits grass_block-block39) 0)
	(block-present grass_block-block40)
	(= (x grass_block-block40) 7)
	(= (y grass_block-block40) 3)
	(= (z grass_block-block40) 0)
	(= (block-hits grass_block-block40) 0)
	(block-present grass_block-block41)
	(= (x grass_block-block41) 8)
	(= (y grass_block-block41) 3)
	(= (z grass_block-block41) 0)
	(= (block-hits grass_block-block41) 0)
	(block-present grass_block-block42)
	(= (x grass_block-block42) 9)
	(= (y grass_block-block42) 3)
	(= (z grass_block-block42) 0)
	(= (block-hits grass_block-block42) 0)
	(block-present grass_block-block43)
	(= (x grass_block-block43) 10)
	(= (y grass_block-block43) 3)
	(= (z grass_block-block43) 0)
	(= (block-hits grass_block-block43) 0)
	(block-present grass_block-block44)
	(= (x grass_block-block44) 11)
	(= (y grass_block-block44) 3)
	(= (z grass_block-block44) 0)
	(= (block-hits grass_block-block44) 0)
	(block-present grass_block-block45)
	(= (x grass_block-block45) 12)
	(= (y grass_block-block45) 3)
	(= (z grass_block-block45) 0)
	(= (block-hits grass_block-block45) 0)
	(block-present grass_block-block46)
	(= (x grass_block-block46) 13)
	(= (y grass_block-block46) 3)
	(= (z grass_block-block46) 0)
	(= (block-hits grass_block-block46) 0)
	(block-present grass_block-block47)
	(= (x grass_block-block47) 14)
	(= (y grass_block-block47) 3)
	(= (z grass_block-block47) 0)
	(= (block-hits grass_block-block47) 0)
	(block-present grass_block-block48)
	(= (x grass_block-block48) 15)
	(= (y grass_block-block48) 3)
	(= (z grass_block-block48) 0)
	(= (block-hits grass_block-block48) 0)
	(block-present grass_block-block49)
	(= (x grass_block-block49) 16)
	(= (y grass_block-block49) 3)
	(= (z grass_block-block49) 0)
	(= (block-hits grass_block-block49) 0)
	(block-present grass_block-block50)
	(= (x grass_block-block50) 17)
	(= (y grass_block-block50) 3)
	(= (z grass_block-block50) 0)
	(= (block-hits grass_block-block50) 0)
	(block-present grass_block-block51)
	(= (x grass_block-block51) 18)
	(= (y grass_block-block51) 3)
	(= (z grass_block-block51) 0)
	(= (block-hits grass_block-block51) 0)
	(block-present grass_block-block52)
	(= (x grass_block-block52) 19)
	(= (y grass_block-block52) 3)
	(= (z grass_block-block52) 0)
	(= (block-hits grass_block-block52) 0)
	(block-present grass_block-block53)
	(= (x grass_block-block53) 20)
	(= (y grass_block-block53) 3)
	(= (z grass_block-block53) 0)
	(= (block-hits grass_block-block53) 0)
	(block-present grass_block-block54)
	(= (x grass_block-block54) 21)
	(= (y grass_block-block54) 3)
	(= (z grass_block-block54) 0)
	(= (block-hits grass_block-block54) 0)
	(block-present grass_block-block55)
	(= (x grass_block-block55) 22)
	(= (y grass_block-block55) 3)
	(= (z grass_block-block55) 0)
	(= (block-hits grass_block-block55) 0)
	(block-present grass_block-block56)
	(= (x grass_block-block56) 23)
	(= (y grass_block-block56) 3)
	(= (z grass_block-block56) 0)
	(= (block-hits grass_block-block56) 0)
	(block-present grass_block-block57)
	(= (x grass_block-block57) 24)
	(= (y grass_block-block57) 3)
	(= (z grass_block-block57) 0)
	(= (block-hits grass_block-block57) 0)
	(block-present grass_block-block58)
	(= (x grass_block-block58) 25)
	(= (y grass_block-block58) 3)
	(= (z grass_block-block58) 0)
	(= (block-hits grass_block-block58) 0)
	(block-present grass_block-block59)
	(= (x grass_block-block59) 26)
	(= (y grass_block-block59) 3)
	(= (z grass_block-block59) 0)
	(= (block-hits grass_block-block59) 0)
	(block-present grass_block-block60)
	(= (x grass_block-block60) 27)
	(= (y grass_block-block60) 3)
	(= (z grass_block-block60) 0)
	(= (block-hits grass_block-block60) 0)
	(block-present grass_block-block61)
	(= (x grass_block-block61) 28)
	(= (y grass_block-block61) 3)
	(= (z grass_block-block61) 0)
	(= (block-hits grass_block-block61) 0)
	(block-present grass_block-block62)
	(= (x grass_block-block62) 29)
	(= (y grass_block-block62) 3)
	(= (z grass_block-block62) 0)
	(= (block-hits grass_block-block62) 0)
	(block-present grass_block-block63)
	(= (x grass_block-block63) 30)
	(= (y grass_block-block63) 3)
	(= (z grass_block-block63) 0)
	(= (block-hits grass_block-block63) 0)
	(block-present grass_block-block64)
	(= (x grass_block-block64) 31)
	(= (y grass_block-block64) 3)
	(= (z grass_block-block64) 0)
	(= (block-hits grass_block-block64) 0)
	(block-present grass_block-block65)
	(= (x grass_block-block65) 32)
	(= (y grass_block-block65) 3)
	(= (z grass_block-block65) 0)
	(= (block-hits grass_block-block65) 0)
)
(:goal
	(and (goal-achieved steve))
		
)
)