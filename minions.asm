;-----------------------------------------
; Handles minions spawning and movement
;-----------------------------------------

spawn_minions:
	jsr randgen					; Generate random number
	lsr RANDNUM					; shift bit 0
	bcc spawn_laser_minion		; If even number generate enemy type 1
	bcs spawn_rocket_minion		; If odd number generate enemy type 2

spawn_laser_minion:
	ldx MINION_IND				; Get the current index
	lda #$01					; 01 represents laser
	sta minion_status ,x		; Save the status
	inx							; Increment the index
	stx MINION_IND				; Save the new index
	cpx #$04					; If not at the end of the index
	bne spawn_minions			; Keep spawning more minions
	rts

spawn_rocket_minion:
	ldx MINION_IND				; Get the current index
	lda #$02					; 02 represents rocket
	sta minion_status ,x		; Save the status
	inx							; Increment the index
	stx MINION_IND				; Save the new index
	cpx #$04					; If not at the end of the index
	bne spawn_minions
	rts


draw_minions:
	ldx MINION_IND				; Get the current minion index
	ldy minion_status ,x		; Get the minion status
	cpy #$01					; Is it laser minion?
	beq draw_laser_minion		; If so draw it
	cpy #$02					; Is it rocket minion?
	beq draw_rocket_minion		; Draw it
	bne end_draw_minion			; Otherwise dont draw a thing
draw_laser_minion:
	ldx MINION_IND				; Get the current minion index
	ldy minion_pos ,x			; Get the position of the minion
	lda #$0f					; Laser minion char
	sta $1e00 ,y				; At the location
	lda #$02
	sta $9600 ,y				; Color location
	jmp end_draw_minion			; Done drawing

draw_rocket_minion:
	ldx MINION_IND				; Get the current minion index
	ldy minion_pos ,x			; Get the position of the minion
	lda #$10					; Rocket minion char
	sta $1e00 ,y				; At the location
	lda #$05
	sta $9600 ,y				; Color location

end_draw_minion:
	inx							; Next minion
	stx MINION_IND				; store the new minion
	cpx #$04					; Are we done drawing minions?
	bne draw_minions			; If not keep drawing

	rts

minion_move_left:
	ldx MINION_IND
	ldy minion_pos ,x
	cpy #$6e
	beq minion_move_end
	cpy #$84
	beq minion_move_end
	cpy #$9a
	beq minion_move_end
	cpy #$b0
	beq minion_move_end
	cpy #$c6
	beq minion_move_end
	cpy #$dc
	beq minion_move_end

	dey
	sty minion_pos ,x
	jmp minion_move_end

minion_move_right:
	ldx MINION_IND
	ldy minion_pos ,x
	cpy #$6e
	beq minion_move_end
	cpy #$84
	beq minion_move_end
	cpy #$9a
	beq minion_move_end
	cpy #$b0
	beq minion_move_end
	cpy #$c6
	beq minion_move_end
	cpy #$dc
	beq minion_move_end

	iny
	sty minion_pos ,x

minion_move_end:
	inx
	stx MINION_IND

	cpx MINIONS
	bne minion_ai

	rts

minion_ai:
	jmp minion_move_left

	rts

