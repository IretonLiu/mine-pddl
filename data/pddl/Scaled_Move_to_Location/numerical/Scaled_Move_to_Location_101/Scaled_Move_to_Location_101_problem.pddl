(define (problem Scaled_Move_to_Location_101_problem)
	(:domain Scaled_Move_to_Location_101)
(:objects
	steve - agent
	grass_block0 grass_block1 grass_block2 grass_block3 grass_block4 grass_block5 grass_block6 grass_block7 grass_block8 grass_block9 grass_block10 grass_block11 grass_block12 grass_block13 grass_block14 grass_block15 grass_block16 grass_block17 grass_block18 grass_block19 grass_block20 grass_block21 grass_block22 grass_block23 grass_block24 grass_block25 grass_block26 grass_block27 grass_block28 grass_block29 grass_block30 grass_block31 grass_block32 grass_block33 grass_block34 grass_block35 grass_block36 grass_block37 grass_block38 grass_block39 grass_block40 grass_block41 grass_block42 grass_block43 grass_block44 grass_block45 grass_block46 grass_block47 grass_block48 grass_block49 grass_block50 grass_block51 grass_block52 grass_block53 grass_block54 grass_block55 grass_block56 grass_block57 grass_block58 grass_block59 grass_block60 grass_block61 grass_block62 grass_block63 grass_block64 grass_block65 grass_block66 grass_block67 grass_block68 grass_block69 grass_block70 grass_block71 grass_block72 grass_block73 grass_block74 grass_block75 grass_block76 grass_block77 grass_block78 grass_block79 grass_block80 grass_block81 grass_block82 grass_block83 grass_block84 grass_block85 grass_block86 grass_block87 grass_block88 grass_block89 grass_block90 grass_block91 grass_block92 grass_block93 grass_block94 grass_block95 grass_block96 grass_block97 grass_block98 grass_block99 grass_block100 - grass_block
	grass_block-block0 grass_block-block1 grass_block-block2 grass_block-block3 grass_block-block4 grass_block-block5 grass_block-block6 grass_block-block7 grass_block-block8 grass_block-block9 grass_block-block10 grass_block-block11 grass_block-block12 grass_block-block13 grass_block-block14 grass_block-block15 grass_block-block16 grass_block-block17 grass_block-block18 grass_block-block19 grass_block-block20 grass_block-block21 grass_block-block22 grass_block-block23 grass_block-block24 grass_block-block25 grass_block-block26 grass_block-block27 grass_block-block28 grass_block-block29 grass_block-block30 grass_block-block31 grass_block-block32 grass_block-block33 grass_block-block34 grass_block-block35 grass_block-block36 grass_block-block37 grass_block-block38 grass_block-block39 grass_block-block40 grass_block-block41 grass_block-block42 grass_block-block43 grass_block-block44 grass_block-block45 grass_block-block46 grass_block-block47 grass_block-block48 grass_block-block49 grass_block-block50 grass_block-block51 grass_block-block52 grass_block-block53 grass_block-block54 grass_block-block55 grass_block-block56 grass_block-block57 grass_block-block58 grass_block-block59 grass_block-block60 grass_block-block61 grass_block-block62 grass_block-block63 grass_block-block64 grass_block-block65 grass_block-block66 grass_block-block67 grass_block-block68 grass_block-block69 grass_block-block70 grass_block-block71 grass_block-block72 grass_block-block73 grass_block-block74 grass_block-block75 grass_block-block76 grass_block-block77 grass_block-block78 grass_block-block79 grass_block-block80 grass_block-block81 grass_block-block82 grass_block-block83 grass_block-block84 grass_block-block85 grass_block-block86 grass_block-block87 grass_block-block88 grass_block-block89 grass_block-block90 grass_block-block91 grass_block-block92 grass_block-block93 grass_block-block94 grass_block-block95 grass_block-block96 grass_block-block97 grass_block-block98 grass_block-block99 grass_block-block100 - grass_block-block
)
(:init
	(agent-alive steve)
	(not (goal-achieved steve))
	(= (x steve) -50)
	(= (y steve) 4)
	(= (z steve) 0)
	(= (agent-num-grass_block steve) 0)
	(block-present grass_block-block0)
	(= (x grass_block-block0) -50)
	(= (y grass_block-block0) 3)
	(= (z grass_block-block0) 0)
	(= (block-hits grass_block-block0) 0)
	(block-present grass_block-block1)
	(= (x grass_block-block1) -49)
	(= (y grass_block-block1) 3)
	(= (z grass_block-block1) 0)
	(= (block-hits grass_block-block1) 0)
	(block-present grass_block-block2)
	(= (x grass_block-block2) -48)
	(= (y grass_block-block2) 3)
	(= (z grass_block-block2) 0)
	(= (block-hits grass_block-block2) 0)
	(block-present grass_block-block3)
	(= (x grass_block-block3) -47)
	(= (y grass_block-block3) 3)
	(= (z grass_block-block3) 0)
	(= (block-hits grass_block-block3) 0)
	(block-present grass_block-block4)
	(= (x grass_block-block4) -46)
	(= (y grass_block-block4) 3)
	(= (z grass_block-block4) 0)
	(= (block-hits grass_block-block4) 0)
	(block-present grass_block-block5)
	(= (x grass_block-block5) -45)
	(= (y grass_block-block5) 3)
	(= (z grass_block-block5) 0)
	(= (block-hits grass_block-block5) 0)
	(block-present grass_block-block6)
	(= (x grass_block-block6) -44)
	(= (y grass_block-block6) 3)
	(= (z grass_block-block6) 0)
	(= (block-hits grass_block-block6) 0)
	(block-present grass_block-block7)
	(= (x grass_block-block7) -43)
	(= (y grass_block-block7) 3)
	(= (z grass_block-block7) 0)
	(= (block-hits grass_block-block7) 0)
	(block-present grass_block-block8)
	(= (x grass_block-block8) -42)
	(= (y grass_block-block8) 3)
	(= (z grass_block-block8) 0)
	(= (block-hits grass_block-block8) 0)
	(block-present grass_block-block9)
	(= (x grass_block-block9) -41)
	(= (y grass_block-block9) 3)
	(= (z grass_block-block9) 0)
	(= (block-hits grass_block-block9) 0)
	(block-present grass_block-block10)
	(= (x grass_block-block10) -40)
	(= (y grass_block-block10) 3)
	(= (z grass_block-block10) 0)
	(= (block-hits grass_block-block10) 0)
	(block-present grass_block-block11)
	(= (x grass_block-block11) -39)
	(= (y grass_block-block11) 3)
	(= (z grass_block-block11) 0)
	(= (block-hits grass_block-block11) 0)
	(block-present grass_block-block12)
	(= (x grass_block-block12) -38)
	(= (y grass_block-block12) 3)
	(= (z grass_block-block12) 0)
	(= (block-hits grass_block-block12) 0)
	(block-present grass_block-block13)
	(= (x grass_block-block13) -37)
	(= (y grass_block-block13) 3)
	(= (z grass_block-block13) 0)
	(= (block-hits grass_block-block13) 0)
	(block-present grass_block-block14)
	(= (x grass_block-block14) -36)
	(= (y grass_block-block14) 3)
	(= (z grass_block-block14) 0)
	(= (block-hits grass_block-block14) 0)
	(block-present grass_block-block15)
	(= (x grass_block-block15) -35)
	(= (y grass_block-block15) 3)
	(= (z grass_block-block15) 0)
	(= (block-hits grass_block-block15) 0)
	(block-present grass_block-block16)
	(= (x grass_block-block16) -34)
	(= (y grass_block-block16) 3)
	(= (z grass_block-block16) 0)
	(= (block-hits grass_block-block16) 0)
	(block-present grass_block-block17)
	(= (x grass_block-block17) -33)
	(= (y grass_block-block17) 3)
	(= (z grass_block-block17) 0)
	(= (block-hits grass_block-block17) 0)
	(block-present grass_block-block18)
	(= (x grass_block-block18) -32)
	(= (y grass_block-block18) 3)
	(= (z grass_block-block18) 0)
	(= (block-hits grass_block-block18) 0)
	(block-present grass_block-block19)
	(= (x grass_block-block19) -31)
	(= (y grass_block-block19) 3)
	(= (z grass_block-block19) 0)
	(= (block-hits grass_block-block19) 0)
	(block-present grass_block-block20)
	(= (x grass_block-block20) -30)
	(= (y grass_block-block20) 3)
	(= (z grass_block-block20) 0)
	(= (block-hits grass_block-block20) 0)
	(block-present grass_block-block21)
	(= (x grass_block-block21) -29)
	(= (y grass_block-block21) 3)
	(= (z grass_block-block21) 0)
	(= (block-hits grass_block-block21) 0)
	(block-present grass_block-block22)
	(= (x grass_block-block22) -28)
	(= (y grass_block-block22) 3)
	(= (z grass_block-block22) 0)
	(= (block-hits grass_block-block22) 0)
	(block-present grass_block-block23)
	(= (x grass_block-block23) -27)
	(= (y grass_block-block23) 3)
	(= (z grass_block-block23) 0)
	(= (block-hits grass_block-block23) 0)
	(block-present grass_block-block24)
	(= (x grass_block-block24) -26)
	(= (y grass_block-block24) 3)
	(= (z grass_block-block24) 0)
	(= (block-hits grass_block-block24) 0)
	(block-present grass_block-block25)
	(= (x grass_block-block25) -25)
	(= (y grass_block-block25) 3)
	(= (z grass_block-block25) 0)
	(= (block-hits grass_block-block25) 0)
	(block-present grass_block-block26)
	(= (x grass_block-block26) -24)
	(= (y grass_block-block26) 3)
	(= (z grass_block-block26) 0)
	(= (block-hits grass_block-block26) 0)
	(block-present grass_block-block27)
	(= (x grass_block-block27) -23)
	(= (y grass_block-block27) 3)
	(= (z grass_block-block27) 0)
	(= (block-hits grass_block-block27) 0)
	(block-present grass_block-block28)
	(= (x grass_block-block28) -22)
	(= (y grass_block-block28) 3)
	(= (z grass_block-block28) 0)
	(= (block-hits grass_block-block28) 0)
	(block-present grass_block-block29)
	(= (x grass_block-block29) -21)
	(= (y grass_block-block29) 3)
	(= (z grass_block-block29) 0)
	(= (block-hits grass_block-block29) 0)
	(block-present grass_block-block30)
	(= (x grass_block-block30) -20)
	(= (y grass_block-block30) 3)
	(= (z grass_block-block30) 0)
	(= (block-hits grass_block-block30) 0)
	(block-present grass_block-block31)
	(= (x grass_block-block31) -19)
	(= (y grass_block-block31) 3)
	(= (z grass_block-block31) 0)
	(= (block-hits grass_block-block31) 0)
	(block-present grass_block-block32)
	(= (x grass_block-block32) -18)
	(= (y grass_block-block32) 3)
	(= (z grass_block-block32) 0)
	(= (block-hits grass_block-block32) 0)
	(block-present grass_block-block33)
	(= (x grass_block-block33) -17)
	(= (y grass_block-block33) 3)
	(= (z grass_block-block33) 0)
	(= (block-hits grass_block-block33) 0)
	(block-present grass_block-block34)
	(= (x grass_block-block34) -16)
	(= (y grass_block-block34) 3)
	(= (z grass_block-block34) 0)
	(= (block-hits grass_block-block34) 0)
	(block-present grass_block-block35)
	(= (x grass_block-block35) -15)
	(= (y grass_block-block35) 3)
	(= (z grass_block-block35) 0)
	(= (block-hits grass_block-block35) 0)
	(block-present grass_block-block36)
	(= (x grass_block-block36) -14)
	(= (y grass_block-block36) 3)
	(= (z grass_block-block36) 0)
	(= (block-hits grass_block-block36) 0)
	(block-present grass_block-block37)
	(= (x grass_block-block37) -13)
	(= (y grass_block-block37) 3)
	(= (z grass_block-block37) 0)
	(= (block-hits grass_block-block37) 0)
	(block-present grass_block-block38)
	(= (x grass_block-block38) -12)
	(= (y grass_block-block38) 3)
	(= (z grass_block-block38) 0)
	(= (block-hits grass_block-block38) 0)
	(block-present grass_block-block39)
	(= (x grass_block-block39) -11)
	(= (y grass_block-block39) 3)
	(= (z grass_block-block39) 0)
	(= (block-hits grass_block-block39) 0)
	(block-present grass_block-block40)
	(= (x grass_block-block40) -10)
	(= (y grass_block-block40) 3)
	(= (z grass_block-block40) 0)
	(= (block-hits grass_block-block40) 0)
	(block-present grass_block-block41)
	(= (x grass_block-block41) -9)
	(= (y grass_block-block41) 3)
	(= (z grass_block-block41) 0)
	(= (block-hits grass_block-block41) 0)
	(block-present grass_block-block42)
	(= (x grass_block-block42) -8)
	(= (y grass_block-block42) 3)
	(= (z grass_block-block42) 0)
	(= (block-hits grass_block-block42) 0)
	(block-present grass_block-block43)
	(= (x grass_block-block43) -7)
	(= (y grass_block-block43) 3)
	(= (z grass_block-block43) 0)
	(= (block-hits grass_block-block43) 0)
	(block-present grass_block-block44)
	(= (x grass_block-block44) -6)
	(= (y grass_block-block44) 3)
	(= (z grass_block-block44) 0)
	(= (block-hits grass_block-block44) 0)
	(block-present grass_block-block45)
	(= (x grass_block-block45) -5)
	(= (y grass_block-block45) 3)
	(= (z grass_block-block45) 0)
	(= (block-hits grass_block-block45) 0)
	(block-present grass_block-block46)
	(= (x grass_block-block46) -4)
	(= (y grass_block-block46) 3)
	(= (z grass_block-block46) 0)
	(= (block-hits grass_block-block46) 0)
	(block-present grass_block-block47)
	(= (x grass_block-block47) -3)
	(= (y grass_block-block47) 3)
	(= (z grass_block-block47) 0)
	(= (block-hits grass_block-block47) 0)
	(block-present grass_block-block48)
	(= (x grass_block-block48) -2)
	(= (y grass_block-block48) 3)
	(= (z grass_block-block48) 0)
	(= (block-hits grass_block-block48) 0)
	(block-present grass_block-block49)
	(= (x grass_block-block49) -1)
	(= (y grass_block-block49) 3)
	(= (z grass_block-block49) 0)
	(= (block-hits grass_block-block49) 0)
	(block-present grass_block-block50)
	(= (x grass_block-block50) 0)
	(= (y grass_block-block50) 3)
	(= (z grass_block-block50) 0)
	(= (block-hits grass_block-block50) 0)
	(block-present grass_block-block51)
	(= (x grass_block-block51) 1)
	(= (y grass_block-block51) 3)
	(= (z grass_block-block51) 0)
	(= (block-hits grass_block-block51) 0)
	(block-present grass_block-block52)
	(= (x grass_block-block52) 2)
	(= (y grass_block-block52) 3)
	(= (z grass_block-block52) 0)
	(= (block-hits grass_block-block52) 0)
	(block-present grass_block-block53)
	(= (x grass_block-block53) 3)
	(= (y grass_block-block53) 3)
	(= (z grass_block-block53) 0)
	(= (block-hits grass_block-block53) 0)
	(block-present grass_block-block54)
	(= (x grass_block-block54) 4)
	(= (y grass_block-block54) 3)
	(= (z grass_block-block54) 0)
	(= (block-hits grass_block-block54) 0)
	(block-present grass_block-block55)
	(= (x grass_block-block55) 5)
	(= (y grass_block-block55) 3)
	(= (z grass_block-block55) 0)
	(= (block-hits grass_block-block55) 0)
	(block-present grass_block-block56)
	(= (x grass_block-block56) 6)
	(= (y grass_block-block56) 3)
	(= (z grass_block-block56) 0)
	(= (block-hits grass_block-block56) 0)
	(block-present grass_block-block57)
	(= (x grass_block-block57) 7)
	(= (y grass_block-block57) 3)
	(= (z grass_block-block57) 0)
	(= (block-hits grass_block-block57) 0)
	(block-present grass_block-block58)
	(= (x grass_block-block58) 8)
	(= (y grass_block-block58) 3)
	(= (z grass_block-block58) 0)
	(= (block-hits grass_block-block58) 0)
	(block-present grass_block-block59)
	(= (x grass_block-block59) 9)
	(= (y grass_block-block59) 3)
	(= (z grass_block-block59) 0)
	(= (block-hits grass_block-block59) 0)
	(block-present grass_block-block60)
	(= (x grass_block-block60) 10)
	(= (y grass_block-block60) 3)
	(= (z grass_block-block60) 0)
	(= (block-hits grass_block-block60) 0)
	(block-present grass_block-block61)
	(= (x grass_block-block61) 11)
	(= (y grass_block-block61) 3)
	(= (z grass_block-block61) 0)
	(= (block-hits grass_block-block61) 0)
	(block-present grass_block-block62)
	(= (x grass_block-block62) 12)
	(= (y grass_block-block62) 3)
	(= (z grass_block-block62) 0)
	(= (block-hits grass_block-block62) 0)
	(block-present grass_block-block63)
	(= (x grass_block-block63) 13)
	(= (y grass_block-block63) 3)
	(= (z grass_block-block63) 0)
	(= (block-hits grass_block-block63) 0)
	(block-present grass_block-block64)
	(= (x grass_block-block64) 14)
	(= (y grass_block-block64) 3)
	(= (z grass_block-block64) 0)
	(= (block-hits grass_block-block64) 0)
	(block-present grass_block-block65)
	(= (x grass_block-block65) 15)
	(= (y grass_block-block65) 3)
	(= (z grass_block-block65) 0)
	(= (block-hits grass_block-block65) 0)
	(block-present grass_block-block66)
	(= (x grass_block-block66) 16)
	(= (y grass_block-block66) 3)
	(= (z grass_block-block66) 0)
	(= (block-hits grass_block-block66) 0)
	(block-present grass_block-block67)
	(= (x grass_block-block67) 17)
	(= (y grass_block-block67) 3)
	(= (z grass_block-block67) 0)
	(= (block-hits grass_block-block67) 0)
	(block-present grass_block-block68)
	(= (x grass_block-block68) 18)
	(= (y grass_block-block68) 3)
	(= (z grass_block-block68) 0)
	(= (block-hits grass_block-block68) 0)
	(block-present grass_block-block69)
	(= (x grass_block-block69) 19)
	(= (y grass_block-block69) 3)
	(= (z grass_block-block69) 0)
	(= (block-hits grass_block-block69) 0)
	(block-present grass_block-block70)
	(= (x grass_block-block70) 20)
	(= (y grass_block-block70) 3)
	(= (z grass_block-block70) 0)
	(= (block-hits grass_block-block70) 0)
	(block-present grass_block-block71)
	(= (x grass_block-block71) 21)
	(= (y grass_block-block71) 3)
	(= (z grass_block-block71) 0)
	(= (block-hits grass_block-block71) 0)
	(block-present grass_block-block72)
	(= (x grass_block-block72) 22)
	(= (y grass_block-block72) 3)
	(= (z grass_block-block72) 0)
	(= (block-hits grass_block-block72) 0)
	(block-present grass_block-block73)
	(= (x grass_block-block73) 23)
	(= (y grass_block-block73) 3)
	(= (z grass_block-block73) 0)
	(= (block-hits grass_block-block73) 0)
	(block-present grass_block-block74)
	(= (x grass_block-block74) 24)
	(= (y grass_block-block74) 3)
	(= (z grass_block-block74) 0)
	(= (block-hits grass_block-block74) 0)
	(block-present grass_block-block75)
	(= (x grass_block-block75) 25)
	(= (y grass_block-block75) 3)
	(= (z grass_block-block75) 0)
	(= (block-hits grass_block-block75) 0)
	(block-present grass_block-block76)
	(= (x grass_block-block76) 26)
	(= (y grass_block-block76) 3)
	(= (z grass_block-block76) 0)
	(= (block-hits grass_block-block76) 0)
	(block-present grass_block-block77)
	(= (x grass_block-block77) 27)
	(= (y grass_block-block77) 3)
	(= (z grass_block-block77) 0)
	(= (block-hits grass_block-block77) 0)
	(block-present grass_block-block78)
	(= (x grass_block-block78) 28)
	(= (y grass_block-block78) 3)
	(= (z grass_block-block78) 0)
	(= (block-hits grass_block-block78) 0)
	(block-present grass_block-block79)
	(= (x grass_block-block79) 29)
	(= (y grass_block-block79) 3)
	(= (z grass_block-block79) 0)
	(= (block-hits grass_block-block79) 0)
	(block-present grass_block-block80)
	(= (x grass_block-block80) 30)
	(= (y grass_block-block80) 3)
	(= (z grass_block-block80) 0)
	(= (block-hits grass_block-block80) 0)
	(block-present grass_block-block81)
	(= (x grass_block-block81) 31)
	(= (y grass_block-block81) 3)
	(= (z grass_block-block81) 0)
	(= (block-hits grass_block-block81) 0)
	(block-present grass_block-block82)
	(= (x grass_block-block82) 32)
	(= (y grass_block-block82) 3)
	(= (z grass_block-block82) 0)
	(= (block-hits grass_block-block82) 0)
	(block-present grass_block-block83)
	(= (x grass_block-block83) 33)
	(= (y grass_block-block83) 3)
	(= (z grass_block-block83) 0)
	(= (block-hits grass_block-block83) 0)
	(block-present grass_block-block84)
	(= (x grass_block-block84) 34)
	(= (y grass_block-block84) 3)
	(= (z grass_block-block84) 0)
	(= (block-hits grass_block-block84) 0)
	(block-present grass_block-block85)
	(= (x grass_block-block85) 35)
	(= (y grass_block-block85) 3)
	(= (z grass_block-block85) 0)
	(= (block-hits grass_block-block85) 0)
	(block-present grass_block-block86)
	(= (x grass_block-block86) 36)
	(= (y grass_block-block86) 3)
	(= (z grass_block-block86) 0)
	(= (block-hits grass_block-block86) 0)
	(block-present grass_block-block87)
	(= (x grass_block-block87) 37)
	(= (y grass_block-block87) 3)
	(= (z grass_block-block87) 0)
	(= (block-hits grass_block-block87) 0)
	(block-present grass_block-block88)
	(= (x grass_block-block88) 38)
	(= (y grass_block-block88) 3)
	(= (z grass_block-block88) 0)
	(= (block-hits grass_block-block88) 0)
	(block-present grass_block-block89)
	(= (x grass_block-block89) 39)
	(= (y grass_block-block89) 3)
	(= (z grass_block-block89) 0)
	(= (block-hits grass_block-block89) 0)
	(block-present grass_block-block90)
	(= (x grass_block-block90) 40)
	(= (y grass_block-block90) 3)
	(= (z grass_block-block90) 0)
	(= (block-hits grass_block-block90) 0)
	(block-present grass_block-block91)
	(= (x grass_block-block91) 41)
	(= (y grass_block-block91) 3)
	(= (z grass_block-block91) 0)
	(= (block-hits grass_block-block91) 0)
	(block-present grass_block-block92)
	(= (x grass_block-block92) 42)
	(= (y grass_block-block92) 3)
	(= (z grass_block-block92) 0)
	(= (block-hits grass_block-block92) 0)
	(block-present grass_block-block93)
	(= (x grass_block-block93) 43)
	(= (y grass_block-block93) 3)
	(= (z grass_block-block93) 0)
	(= (block-hits grass_block-block93) 0)
	(block-present grass_block-block94)
	(= (x grass_block-block94) 44)
	(= (y grass_block-block94) 3)
	(= (z grass_block-block94) 0)
	(= (block-hits grass_block-block94) 0)
	(block-present grass_block-block95)
	(= (x grass_block-block95) 45)
	(= (y grass_block-block95) 3)
	(= (z grass_block-block95) 0)
	(= (block-hits grass_block-block95) 0)
	(block-present grass_block-block96)
	(= (x grass_block-block96) 46)
	(= (y grass_block-block96) 3)
	(= (z grass_block-block96) 0)
	(= (block-hits grass_block-block96) 0)
	(block-present grass_block-block97)
	(= (x grass_block-block97) 47)
	(= (y grass_block-block97) 3)
	(= (z grass_block-block97) 0)
	(= (block-hits grass_block-block97) 0)
	(block-present grass_block-block98)
	(= (x grass_block-block98) 48)
	(= (y grass_block-block98) 3)
	(= (z grass_block-block98) 0)
	(= (block-hits grass_block-block98) 0)
	(block-present grass_block-block99)
	(= (x grass_block-block99) 49)
	(= (y grass_block-block99) 3)
	(= (z grass_block-block99) 0)
	(= (block-hits grass_block-block99) 0)
	(block-present grass_block-block100)
	(= (x grass_block-block100) 50)
	(= (y grass_block-block100) 3)
	(= (z grass_block-block100) 0)
	(= (block-hits grass_block-block100) 0)
)
(:goal
	(and (goal-achieved steve))
		
)
)