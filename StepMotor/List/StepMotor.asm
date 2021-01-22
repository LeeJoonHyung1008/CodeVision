
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128L
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128L
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _switch1=R5
	.DEF _switch2=R4
	.DEF _i=R6
	.DEF _j=R8
	.DEF _LeftstepCount=R10
	.DEF _RightstepCount=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x4:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x48:
	.DB  0x0,0x0,0x0,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _rotateR
	.DW  _0x3*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x4*2

	.DW  0x04
	.DW  0x06
	.DW  _0x48*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <math.h>
;#include "StepMotor.h"
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;char switch1; // 새롭게 선언한 switch1, switch2입니다. (boolean 변수)
;char switch2;
;int i = 0; // for문에서 밝기 제어를 담당할 변수 I, j 입니다.
;int j = 0;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 000D {

	.CSEG
_ext_int0_isr:
	ST   -Y,R30
; 0000 000E // Place your code here
; 0000 000F  switch1 = TRUE; // 해당 Interrupt가 호출되면 switch1의 boolean 값을 TRUE로 바
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0010 }
	RJMP _0x47
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void) //
; 0000 0013 {
_ext_int1_isr:
	ST   -Y,R30
; 0000 0014 // Place your code here
; 0000 0015  switch2 = TRUE; // 해당 Interrupt가 호출되면 switch2의 boolean 값을 TRUE로 바
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0016 }
_0x47:
	LD   R30,Y+
	RETI
;
;void InitializeSwitch(void) // Switch 관련 레지스터를 설정하는 함수입니다.
; 0000 0019 {
_InitializeSwitch:
; 0000 001A // 스위치 PORTD 0,1
; 0000 001B  PORTD &= 0xfc;
	IN   R30,0x12
	ANDI R30,LOW(0xFC)
	OUT  0x12,R30
; 0000 001C  DDRD &= 0xfc;
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
; 0000 001D // External Interrupt(s) initialization
; 0000 001E // INT0: On
; 0000 001F // INT0 Mode: Falling Edge
; 0000 0020 // INT1: On
; 0000 0021 // INT1 Mode: Falling Edge
; 0000 0022 // INT2: Off
; 0000 0023 // INT3: Off
; 0000 0024 // INT4: Off
; 0000 0025 // INT5: Off
; 0000 0026 // INT6: Off
; 0000 0027 // INT7: Off
; 0000 0028  EICRA=0x0A; // SW1, 2에 대해 모두 Falling Edge로 선언합니다.
	LDI  R30,LOW(10)
	STS  106,R30
; 0000 0029  EICRB=0x00; // 아무런 Interrupt를 사용하지 않습니다.
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0000 002A  EIMSK=0x03; // INT0, 1을 Enable 해줍니다.
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0000 002B  EIFR=0x03; // INT0, 1을 Enable 해줍니다.
	OUT  0x38,R30
; 0000 002C  }
	RET
;char SW1(void) // SW1에 대한 함수입니다. {
; 0000 002E  {
; 0000 002F  char ret; // return 해줄 변수를 새롭게 선언합니다.
; 0000 0030 
; 0000 0031  ret = switch1; // switch1의 현재 값과 바꿉니다.
;	ret -> R17
; 0000 0032  switch1 = FALSE; // switch1에 FALSE 값을 넣습니다.
; 0000 0033 
; 0000 0034  return ret; // ret를 반환합니다.
; 0000 0035  }
;char SW2(void) // SW2에 대한 함수입니다. {
; 0000 0037  {
; 0000 0038  char ret; // return 해줄 변수를 새롭게 선언합니다.
; 0000 0039 
; 0000 003A  ret = switch2; // switch2의 현재 값과 바꿉니다.
;	ret -> R17
; 0000 003B  switch2 = FALSE; // switch2에 FALSE 값을 넣습니다.
; 0000 003C 
; 0000 003D  return ret; // ret를 반환합니다.
; 0000 003E  }
;
;// Declare your global variables here
;     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};

	.DSEG
;     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
;     int LeftstepCount, RightstepCount;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
;     unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;    // 왼쪽과 오른쪽 모터의 TCNT 속도
;     unsigned char direction_control;        // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
;
;     struct {
;          int nStep4perBlock;            // 한 블록 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn90forRight;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn90forLeft;
;     } Information;
;     struct {
;          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
;          char RmotorRun;			// 오른쪽 모터가 회전했는지에 대한 Flag
;     } Flag;
;
;void Direction(int mode)
; 0000 0052 {

	.CSEG
_Direction:
; 0000 0053      int LStepCount = 0, RStepCount = 0;
; 0000 0054 
; 0000 0055      TCCR1B = 0x04;
	CALL __SAVELOCR4
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 0056      TCCR3B = 0x04;
	STS  138,R30
; 0000 0057 
; 0000 0058      direction_control = mode;
	LDD  R30,Y+4
	STS  _direction_control,R30
; 0000 0059 
; 0000 005A      Flag.LmotorRun = FALSE;
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0000 005B      Flag.RmotorRun = FALSE;
	__PUTB1MN _Flag,1
; 0000 005C 
; 0000 005D      switch(mode)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0000 005E      {
; 0000 005F      case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8
; 0000 0060           while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
_0x9:
	CALL SUBOPT_0x0
	CP   R16,R30
	CPC  R17,R31
	BRLT _0xC
	CALL SUBOPT_0x0
	CP   R18,R30
	CPC  R19,R31
	BRGE _0xB
_0xC:
; 0000 0061           {
; 0000 0062                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0xE
; 0000 0063                {
; 0000 0064                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 0065                     Flag.LmotorRun = FALSE;
; 0000 0066                }
; 0000 0067                if(Flag.RmotorRun)
_0xE:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0xF
; 0000 0068                {
; 0000 0069                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 006A                     Flag.RmotorRun = FALSE;
; 0000 006B                }
; 0000 006C           }
_0xF:
	RJMP _0x9
_0xB:
; 0000 006D           break;
	RJMP _0x7
; 0000 006E      case HALF:
_0x8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x10
; 0000 006F           while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
_0x11:
	CALL SUBOPT_0x0
	ASR  R31
	ROR  R30
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x14
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x13
_0x14:
; 0000 0070           {
; 0000 0071                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x16
; 0000 0072                {
; 0000 0073                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 0074                     Flag.LmotorRun = FALSE;
; 0000 0075                }
; 0000 0076                if(Flag.RmotorRun)
_0x16:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x17
; 0000 0077                {
; 0000 0078                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 0079                     Flag.RmotorRun = FALSE;
; 0000 007A                }
; 0000 007B           }
_0x17:
	RJMP _0x11
_0x13:
; 0000 007C           break;
	RJMP _0x7
; 0000 007D      case LEFT:
_0x10:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ _0x19
; 0000 007E      case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1A
_0x19:
; 0000 007F           while(LStepCount<Information.nStep4Turn90forLeft || RStepCount<Information.nStep4Turn90forRight)
_0x1B:
	__GETW1MN _Information,4
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x1E
	__GETW1MN _Information,2
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x1D
_0x1E:
; 0000 0080           {
; 0000 0081                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x20
; 0000 0082                {
; 0000 0083                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 0084                     Flag.LmotorRun = FALSE;
; 0000 0085                }
; 0000 0086                if(Flag.RmotorRun)
_0x20:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x21
; 0000 0087                {
; 0000 0088                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 0089                     Flag.RmotorRun = FALSE;
; 0000 008A                }
; 0000 008B           }
_0x21:
	RJMP _0x1B
_0x1D:
; 0000 008C           break;
	RJMP _0x7
; 0000 008D      case BACK:
_0x1A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x7
; 0000 008E           while(LStepCount<(Information.nStep4Turn90forLeft*2) || RStepCount<(Information.nStep4Turn90forRight*2))
_0x23:
	__GETW2MN _Information,4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x26
	__GETW2MN _Information,2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x25
_0x26:
; 0000 008F           {
; 0000 0090                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x28
; 0000 0091                {
; 0000 0092                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 0093                     Flag.LmotorRun = FALSE;
; 0000 0094                }
; 0000 0095                if(Flag.RmotorRun)
_0x28:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x29
; 0000 0096                {
; 0000 0097                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 0098                     Flag.RmotorRun = FALSE;
; 0000 0099                }
; 0000 009A           }
_0x29:
	RJMP _0x23
_0x25:
; 0000 009B           break;
; 0000 009C      }
_0x7:
; 0000 009D      TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 009E      TCCR3B = 0x00;
	STS  138,R30
; 0000 009F }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;
;
;// Timer1 overflow interrupt service routine
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00A6 {
_timer1_ovf_isr:
	CALL SUBOPT_0x3
; 0000 00A7 // Place your code here
; 0000 00A8      switch(direction_control)
; 0000 00A9      {
; 0000 00AA           case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00AB                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x4
	OR   R30,R0
	OUT  0x12,R30
; 0000 00AC                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0000 00AD                LeftstepCount--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0000 00AE                if(LeftstepCount < 0)
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x2E
; 0000 00AF                     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R10,R30
; 0000 00B0                break;
_0x2E:
	RJMP _0x2C
; 0000 00B1           case RIGHT:
_0x2D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x30
; 0000 00B2           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x31
_0x30:
; 0000 00B3           case FORWARD:
	RJMP _0x32
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x33
_0x32:
; 0000 00B4           case HALF:
	RJMP _0x34
_0x33:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2C
_0x34:
; 0000 00B5                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x4
	OR   R30,R0
	OUT  0x12,R30
; 0000 00B6                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0000 00B7                LeftstepCount++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00B8                LeftstepCount %= sizeof(rotateL);
	MOVW R26,R10
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R10,R30
; 0000 00B9                break;
; 0000 00BA      }
_0x2C:
; 0000 00BB      Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0000 00BC 
; 0000 00BD      TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	LDS  R30,_VelocityLeftmotorTCNT1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0000 00BE      TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	LDS  R30,_VelocityLeftmotorTCNT1
	OUT  0x2C,R30
; 0000 00BF }
	RJMP _0x46
;
;// Timer 3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 00C3 {
_timer3_ovf_isr:
	CALL SUBOPT_0x3
; 0000 00C4 // Place your code here
; 0000 00C5      switch(direction_control)
; 0000 00C6      {
; 0000 00C7           case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x3A
; 0000 00C8           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3B
_0x3A:
; 0000 00C9                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R0
	OUT  0x3,R30
; 0000 00CA                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0000 00CB                RightstepCount--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 00CC                if(RightstepCount < 0)
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE _0x3C
; 0000 00CD                     RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 00CE                break;
_0x3C:
	RJMP _0x38
; 0000 00CF           case FORWARD:
_0x3B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x3E
; 0000 00D0           case HALF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3F
_0x3E:
; 0000 00D1           case LEFT:
	RJMP _0x40
_0x3F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x38
_0x40:
; 0000 00D2                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R0
	OUT  0x3,R30
; 0000 00D3                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0000 00D4                RightstepCount++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00D5                RightstepCount %= sizeof(rotateR);
	MOVW R26,R12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R12,R30
; 0000 00D6                break;
; 0000 00D7      }
_0x38:
; 0000 00D8      Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0000 00D9 
; 0000 00DA      TCNT3H = VelocityRightmotorTCNT3 >> 8;
	LDS  R30,_VelocityRightmotorTCNT3+1
	STS  137,R30
; 0000 00DB      TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	LDS  R30,_VelocityRightmotorTCNT3
	STS  136,R30
; 0000 00DC }
_0x46:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 00E1 {
_main:
; 0000 00E2     double distance4perStep;
; 0000 00E3     distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	SBIW R28,4
;	distance4perStep -> Y+0
	__GETD1N 0x3ECD154B
	CALL __PUTD1S0
; 0000 00E4 	Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	CALL SUBOPT_0x6
	__GETD2N 0x43340000
	CALL SUBOPT_0x7
	STS  _Information,R30
	STS  _Information+1,R31
; 0000 00E5 	Information.nStep4Turn90forRight = (int)((PI*MOUSE_WIDTH/3.8)/distance4perStep);
	CALL SUBOPT_0x6
	__GETD2N 0x428795A3
	CALL SUBOPT_0x7
	__PUTW1MN _Information,2
; 0000 00E6     Information.nStep4Turn90forLeft = (int)((PI*MOUSE_WIDTH/3.9)/distance4perStep);
	CALL SUBOPT_0x6
	__GETD2N 0x42841BA6
	CALL SUBOPT_0x7
	__PUTW1MN _Information,4
; 0000 00E7 // LEFT MOTOR - PORTD 4,5,6,7
; 0000 00E8      PORTD&=0x0F;
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0000 00E9      DDRD|=0xF0;
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
; 0000 00EA 
; 0000 00EB // RIGHT MOTOR - PORTE 4,5,6,7
; 0000 00EC      PORTE&=0x0F;
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	OUT  0x3,R30
; 0000 00ED      DDRE|=0xF0;
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
; 0000 00EE 
; 0000 00EF // Timer/Counter 1 initialization
; 0000 00F0 // Clock source: System Clock
; 0000 00F1 // Clock value: 62.500 kHz
; 0000 00F2 // Mode: Normal top=FFFFh
; 0000 00F3 // OC1A output: Discon.
; 0000 00F4 // OC1B output: Discon.
; 0000 00F5 // OC1C output: Discon.
; 0000 00F6 // Noise Canceler: Off
; 0000 00F7 // Input Capture on Falling Edge
; 0000 00F8 // Timer 1 Overflow Interrupt: On
; 0000 00F9 // Input Capture Interrupt: Off
; 0000 00FA // Compare A Match Interrupt: Off
; 0000 00FB // Compare B Match Interrupt: Off
; 0000 00FC // Compare C Match Interrupt: Off
; 0000 00FD      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00FE      TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 00FF      TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0100      TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0101      ICR1H=0x00;
	OUT  0x27,R30
; 0000 0102      ICR1L=0x00;
	OUT  0x26,R30
; 0000 0103      OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0104      OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0105      OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0106      OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0107      OCR1CH=0x00;
	STS  121,R30
; 0000 0108      OCR1CL=0x00;
	STS  120,R30
; 0000 0109 
; 0000 010A // Timer/Counter 3 initialization
; 0000 010B // Clock source: System Clock
; 0000 010C // Clock value: 62.500 kHz
; 0000 010D // Mode: Normal top=FFFFh
; 0000 010E // OC3A output: Discon.
; 0000 010F // OC3B output: Discon.
; 0000 0110 // OC3C output: Discon.
; 0000 0111 // Noise Canceler: Off
; 0000 0112 // Input Capture on Falling Edge
; 0000 0113 // Timer 3 Overflow Interrupt: On
; 0000 0114 // Input Capture Interrupt: Off
; 0000 0115 // Compare A Match Interrupt: Off
; 0000 0116 // Compare B Match Interrupt: Off
; 0000 0117 // Compare C Match Interrupt: Off
; 0000 0118      TCCR3A=0x00;
	STS  139,R30
; 0000 0119      TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0000 011A      TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 011B      TCNT3L=0x00;
	STS  136,R30
; 0000 011C      ICR3H=0x00;
	STS  129,R30
; 0000 011D      ICR3L=0x00;
	STS  128,R30
; 0000 011E      OCR3AH=0x00;
	STS  135,R30
; 0000 011F      OCR3AL=0x00;
	STS  134,R30
; 0000 0120      OCR3BH=0x00;
	STS  133,R30
; 0000 0121      OCR3BL=0x00;
	STS  132,R30
; 0000 0122      OCR3CH=0x00;
	STS  131,R30
; 0000 0123      OCR3CL=0x00;
	STS  130,R30
; 0000 0124 
; 0000 0125 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0126      TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 0127      ETIMSK=0x04;
	STS  125,R30
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B #asm("sei")
	sei
; 0000 012C 
; 0000 012D     LeftstepCount = 0;		// 왼쪽 모터의 스텝 초기화
	CLR  R10
	CLR  R11
; 0000 012E      RightstepCount = 0;		// 오른쪽 모터의 스텝 초기화
	CLR  R12
	CLR  R13
; 0000 012F 
; 0000 0130 // Global enable interrupts
; 0000 0131 #asm("sei")
	sei
; 0000 0132 
; 0000 0133      VelocityLeftmotorTCNT1 = 65400;	// 왼쪽 모터의 속도 (65200 ~ 65535)
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
; 0000 0134      VelocityRightmotorTCNT3 = 65400;	// 오른쪽 모터의 속도 (65200 ~ 65535)
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
; 0000 0135     InitializeSwitch;
	LDI  R30,LOW(_InitializeSwitch)
	LDI  R31,HIGH(_InitializeSwitch)
; 0000 0136 //     Direction(RIGHT);		// 우로 90도 턴
; 0000 0137 //     Direction(HALF);		// 반블럭 전진
; 0000 0138 
; 0000 0139       switch1 = FALSE; // switch1, 2의 초기값은 FALSE 입니다.
	CLR  R5
; 0000 013A         switch2 = FALSE;
	CLR  R4
; 0000 013B while (1)
; 0000 013C       {
; 0000 013D       // Place your code here
; 0000 013E       Direction(LEFT);		// 좌로 90도 턴
	CALL SUBOPT_0x8
; 0000 013F 
; 0000 0140       Direction(LEFT);		// 좌로 90도
	CALL SUBOPT_0x8
; 0000 0141 
; 0000 0142             Direction(LEFT);		// 좌로 90도 턴
	CALL SUBOPT_0x8
; 0000 0143 
; 0000 0144       Direction(LEFT);		// 좌로 90도
	CALL SUBOPT_0x8
; 0000 0145             Direction(LEFT);		// 좌로 90도 턴
	CALL SUBOPT_0x8
; 0000 0146 
; 0000 0147       Direction(LEFT);		// 좌로 90도
	CALL SUBOPT_0x8
; 0000 0148             Direction(LEFT);		// 좌로 90도 턴
	CALL SUBOPT_0x8
; 0000 0149 
; 0000 014A       Direction(LEFT);		// 좌로 90도
	CALL SUBOPT_0x8
; 0000 014B       break;
; 0000 014C       }
; 0000 014D }
	ADIW R28,4
_0x45:
	RJMP _0x45

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rotateR:
	.BYTE 0x8
_rotateL:
	.BYTE 0x8
_VelocityLeftmotorTCNT1:
	.BYTE 0x2
_VelocityRightmotorTCNT3:
	.BYTE 0x2
_direction_control:
	.BYTE 0x1
_Information:
	.BYTE 0x6
_Flag:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R30,_Information
	LDS  R31,_Information+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	STS  _Flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	__ADDWRN 18,19,1
	LDI  R30,LOW(0)
	__PUTB1MN _Flag,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_direction_control
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	IN   R0,18
	LDI  R26,LOW(_rotateL)
	LDI  R27,HIGH(_rotateL)
	ADD  R26,R10
	ADC  R27,R11
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	IN   R0,3
	LDI  R26,LOW(_rotateR)
	LDI  R27,HIGH(_rotateR)
	ADD  R26,R12
	ADC  R27,R13
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __DIVF21
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
