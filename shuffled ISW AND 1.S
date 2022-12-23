    .text
	.section	.rodata
	.align	2
.LC0:
	.word	238
	.word	74
	.word	95
	.word	215
	.word	68
	.word	222
	.word	28
	.word	187
	.align	2
.LC1:
	.word	42
	.word	77
	.word	95
	.word	174
	.word	197
	.word	173
	.word	110
	.word	203
	.align	2
.LC2:
	.word	31
	.word	186
	.word	185
	.word	133
	.word	97
	.word	66
	.word	236
	.word	8
	.word	224
	.word	124
	.word	254
	.word	124
	.word	178
	.word	111
	.word	137
	.word	97
	.word	173
	.word	145
	.word	58
	.word	86
	.word	12
	.word	42
	.word	238
	.word	135
	.word	39
	.word	129
	.word	172
	.word	214
	.word	3027

.macro chongfu 
	movtordind a3,x0,x0    #index a3
	li a2,128
	beq a3,a2,.L2
	srli	a2,a3,3   #y  a2
	slli	a3,a3,29  #x 	  a3
	srli	a3,a3,29  #x 	  a3

	li a5,4
	mul a5,a5,t1        #偏移
	lui	a6,%hi(.LC2)
	addi	a6,a6,%lo(.LC2) #r地址  a6
	add a6,a6,a5
	lw a4,0(a6)   #r a4

    li a5,4
	mul a5,a5,a3        #偏移
	lui	a6,%hi(.LC0)
	addi	a6,a6,%lo(.LC0) #x地址  a6
	add a6,a6,a5
	lw a6,0(a6)   #新x
	li a5,4
	mul a5,a5,a2        #偏移
	lui	a7,%hi(.LC1)
	addi	a7,a7,%lo(.LC1) #y地址  a7
	add a7,a7,a5
	lw a7,0(a7)   #新y
	and a6,a6,a7  #x&y存入a6
	xor a6,a6,a4  #x&y^r
	li a5,4
	mul a5,a5,a2        #偏移
	addi a5,a5,-224  #偏移    414:
	add a7,s0,a5
	lw a7,0(a7)   #xy a7
	xor a7,a7,a6  #x&y^r^xy = xy
	add a5,s0,a5
	sw a7,0(a5)   #xy写回
	#下面 y[]&x[]^xy
	li a5,4
	mul a5,a5,a2        #偏移
	lui	a6,%hi(.LC0)
	addi	a6,a6,%lo(.LC0) #取y值对应的x地址  a6
	add a6,a6,a5
	lw a6,0(a6)   #新x
	li a5,4
	mul a5,a5,a3        #偏移
	lui	a7,%hi(.LC1)
	addi	a7,a7,%lo(.LC1) #取x值对应的y地址  a7
	add a7,a7,a5
	lw a7,0(a7)   #新y    458:
	and a6,a6,a7  #x&y存入a6
	li a5,4
	mul a5,a5,a2        #偏移
	addi a5,a5,-224  #偏移
	add a7,s0,a5
	lw a7,0(a7)   #xy a7
	xor a7,a7,a6  #x&y^xy = xy
	add a5,s0,a5
	sw a7,0(a5)   #xy写回  47C
	#下面是对应x行^r
	li a5,4
	mul a5,a5,a3        #偏移
	addi a5,a5,-224 #偏移
	add a7,s0,a5
	lw a7,0(a7)   #xy a7
	xor a7,a7,a4  #xy^r = xy
	add a5,s0,a5
	sw a7,0(a5)   #xy写回
.endm
	.text
	.align	2
	.globl	shixian
	.type	shixian, @function
shixian:
	addi	sp,sp,-224
	sw	ra,220(sp)
	sw	s0,216(sp)
	addi	s0,sp,224
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-48(s0)
	sw	a6,-44(s0)
	sw	a0,-40(s0)
	sw	a1,-36(s0)
	sw	a2,-32(s0)
	sw	a3,-28(s0)
	sw	a4,-24(s0)
	sw	a5,-20(s0)
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-80(s0)
	sw	a6,-76(s0)
	sw	a0,-72(s0)
	sw	a1,-68(s0)
	sw	a2,-64(s0)
	sw	a3,-60(s0)
	sw	a4,-56(s0)
	sw	a5,-52(s0)

	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)

	lw	a7,0(a5)
	lw	a6,4(a5)
	lw	a0,8(a5)
	lw	a1,12(a5)
	lw	a2,16(a5)
	lw	a3,20(a5)
	lw	a4,24(a5)
	lw	a5,28(a5)
	sw	a7,-192(s0)
	sw	a6,-188(s0)
	sw	a0,-184(s0)
	sw	a1,-180(s0)
	sw	a2,-176(s0)
	sw	a3,-172(s0)
	sw	a4,-168(s0)
	sw	a5,-164(s0)
	
	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	lw	a7,32(a5)
	lw	a6,36(a5)
	lw	a0,40(a5)
	lw	a1,44(a5)
	lw	a2,48(a5)
	lw	a3,52(a5)
	lw	a4,56(a5)
	lw	a5,60(a5)
	sw	a7,-160(s0)
	sw	a6,-156(s0)
	sw	a0,-152(s0)
	sw	a1,-148(s0)
	sw	a2,-144(s0)
	sw	a3,-140(s0)
	sw	a4,-136(s0)
	sw	a5,-132(s0)

	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	lw	a7,64(a5)
	lw	a6,68(a5)
	lw	a0,72(a5)
	lw	a1,76(a5)
	lw	a2,80(a5)
	lw	a3,84(a5)
	lw	a4,88(a5)
	lw	a5,92(a5)
	sw	a7,-128(s0)
	sw	a6,-124(s0)
	sw	a0,-120(s0)
	sw	a1,-116(s0)
	sw	a2,-112(s0)
	sw	a3,-108(s0)
	sw	a4,-104(s0)
	sw	a5,-100(s0)

	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	lw	a7,96(a5)
	lw	a6,100(a5)
	lw	a0,104(a5)
	lw	a1,108(a5)
	sw	a7,-96(s0)
	sw	a6,-92(s0)
	sw	a0,-88(s0)
	sw	a1,-84(s0)

	addi a5,x0,0
    immtosh x0,a5,0   #第0个shuflle寄存器，写入的值8 1000 x0y1
	addi a5,x0,1
    immtosh x0,a5,1   #x0y2 
    addi a5,x0,2
    immtosh x0,a5,2 #x0y3
	addi a5,x0,3
    immtosh x0,a5,3 #x0y4
	addi a5,x0,4
    immtosh x0,a5,4 #x0y5
	addi a5,x0,5
    immtosh x0,a5,5  #x0y6
	addi a5,x0,6
    immtosh x0,a5,6 #x0y7
    addi a5,x0,7
    immtosh x0,a5,7   #x1y2
    
	addi a5,x0,8
    immtosh x0,a5,128
    addi a5,x0,9
    immtosh x0,a5,128
	addi a5,x0,10
    immtosh x0,a5,128 
	addi a5,x0,11
    immtosh x0,a5,128 
	addi a5,x0,12
    immtosh x0,a5,128 #x1y7

	addi a5,x0,13
    immtosh x0,a5,128   #x2y3 
    addi a5,x0,14
    immtosh x0,a5,128
	addi a5,x0,15
    immtosh x0,a5,128
	addi a5,x0,16
    immtosh x0,a5,128
	addi a5,x0,17
    immtosh x0,a5,128 #x2y7 

    addi a5,x0,18   #x3y4 
    immtosh x0,a5,128
	addi a5,x0,19
    immtosh x0,a5,128
	addi a5,x0,20
    immtosh x0,a5,128
	addi a5,x0,21
    immtosh x0,a5,128

	addi a5,x0,22
    immtosh x0,a5,128 #x4y5
	addi a5,x0,23
    immtosh x0,a5,128
	addi a5,x0,24
    immtosh x0,a5,128

	addi a5,x0,25
    immtosh x0,a5,128#x5y6
	addi a5,x0,26
    immtosh x0,a5,128

	addi a5,x0,27
    immtosh x0,a5,128#x6y7

	addi a5,x0,28
    immtosh x0,a5,128
	addi a5,x0,29
    immtosh x0,a5,128
	addi a5,x0,30
    immtosh x0,a5,128
	addi a5,x0,31
    immtosh x0,a5,128
    
	li a5,0
	li a5,0
	li a3,112
	add a5,a5,a3
       
        lui	a6,%hi(.LC2)
	addi	a6,a6,%lo(.LC2) #x地址  a6
	add a6,a6,a5
	lw a4,0(a6)   #a4 shirandseed

	addi a5,x0,5
        permute x0,a5,a4   #打乱

	initind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN01
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN10



.LCN10:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN11
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN20
	
.LCN20:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN21
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN30
	
.LCN30:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN31
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN40

.LCN40:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN41
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN50

.LCN50:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN51
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN60
.LCN60:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN61
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN70
.LCN70:	
	incind x0,x0,x0
	movtordind a3,x0,x0
	add x0,x0,x0
	bne	a3,zero,.LCN71
	lw	a4,-48(s0)  #x
	lw	a5,-80(s0)   #y
	and	a5,a4,a5
	sw	a5,-224(s0)  ##x0y0
	j	.LCN80
	


.LCN80:
	addi x0,x0,0
    addi a5,x0,0
    immtosh x0,a5,8   #第0个shuflle寄存器，写入的值8 1000 x0y1
	addi a5,x0,1
    immtosh x0,a5,16   #x0y2 
    addi a5,x0,2
    immtosh x0,a5,24 #x0y3
	addi a5,x0,3
    immtosh x0,a5,32 #x0y4
	addi a5,x0,4
    immtosh x0,a5,40 #x0y5
	addi a5,x0,5
    immtosh x0,a5,48  #x0y6
	addi a5,x0,6
    immtosh x0,a5,56 #x0y7


    addi a5,x0,7
    immtosh x0,a5,17   #x1y2
	addi a5,x0,8
    immtosh x0,a5,25  
    addi a5,x0,9
    immtosh x0,a5,33 
	addi a5,x0,10
    immtosh x0,a5,41 
	addi a5,x0,11
    immtosh x0,a5,49 
	addi a5,x0,12
    immtosh x0,a5,57 #x1y7

	addi a5,x0,13
    immtosh x0,a5,26   #x2y3 
    addi a5,x0,14
    immtosh x0,a5,34 
	addi a5,x0,15
    immtosh x0,a5,42 
	addi a5,x0,16
    immtosh x0,a5,50 
	addi a5,x0,17
    immtosh x0,a5,58  #x2y7 

    addi a5,x0,18   #x3y4 
    immtosh x0,a5,35 
	addi a5,x0,19
    immtosh x0,a5,43 
	addi a5,x0,20
    immtosh x0,a5,51 
	addi a5,x0,21
    immtosh x0,a5,59

	addi a5,x0,22
    immtosh x0,a5,44  #x4y5
	addi a5,x0,23
    immtosh x0,a5,52 
	addi a5,x0,24
    immtosh x0,a5,60

	addi a5,x0,25
    immtosh x0,a5,53 #x5y6
	addi a5,x0,26
    immtosh x0,a5,61

	addi a5,x0,27
    immtosh x0,a5,62 #x6y7

	addi a5,x0,28
    immtosh x0,a5,128
	addi a5,x0,29
    immtosh x0,a5,128
	addi a5,x0,30
    immtosh x0,a5,128
	addi a5,x0,31
    immtosh x0,a5,128
    
    #li a5,4
	#li a3,28
	 #mul a5,a5,a3        #偏移
	li a5,0
	li a3,112
	add a5,a5,a3
       
        lui	a6,%hi(.LC2)
	addi	a6,a6,%lo(.LC2) #x地址  a6
	add a6,a6,a5
	lw a4,0(a6)   #a4 shirandseed

	addi a5,x0,5
        permute x0,a5,a4   #打乱

	initind x0,x0,x0
	li t1,0
	chongfu
	incind x0,x0,x0
	li t1,1
	chongfu
	incind x0,x0,x0
	li t1,2
	chongfu
	incind x0,x0,x0
	li t1,3
	chongfu
	incind x0,x0,x0
	li t1,4
	chongfu
	incind x0,x0,x0
	li t1,5
	chongfu
	incind x0,x0,x0
	li t1,6
	chongfu
	incind x0,x0,x0
	li t1,7
	chongfu
	incind x0,x0,x0
	li t1,8
	chongfu
	incind x0,x0,x0
	li t1,9
	chongfu
	incind x0,x0,x0
	li t1,10
	chongfu
	incind x0,x0,x0
	li t1,11
	chongfu
	incind x0,x0,x0
	li t1,12
	chongfu
	incind x0,x0,x0
	li t1,13
	chongfu
	incind x0,x0,x0
	li t1,14
	chongfu
	incind x0,x0,x0
	li t1,15
	chongfu
	incind x0,x0,x0
	li t1,16
	chongfu
	incind x0,x0,x0
	li t1,17
	chongfu
	incind x0,x0,x0
	li t1,18
	chongfu
	incind x0,x0,x0
	li t1,19
	chongfu
	incind x0,x0,x0
	li t1,20
	chongfu
	incind x0,x0,x0
	li t1,21
	chongfu
	incind x0,x0,x0
	li t1,22
	chongfu
	incind x0,x0,x0
	li t1,23
	chongfu
	incind x0,x0,x0
	li t1,24
	chongfu
	incind x0,x0,x0
	li t1,25
	chongfu
	incind x0,x0,x0
	li t1,26
	chongfu
	incind x0,x0,x0
	li t1,27
	chongfu
	incind x0,x0,x0
	chongfu
	incind x0,x0,x0
	chongfu
	incind x0,x0,x0
	chongfu
	incind x0,x0,x0
	chongfu
	j .L2
	
.L2:


	
	lw	ra,220(sp)
	lw	s0,216(sp)
	addi	sp,sp,224
	jr	ra




.LCN01:
	li	a0,1
	bne	a3,a0,.LCN02
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN10
.LCN02:
	li	a0,2
	bne	a3,a0,.LCN03
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN10
.LCN03:
	li	a0,3
	bne	a3,a0,.LCN04
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN10
.LCN04:
	li	a0,4
	bne	a3,a0,.LCN05
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN10
.LCN05:
	li	a0,5
	bne	a3,a0,.LCN06
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN10
.LCN06:
	li	a0,6
	bne	a3,a0,.LCN07
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN10
.LCN07:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN10
	
.LCN11:
	li	a0,1
	bne	a3,a0,.LCN12
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN20
.LCN12:
	li	a0,2
	bne	a3,a0,.LCN13
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN20
.LCN13:
	li	a0,3
	bne	a3,a0,.LCN14
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN20
.LCN14:
	li	a0,4
	bne	a3,a0,.LCN15
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN20
.LCN15:
	li	a0,5
	bne	a3,a0,.LCN16
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN20
.LCN16:
	li	a0,6
	bne	a3,a0,.LCN17
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN20
.LCN17:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN20
	
.LCN21:
	li	a0,1
	bne	a3,a0,.LCN22
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN30
.LCN22:
	li	a0,2
	bne	a3,a0,.LCN23
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN30
.LCN23:
	li	a0,3
	bne	a3,a0,.LCN24
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN30
.LCN24:
	li	a0,4
	bne	a3,a0,.LCN25
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN30
.LCN25:
	li	a0,5
	bne	a3,a0,.LCN26
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN30
.LCN26:
	li	a0,6
	bne	a3,a0,.LCN27
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN30
.LCN27:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN30

.LCN31:
	li	a0,1
	bne	a3,a0,.LCN32
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN40
.LCN32:
	li	a0,2
	bne	a3,a0,.LCN33
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN40
.LCN33:
	li	a0,3
	bne	a3,a0,.LCN34
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN40
.LCN34:
	li	a0,4
	bne	a3,a0,.LCN35
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN40
.LCN35:
	li	a0,5
	bne	a3,a0,.LCN36
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN40
.LCN36:
	li	a0,6
	bne	a3,a0,.LCN37
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN40
.LCN37:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN40
	
.LCN41:
	li	a0,1
	bne	a3,a0,.LCN42
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN50
.LCN42:
	li	a0,2
	bne	a3,a0,.LCN43
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN50
.LCN43:
	li	a0,3
	bne	a3,a0,.LCN44
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN50
.LCN44:
	li	a0,4
	bne	a3,a0,.LCN45
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN50
.LCN45:
	li	a0,5
	bne	a3,a0,.LCN46
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN50
.LCN46:
	li	a0,6
	bne	a3,a0,.LCN47
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN50
.LCN47:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN50
	
.LCN51:
	li	a0,1
	bne	a3,a0,.LCN52
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN60
.LCN52:
	li	a0,2
	bne	a3,a0,.LCN53
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN60
.LCN53:
	li	a0,3
	bne	a3,a0,.LCN54
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN60
.LCN54:
	li	a0,4
	bne	a3,a0,.LCN55
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN60
.LCN55:
	li	a0,5
	bne	a3,a0,.LCN56
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN60
.LCN56:
	li	a0,6
	bne	a3,a0,.LCN57
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN60
.LCN57:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN60
	
.LCN61:
	li	a0,1
	bne	a3,a0,.LCN62
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN70
.LCN62:
	li	a0,2
	bne	a3,a0,.LCN63
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN70
.LCN63:
	li	a0,3
	bne	a3,a0,.LCN64
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN70
.LCN64:
	li	a0,4
	bne	a3,a0,.LCN65
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN70
.LCN65:
	li	a0,5
	bne	a3,a0,.LCN66
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN70
.LCN66:
	li	a0,6
	bne	a3,a0,.LCN67
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN70
.LCN67:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN70
	
.LCN71:
	li	a0,1
	bne	a3,a0,.LCN72
	lw	a4,-44(s0)
	lw	a5,-76(s0)
	and	a5,a4,a5
	sw	a5,-220(s0)
	j	.LCN80
.LCN72:
	li	a0,2
	bne	a3,a0,.LCN73
	lw	a4,-40(s0)
	lw	a5,-72(s0)
	and	a5,a4,a5
	sw	a5,-216(s0)
	j	.LCN80
.LCN73:
	li	a0,3
	bne	a3,a0,.LCN74
	lw	a4,-36(s0)
	lw	a5,-68(s0)
	and	a5,a4,a5
	sw	a5,-212(s0)
	j	.LCN80
.LCN74:
	li	a0,4
	bne	a3,a0,.LCN75
	lw	a4,-32(s0)
	lw	a5,-64(s0)
	and	a5,a4,a5
	sw	a5,-208(s0)
	j	.LCN80
.LCN75:
	li	a0,5
	bne	a3,a0,.LCN76
	lw	a4,-28(s0)
	lw	a5,-60(s0)
	and	a5,a4,a5
	sw	a5,-204(s0)
	j	.LCN80
.LCN76:
	li	a0,6
	bne	a3,a0,.LCN77
	lw	a4,-24(s0)
	lw	a5,-56(s0)
	and	a5,a4,a5
	sw	a5,-200(s0)
	j	.LCN80
.LCN77:
	lw	a4,-20(s0)
	lw	a5,-52(s0)
	and	a5,a4,a5
	sw	a5,-196(s0)
	j	.LCN80
	
	

	
	

