(define (problem Scaled_Move_to_Location_160_problem)
	(:domain Scaled_Move_to_Location_160)
(:objects
	steve - agent
	grass_block0 grass_block1 grass_block2 grass_block3 grass_block4 grass_block5 grass_block6 grass_block7 grass_block8 grass_block9 grass_block10 grass_block11 grass_block12 grass_block13 grass_block14 grass_block15 grass_block16 grass_block17 grass_block18 grass_block19 grass_block20 grass_block21 grass_block22 grass_block23 grass_block24 grass_block25 grass_block26 grass_block27 grass_block28 grass_block29 grass_block30 grass_block31 grass_block32 grass_block33 grass_block34 grass_block35 grass_block36 grass_block37 grass_block38 grass_block39 grass_block40 grass_block41 grass_block42 grass_block43 grass_block44 grass_block45 grass_block46 grass_block47 grass_block48 grass_block49 grass_block50 grass_block51 grass_block52 grass_block53 grass_block54 grass_block55 grass_block56 grass_block57 grass_block58 grass_block59 grass_block60 grass_block61 grass_block62 grass_block63 grass_block64 grass_block65 grass_block66 grass_block67 grass_block68 grass_block69 grass_block70 grass_block71 grass_block72 grass_block73 grass_block74 grass_block75 grass_block76 grass_block77 grass_block78 grass_block79 grass_block80 grass_block81 grass_block82 grass_block83 grass_block84 grass_block85 grass_block86 grass_block87 grass_block88 grass_block89 grass_block90 grass_block91 grass_block92 grass_block93 grass_block94 grass_block95 grass_block96 grass_block97 grass_block98 grass_block99 grass_block100 grass_block101 grass_block102 grass_block103 grass_block104 grass_block105 grass_block106 grass_block107 grass_block108 grass_block109 grass_block110 grass_block111 grass_block112 grass_block113 grass_block114 grass_block115 grass_block116 grass_block117 grass_block118 grass_block119 grass_block120 grass_block121 grass_block122 grass_block123 grass_block124 grass_block125 grass_block126 grass_block127 grass_block128 grass_block129 grass_block130 grass_block131 grass_block132 grass_block133 grass_block134 grass_block135 grass_block136 grass_block137 grass_block138 grass_block139 grass_block140 grass_block141 grass_block142 grass_block143 grass_block144 grass_block145 grass_block146 grass_block147 grass_block148 grass_block149 grass_block150 grass_block151 grass_block152 grass_block153 grass_block154 grass_block155 grass_block156 grass_block157 grass_block158 grass_block159 - grass_block
	grass_block-block0 grass_block-block1 grass_block-block2 grass_block-block3 grass_block-block4 grass_block-block5 grass_block-block6 grass_block-block7 grass_block-block8 grass_block-block9 grass_block-block10 grass_block-block11 grass_block-block12 grass_block-block13 grass_block-block14 grass_block-block15 grass_block-block16 grass_block-block17 grass_block-block18 grass_block-block19 grass_block-block20 grass_block-block21 grass_block-block22 grass_block-block23 grass_block-block24 grass_block-block25 grass_block-block26 grass_block-block27 grass_block-block28 grass_block-block29 grass_block-block30 grass_block-block31 grass_block-block32 grass_block-block33 grass_block-block34 grass_block-block35 grass_block-block36 grass_block-block37 grass_block-block38 grass_block-block39 grass_block-block40 grass_block-block41 grass_block-block42 grass_block-block43 grass_block-block44 grass_block-block45 grass_block-block46 grass_block-block47 grass_block-block48 grass_block-block49 grass_block-block50 grass_block-block51 grass_block-block52 grass_block-block53 grass_block-block54 grass_block-block55 grass_block-block56 grass_block-block57 grass_block-block58 grass_block-block59 grass_block-block60 grass_block-block61 grass_block-block62 grass_block-block63 grass_block-block64 grass_block-block65 grass_block-block66 grass_block-block67 grass_block-block68 grass_block-block69 grass_block-block70 grass_block-block71 grass_block-block72 grass_block-block73 grass_block-block74 grass_block-block75 grass_block-block76 grass_block-block77 grass_block-block78 grass_block-block79 grass_block-block80 grass_block-block81 grass_block-block82 grass_block-block83 grass_block-block84 grass_block-block85 grass_block-block86 grass_block-block87 grass_block-block88 grass_block-block89 grass_block-block90 grass_block-block91 grass_block-block92 grass_block-block93 grass_block-block94 grass_block-block95 grass_block-block96 grass_block-block97 grass_block-block98 grass_block-block99 grass_block-block100 grass_block-block101 grass_block-block102 grass_block-block103 grass_block-block104 grass_block-block105 grass_block-block106 grass_block-block107 grass_block-block108 grass_block-block109 grass_block-block110 grass_block-block111 grass_block-block112 grass_block-block113 grass_block-block114 grass_block-block115 grass_block-block116 grass_block-block117 grass_block-block118 grass_block-block119 grass_block-block120 grass_block-block121 grass_block-block122 grass_block-block123 grass_block-block124 grass_block-block125 grass_block-block126 grass_block-block127 grass_block-block128 grass_block-block129 grass_block-block130 grass_block-block131 grass_block-block132 grass_block-block133 grass_block-block134 grass_block-block135 grass_block-block136 grass_block-block137 grass_block-block138 grass_block-block139 grass_block-block140 grass_block-block141 grass_block-block142 grass_block-block143 grass_block-block144 grass_block-block145 grass_block-block146 grass_block-block147 grass_block-block148 grass_block-block149 grass_block-block150 grass_block-block151 grass_block-block152 grass_block-block153 grass_block-block154 grass_block-block155 grass_block-block156 grass_block-block157 grass_block-block158 grass_block-block159 - grass_block-block
)
(:init
	(agent-alive steve)
	(not (goal-achieved steve))
	(= (x steve) -80)
	(= (y steve) 4)
	(= (z steve) 0)
	(= (agent-num-grass_block steve) 0)
	(block-present grass_block-block0)
	(= (x grass_block-block0) -80)
	(= (y grass_block-block0) 3)
	(= (z grass_block-block0) 0)
	(= (block-hits grass_block-block0) 0)
	(block-present grass_block-block1)
	(= (x grass_block-block1) -79)
	(= (y grass_block-block1) 3)
	(= (z grass_block-block1) 0)
	(= (block-hits grass_block-block1) 0)
	(block-present grass_block-block2)
	(= (x grass_block-block2) -78)
	(= (y grass_block-block2) 3)
	(= (z grass_block-block2) 0)
	(= (block-hits grass_block-block2) 0)
	(block-present grass_block-block3)
	(= (x grass_block-block3) -77)
	(= (y grass_block-block3) 3)
	(= (z grass_block-block3) 0)
	(= (block-hits grass_block-block3) 0)
	(block-present grass_block-block4)
	(= (x grass_block-block4) -76)
	(= (y grass_block-block4) 3)
	(= (z grass_block-block4) 0)
	(= (block-hits grass_block-block4) 0)
	(block-present grass_block-block5)
	(= (x grass_block-block5) -75)
	(= (y grass_block-block5) 3)
	(= (z grass_block-block5) 0)
	(= (block-hits grass_block-block5) 0)
	(block-present grass_block-block6)
	(= (x grass_block-block6) -74)
	(= (y grass_block-block6) 3)
	(= (z grass_block-block6) 0)
	(= (block-hits grass_block-block6) 0)
	(block-present grass_block-block7)
	(= (x grass_block-block7) -73)
	(= (y grass_block-block7) 3)
	(= (z grass_block-block7) 0)
	(= (block-hits grass_block-block7) 0)
	(block-present grass_block-block8)
	(= (x grass_block-block8) -72)
	(= (y grass_block-block8) 3)
	(= (z grass_block-block8) 0)
	(= (block-hits grass_block-block8) 0)
	(block-present grass_block-block9)
	(= (x grass_block-block9) -71)
	(= (y grass_block-block9) 3)
	(= (z grass_block-block9) 0)
	(= (block-hits grass_block-block9) 0)
	(block-present grass_block-block10)
	(= (x grass_block-block10) -70)
	(= (y grass_block-block10) 3)
	(= (z grass_block-block10) 0)
	(= (block-hits grass_block-block10) 0)
	(block-present grass_block-block11)
	(= (x grass_block-block11) -69)
	(= (y grass_block-block11) 3)
	(= (z grass_block-block11) 0)
	(= (block-hits grass_block-block11) 0)
	(block-present grass_block-block12)
	(= (x grass_block-block12) -68)
	(= (y grass_block-block12) 3)
	(= (z grass_block-block12) 0)
	(= (block-hits grass_block-block12) 0)
	(block-present grass_block-block13)
	(= (x grass_block-block13) -67)
	(= (y grass_block-block13) 3)
	(= (z grass_block-block13) 0)
	(= (block-hits grass_block-block13) 0)
	(block-present grass_block-block14)
	(= (x grass_block-block14) -66)
	(= (y grass_block-block14) 3)
	(= (z grass_block-block14) 0)
	(= (block-hits grass_block-block14) 0)
	(block-present grass_block-block15)
	(= (x grass_block-block15) -65)
	(= (y grass_block-block15) 3)
	(= (z grass_block-block15) 0)
	(= (block-hits grass_block-block15) 0)
	(block-present grass_block-block16)
	(= (x grass_block-block16) -64)
	(= (y grass_block-block16) 3)
	(= (z grass_block-block16) 0)
	(= (block-hits grass_block-block16) 0)
	(block-present grass_block-block17)
	(= (x grass_block-block17) -63)
	(= (y grass_block-block17) 3)
	(= (z grass_block-block17) 0)
	(= (block-hits grass_block-block17) 0)
	(block-present grass_block-block18)
	(= (x grass_block-block18) -62)
	(= (y grass_block-block18) 3)
	(= (z grass_block-block18) 0)
	(= (block-hits grass_block-block18) 0)
	(block-present grass_block-block19)
	(= (x grass_block-block19) -61)
	(= (y grass_block-block19) 3)
	(= (z grass_block-block19) 0)
	(= (block-hits grass_block-block19) 0)
	(block-present grass_block-block20)
	(= (x grass_block-block20) -60)
	(= (y grass_block-block20) 3)
	(= (z grass_block-block20) 0)
	(= (block-hits grass_block-block20) 0)
	(block-present grass_block-block21)
	(= (x grass_block-block21) -59)
	(= (y grass_block-block21) 3)
	(= (z grass_block-block21) 0)
	(= (block-hits grass_block-block21) 0)
	(block-present grass_block-block22)
	(= (x grass_block-block22) -58)
	(= (y grass_block-block22) 3)
	(= (z grass_block-block22) 0)
	(= (block-hits grass_block-block22) 0)
	(block-present grass_block-block23)
	(= (x grass_block-block23) -57)
	(= (y grass_block-block23) 3)
	(= (z grass_block-block23) 0)
	(= (block-hits grass_block-block23) 0)
	(block-present grass_block-block24)
	(= (x grass_block-block24) -56)
	(= (y grass_block-block24) 3)
	(= (z grass_block-block24) 0)
	(= (block-hits grass_block-block24) 0)
	(block-present grass_block-block25)
	(= (x grass_block-block25) -55)
	(= (y grass_block-block25) 3)
	(= (z grass_block-block25) 0)
	(= (block-hits grass_block-block25) 0)
	(block-present grass_block-block26)
	(= (x grass_block-block26) -54)
	(= (y grass_block-block26) 3)
	(= (z grass_block-block26) 0)
	(= (block-hits grass_block-block26) 0)
	(block-present grass_block-block27)
	(= (x grass_block-block27) -53)
	(= (y grass_block-block27) 3)
	(= (z grass_block-block27) 0)
	(= (block-hits grass_block-block27) 0)
	(block-present grass_block-block28)
	(= (x grass_block-block28) -52)
	(= (y grass_block-block28) 3)
	(= (z grass_block-block28) 0)
	(= (block-hits grass_block-block28) 0)
	(block-present grass_block-block29)
	(= (x grass_block-block29) -51)
	(= (y grass_block-block29) 3)
	(= (z grass_block-block29) 0)
	(= (block-hits grass_block-block29) 0)
	(block-present grass_block-block30)
	(= (x grass_block-block30) -50)
	(= (y grass_block-block30) 3)
	(= (z grass_block-block30) 0)
	(= (block-hits grass_block-block30) 0)
	(block-present grass_block-block31)
	(= (x grass_block-block31) -49)
	(= (y grass_block-block31) 3)
	(= (z grass_block-block31) 0)
	(= (block-hits grass_block-block31) 0)
	(block-present grass_block-block32)
	(= (x grass_block-block32) -48)
	(= (y grass_block-block32) 3)
	(= (z grass_block-block32) 0)
	(= (block-hits grass_block-block32) 0)
	(block-present grass_block-block33)
	(= (x grass_block-block33) -47)
	(= (y grass_block-block33) 3)
	(= (z grass_block-block33) 0)
	(= (block-hits grass_block-block33) 0)
	(block-present grass_block-block34)
	(= (x grass_block-block34) -46)
	(= (y grass_block-block34) 3)
	(= (z grass_block-block34) 0)
	(= (block-hits grass_block-block34) 0)
	(block-present grass_block-block35)
	(= (x grass_block-block35) -45)
	(= (y grass_block-block35) 3)
	(= (z grass_block-block35) 0)
	(= (block-hits grass_block-block35) 0)
	(block-present grass_block-block36)
	(= (x grass_block-block36) -44)
	(= (y grass_block-block36) 3)
	(= (z grass_block-block36) 0)
	(= (block-hits grass_block-block36) 0)
	(block-present grass_block-block37)
	(= (x grass_block-block37) -43)
	(= (y grass_block-block37) 3)
	(= (z grass_block-block37) 0)
	(= (block-hits grass_block-block37) 0)
	(block-present grass_block-block38)
	(= (x grass_block-block38) -42)
	(= (y grass_block-block38) 3)
	(= (z grass_block-block38) 0)
	(= (block-hits grass_block-block38) 0)
	(block-present grass_block-block39)
	(= (x grass_block-block39) -41)
	(= (y grass_block-block39) 3)
	(= (z grass_block-block39) 0)
	(= (block-hits grass_block-block39) 0)
	(block-present grass_block-block40)
	(= (x grass_block-block40) -40)
	(= (y grass_block-block40) 3)
	(= (z grass_block-block40) 0)
	(= (block-hits grass_block-block40) 0)
	(block-present grass_block-block41)
	(= (x grass_block-block41) -39)
	(= (y grass_block-block41) 3)
	(= (z grass_block-block41) 0)
	(= (block-hits grass_block-block41) 0)
	(block-present grass_block-block42)
	(= (x grass_block-block42) -38)
	(= (y grass_block-block42) 3)
	(= (z grass_block-block42) 0)
	(= (block-hits grass_block-block42) 0)
	(block-present grass_block-block43)
	(= (x grass_block-block43) -37)
	(= (y grass_block-block43) 3)
	(= (z grass_block-block43) 0)
	(= (block-hits grass_block-block43) 0)
	(block-present grass_block-block44)
	(= (x grass_block-block44) -36)
	(= (y grass_block-block44) 3)
	(= (z grass_block-block44) 0)
	(= (block-hits grass_block-block44) 0)
	(block-present grass_block-block45)
	(= (x grass_block-block45) -35)
	(= (y grass_block-block45) 3)
	(= (z grass_block-block45) 0)
	(= (block-hits grass_block-block45) 0)
	(block-present grass_block-block46)
	(= (x grass_block-block46) -34)
	(= (y grass_block-block46) 3)
	(= (z grass_block-block46) 0)
	(= (block-hits grass_block-block46) 0)
	(block-present grass_block-block47)
	(= (x grass_block-block47) -33)
	(= (y grass_block-block47) 3)
	(= (z grass_block-block47) 0)
	(= (block-hits grass_block-block47) 0)
	(block-present grass_block-block48)
	(= (x grass_block-block48) -32)
	(= (y grass_block-block48) 3)
	(= (z grass_block-block48) 0)
	(= (block-hits grass_block-block48) 0)
	(block-present grass_block-block49)
	(= (x grass_block-block49) -31)
	(= (y grass_block-block49) 3)
	(= (z grass_block-block49) 0)
	(= (block-hits grass_block-block49) 0)
	(block-present grass_block-block50)
	(= (x grass_block-block50) -30)
	(= (y grass_block-block50) 3)
	(= (z grass_block-block50) 0)
	(= (block-hits grass_block-block50) 0)
	(block-present grass_block-block51)
	(= (x grass_block-block51) -29)
	(= (y grass_block-block51) 3)
	(= (z grass_block-block51) 0)
	(= (block-hits grass_block-block51) 0)
	(block-present grass_block-block52)
	(= (x grass_block-block52) -28)
	(= (y grass_block-block52) 3)
	(= (z grass_block-block52) 0)
	(= (block-hits grass_block-block52) 0)
	(block-present grass_block-block53)
	(= (x grass_block-block53) -27)
	(= (y grass_block-block53) 3)
	(= (z grass_block-block53) 0)
	(= (block-hits grass_block-block53) 0)
	(block-present grass_block-block54)
	(= (x grass_block-block54) -26)
	(= (y grass_block-block54) 3)
	(= (z grass_block-block54) 0)
	(= (block-hits grass_block-block54) 0)
	(block-present grass_block-block55)
	(= (x grass_block-block55) -25)
	(= (y grass_block-block55) 3)
	(= (z grass_block-block55) 0)
	(= (block-hits grass_block-block55) 0)
	(block-present grass_block-block56)
	(= (x grass_block-block56) -24)
	(= (y grass_block-block56) 3)
	(= (z grass_block-block56) 0)
	(= (block-hits grass_block-block56) 0)
	(block-present grass_block-block57)
	(= (x grass_block-block57) -23)
	(= (y grass_block-block57) 3)
	(= (z grass_block-block57) 0)
	(= (block-hits grass_block-block57) 0)
	(block-present grass_block-block58)
	(= (x grass_block-block58) -22)
	(= (y grass_block-block58) 3)
	(= (z grass_block-block58) 0)
	(= (block-hits grass_block-block58) 0)
	(block-present grass_block-block59)
	(= (x grass_block-block59) -21)
	(= (y grass_block-block59) 3)
	(= (z grass_block-block59) 0)
	(= (block-hits grass_block-block59) 0)
	(block-present grass_block-block60)
	(= (x grass_block-block60) -20)
	(= (y grass_block-block60) 3)
	(= (z grass_block-block60) 0)
	(= (block-hits grass_block-block60) 0)
	(block-present grass_block-block61)
	(= (x grass_block-block61) -19)
	(= (y grass_block-block61) 3)
	(= (z grass_block-block61) 0)
	(= (block-hits grass_block-block61) 0)
	(block-present grass_block-block62)
	(= (x grass_block-block62) -18)
	(= (y grass_block-block62) 3)
	(= (z grass_block-block62) 0)
	(= (block-hits grass_block-block62) 0)
	(block-present grass_block-block63)
	(= (x grass_block-block63) -17)
	(= (y grass_block-block63) 3)
	(= (z grass_block-block63) 0)
	(= (block-hits grass_block-block63) 0)
	(block-present grass_block-block64)
	(= (x grass_block-block64) -16)
	(= (y grass_block-block64) 3)
	(= (z grass_block-block64) 0)
	(= (block-hits grass_block-block64) 0)
	(block-present grass_block-block65)
	(= (x grass_block-block65) -15)
	(= (y grass_block-block65) 3)
	(= (z grass_block-block65) 0)
	(= (block-hits grass_block-block65) 0)
	(block-present grass_block-block66)
	(= (x grass_block-block66) -14)
	(= (y grass_block-block66) 3)
	(= (z grass_block-block66) 0)
	(= (block-hits grass_block-block66) 0)
	(block-present grass_block-block67)
	(= (x grass_block-block67) -13)
	(= (y grass_block-block67) 3)
	(= (z grass_block-block67) 0)
	(= (block-hits grass_block-block67) 0)
	(block-present grass_block-block68)
	(= (x grass_block-block68) -12)
	(= (y grass_block-block68) 3)
	(= (z grass_block-block68) 0)
	(= (block-hits grass_block-block68) 0)
	(block-present grass_block-block69)
	(= (x grass_block-block69) -11)
	(= (y grass_block-block69) 3)
	(= (z grass_block-block69) 0)
	(= (block-hits grass_block-block69) 0)
	(block-present grass_block-block70)
	(= (x grass_block-block70) -10)
	(= (y grass_block-block70) 3)
	(= (z grass_block-block70) 0)
	(= (block-hits grass_block-block70) 0)
	(block-present grass_block-block71)
	(= (x grass_block-block71) -9)
	(= (y grass_block-block71) 3)
	(= (z grass_block-block71) 0)
	(= (block-hits grass_block-block71) 0)
	(block-present grass_block-block72)
	(= (x grass_block-block72) -8)
	(= (y grass_block-block72) 3)
	(= (z grass_block-block72) 0)
	(= (block-hits grass_block-block72) 0)
	(block-present grass_block-block73)
	(= (x grass_block-block73) -7)
	(= (y grass_block-block73) 3)
	(= (z grass_block-block73) 0)
	(= (block-hits grass_block-block73) 0)
	(block-present grass_block-block74)
	(= (x grass_block-block74) -6)
	(= (y grass_block-block74) 3)
	(= (z grass_block-block74) 0)
	(= (block-hits grass_block-block74) 0)
	(block-present grass_block-block75)
	(= (x grass_block-block75) -5)
	(= (y grass_block-block75) 3)
	(= (z grass_block-block75) 0)
	(= (block-hits grass_block-block75) 0)
	(block-present grass_block-block76)
	(= (x grass_block-block76) -4)
	(= (y grass_block-block76) 3)
	(= (z grass_block-block76) 0)
	(= (block-hits grass_block-block76) 0)
	(block-present grass_block-block77)
	(= (x grass_block-block77) -3)
	(= (y grass_block-block77) 3)
	(= (z grass_block-block77) 0)
	(= (block-hits grass_block-block77) 0)
	(block-present grass_block-block78)
	(= (x grass_block-block78) -2)
	(= (y grass_block-block78) 3)
	(= (z grass_block-block78) 0)
	(= (block-hits grass_block-block78) 0)
	(block-present grass_block-block79)
	(= (x grass_block-block79) -1)
	(= (y grass_block-block79) 3)
	(= (z grass_block-block79) 0)
	(= (block-hits grass_block-block79) 0)
	(block-present grass_block-block80)
	(= (x grass_block-block80) 0)
	(= (y grass_block-block80) 3)
	(= (z grass_block-block80) 0)
	(= (block-hits grass_block-block80) 0)
	(block-present grass_block-block81)
	(= (x grass_block-block81) 1)
	(= (y grass_block-block81) 3)
	(= (z grass_block-block81) 0)
	(= (block-hits grass_block-block81) 0)
	(block-present grass_block-block82)
	(= (x grass_block-block82) 2)
	(= (y grass_block-block82) 3)
	(= (z grass_block-block82) 0)
	(= (block-hits grass_block-block82) 0)
	(block-present grass_block-block83)
	(= (x grass_block-block83) 3)
	(= (y grass_block-block83) 3)
	(= (z grass_block-block83) 0)
	(= (block-hits grass_block-block83) 0)
	(block-present grass_block-block84)
	(= (x grass_block-block84) 4)
	(= (y grass_block-block84) 3)
	(= (z grass_block-block84) 0)
	(= (block-hits grass_block-block84) 0)
	(block-present grass_block-block85)
	(= (x grass_block-block85) 5)
	(= (y grass_block-block85) 3)
	(= (z grass_block-block85) 0)
	(= (block-hits grass_block-block85) 0)
	(block-present grass_block-block86)
	(= (x grass_block-block86) 6)
	(= (y grass_block-block86) 3)
	(= (z grass_block-block86) 0)
	(= (block-hits grass_block-block86) 0)
	(block-present grass_block-block87)
	(= (x grass_block-block87) 7)
	(= (y grass_block-block87) 3)
	(= (z grass_block-block87) 0)
	(= (block-hits grass_block-block87) 0)
	(block-present grass_block-block88)
	(= (x grass_block-block88) 8)
	(= (y grass_block-block88) 3)
	(= (z grass_block-block88) 0)
	(= (block-hits grass_block-block88) 0)
	(block-present grass_block-block89)
	(= (x grass_block-block89) 9)
	(= (y grass_block-block89) 3)
	(= (z grass_block-block89) 0)
	(= (block-hits grass_block-block89) 0)
	(block-present grass_block-block90)
	(= (x grass_block-block90) 10)
	(= (y grass_block-block90) 3)
	(= (z grass_block-block90) 0)
	(= (block-hits grass_block-block90) 0)
	(block-present grass_block-block91)
	(= (x grass_block-block91) 11)
	(= (y grass_block-block91) 3)
	(= (z grass_block-block91) 0)
	(= (block-hits grass_block-block91) 0)
	(block-present grass_block-block92)
	(= (x grass_block-block92) 12)
	(= (y grass_block-block92) 3)
	(= (z grass_block-block92) 0)
	(= (block-hits grass_block-block92) 0)
	(block-present grass_block-block93)
	(= (x grass_block-block93) 13)
	(= (y grass_block-block93) 3)
	(= (z grass_block-block93) 0)
	(= (block-hits grass_block-block93) 0)
	(block-present grass_block-block94)
	(= (x grass_block-block94) 14)
	(= (y grass_block-block94) 3)
	(= (z grass_block-block94) 0)
	(= (block-hits grass_block-block94) 0)
	(block-present grass_block-block95)
	(= (x grass_block-block95) 15)
	(= (y grass_block-block95) 3)
	(= (z grass_block-block95) 0)
	(= (block-hits grass_block-block95) 0)
	(block-present grass_block-block96)
	(= (x grass_block-block96) 16)
	(= (y grass_block-block96) 3)
	(= (z grass_block-block96) 0)
	(= (block-hits grass_block-block96) 0)
	(block-present grass_block-block97)
	(= (x grass_block-block97) 17)
	(= (y grass_block-block97) 3)
	(= (z grass_block-block97) 0)
	(= (block-hits grass_block-block97) 0)
	(block-present grass_block-block98)
	(= (x grass_block-block98) 18)
	(= (y grass_block-block98) 3)
	(= (z grass_block-block98) 0)
	(= (block-hits grass_block-block98) 0)
	(block-present grass_block-block99)
	(= (x grass_block-block99) 19)
	(= (y grass_block-block99) 3)
	(= (z grass_block-block99) 0)
	(= (block-hits grass_block-block99) 0)
	(block-present grass_block-block100)
	(= (x grass_block-block100) 20)
	(= (y grass_block-block100) 3)
	(= (z grass_block-block100) 0)
	(= (block-hits grass_block-block100) 0)
	(block-present grass_block-block101)
	(= (x grass_block-block101) 21)
	(= (y grass_block-block101) 3)
	(= (z grass_block-block101) 0)
	(= (block-hits grass_block-block101) 0)
	(block-present grass_block-block102)
	(= (x grass_block-block102) 22)
	(= (y grass_block-block102) 3)
	(= (z grass_block-block102) 0)
	(= (block-hits grass_block-block102) 0)
	(block-present grass_block-block103)
	(= (x grass_block-block103) 23)
	(= (y grass_block-block103) 3)
	(= (z grass_block-block103) 0)
	(= (block-hits grass_block-block103) 0)
	(block-present grass_block-block104)
	(= (x grass_block-block104) 24)
	(= (y grass_block-block104) 3)
	(= (z grass_block-block104) 0)
	(= (block-hits grass_block-block104) 0)
	(block-present grass_block-block105)
	(= (x grass_block-block105) 25)
	(= (y grass_block-block105) 3)
	(= (z grass_block-block105) 0)
	(= (block-hits grass_block-block105) 0)
	(block-present grass_block-block106)
	(= (x grass_block-block106) 26)
	(= (y grass_block-block106) 3)
	(= (z grass_block-block106) 0)
	(= (block-hits grass_block-block106) 0)
	(block-present grass_block-block107)
	(= (x grass_block-block107) 27)
	(= (y grass_block-block107) 3)
	(= (z grass_block-block107) 0)
	(= (block-hits grass_block-block107) 0)
	(block-present grass_block-block108)
	(= (x grass_block-block108) 28)
	(= (y grass_block-block108) 3)
	(= (z grass_block-block108) 0)
	(= (block-hits grass_block-block108) 0)
	(block-present grass_block-block109)
	(= (x grass_block-block109) 29)
	(= (y grass_block-block109) 3)
	(= (z grass_block-block109) 0)
	(= (block-hits grass_block-block109) 0)
	(block-present grass_block-block110)
	(= (x grass_block-block110) 30)
	(= (y grass_block-block110) 3)
	(= (z grass_block-block110) 0)
	(= (block-hits grass_block-block110) 0)
	(block-present grass_block-block111)
	(= (x grass_block-block111) 31)
	(= (y grass_block-block111) 3)
	(= (z grass_block-block111) 0)
	(= (block-hits grass_block-block111) 0)
	(block-present grass_block-block112)
	(= (x grass_block-block112) 32)
	(= (y grass_block-block112) 3)
	(= (z grass_block-block112) 0)
	(= (block-hits grass_block-block112) 0)
	(block-present grass_block-block113)
	(= (x grass_block-block113) 33)
	(= (y grass_block-block113) 3)
	(= (z grass_block-block113) 0)
	(= (block-hits grass_block-block113) 0)
	(block-present grass_block-block114)
	(= (x grass_block-block114) 34)
	(= (y grass_block-block114) 3)
	(= (z grass_block-block114) 0)
	(= (block-hits grass_block-block114) 0)
	(block-present grass_block-block115)
	(= (x grass_block-block115) 35)
	(= (y grass_block-block115) 3)
	(= (z grass_block-block115) 0)
	(= (block-hits grass_block-block115) 0)
	(block-present grass_block-block116)
	(= (x grass_block-block116) 36)
	(= (y grass_block-block116) 3)
	(= (z grass_block-block116) 0)
	(= (block-hits grass_block-block116) 0)
	(block-present grass_block-block117)
	(= (x grass_block-block117) 37)
	(= (y grass_block-block117) 3)
	(= (z grass_block-block117) 0)
	(= (block-hits grass_block-block117) 0)
	(block-present grass_block-block118)
	(= (x grass_block-block118) 38)
	(= (y grass_block-block118) 3)
	(= (z grass_block-block118) 0)
	(= (block-hits grass_block-block118) 0)
	(block-present grass_block-block119)
	(= (x grass_block-block119) 39)
	(= (y grass_block-block119) 3)
	(= (z grass_block-block119) 0)
	(= (block-hits grass_block-block119) 0)
	(block-present grass_block-block120)
	(= (x grass_block-block120) 40)
	(= (y grass_block-block120) 3)
	(= (z grass_block-block120) 0)
	(= (block-hits grass_block-block120) 0)
	(block-present grass_block-block121)
	(= (x grass_block-block121) 41)
	(= (y grass_block-block121) 3)
	(= (z grass_block-block121) 0)
	(= (block-hits grass_block-block121) 0)
	(block-present grass_block-block122)
	(= (x grass_block-block122) 42)
	(= (y grass_block-block122) 3)
	(= (z grass_block-block122) 0)
	(= (block-hits grass_block-block122) 0)
	(block-present grass_block-block123)
	(= (x grass_block-block123) 43)
	(= (y grass_block-block123) 3)
	(= (z grass_block-block123) 0)
	(= (block-hits grass_block-block123) 0)
	(block-present grass_block-block124)
	(= (x grass_block-block124) 44)
	(= (y grass_block-block124) 3)
	(= (z grass_block-block124) 0)
	(= (block-hits grass_block-block124) 0)
	(block-present grass_block-block125)
	(= (x grass_block-block125) 45)
	(= (y grass_block-block125) 3)
	(= (z grass_block-block125) 0)
	(= (block-hits grass_block-block125) 0)
	(block-present grass_block-block126)
	(= (x grass_block-block126) 46)
	(= (y grass_block-block126) 3)
	(= (z grass_block-block126) 0)
	(= (block-hits grass_block-block126) 0)
	(block-present grass_block-block127)
	(= (x grass_block-block127) 47)
	(= (y grass_block-block127) 3)
	(= (z grass_block-block127) 0)
	(= (block-hits grass_block-block127) 0)
	(block-present grass_block-block128)
	(= (x grass_block-block128) 48)
	(= (y grass_block-block128) 3)
	(= (z grass_block-block128) 0)
	(= (block-hits grass_block-block128) 0)
	(block-present grass_block-block129)
	(= (x grass_block-block129) 49)
	(= (y grass_block-block129) 3)
	(= (z grass_block-block129) 0)
	(= (block-hits grass_block-block129) 0)
	(block-present grass_block-block130)
	(= (x grass_block-block130) 50)
	(= (y grass_block-block130) 3)
	(= (z grass_block-block130) 0)
	(= (block-hits grass_block-block130) 0)
	(block-present grass_block-block131)
	(= (x grass_block-block131) 51)
	(= (y grass_block-block131) 3)
	(= (z grass_block-block131) 0)
	(= (block-hits grass_block-block131) 0)
	(block-present grass_block-block132)
	(= (x grass_block-block132) 52)
	(= (y grass_block-block132) 3)
	(= (z grass_block-block132) 0)
	(= (block-hits grass_block-block132) 0)
	(block-present grass_block-block133)
	(= (x grass_block-block133) 53)
	(= (y grass_block-block133) 3)
	(= (z grass_block-block133) 0)
	(= (block-hits grass_block-block133) 0)
	(block-present grass_block-block134)
	(= (x grass_block-block134) 54)
	(= (y grass_block-block134) 3)
	(= (z grass_block-block134) 0)
	(= (block-hits grass_block-block134) 0)
	(block-present grass_block-block135)
	(= (x grass_block-block135) 55)
	(= (y grass_block-block135) 3)
	(= (z grass_block-block135) 0)
	(= (block-hits grass_block-block135) 0)
	(block-present grass_block-block136)
	(= (x grass_block-block136) 56)
	(= (y grass_block-block136) 3)
	(= (z grass_block-block136) 0)
	(= (block-hits grass_block-block136) 0)
	(block-present grass_block-block137)
	(= (x grass_block-block137) 57)
	(= (y grass_block-block137) 3)
	(= (z grass_block-block137) 0)
	(= (block-hits grass_block-block137) 0)
	(block-present grass_block-block138)
	(= (x grass_block-block138) 58)
	(= (y grass_block-block138) 3)
	(= (z grass_block-block138) 0)
	(= (block-hits grass_block-block138) 0)
	(block-present grass_block-block139)
	(= (x grass_block-block139) 59)
	(= (y grass_block-block139) 3)
	(= (z grass_block-block139) 0)
	(= (block-hits grass_block-block139) 0)
	(block-present grass_block-block140)
	(= (x grass_block-block140) 60)
	(= (y grass_block-block140) 3)
	(= (z grass_block-block140) 0)
	(= (block-hits grass_block-block140) 0)
	(block-present grass_block-block141)
	(= (x grass_block-block141) 61)
	(= (y grass_block-block141) 3)
	(= (z grass_block-block141) 0)
	(= (block-hits grass_block-block141) 0)
	(block-present grass_block-block142)
	(= (x grass_block-block142) 62)
	(= (y grass_block-block142) 3)
	(= (z grass_block-block142) 0)
	(= (block-hits grass_block-block142) 0)
	(block-present grass_block-block143)
	(= (x grass_block-block143) 63)
	(= (y grass_block-block143) 3)
	(= (z grass_block-block143) 0)
	(= (block-hits grass_block-block143) 0)
	(block-present grass_block-block144)
	(= (x grass_block-block144) 64)
	(= (y grass_block-block144) 3)
	(= (z grass_block-block144) 0)
	(= (block-hits grass_block-block144) 0)
	(block-present grass_block-block145)
	(= (x grass_block-block145) 65)
	(= (y grass_block-block145) 3)
	(= (z grass_block-block145) 0)
	(= (block-hits grass_block-block145) 0)
	(block-present grass_block-block146)
	(= (x grass_block-block146) 66)
	(= (y grass_block-block146) 3)
	(= (z grass_block-block146) 0)
	(= (block-hits grass_block-block146) 0)
	(block-present grass_block-block147)
	(= (x grass_block-block147) 67)
	(= (y grass_block-block147) 3)
	(= (z grass_block-block147) 0)
	(= (block-hits grass_block-block147) 0)
	(block-present grass_block-block148)
	(= (x grass_block-block148) 68)
	(= (y grass_block-block148) 3)
	(= (z grass_block-block148) 0)
	(= (block-hits grass_block-block148) 0)
	(block-present grass_block-block149)
	(= (x grass_block-block149) 69)
	(= (y grass_block-block149) 3)
	(= (z grass_block-block149) 0)
	(= (block-hits grass_block-block149) 0)
	(block-present grass_block-block150)
	(= (x grass_block-block150) 70)
	(= (y grass_block-block150) 3)
	(= (z grass_block-block150) 0)
	(= (block-hits grass_block-block150) 0)
	(block-present grass_block-block151)
	(= (x grass_block-block151) 71)
	(= (y grass_block-block151) 3)
	(= (z grass_block-block151) 0)
	(= (block-hits grass_block-block151) 0)
	(block-present grass_block-block152)
	(= (x grass_block-block152) 72)
	(= (y grass_block-block152) 3)
	(= (z grass_block-block152) 0)
	(= (block-hits grass_block-block152) 0)
	(block-present grass_block-block153)
	(= (x grass_block-block153) 73)
	(= (y grass_block-block153) 3)
	(= (z grass_block-block153) 0)
	(= (block-hits grass_block-block153) 0)
	(block-present grass_block-block154)
	(= (x grass_block-block154) 74)
	(= (y grass_block-block154) 3)
	(= (z grass_block-block154) 0)
	(= (block-hits grass_block-block154) 0)
	(block-present grass_block-block155)
	(= (x grass_block-block155) 75)
	(= (y grass_block-block155) 3)
	(= (z grass_block-block155) 0)
	(= (block-hits grass_block-block155) 0)
	(block-present grass_block-block156)
	(= (x grass_block-block156) 76)
	(= (y grass_block-block156) 3)
	(= (z grass_block-block156) 0)
	(= (block-hits grass_block-block156) 0)
	(block-present grass_block-block157)
	(= (x grass_block-block157) 77)
	(= (y grass_block-block157) 3)
	(= (z grass_block-block157) 0)
	(= (block-hits grass_block-block157) 0)
	(block-present grass_block-block158)
	(= (x grass_block-block158) 78)
	(= (y grass_block-block158) 3)
	(= (z grass_block-block158) 0)
	(= (block-hits grass_block-block158) 0)
	(block-present grass_block-block159)
	(= (x grass_block-block159) 79)
	(= (y grass_block-block159) 3)
	(= (z grass_block-block159) 0)
	(= (block-hits grass_block-block159) 0)
)
(:goal
	(and (goal-achieved steve))
		
)
)