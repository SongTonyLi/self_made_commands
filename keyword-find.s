	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 0
	.globl	_my_strcasestr                  ; -- Begin function my_strcasestr
	.p2align	2
_my_strcasestr:                         ; @my_strcasestr
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-24]
	ldur	x8, [x29, #-24]
	ldrb	w8, [x8]
	subs	w8, w8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB0_2
	b	LBB0_1
LBB0_1:
	ldur	x8, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB0_19
LBB0_2:
	b	LBB0_3
LBB0_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_6 Depth 2
	ldur	x8, [x29, #-16]
	ldrb	w8, [x8]
	subs	w8, w8, #0
	cset	w8, eq
	tbnz	w8, #0, LBB0_18
	b	LBB0_4
LBB0_4:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldur	x8, [x29, #-16]
	ldrb	w0, [x8]
	bl	_tolower
	str	w0, [sp, #20]                   ; 4-byte Folded Spill
	ldur	x8, [x29, #-24]
	ldrb	w0, [x8]
	bl	_tolower
	mov	x8, x0
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	subs	w8, w0, w8
	cset	w8, ne
	tbnz	w8, #0, LBB0_16
	b	LBB0_5
LBB0_5:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldur	x8, [x29, #-16]
	str	x8, [sp, #32]
	ldur	x8, [x29, #-24]
	str	x8, [sp, #24]
	b	LBB0_6
LBB0_6:                                 ;   Parent Loop BB0_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x8, [sp, #32]
	ldrsb	w8, [x8]
	subs	w8, w8, #0
	cset	w8, eq
	mov	w9, #0
	str	w9, [sp, #16]                   ; 4-byte Folded Spill
	tbnz	w8, #0, LBB0_8
	b	LBB0_7
LBB0_7:                                 ;   in Loop: Header=BB0_6 Depth=2
	ldr	x8, [sp, #24]
	ldrsb	w8, [x8]
	subs	w8, w8, #0
	cset	w8, ne
	str	w8, [sp, #16]                   ; 4-byte Folded Spill
	b	LBB0_8
LBB0_8:                                 ;   in Loop: Header=BB0_6 Depth=2
	ldr	w8, [sp, #16]                   ; 4-byte Folded Reload
	tbz	w8, #0, LBB0_13
	b	LBB0_9
LBB0_9:                                 ;   in Loop: Header=BB0_6 Depth=2
	ldr	x8, [sp, #32]
	ldrb	w0, [x8]
	bl	_tolower
	str	w0, [sp, #12]                   ; 4-byte Folded Spill
	ldr	x8, [sp, #24]
	ldrb	w0, [x8]
	bl	_tolower
	mov	x8, x0
	ldr	w0, [sp, #12]                   ; 4-byte Folded Reload
	subs	w8, w0, w8
	cset	w8, eq
	tbnz	w8, #0, LBB0_11
	b	LBB0_10
LBB0_10:                                ;   in Loop: Header=BB0_3 Depth=1
	b	LBB0_13
LBB0_11:                                ;   in Loop: Header=BB0_6 Depth=2
	b	LBB0_12
LBB0_12:                                ;   in Loop: Header=BB0_6 Depth=2
	ldr	x8, [sp, #32]
	add	x8, x8, #1
	str	x8, [sp, #32]
	ldr	x8, [sp, #24]
	add	x8, x8, #1
	str	x8, [sp, #24]
	b	LBB0_6
LBB0_13:                                ;   in Loop: Header=BB0_3 Depth=1
	ldr	x8, [sp, #24]
	ldrb	w8, [x8]
	subs	w8, w8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB0_15
	b	LBB0_14
LBB0_14:
	ldur	x8, [x29, #-16]
	stur	x8, [x29, #-8]
	b	LBB0_19
LBB0_15:                                ;   in Loop: Header=BB0_3 Depth=1
	b	LBB0_16
LBB0_16:                                ;   in Loop: Header=BB0_3 Depth=1
	b	LBB0_17
LBB0_17:                                ;   in Loop: Header=BB0_3 Depth=1
	ldur	x8, [x29, #-16]
	add	x8, x8, #1
	stur	x8, [x29, #-16]
	b	LBB0_3
LBB0_18:
                                        ; kill: def $x8 killed $xzr
	stur	xzr, [x29, #-8]
	b	LBB0_19
LBB0_19:
	ldur	x0, [x29, #-8]
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_print_with_highlight           ; -- Begin function print_with_highlight
	.p2align	2
_print_with_highlight:                  ; @print_with_highlight
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	ldur	x8, [x29, #-8]
	stur	x8, [x29, #-24]
	ldur	x0, [x29, #-16]
	bl	_strlen
	str	x0, [sp, #32]
	b	LBB1_1
LBB1_1:                                 ; =>This Inner Loop Header: Depth=1
	ldur	x0, [x29, #-24]
	ldur	x1, [x29, #-16]
	bl	_my_strcasestr
	str	x0, [sp, #24]
	ldr	x8, [sp, #24]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB1_3
	b	LBB1_2
LBB1_2:
	ldur	x8, [x29, #-24]
	mov	x9, sp
	str	x8, [x9]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	b	LBB1_4
LBB1_3:                                 ;   in Loop: Header=BB1_1 Depth=1
	ldr	x8, [sp, #24]
	ldur	x9, [x29, #-24]
	subs	x10, x8, x9
	ldur	x8, [x29, #-24]
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	ldr	x10, [sp, #32]
	ldr	x8, [sp, #24]
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	ldr	x8, [sp, #24]
	ldr	x9, [sp, #32]
	add	x8, x8, x9
	stur	x8, [x29, #-24]
	b	LBB1_1
LBB1_4:
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	bl	_printf
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_print_progress                 ; -- Begin function print_progress
	.p2align	2
_print_progress:                        ; @print_progress
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	ldr	x0, [x8]
	adrp	x8, _print_progress.idx@PAGE
	stur	x8, [x29, #-16]                 ; 8-byte Folded Spill
	ldrsw	x9, [x8, _print_progress.idx@PAGEOFF]
	adrp	x8, _print_progress.spinner@PAGE
	add	x8, x8, _print_progress.spinner@PAGEOFF
	ldrsb	w12, [x8, x9]
	adrp	x8, _processed_entries@PAGE
	ldr	w8, [x8, _processed_entries@PAGEOFF]
                                        ; implicit-def: $x10
	mov	x10, x8
	ldur	x8, [x29, #-8]
	mov	x9, sp
                                        ; implicit-def: $x11
	mov	x11, x12
	str	x11, [x9]
	str	x10, [x9, #8]
	str	x8, [x9, #16]
	adrp	x1, l_.str.4@PAGE
	add	x1, x1, l_.str.4@PAGEOFF
	bl	_fprintf
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	bl	_fflush
	ldur	x9, [x29, #-16]                 ; 8-byte Folded Reload
	ldr	w8, [x9, _print_progress.idx@PAGEOFF]
	add	w8, w8, #1
	mov	w11, #4
	sdiv	w10, w8, w11
	mul	w10, w10, w11
	subs	w8, w8, w10
	str	w8, [x9, _print_progress.idx@PAGEOFF]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_contains_keyword_case_insensitive ; -- Begin function contains_keyword_case_insensitive
	.p2align	2
_contains_keyword_case_insensitive:     ; @contains_keyword_case_insensitive
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-24]
	ldur	x0, [x29, #-16]
	bl	_strlen
	stur	x0, [x29, #-32]
	ldur	x0, [x29, #-24]
	bl	_strlen
	str	x0, [sp, #40]
	ldr	x8, [sp, #40]
	ldur	x9, [x29, #-32]
	subs	x8, x8, x9
	cset	w8, ls
	tbnz	w8, #0, LBB3_2
	b	LBB3_1
LBB3_1:
	mov	w8, #0
	and	w8, w8, #0x1
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
	b	LBB3_15
LBB3_2:
	str	xzr, [sp, #32]
	b	LBB3_3
LBB3_3:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB3_5 Depth 2
	ldr	x8, [sp, #32]
	ldur	x9, [x29, #-32]
	ldr	x10, [sp, #40]
	subs	x9, x9, x10
	subs	x8, x8, x9
	cset	w8, hi
	tbnz	w8, #0, LBB3_14
	b	LBB3_4
LBB3_4:                                 ;   in Loop: Header=BB3_3 Depth=1
	mov	w8, #1
	strb	w8, [sp, #31]
	str	xzr, [sp, #16]
	b	LBB3_5
LBB3_5:                                 ;   Parent Loop BB3_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	x8, [sp, #16]
	ldr	x9, [sp, #40]
	subs	x8, x8, x9
	cset	w8, hs
	tbnz	w8, #0, LBB3_10
	b	LBB3_6
LBB3_6:                                 ;   in Loop: Header=BB3_5 Depth=2
	ldur	x8, [x29, #-16]
	ldr	x9, [sp, #32]
	ldr	x10, [sp, #16]
	add	x9, x9, x10
	ldrb	w0, [x8, x9]
	bl	_tolower
	str	w0, [sp, #12]                   ; 4-byte Folded Spill
	ldur	x8, [x29, #-24]
	ldr	x9, [sp, #16]
	ldrb	w0, [x8, x9]
	bl	_tolower
	mov	x8, x0
	ldr	w0, [sp, #12]                   ; 4-byte Folded Reload
	subs	w8, w0, w8
	cset	w8, eq
	tbnz	w8, #0, LBB3_8
	b	LBB3_7
LBB3_7:                                 ;   in Loop: Header=BB3_3 Depth=1
	strb	wzr, [sp, #31]
	b	LBB3_10
LBB3_8:                                 ;   in Loop: Header=BB3_5 Depth=2
	b	LBB3_9
LBB3_9:                                 ;   in Loop: Header=BB3_5 Depth=2
	ldr	x8, [sp, #16]
	add	x8, x8, #1
	str	x8, [sp, #16]
	b	LBB3_5
LBB3_10:                                ;   in Loop: Header=BB3_3 Depth=1
	ldrb	w8, [sp, #31]
	tbz	w8, #0, LBB3_12
	b	LBB3_11
LBB3_11:
	mov	w8, #1
	and	w8, w8, #0x1
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
	b	LBB3_15
LBB3_12:                                ;   in Loop: Header=BB3_3 Depth=1
	b	LBB3_13
LBB3_13:                                ;   in Loop: Header=BB3_3 Depth=1
	ldr	x8, [sp, #32]
	add	x8, x8, #1
	str	x8, [sp, #32]
	b	LBB3_3
LBB3_14:
	mov	w8, #0
	and	w8, w8, #0x1
	and	w8, w8, #0x1
	sturb	w8, [x29, #-1]
	b	LBB3_15
LBB3_15:
	ldurb	w8, [x29, #-1]
	and	w0, w8, #0x1
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_contains_keyword               ; -- Begin function contains_keyword
	.p2align	2
_contains_keyword:                      ; @contains_keyword
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	ldr	x1, [sp]
	bl	_strstr
	subs	x8, x0, #0
	cset	w8, ne
	and	w0, w8, #0x1
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_iterate                        ; -- Begin function iterate
	.p2align	2
_iterate:                               ; @iterate
	.cfi_startproc
; %bb.0:
	stp	x28, x27, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	mov	w9, #8464
	adrp	x16, ___chkstk_darwin@GOTPAGE
	ldr	x16, [x16, ___chkstk_darwin@GOTPAGEOFF]
	blr	x16
	sub	sp, sp, #2, lsl #12             ; =8192
	sub	sp, sp, #272
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	str	x0, [sp, #248]
	str	x1, [sp, #240]
	mov	w8, #1
	and	w8, w2, w8
	strb	w8, [sp, #239]
	str	x3, [sp, #224]
	str	x4, [sp, #216]
	ldr	x8, [sp, #248]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB5_2
	b	LBB5_1
LBB5_1:
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	ldr	x8, [sp, #224]
	mov	x9, sp
	str	x8, [x9]
	adrp	x1, l_.str.5@PAGE
	add	x1, x1, l_.str.5@PAGEOFF
	bl	_fprintf
	mov	w8, #1
	str	w8, [sp, #260]
	b	LBB5_25
LBB5_2:
	b	LBB5_3
LBB5_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x0, [sp, #248]
	bl	_readdir
	mov	x8, x0
	str	x8, [sp, #208]
	subs	x8, x0, #0
	cset	w8, eq
	tbnz	w8, #0, LBB5_24
	b	LBB5_4
LBB5_4:                                 ;   in Loop: Header=BB5_3 Depth=1
	ldr	x8, [sp, #208]
	add	x8, x8, #21
	str	x8, [sp, #200]
	ldr	x0, [sp, #200]
	adrp	x1, l_.str.6@PAGE
	add	x1, x1, l_.str.6@PAGEOFF
	bl	_strcmp
	subs	w8, w0, #0
	cset	w8, eq
	tbnz	w8, #0, LBB5_6
	b	LBB5_5
LBB5_5:                                 ;   in Loop: Header=BB5_3 Depth=1
	ldr	x0, [sp, #200]
	adrp	x1, l_.str.7@PAGE
	add	x1, x1, l_.str.7@PAGEOFF
	bl	_strcmp
	subs	w8, w0, #0
	cset	w8, ne
	tbnz	w8, #0, LBB5_7
	b	LBB5_6
LBB5_6:                                 ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_3
LBB5_7:                                 ;   in Loop: Header=BB5_3 Depth=1
	adrp	x9, _processed_entries@PAGE
	ldr	w8, [x9, _processed_entries@PAGEOFF]
	add	w8, w8, #1
	str	w8, [x9, _processed_entries@PAGEOFF]
	ldr	x8, [sp, #216]
	ldr	x0, [x8, #8]
	bl	_print_progress
	ldr	x0, [sp, #200]
	ldr	x1, [sp, #240]
	bl	_contains_keyword_case_insensitive
	tbz	w0, #0, LBB5_12
	b	LBB5_8
LBB5_8:                                 ;   in Loop: Header=BB5_3 Depth=1
	ldr	x10, [sp, #224]
	ldr	x8, [sp, #200]
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	add	x0, sp, #1, lsl #12             ; =4096
	add	x0, x0, #264
	mov	x3, #4096
	mov	x1, x3
	mov	w2, #0
	adrp	x4, l_.str.8@PAGE
	add	x4, x4, l_.str.8@PAGEOFF
	bl	___snprintf_chk
                                        ; implicit-def: $x8
	mov	x8, x0
	sxtw	x8, w8
	str	x8, [sp, #192]
	ldr	x8, [sp, #192]
	subs	x8, x8, #1, lsl #12             ; =4096
	cset	w8, hs
	tbnz	w8, #0, LBB5_10
	b	LBB5_9
LBB5_9:                                 ;   in Loop: Header=BB5_3 Depth=1
	ldr	x0, [sp, #216]
	add	x1, sp, #1, lsl #12             ; =4096
	add	x1, x1, #264
	bl	_results_add
	b	LBB5_11
LBB5_10:                                ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_11
LBB5_11:                                ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_12
LBB5_12:                                ;   in Loop: Header=BB5_3 Depth=1
	ldrb	w8, [sp, #239]
	tbz	w8, #0, LBB5_23
	b	LBB5_13
LBB5_13:                                ;   in Loop: Header=BB5_3 Depth=1
	ldr	x10, [sp, #224]
	ldr	x8, [sp, #200]
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	add	x0, sp, #264
	mov	x3, #4096
	mov	x1, x3
	mov	w2, #0
	adrp	x4, l_.str.8@PAGE
	add	x4, x4, l_.str.8@PAGEOFF
	bl	___snprintf_chk
                                        ; implicit-def: $x8
	mov	x8, x0
	sxtw	x8, w8
	str	x8, [sp, #184]
	ldr	x8, [sp, #184]
	subs	x8, x8, #1, lsl #12             ; =4096
	cset	w8, lo
	tbnz	w8, #0, LBB5_15
	b	LBB5_14
LBB5_14:                                ;   in Loop: Header=BB5_3 Depth=1
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	ldr	x10, [sp, #224]
	ldr	x8, [sp, #200]
	mov	x9, sp
	str	x10, [x9]
	str	x8, [x9, #8]
	adrp	x1, l_.str.9@PAGE
	add	x1, x1, l_.str.9@PAGEOFF
	bl	_fprintf
	b	LBB5_3
LBB5_15:                                ;   in Loop: Header=BB5_3 Depth=1
	add	x0, sp, #264
	add	x1, sp, #40
	bl	_lstat
	subs	w8, w0, #0
	cset	w8, ne
	tbnz	w8, #0, LBB5_22
	b	LBB5_16
LBB5_16:                                ;   in Loop: Header=BB5_3 Depth=1
	ldrh	w8, [sp, #44]
	and	w8, w8, #0xf000
	subs	w8, w8, #4, lsl #12             ; =16384
	cset	w8, ne
	tbnz	w8, #0, LBB5_22
	b	LBB5_17
LBB5_17:                                ;   in Loop: Header=BB5_3 Depth=1
	ldrh	w8, [sp, #44]
	and	w8, w8, #0xf000
	subs	w8, w8, #10, lsl #12            ; =40960
	cset	w8, eq
	tbnz	w8, #0, LBB5_22
	b	LBB5_18
LBB5_18:                                ;   in Loop: Header=BB5_3 Depth=1
	add	x0, sp, #264
	bl	_opendir
	str	x0, [sp, #32]
	ldr	x8, [sp, #32]
	subs	x8, x8, #0
	cset	w8, eq
	tbnz	w8, #0, LBB5_20
	b	LBB5_19
LBB5_19:                                ;   in Loop: Header=BB5_3 Depth=1
	ldr	x0, [sp, #32]
	ldr	x1, [sp, #240]
	ldrb	w8, [sp, #239]
	ldr	x4, [sp, #216]
	and	w2, w8, #0x1
	add	x3, sp, #264
	bl	_iterate
	ldr	x0, [sp, #32]
	bl	_closedir
	b	LBB5_21
LBB5_20:                                ;   in Loop: Header=BB5_3 Depth=1
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	mov	x9, sp
	add	x8, sp, #264
	str	x8, [x9]
	adrp	x1, l_.str.10@PAGE
	add	x1, x1, l_.str.10@PAGEOFF
	bl	_fprintf
	b	LBB5_21
LBB5_21:                                ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_22
LBB5_22:                                ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_23
LBB5_23:                                ;   in Loop: Header=BB5_3 Depth=1
	b	LBB5_3
LBB5_24:
	str	wzr, [sp, #260]
	b	LBB5_25
LBB5_25:
	ldr	w8, [sp, #260]
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-24]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	subs	x8, x8, x9
	cset	w8, eq
	tbnz	w8, #0, LBB5_27
	b	LBB5_26
LBB5_26:
	bl	___stack_chk_fail
LBB5_27:
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	add	sp, sp, #2, lsl #12             ; =8192
	add	sp, sp, #272
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function results_add
_results_add:                           ; @results_add
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-16]
	stur	x1, [x29, #-24]
	ldur	x8, [x29, #-16]
	ldr	x8, [x8, #8]
	ldur	x9, [x29, #-16]
	ldr	x9, [x9, #16]
	subs	x8, x8, x9
	cset	w8, ne
	tbnz	w8, #0, LBB6_7
	b	LBB6_1
LBB6_1:
	ldur	x8, [x29, #-16]
	ldr	x8, [x8, #16]
	subs	x8, x8, #0
	cset	w8, eq
	tbnz	w8, #0, LBB6_3
	b	LBB6_2
LBB6_2:
	ldur	x8, [x29, #-16]
	ldr	x8, [x8, #16]
	lsl	x8, x8, #1
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	b	LBB6_4
LBB6_3:
	mov	x8, #64
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	b	LBB6_4
LBB6_4:
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp, #32]
	ldur	x8, [x29, #-16]
	ldr	x0, [x8]
	ldr	x8, [sp, #32]
	lsl	x1, x8, #3
	bl	_realloc
	str	x0, [sp, #24]
	ldr	x8, [sp, #24]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB6_6
	b	LBB6_5
LBB6_5:
	stur	wzr, [x29, #-4]
	b	LBB6_10
LBB6_6:
	ldr	x8, [sp, #24]
	ldur	x9, [x29, #-16]
	str	x8, [x9]
	ldr	x8, [sp, #32]
	ldur	x9, [x29, #-16]
	str	x8, [x9, #16]
	b	LBB6_7
LBB6_7:
	ldur	x0, [x29, #-24]
	bl	_strdup
	str	x0, [sp, #16]
	ldr	x8, [sp, #16]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB6_9
	b	LBB6_8
LBB6_8:
	stur	wzr, [x29, #-4]
	b	LBB6_10
LBB6_9:
	ldr	x8, [sp, #16]
	ldur	x9, [x29, #-16]
	ldr	x9, [x9]
	ldur	x12, [x29, #-16]
	ldr	x10, [x12, #8]
	add	x11, x10, #1
	str	x11, [x12, #8]
	str	x8, [x9, x10, lsl  #3]
	mov	w8, #1
	stur	w8, [x29, #-4]
	b	LBB6_10
LBB6_10:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, #112]            ; 16-byte Folded Spill
	add	x29, sp, #112
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, ___stderrp@GOTPAGE
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	stur	wzr, [x29, #-4]
	stur	w0, [x29, #-8]
	stur	x1, [x29, #-16]
	ldur	w8, [x29, #-8]
	subs	w8, w8, #2
	cset	w8, lt
	tbnz	w8, #0, LBB7_4
	b	LBB7_1
LBB7_1:
	ldur	w8, [x29, #-8]
	subs	w8, w8, #3
	cset	w8, gt
	tbnz	w8, #0, LBB7_4
	b	LBB7_2
LBB7_2:
	ldur	w8, [x29, #-8]
	subs	w8, w8, #3
	cset	w8, ne
	tbnz	w8, #0, LBB7_5
	b	LBB7_3
LBB7_3:
	ldur	x8, [x29, #-16]
	ldr	x0, [x8, #8]
	adrp	x1, l_.str.11@PAGE
	add	x1, x1, l_.str.11@PAGEOFF
	bl	_strcmp
	subs	w8, w0, #0
	cset	w8, eq
	tbnz	w8, #0, LBB7_5
	b	LBB7_4
LBB7_4:
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	ldur	x8, [x29, #-16]
	ldr	x8, [x8]
	mov	x9, sp
	str	x8, [x9]
	adrp	x1, l_.str.12@PAGE
	add	x1, x1, l_.str.12@PAGEOFF
	bl	_fprintf
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	adrp	x1, l_.str.13@PAGE
	add	x1, x1, l_.str.13@PAGEOFF
	bl	_fprintf
	mov	w8, #1
	stur	w8, [x29, #-4]
	b	LBB7_17
LBB7_5:
	sturb	wzr, [x29, #-25]
	ldur	w8, [x29, #-8]
	subs	w8, w8, #2
	cset	w8, ne
	tbnz	w8, #0, LBB7_7
	b	LBB7_6
LBB7_6:
	ldur	x8, [x29, #-16]
	ldr	x8, [x8, #8]
	stur	x8, [x29, #-24]
	b	LBB7_8
LBB7_7:
	mov	w8, #1
	sturb	w8, [x29, #-25]
	ldur	x8, [x29, #-16]
	ldr	x8, [x8, #16]
	stur	x8, [x29, #-24]
	b	LBB7_8
LBB7_8:
	adrp	x0, l_.str.6@PAGE
	add	x0, x0, l_.str.6@PAGEOFF
	bl	_opendir
	stur	x0, [x29, #-40]
	ldur	x8, [x29, #-40]
	subs	x8, x8, #0
	cset	w8, ne
	tbnz	w8, #0, LBB7_10
	b	LBB7_9
LBB7_9:
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	adrp	x1, l_.str.14@PAGE
	add	x1, x1, l_.str.14@PAGEOFF
	bl	_fprintf
	mov	w8, #1
	stur	w8, [x29, #-4]
	b	LBB7_17
LBB7_10:
	add	x0, sp, #48
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	bl	_results_init
	ldr	x4, [sp, #16]                   ; 8-byte Folded Reload
	ldur	x0, [x29, #-40]
	ldur	x1, [x29, #-24]
	ldurb	w8, [x29, #-25]
	and	w2, w8, #0x1
	adrp	x3, l_.str.6@PAGE
	add	x3, x3, l_.str.6@PAGEOFF
	bl	_iterate
	str	w0, [sp, #44]
	ldur	x0, [x29, #-40]
	bl	_closedir
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x0, [x8]
	adrp	x1, l_.str.3@PAGE
	add	x1, x1, l_.str.3@PAGEOFF
	bl	_fprintf
	ldr	x8, [sp, #56]
	subs	x8, x8, #1
	cset	w8, ls
	tbnz	w8, #0, LBB7_12
	b	LBB7_11
LBB7_11:
	ldr	x0, [sp, #48]
	ldr	x1, [sp, #56]
	mov	x2, #8
	adrp	x3, _compare_results@PAGE
	add	x3, x3, _compare_results@PAGEOFF
	bl	_qsort
	b	LBB7_12
LBB7_12:
	str	xzr, [sp, #32]
	b	LBB7_13
LBB7_13:                                ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #56]
	subs	x8, x8, x9
	cset	w8, hs
	tbnz	w8, #0, LBB7_16
	b	LBB7_14
LBB7_14:                                ;   in Loop: Header=BB7_13 Depth=1
	ldr	x8, [sp, #48]
	ldr	x9, [sp, #32]
	ldr	x0, [x8, x9, lsl  #3]
	ldur	x1, [x29, #-24]
	bl	_print_with_highlight
	b	LBB7_15
LBB7_15:                                ;   in Loop: Header=BB7_13 Depth=1
	ldr	x8, [sp, #32]
	add	x8, x8, #1
	str	x8, [sp, #32]
	b	LBB7_13
LBB7_16:
	add	x0, sp, #48
	bl	_results_free
	ldr	w8, [sp, #44]
	stur	w8, [x29, #-4]
	b	LBB7_17
LBB7_17:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #112]            ; 16-byte Folded Reload
	add	sp, sp, #128
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function results_init
_results_init:                          ; @results_init
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
                                        ; kill: def $x9 killed $xzr
	str	xzr, [x8]
	ldr	x8, [sp, #8]
	str	xzr, [x8, #8]
	ldr	x8, [sp, #8]
	str	xzr, [x8, #16]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function compare_results
_compare_results:                       ; @compare_results
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]
	ldr	x8, [sp, #16]
	str	x8, [sp]
	ldr	x8, [sp, #8]
	ldr	x0, [x8]
	ldr	x8, [sp]
	ldr	x1, [x8]
	bl	_strcmp
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function results_free
_results_free:                          ; @results_free
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	str	xzr, [sp]
	b	LBB10_1
LBB10_1:                                ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp]
	ldr	x9, [sp, #8]
	ldr	x9, [x9, #8]
	subs	x8, x8, x9
	cset	w8, hs
	tbnz	w8, #0, LBB10_4
	b	LBB10_2
LBB10_2:                                ;   in Loop: Header=BB10_1 Depth=1
	ldr	x8, [sp, #8]
	ldr	x8, [x8]
	ldr	x9, [sp]
	ldr	x0, [x8, x9, lsl  #3]
	bl	_free
	b	LBB10_3
LBB10_3:                                ;   in Loop: Header=BB10_1 Depth=1
	ldr	x8, [sp]
	add	x8, x8, #1
	str	x8, [sp]
	b	LBB10_1
LBB10_4:
	ldr	x8, [sp, #8]
	ldr	x0, [x8]
	bl	_free
	ldr	x8, [sp, #8]
                                        ; kill: def $x9 killed $xzr
	str	xzr, [x8]
	ldr	x8, [sp, #8]
	str	xzr, [x8, #8]
	ldr	x8, [sp, #8]
	str	xzr, [x8, #16]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_processed_entries              ; @processed_entries
.zerofill __DATA,__common,_processed_entries,4,2
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"%s"

l_.str.1:                               ; @.str.1
	.asciz	"%.*s"

l_.str.2:                               ; @.str.2
	.asciz	"\033[31m%.*s\033[0m"

l_.str.3:                               ; @.str.3
	.asciz	"\n"

	.section	__TEXT,__const
_print_progress.spinner:                ; @print_progress.spinner
	.asciz	"|/-\\"

.zerofill __DATA,__bss,_print_progress.idx,4,2 ; @print_progress.idx
	.section	__TEXT,__cstring,cstring_literals
l_.str.4:                               ; @.str.4
	.asciz	"\r%c Scanned %d entries | Found %zu matches"

l_.str.5:                               ; @.str.5
	.asciz	"Error: Could not open directory '%s'\n"

l_.str.6:                               ; @.str.6
	.asciz	"."

l_.str.7:                               ; @.str.7
	.asciz	".."

l_.str.8:                               ; @.str.8
	.asciz	"%s/%s"

l_.str.9:                               ; @.str.9
	.asciz	"Warning: Path too long, skipping: %s/%s\n"

l_.str.10:                              ; @.str.10
	.asciz	"Warning: Could not open directory: %s\n"

l_.str.11:                              ; @.str.11
	.asciz	"-r"

l_.str.12:                              ; @.str.12
	.asciz	"Usage: %s [-r] <keyword>\n"

l_.str.13:                              ; @.str.13
	.asciz	"  -r    Recursively search subdirectories\n"

l_.str.14:                              ; @.str.14
	.asciz	"Error: Could not open current directory\n"

.subsections_via_symbols
