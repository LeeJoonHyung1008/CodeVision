
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
	.DEF _LeftstepCount=R4
	.DEF _RightstepCount=R6
	.DEF _direction_control=R9
	.DEF _vel_counter_high_L=R10
	.DEF _vel_counter_high_R=R12

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x6C,0x65,0x66,0x74,0x20,0x3A,0x20,0x25
	.DB  0x64,0x20,0x20,0x20,0x20,0x63,0x65,0x6E
	.DB  0x74,0x65,0x72,0x20,0x3A,0x20,0x25,0x64
	.DB  0x20,0x20,0x20,0x20,0x74,0x69,0x67,0x68
	.DB  0x74,0x20,0x3A,0x20,0x25,0x64,0xA,0x0
	.DB  0x6C,0x65,0x66,0x74,0x20,0x73,0x74,0x61
	.DB  0x6E,0x64,0x61,0x72,0x64,0x20,0x3A,0x20
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x63,0x65
	.DB  0x6E,0x74,0x65,0x72,0x20,0x73,0x74,0x61
	.DB  0x6E,0x64,0x20,0x3A,0x20,0x25,0x64,0x20
	.DB  0x20,0x20,0x20,0x72,0x69,0x67,0x68,0x74
	.DB  0x20,0x73,0x74,0x61,0x6E,0x64,0x20,0x3A
	.DB  0x20,0x25,0x64,0x20,0x20,0x20,0x20,0x63
	.DB  0x65,0x6E,0x74,0x65,0x72,0x20,0x73,0x74
	.DB  0x61,0x6E,0x64,0x61,0x74,0x64,0x20,0x3A
	.DB  0x20,0x25,0x64,0x20,0x20,0x25,0x64,0x20
	.DB  0x20,0x25,0x64,0x0
_0x60003:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x60004:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _rotateR
	.DW  _0x60003*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x60004*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "Algorithm.h"
;#include <stdio.h>
;
;// Declare your global variables here
;extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
;
;
;void InitializeUART(void){ // UART 통신을 위해 각 register를 초기화 한다.
; 0000 000E void InitializeUART(void){

	.CSEG
_InitializeUART:
; 0000 000F  // USART1 initialization
; 0000 0010  // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0011  // USART1 Receiver: On
; 0000 0012  // USART1 Transmitter: On
; 0000 0013  // USART1 Mode: Asynchronous
; 0000 0014  // USART1 Baud Rate: 9600
; 0000 0015  UCSR1A=0x00; // UART 1번 채널에 대해 register를 초기화한다.
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 0016  UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 0017  UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0018  UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0019  UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 001A }
	RET
;
;//eeprom extern int StandardSensor[3], CenterStandardSensor[3];
;
;
;void main(void)
; 0000 0020 {
_main:
; 0000 0021 int i;
; 0000 0022 int mode;
; 0000 0023 i=0;
;	i -> R16,R17
;	mode -> R18,R19
	__GETWRN 16,17,0
; 0000 0024 mode=0;
	__GETWRN 18,19,0
; 0000 0025 
; 0000 0026      InitializeSensor();
	CALL _InitializeSensor
; 0000 0027      InitializeUART();
	RCALL _InitializeUART
; 0000 0028        InitializeLED();
	RCALL _InitializeLED
; 0000 0029      InitializeSwitch();
	CALL _InitializeSwitch
; 0000 002A      InitializeStepmotor();
	CALL _InitializeStepmotor
; 0000 002B      LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 002C      #asm("sei")
	sei
; 0000 002D while(1)                     //메뉴 시작
_0x3:
; 0000 002E {
; 0000 002F      if(SW1() == TRUE)
	CALL _SW1
	CPI  R30,LOW(0x1)
	BRNE _0x6
; 0000 0030      {
; 0000 0031     mode++;
	__ADDWRN 18,19,1
; 0000 0032     mode%=5;
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	MOVW R18,R30
; 0000 0033     LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 0034     switch(mode)
	MOVW R30,R18
; 0000 0035     {
; 0000 0036     case 0: LED_ON(LED1); break;
	SBIW R30,0
	BRNE _0xA
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x48
; 0000 0037     case 1: LED_ON(LED2); break;
_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP _0x48
; 0000 0038     case 2: LED_ON(LED3); break;
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x48
; 0000 0039     case 3: LED_ON(LED4); break;
_0xC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x48
; 0000 003A     case 4: LED_ON(LED1 | LED2 | LED3 | LED4); break;
_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x9
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
_0x48:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LED_ON
; 0000 003B     }
_0x9:
; 0000 003C      }                     //각 모드에 맞는 LED켜기
; 0000 003D      if(SW2() == TRUE)
_0x6:
	CALL _SW2
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xF
; 0000 003E      {
; 0000 003F     switch(mode)
	MOVW R30,R18
; 0000 0040     {
; 0000 0041     case 0:
	SBIW R30,0
	BRNE _0x13
; 0000 0042          Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 0043          A(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x2
; 0000 0044          Direction(Quarter);
; 0000 0045          D(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _D
; 0000 0046          Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 0047          A(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x2
; 0000 0048          Direction(Quarter);
; 0000 0049 
; 0000 004A          delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x3
; 0000 004B     break;                  // 0번 모드 모터테스트
	RJMP _0x12
; 0000 004C     case 1:
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14
; 0000 004D          printf("left : %d    center : %d    tight : %d\n",readSensor(LEFT_SENSOR),readSensor(FRONT_SENSOR),readSensor(RIGHT_SENSOR));
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL SUBOPT_0x5
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 0000 004E          break;                  //1번 모드 센서 테스트
	RJMP _0x12
; 0000 004F     case 2:
_0x14:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x15
; 0000 0050                LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 0051          while(!SW2());
_0x16:
	CALL _SW2
	CPI  R30,0
	BREQ _0x16
; 0000 0052          StandardSensor[1] = readSensor(FRONT_SENSOR);
	__POINTW1MN _StandardSensor,2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0053          LED_ON(LED1);
	CALL SUBOPT_0x8
; 0000 0054          while(!SW2());
_0x19:
	CALL _SW2
	CPI  R30,0
	BREQ _0x19
; 0000 0055          StandardSensor[0] = readSensor(LEFT_SENSOR);    // 왼쪽 벽 정보
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 0056          LED_ON(LED2);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xA
; 0000 0057          while(!SW2());
_0x1C:
	CALL _SW2
	CPI  R30,0
	BREQ _0x1C
; 0000 0058          StandardSensor[2] = readSensor(RIGHT_SENSOR);    // 오른쪽 벽 정보
	__POINTW1MN _StandardSensor,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0059          LED_ON(LED4);
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0xA
; 0000 005A          while(!SW2());
_0x1F:
	CALL _SW2
	CPI  R30,0
	BREQ _0x1F
; 0000 005B          CenterStandardSensor[0] = readSensor(LEFT_SENSOR);    // 자세보정 왼쪽 벽 정보
	CALL SUBOPT_0x4
	CALL SUBOPT_0xB
; 0000 005C          CenterStandardSensor[2]= readSensor(RIGHT_SENSOR);    // 자세보정 오른쪽 벽 정보
	__POINTW1MN _CenterStandardSensor,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 005D          CenterStandardSensor[1]= readSensor(FRONT_SENSOR);
	__POINTW1MN _CenterStandardSensor,2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	CALL SUBOPT_0xC
; 0000 005E          LED_ON(LED1 | LED2 | LED3 | LED4);
; 0000 005F                LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 0060          LED_ON(LED3);
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0xA
; 0000 0061          printf("left standard : %d    center stand : %d    right stand : %d    center standatd : %d  %d  %d",StandardSensor[0],StandardSensor[1],StandardSensor[2],CenterStandardSensor[0],CenterStandardSensor[1],CenterStandardSensor[2]);
	CALL SUBOPT_0xD
; 0000 0062 
; 0000 0063 //         Button.SW2 = FALSE;
; 0000 0064 
; 0000 0065           while(i<5)
_0x22:
	__CPWRN 16,17,5
	BRGE _0x24
; 0000 0066           {         // 전방 벽 정보의 평균값
; 0000 0067              while(!SW2());
_0x25:
	CALL _SW2
	CPI  R30,0
	BREQ _0x25
; 0000 0068              StandardSensor[1] = readSensor(FRONT_SENSOR) + StandardSensor[1]; // 전방 벽 정보
	__POINTW1MN _StandardSensor,2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	MOVW R0,R30
	CALL SUBOPT_0xE
	ADD  R30,R0
	ADC  R31,R1
	POP  R26
	POP  R27
	CALL SUBOPT_0xC
; 0000 0069              LED_ON(LED1 | LED2 | LED3 | LED4);
; 0000 006A              delay_ms(100);
	CALL SUBOPT_0xF
; 0000 006B              LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 006C              i++;
	__ADDWRN 16,17,1
; 0000 006D           }
	RJMP _0x22
_0x24:
; 0000 006E          StandardSensor[1] = (int)(StandardSensor[1] / 6);
	__POINTWRMN 22,23,_StandardSensor,2
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 006F          i = 0;
; 0000 0070          delay_ms(500);
; 0000 0071          LED_ON(LED1);
	CALL SUBOPT_0x8
; 0000 0072 //         Button.SW2 = FALSE;
; 0000 0073 
; 0000 0074           while(i<5)
_0x28:
	__CPWRN 16,17,5
	BRGE _0x2A
; 0000 0075           {         // 좌측 벽 정보의 평균값
; 0000 0076              while(!SW2());
_0x2B:
	CALL _SW2
	CPI  R30,0
	BREQ _0x2B
; 0000 0077              StandardSensor[0] = readSensor(LEFT_SENSOR) + StandardSensor[0]; // 좌측 벽 정보
	CALL SUBOPT_0x4
	MOVW R0,R30
	CALL SUBOPT_0x12
	ADD  R30,R0
	ADC  R31,R1
	CALL SUBOPT_0x9
; 0000 0078              LED_ON(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x13
; 0000 0079              delay_ms(100);
	CALL SUBOPT_0xF
; 0000 007A              LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 007B              i++;
	__ADDWRN 16,17,1
; 0000 007C           }
	RJMP _0x28
_0x2A:
; 0000 007D          StandardSensor[0] = (int)(StandardSensor[0] / 6);
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
; 0000 007E          i = 0;
	__GETWRN 16,17,0
; 0000 007F          delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x3
; 0000 0080          LED_ON(LED1|LED2);
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xA
; 0000 0081 //         Button.SW2 = FALSE;
; 0000 0082 
; 0000 0083 
; 0000 0084          while(i<5)
_0x2E:
	__CPWRN 16,17,5
	BRGE _0x30
; 0000 0085          {
; 0000 0086          // 우측 벽 정보의 평균값
; 0000 0087          while(!SW2());
_0x31:
	CALL _SW2
	CPI  R30,0
	BREQ _0x31
; 0000 0088          StandardSensor[2] = readSensor(RIGHT_SENSOR) + StandardSensor[2]; // 우 벽 정보
	__POINTW1MN _StandardSensor,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	MOVW R0,R30
	CALL SUBOPT_0x14
	ADD  R30,R0
	ADC  R31,R1
	POP  R26
	POP  R27
	CALL SUBOPT_0xC
; 0000 0089          LED_ON(LED1 | LED2 | LED3 | LED4);
; 0000 008A          delay_ms(100);
	CALL SUBOPT_0xF
; 0000 008B          LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 008C          i++;
	__ADDWRN 16,17,1
; 0000 008D          }
	RJMP _0x2E
_0x30:
; 0000 008E          StandardSensor[2] = (int)( StandardSensor[2] / 6);
	__POINTWRMN 22,23,_StandardSensor,4
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 008F          i = 0;
; 0000 0090          delay_ms(500);
; 0000 0091          LED_ON(LED1 | LED2 | LED4);
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0xA
; 0000 0092 //         Button.SW2 = FALSE;
; 0000 0093 
; 0000 0094          while(i<5)
_0x34:
	__CPWRN 16,17,5
	BRGE _0x36
; 0000 0095          {
; 0000 0096          // 좌우보정 정보의 평균값
; 0000 0097          while(!SW2());
_0x37:
	CALL _SW2
	CPI  R30,0
	BREQ _0x37
; 0000 0098          CenterStandardSensor[0] += readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xB
; 0000 0099          CenterStandardSensor[1] += readSensor(FRONT_SENSOR); // 자세보정
	CALL SUBOPT_0x16
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1EN _CenterStandardSensor,2
; 0000 009A          CenterStandardSensor[2] += readSensor(RIGHT_SENSOR); // 자세보정
	CALL SUBOPT_0x17
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1EN _CenterStandardSensor,4
; 0000 009B          LED_ON(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x13
; 0000 009C          delay_ms(100);
	CALL SUBOPT_0xF
; 0000 009D          LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 009E          i++;
	__ADDWRN 16,17,1
; 0000 009F          }
	RJMP _0x34
_0x36:
; 0000 00A0          CenterStandardSensor[0] = (int)(CenterStandardSensor[0]/6);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x10
	CALL SUBOPT_0xB
; 0000 00A1          CenterStandardSensor[1] = (int)(CenterStandardSensor[1]/6); // 자세보정
	__POINTWRMN 22,23,_CenterStandardSensor,2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x10
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 00A2          CenterStandardSensor[2] = (int)(CenterStandardSensor[2]/6); // 자세보정
	__POINTWRMN 22,23,_CenterStandardSensor,4
	CALL SUBOPT_0x17
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 00A3          i = 0;
; 0000 00A4          delay_ms(500);
; 0000 00A5          LED_ON(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x13
; 0000 00A6          LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x0
; 0000 00A7          LED_ON(LED2 | LED3 | LED4);
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0xA
; 0000 00A8 //         Button.SW2 = FALSE;
; 0000 00A9          break;               //2번모드 센서의 벽정보, 중앙보정정보 저장
	RJMP _0x12
; 0000 00AA 
; 0000 00AB     case 3:
_0x15:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A
; 0000 00AC          {
; 0000 00AD         printf("left standard : %d    center stand : %d    right stand : %d    center standatd : %d  %d  %d",StandardSensor[0],StandardSensor[1],StandardSensor[2],CenterStandardSensor[0],CenterStandardSensor[1],CenterStandardSensor[2]);
	CALL SUBOPT_0xD
; 0000 00AE 
; 0000 00AF 
; 0000 00B0                while (1)
_0x3B:
; 0000 00B1                {
; 0000 00B2 //                         delay_ms(500);
; 0000 00B3                    if(readSensor(LEFT_SENSOR) < StandardSensor[0])
	CALL SUBOPT_0x4
	MOVW R0,R30
	CALL SUBOPT_0x12
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x3E
; 0000 00B4                     {
; 0000 00B5 //                         Direction(Quarter);
; 0000 00B6 //                         Direction(Quarter);
; 0000 00B7 
; 0000 00B8                        //  Direction(HexaStep);
; 0000 00B9 
; 0000 00BA                          Direction(SmoothL);
	CALL SUBOPT_0x18
; 0000 00BB                          Direction(SmoothL);
	CALL SUBOPT_0x18
; 0000 00BC                     delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x3
; 0000 00BD                          Direction(Quarter);
	RJMP _0x49
; 0000 00BE                          Direction(Quarter);
; 0000 00BF                     }
; 0000 00C0                     else if(readSensor(FRONT_SENSOR) > StandardSensor[1])
_0x3E:
	CALL SUBOPT_0x6
	MOVW R0,R30
	CALL SUBOPT_0xE
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x40
; 0000 00C1                     {
; 0000 00C2                          if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
	CALL SUBOPT_0x7
	MOVW R0,R30
	CALL SUBOPT_0x14
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x41
; 0000 00C3                          {
; 0000 00C4 //                             Direction(Quarter);
; 0000 00C5 //                             Direction(Quarter);
; 0000 00C6                           //   Direction(HexaStep);
; 0000 00C7 
; 0000 00C8                              Direction(SmoothR);
	CALL SUBOPT_0x19
; 0000 00C9                              Direction(SmoothR);
	CALL SUBOPT_0x19
; 0000 00CA                          delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP _0x4A
; 0000 00CB                              Direction(Quarter);
; 0000 00CC                              Direction(Quarter);
; 0000 00CD                           }
; 0000 00CE                          else
_0x41:
; 0000 00CF                          {
; 0000 00D0                               LED_ON(LED3);
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0xA
; 0000 00D1                               LED_ON(LED4);
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0xA
; 0000 00D2                               Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00D3                               Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00D4 
; 0000 00D5                               Direction(LEFT);
	CALL SUBOPT_0x1A
; 0000 00D6                               Direction(LEFT);
	CALL SUBOPT_0x1A
; 0000 00D7                               delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x4A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00D8 
; 0000 00D9                               Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00DA                               Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00DB                         }
; 0000 00DC                     }
; 0000 00DD                     else
	RJMP _0x43
_0x40:
; 0000 00DE                     {
; 0000 00DF                          if(readSensor(FRONT_SENSOR)< StandardSensor[1])
	CALL SUBOPT_0x6
	MOVW R0,R30
	__POINTW2MN _StandardSensor,2
; 0000 00E0                          {
; 0000 00E1                     //   A(10);
; 0000 00E2                     //     Direction(Quarter);
; 0000 00E3                          Direction(Quarter);
; 0000 00E4                          Direction(Quarter);
; 0000 00E5                          Direction(Quarter);
; 0000 00E6                          }
; 0000 00E7                          else
; 0000 00E8                          {
; 0000 00E9                      //    D(30);
; 0000 00EA                      //    Direction(Quarter);
; 0000 00EB                          Direction(Quarter);
_0x4B:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Direction
; 0000 00EC                          Direction(Quarter);
_0x49:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Direction
; 0000 00ED                          Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00EE                          }
; 0000 00EF                     }
_0x43:
; 0000 00F0                }
	RJMP _0x3B
; 0000 00F1           }
; 0000 00F2          break;               //3번 모드 좌수법
; 0000 00F3          case 4:     {
_0x3A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x12
; 0000 00F4                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00F5                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00F6                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00F7                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00F8 
; 0000 00F9                   Direction(SmoothR);
	CALL SUBOPT_0x19
; 0000 00FA                   Direction(SmoothR);
	CALL SUBOPT_0x19
; 0000 00FB                   delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x3
; 0000 00FC 
; 0000 00FD                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00FE                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 00FF                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 0100                   Direction(Quarter);
	CALL SUBOPT_0x1
; 0000 0101                   Direction(SmoothL);
	CALL SUBOPT_0x18
; 0000 0102                   Direction(SmoothL);
	CALL SUBOPT_0x18
; 0000 0103 
; 0000 0104          }break;         //4번모드 smooth turn 보정을 위한 테스트
; 0000 0105     }
_0x12:
; 0000 0106    }
; 0000 0107 
; 0000 0108 }     ;
_0xF:
	RJMP _0x3
; 0000 0109 
; 0000 010A }
_0x47:
	RJMP _0x47
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
;#include "LED.h"
;
;void InitializeLED(void)
; 0001 0006 {

	.CSEG
_InitializeLED:
; 0001 0007      // LED - PORTF 4,5,6,7
; 0001 0008      PORTF &= 0x0F;
	LDS  R30,98
	ANDI R30,LOW(0xF)
	STS  98,R30
; 0001 0009      DDRF |= 0xF0;
	LDS  R30,97
	ORI  R30,LOW(0xF0)
	STS  97,R30
; 0001 000A }
	RET
;
;void LED_OFF(int nLED)
; 0001 000D {
_LED_OFF:
; 0001 000E      PORTF |= nLED;
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R30,X
	LD   R26,Y
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0001 000F }
	JMP  _0x20A0005
;
;void LED_ON(int nLED)
; 0001 0012 {
_LED_ON:
; 0001 0013      PORTF &= ~(nLED);
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R26,X
	LD   R30,Y
	COM  R30
	AND  R30,R26
	MOV  R26,R0
	ST   X,R30
; 0001 0014 }
	JMP  _0x20A0005
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
;// Standard Input/Output functions
;#include <stdio.h>
;#include "Sensor.h"
;#include "StepMotor.h"  // Sensor의 값을 이용하여 모터를 제어하기 때문에 모터 헤더파일이 들어가야 한다.
;
;eeprom int StandardSensor[3], CenterStandardSensor[3];
;
;void InitializeSensor(void)
; 0002 000B {

	.CSEG
_InitializeSensor:
; 0002 000C      // 발광센서 PORTB 5,6,7
; 0002 000D      PORTB &= 0x1f;
	IN   R30,0x18
	ANDI R30,LOW(0x1F)
	OUT  0x18,R30
; 0002 000E      DDRB |= 0xe0;
	IN   R30,0x17
	ORI  R30,LOW(0xE0)
	OUT  0x17,R30
; 0002 000F      // 수광센서 PORTF 0,1,2
; 0002 0010      PORTF &= 0xf8;
	LDS  R30,98
	ANDI R30,LOW(0xF8)
	STS  98,R30
; 0002 0011      DDRF &= 0xf8;
	LDS  R30,97
	ANDI R30,LOW(0xF8)
	STS  97,R30
; 0002 0012 
; 0002 0013 // ADC initialization
; 0002 0014 // ADC Clock frequency: 125.000 kHz
; 0002 0015 // ADC Voltage Reference: AVCC pin
; 0002 0016      ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0002 0017      ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0002 0018 }
	RET
;
;unsigned int read_adc(unsigned char adc_input)
; 0002 001B {
_read_adc:
; 0002 001C     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0002 001D     // Delay needed for the stabilization of the ADC input voltage
; 0002 001E     delay_us(10);
	__DELAY_USB 53
; 0002 001F     // Start the AD conversion
; 0002 0020     ADCSRA|=0x40;
	SBI  0x6,6
; 0002 0021     // Wait for the AD conversion to complete
; 0002 0022     while ((ADCSRA & 0x10)==0);
_0x40003:
	SBIS 0x6,4
	RJMP _0x40003
; 0002 0023     ADCSRA|=0x10;
	SBI  0x6,4
; 0002 0024     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20A0002
; 0002 0025 }
;
;unsigned int readSensor(char si)
; 0002 0028 {
_readSensor:
; 0002 0029      unsigned int ret;
; 0002 002A 
; 0002 002B      switch(si)
	ST   -Y,R17
	ST   -Y,R16
;	si -> Y+2
;	ret -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
; 0002 002C      {
; 0002 002D           case FRONT_SENSOR:
	SBIW R30,0
	BRNE _0x40009
; 0002 002E                PORTB.5=1;
	SBI  0x18,5
; 0002 002F                delay_us(50);
	CALL SUBOPT_0x1B
; 0002 0030                ret=read_adc(si);
; 0002 0031                PORTB.5=0;
	CBI  0x18,5
; 0002 0032                break;
	RJMP _0x40008
; 0002 0033           case LEFT_SENSOR:
_0x40009:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4000E
; 0002 0034                PORTB.6=1;
	SBI  0x18,6
; 0002 0035                delay_us(50);
	CALL SUBOPT_0x1B
; 0002 0036                ret=read_adc(si);
; 0002 0037                PORTB.6=0;
	CBI  0x18,6
; 0002 0038                break;
	RJMP _0x40008
; 0002 0039           case RIGHT_SENSOR:
_0x4000E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40008
; 0002 003A                PORTB.7=1;
	SBI  0x18,7
; 0002 003B                delay_us(50);
	CALL SUBOPT_0x1B
; 0002 003C                ret=read_adc(si);
; 0002 003D                PORTB.7=0;
	CBI  0x18,7
; 0002 003E                break;
; 0002 003F      }
_0x40008:
; 0002 0040      return ret;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0001
; 0002 0041 }
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
;#include <math.h>
;#include "StepMotor.h"
;#include "Sensor.h"
;#include <delay.h>
;
;// Declare your global variables here
;     char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};

	.DSEG
;     char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
;
;     int LeftstepCount;
;     int RightstepCount;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
;     unsigned int VelocityLeftmotorTCNT1;
;     unsigned int VelocityRightmotorTCNT3;    // 왼쪽과 오른쪽 모터의 TCNT 속도
;     unsigned char direction_control;        // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
;
;     unsigned int vel_counter_high_L, vel_counter_high_R, vel_counter_high; // 마우스 보정을 위한 변수 설정.
;
;     struct {
;          int nStep4perBlock;            // 한 블록 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn90forRight;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn90forLeft;  // LEFT가 90도 회전을 하기 위한 step 수
;          int nStep4Turn90_smooth;
;     } Information;
;     struct {
;          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
;          char RmotorRun;            // 오른쪽 모터가 회전했는지에 대한 Flag
;     } Flag;
;
;    void A(int speed)
; 0003 001F     {

	.CSEG
_A:
; 0003 0020         VelocityLeftmotorTCNT1=65400;
;	speed -> Y+0
	CALL SUBOPT_0x1C
; 0003 0021         VelocityRightmotorTCNT3=65400;
; 0003 0022         VelocityLeftmotorTCNT1+=speed;
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x1D
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1E
; 0003 0023         VelocityRightmotorTCNT3+=speed;
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x1F
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x20
; 0003 0024 
; 0003 0025         if(VelocityLeftmotorTCNT1 > 65535)
	CALL SUBOPT_0x1D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x60005
; 0003 0026         {
; 0003 0027             VelocityLeftmotorTCNT1 = 65535;
	CALL SUBOPT_0x1E
; 0003 0028         }
; 0003 0029 
; 0003 002A         if(VelocityRightmotorTCNT3 > 65535)
_0x60005:
	CALL SUBOPT_0x1F
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x60006
; 0003 002B         {
; 0003 002C             VelocityRightmotorTCNT3 = 65535;
	CALL SUBOPT_0x20
; 0003 002D         }
; 0003 002E 
; 0003 002F     }
_0x60006:
	RJMP _0x20A0005
;
;    void D(int speed2)
; 0003 0032     {
_D:
; 0003 0033         VelocityLeftmotorTCNT1=65400;
;	speed2 -> Y+0
	CALL SUBOPT_0x1C
; 0003 0034         VelocityRightmotorTCNT3=65400;
; 0003 0035         VelocityLeftmotorTCNT1-=speed2;
	LD   R26,Y
	LDD  R27,Y+1
	LDS  R30,_VelocityLeftmotorTCNT1
	LDS  R31,_VelocityLeftmotorTCNT1+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x1E
; 0003 0036         VelocityRightmotorTCNT3-=speed2;
	LD   R26,Y
	LDD  R27,Y+1
	LDS  R30,_VelocityRightmotorTCNT3
	LDS  R31,_VelocityRightmotorTCNT3+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x20
; 0003 0037 
; 0003 0038         if(VelocityLeftmotorTCNT1 < 65200)
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0xFEB0)
	LDI  R30,HIGH(0xFEB0)
	CPC  R27,R30
	BRSH _0x60007
; 0003 0039         {
; 0003 003A             VelocityLeftmotorTCNT1 = 65200;
	LDI  R30,LOW(65200)
	LDI  R31,HIGH(65200)
	CALL SUBOPT_0x1E
; 0003 003B         }
; 0003 003C 
; 0003 003D         if(VelocityRightmotorTCNT3 < 65200)
_0x60007:
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0xFEB0)
	LDI  R30,HIGH(0xFEB0)
	CPC  R27,R30
	BRSH _0x60008
; 0003 003E         {
; 0003 003F             VelocityRightmotorTCNT3 = 65200;
	LDI  R30,LOW(65200)
	LDI  R31,HIGH(65200)
	CALL SUBOPT_0x20
; 0003 0040         }
; 0003 0041     }
_0x60008:
_0x20A0005:
	ADIW R28,2
	RET
;
;int adjustmouse(void)
; 0003 0044 {
_adjustmouse:
; 0003 0045     int adjLeftSensor,adjRightSensor;
; 0003 0046     int adjflagcnt = 0;
; 0003 0047 
; 0003 0048     adjLeftSensor = readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x21
;	adjLeftSensor -> R16,R17
;	adjRightSensor -> R18,R19
;	adjflagcnt -> R20,R21
	MOVW R16,R30
; 0003 0049     adjRightSensor = readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x22
; 0003 004A 
; 0003 004B     vel_counter_high_L = VelocityLeftmotorTCNT1;	        //현재 바퀴속도값을 변수 counter에 각각 저장(65200 ~ 65535)
; 0003 004C     vel_counter_high_R = VelocityRightmotorTCNT3;
; 0003 004D 
; 0003 004E     if((adjRightSensor < StandardSensor[2])             // 오른쪽 벽이 존재하지 않을 경우
; 0003 004F     || (adjLeftSensor < StandardSensor[1]))             // 왼쪽 벽이 존재하지 않을 경우
	CALL SUBOPT_0x14
	CP   R18,R30
	CPC  R19,R31
	BRLT _0x6000A
	CALL SUBOPT_0xE
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60009
_0x6000A:
; 0003 0050     {
; 0003 0051         vel_counter_high_L = vel_counter_high;          // 속도를 같게하고 리턴
	CALL SUBOPT_0x23
; 0003 0052         vel_counter_high_R = vel_counter_high;
; 0003 0053         return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RJMP _0x20A0004
; 0003 0054     }
; 0003 0055 
; 0003 0056     if(adjRightSensor < CenterStandardSensor[2])            // 오른쪽 벽이 멀 경우
_0x60009:
	CALL SUBOPT_0x17
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6000C
; 0003 0057     {
; 0003 0058         vel_counter_high_L+=2.5;
	MOVW R30,R10
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	MOVW R10,R30
; 0003 0059         vel_counter_high_R-=2.5;
	MOVW R30,R12
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0003 005A         if(vel_counter_high_L > vel_counter_high+15)
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x6000D
; 0003 005B         {
; 0003 005C             vel_counter_high_L = vel_counter_high+15;
	CALL SUBOPT_0x28
	ADIW R30,15
	MOVW R10,R30
; 0003 005D         }
; 0003 005E 
; 0003 005F         if(vel_counter_high_R < (vel_counter_high - 15))
_0x6000D:
	CALL SUBOPT_0x28
	SBIW R30,15
	CP   R12,R30
	CPC  R13,R31
	BRSH _0x6000E
; 0003 0060         {
; 0003 0061             vel_counter_high_R = (vel_counter_high - 15);
	CALL SUBOPT_0x28
	SBIW R30,15
	MOVW R12,R30
; 0003 0062         }
; 0003 0063     }
_0x6000E:
; 0003 0064     else
	RJMP _0x6000F
_0x6000C:
; 0003 0065     adjflagcnt++;
	__ADDWRN 20,21,1
; 0003 0066 
; 0003 0067     if(adjLeftSensor < CenterStandardSensor[1])    // 왼쪽 벽이 멀 경우
_0x6000F:
	CALL SUBOPT_0x16
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60010
; 0003 0068     {
; 0003 0069         vel_counter_high_L-=2.5;
	MOVW R30,R10
	CALL SUBOPT_0x26
	MOVW R10,R30
; 0003 006A         vel_counter_high_R+=2.5;
	MOVW R30,R12
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	CALL SUBOPT_0x27
; 0003 006B         if(vel_counter_high_R > vel_counter_high+15)
	CP   R30,R12
	CPC  R31,R13
	BRSH _0x60011
; 0003 006C         {
; 0003 006D             vel_counter_high_R = vel_counter_high+15;
	CALL SUBOPT_0x28
	ADIW R30,15
	MOVW R12,R30
; 0003 006E         }
; 0003 006F         if(vel_counter_high_L < (vel_counter_high - 15))
_0x60011:
	CALL SUBOPT_0x28
	SBIW R30,15
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x60012
; 0003 0070         {
; 0003 0071             vel_counter_high_L = (vel_counter_high - 15);
	CALL SUBOPT_0x28
	SBIW R30,15
	MOVW R10,R30
; 0003 0072         }
; 0003 0073     }
_0x60012:
; 0003 0074     else
	RJMP _0x60013
_0x60010:
; 0003 0075     adjflagcnt++;
	__ADDWRN 20,21,1
; 0003 0076 
; 0003 0077     if(adjflagcnt == 2)  // 오른쪽 벽과 왼쪽 벽이 둘다 멀지 않을 경우
_0x60013:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x60014
; 0003 0078 	{
; 0003 0079 		vel_counter_high_L = vel_counter_high;  // 속도 동일하게
	CALL SUBOPT_0x23
; 0003 007A 		vel_counter_high_R = vel_counter_high;
; 0003 007B 
; 0003 007C 	}
; 0003 007D     VelocityLeftmotorTCNT1 = vel_counter_high_L;
_0x60014:
	CALL SUBOPT_0x29
; 0003 007E     VelocityRightmotorTCNT3 = vel_counter_high_R;
; 0003 007F }
	CALL __LOADLOCR6
	RJMP _0x20A0004
;
;int adjustmouse_Super(void)  //보정
; 0003 0082 {
_adjustmouse_Super:
; 0003 0083     int adjLeftSensor,adjRightSensor;  //보정하기위한 센서값을 저장한 변수
; 0003 0084     int adjflagcnt = 0;
; 0003 0085 
; 0003 0086     adjLeftSensor = readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x21
;	adjLeftSensor -> R16,R17
;	adjRightSensor -> R18,R19
;	adjflagcnt -> R20,R21
	MOVW R16,R30
; 0003 0087     adjRightSensor = readSensor(RIGHT_SENSOR);  //읽어들인 센서값을 저장
	CALL SUBOPT_0x7
	CALL SUBOPT_0x22
; 0003 0088 
; 0003 0089     vel_counter_high_L=VelocityLeftmotorTCNT1;   //모터 속도 65250 으로 초기화
; 0003 008A     vel_counter_high_R=VelocityRightmotorTCNT3;  //모터 속도 65400 으로 초기화
; 0003 008B 
; 0003 008C 
; 0003 008D     if(adjRightSensor > CenterStandardSensor[2])  //미로 주행 중 오른 쪽 벽에 너무 가까이 붙었을 경우
	CALL SUBOPT_0x17
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x60015
; 0003 008E     {
; 0003 008F         vel_counter_high_L-=2;
	CALL SUBOPT_0x2A
; 0003 0090         vel_counter_high_R+=1;
; 0003 0091         if(vel_counter_high_R > vel_counter_high+20)
	BRSH _0x60016
; 0003 0092             vel_counter_high_R = vel_counter_high+20;
	CALL SUBOPT_0x2B
; 0003 0093         if(vel_counter_high_L < (vel_counter_high-20))
_0x60016:
	CALL SUBOPT_0x2C
	BRSH _0x60017
; 0003 0094             vel_counter_high_L = (vel_counter_high-20);
	CALL SUBOPT_0x2D
; 0003 0095         //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 높여서 오른쪽 벽에서 멀어지도록 하였다.
; 0003 0096     }
_0x60017:
; 0003 0097     else
	RJMP _0x60018
_0x60015:
; 0003 0098     {
; 0003 0099         if(adjRightSensor < CenterStandardSensor[2]) // 오른쪽 벽이 멀 경우
	CALL SUBOPT_0x17
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60019
; 0003 009A         {
; 0003 009B             vel_counter_high_L+=1;
	CALL SUBOPT_0x2E
; 0003 009C             vel_counter_high_R-=2;
; 0003 009D             if(vel_counter_high_L > vel_counter_high+20)
	BRSH _0x6001A
; 0003 009E                 vel_counter_high_L = vel_counter_high+20;
	CALL SUBOPT_0x2F
; 0003 009F             if(vel_counter_high_R < vel_counter_high-20)
_0x6001A:
	CALL SUBOPT_0x30
	BRSH _0x6001B
; 0003 00A0                 vel_counter_high_R = vel_counter_high-20;
	CALL SUBOPT_0x31
; 0003 00A1             //오른쪽 벽이 멀 경우에 왼쪽 모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하게 한다.
; 0003 00A2         }
_0x6001B:
; 0003 00A3         else
	RJMP _0x6001C
_0x60019:
; 0003 00A4             adjflagcnt++;  //오른쪽 벽에 너무 가깝지도 않고, 멀지도 않은 경우 flagcnt 증가
	__ADDWRN 20,21,1
; 0003 00A5 
; 0003 00A6         if(adjLeftSensor < CenterStandardSensor[1]) // 왼쪽 벽이 멀 경우
_0x6001C:
	CALL SUBOPT_0x16
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x6001D
; 0003 00A7         {
; 0003 00A8             vel_counter_high_L-=2;
	CALL SUBOPT_0x2A
; 0003 00A9             vel_counter_high_R+=1;
; 0003 00AA             if(vel_counter_high_R > vel_counter_high+20)
	BRSH _0x6001E
; 0003 00AB                 vel_counter_high_R = vel_counter_high+20;
	CALL SUBOPT_0x2B
; 0003 00AC             if(vel_counter_high_L < (vel_counter_high-20))
_0x6001E:
	CALL SUBOPT_0x2C
	BRSH _0x6001F
; 0003 00AD                 vel_counter_high_L = (vel_counter_high-20);
	CALL SUBOPT_0x2D
; 0003 00AE             //왼쪽 벽이 멀 경우에 오른쪽 모터의 속도를 높이고 왼쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00AF         }
_0x6001F:
; 0003 00B0         else
	RJMP _0x60020
_0x6001D:
; 0003 00B1             adjflagcnt++;   //오른쪽 벽에 너무 가깝지도 않고, 왼쪽 벽과도 멀지 않은 경우 flagcnt 증가
	__ADDWRN 20,21,1
; 0003 00B2     }
_0x60020:
_0x60018:
; 0003 00B3 
; 0003 00B4     if(adjLeftSensor > CenterStandardSensor[1])  //마우스가 왼쪽 벽에 너무 가까이 붙은 경우
	CALL SUBOPT_0x16
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x60021
; 0003 00B5     {
; 0003 00B6         vel_counter_high_L+=1;
	CALL SUBOPT_0x2E
; 0003 00B7         vel_counter_high_R-=2;
; 0003 00B8         if(vel_counter_high_L > vel_counter_high+20)
	BRSH _0x60022
; 0003 00B9             vel_counter_high_L = vel_counter_high+20;
	CALL SUBOPT_0x2F
; 0003 00BA         if(vel_counter_high_R < vel_counter_high-20)
_0x60022:
	CALL SUBOPT_0x30
	BRSH _0x60023
; 0003 00BB             vel_counter_high_R = vel_counter_high-20;
	CALL SUBOPT_0x31
; 0003 00BC         //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00BD     }
_0x60023:
; 0003 00BE     else
	RJMP _0x60024
_0x60021:
; 0003 00BF     {
; 0003 00C0         if(adjRightSensor < CenterStandardSensor[2]) // 오른쪽 벽이 멀 경우
	CALL SUBOPT_0x17
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60025
; 0003 00C1         {
; 0003 00C2             vel_counter_high_L+=1;
	CALL SUBOPT_0x2E
; 0003 00C3             vel_counter_high_R-=2;
; 0003 00C4             if(vel_counter_high_L > vel_counter_high+20)
	BRSH _0x60026
; 0003 00C5                 vel_counter_high_L = vel_counter_high+20;
	CALL SUBOPT_0x2F
; 0003 00C6             if(vel_counter_high_R < vel_counter_high-20)
_0x60026:
	CALL SUBOPT_0x30
	BRSH _0x60027
; 0003 00C7                 vel_counter_high_R = vel_counter_high-20;
	CALL SUBOPT_0x31
; 0003 00C8             //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00C9         }
_0x60027:
; 0003 00CA         else
	RJMP _0x60028
_0x60025:
; 0003 00CB             adjflagcnt++;  //왼쪽 벽에 너무 가깝지 않고 오른쪽 벽과도 멀지 않은 경우 flagcnt 증가
	__ADDWRN 20,21,1
; 0003 00CC 
; 0003 00CD         if(adjLeftSensor < CenterStandardSensor[1]) // 왼쪽 벽이 멀 경우
_0x60028:
	CALL SUBOPT_0x16
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60029
; 0003 00CE         {
; 0003 00CF             vel_counter_high_L-=2;
	CALL SUBOPT_0x2A
; 0003 00D0             vel_counter_high_R+=1;
; 0003 00D1             if(vel_counter_high_R > vel_counter_high+20)
	BRSH _0x6002A
; 0003 00D2                 vel_counter_high_R = vel_counter_high+20;
	CALL SUBOPT_0x2B
; 0003 00D3             if(vel_counter_high_L < (vel_counter_high-20))
_0x6002A:
	CALL SUBOPT_0x2C
	BRSH _0x6002B
; 0003 00D4                 vel_counter_high_L = (vel_counter_high-20);
	CALL SUBOPT_0x2D
; 0003 00D5             //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 줄여 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00D6         }
_0x6002B:
; 0003 00D7         else
	RJMP _0x6002C
_0x60029:
; 0003 00D8             adjflagcnt++;  //왼쪽 벽에 너무 붙지도 않고, 왼쪽 벽에 멀지 않은 경우(마우스가 주행경로의 가운데) flagcnt 증가
	__ADDWRN 20,21,1
; 0003 00D9 
; 0003 00DA     }
_0x6002C:
_0x60024:
; 0003 00DB 
; 0003 00DC     if(adjRightSensor < StandardSensor[2]) //오른쪽 벽이 존재하지 않을 경우
	CALL SUBOPT_0x14
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6002D
; 0003 00DD     {
; 0003 00DE         if(adjLeftSensor < CenterStandardSensor[1]) // 왼쪽 벽이 멀 경우
	CALL SUBOPT_0x16
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x6002E
; 0003 00DF         {
; 0003 00E0             vel_counter_high_L-=2;
	CALL SUBOPT_0x2A
; 0003 00E1             vel_counter_high_R+=1;
; 0003 00E2             if(vel_counter_high_R > vel_counter_high+20)
	BRSH _0x6002F
; 0003 00E3                 vel_counter_high_R = vel_counter_high+20;
	CALL SUBOPT_0x2B
; 0003 00E4             if(vel_counter_high_L < (vel_counter_high-20))
_0x6002F:
	CALL SUBOPT_0x2C
	BRSH _0x60030
; 0003 00E5                 vel_counter_high_L = (vel_counter_high-20);
	CALL SUBOPT_0x2D
; 0003 00E6             //왼쪽 벽이 멀 경우에 오른쪽 모터의 속도를 높이고 왼쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00E7         }
_0x60030:
; 0003 00E8         if(adjLeftSensor > CenterStandardSensor[1])  //마우스가 왼쪽 벽에 너무 가까이 붙은 경우
_0x6002E:
	CALL SUBOPT_0x16
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x60031
; 0003 00E9         {
; 0003 00EA         vel_counter_high_L+=1;
	CALL SUBOPT_0x2E
; 0003 00EB         vel_counter_high_R-=2;
; 0003 00EC         if(vel_counter_high_L > vel_counter_high+20)
	BRSH _0x60032
; 0003 00ED             vel_counter_high_L = vel_counter_high+20;
	CALL SUBOPT_0x2F
; 0003 00EE         if(vel_counter_high_R < vel_counter_high-20)
_0x60032:
	CALL SUBOPT_0x30
	BRSH _0x60033
; 0003 00EF             vel_counter_high_R = vel_counter_high-20;
	CALL SUBOPT_0x31
; 0003 00F0         //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00F1         }
_0x60033:
; 0003 00F2     }
_0x60031:
; 0003 00F3 
; 0003 00F4      if(adjLeftSensor < StandardSensor[2]) //왼쪽 벽이 존재하지 않을 경우
_0x6002D:
	CALL SUBOPT_0x14
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60034
; 0003 00F5      {
; 0003 00F6            if(adjRightSensor < CenterStandardSensor[2]) // 오른쪽 벽이 멀 경우
	CALL SUBOPT_0x17
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60035
; 0003 00F7         {
; 0003 00F8             vel_counter_high_L+=1;
	CALL SUBOPT_0x2E
; 0003 00F9             vel_counter_high_R-=2;
; 0003 00FA             if(vel_counter_high_L > vel_counter_high+20)
	BRSH _0x60036
; 0003 00FB                 vel_counter_high_L = vel_counter_high+20;
	CALL SUBOPT_0x2F
; 0003 00FC             if(vel_counter_high_R < vel_counter_high-20)
_0x60036:
	CALL SUBOPT_0x30
	BRSH _0x60037
; 0003 00FD                 vel_counter_high_R = vel_counter_high-20;
	CALL SUBOPT_0x31
; 0003 00FE             //왼쪽모터의 속도를 높이고 오른쪽 모터의 속도를 줄여서 주행경로의 가운데에 마우스가 위치하도록 한다.
; 0003 00FF         }
_0x60037:
; 0003 0100         if(adjRightSensor > CenterStandardSensor[2])  //미로 주행 중 오른 쪽 벽에 너무 가까이 붙었을 경우
_0x60035:
	CALL SUBOPT_0x17
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x60038
; 0003 0101          {
; 0003 0102         vel_counter_high_L-=2;
	CALL SUBOPT_0x2A
; 0003 0103         vel_counter_high_R+=1;
; 0003 0104         if(vel_counter_high_R > vel_counter_high+20)
	BRSH _0x60039
; 0003 0105             vel_counter_high_R = vel_counter_high+20;
	CALL SUBOPT_0x2B
; 0003 0106         if(vel_counter_high_L < (vel_counter_high-20))
_0x60039:
	CALL SUBOPT_0x2C
	BRSH _0x6003A
; 0003 0107             vel_counter_high_L = (vel_counter_high-20);
	CALL SUBOPT_0x2D
; 0003 0108         //왼쪽 모터의 속도를 줄이고 오른쪽 모터의 속도를 높여서 오른쪽 벽에서 멀어지도록 하였다.
; 0003 0109         }
_0x6003A:
; 0003 010A 
; 0003 010B      }
_0x60038:
; 0003 010C 
; 0003 010D     if(adjflagcnt == 2)
_0x60034:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x6003B
; 0003 010E     {       // 속도 동일하게
; 0003 010F         vel_counter_high_L = vel_counter_high;
	CALL SUBOPT_0x23
; 0003 0110         vel_counter_high_R = vel_counter_high;
; 0003 0111     }
; 0003 0112     return 0;
_0x6003B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RJMP _0x20A0004
; 0003 0113 }
;
;void InitializeStepmotor(void)
; 0003 0116 {
_InitializeStepmotor:
; 0003 0117 	double distance4perStep;
; 0003 0118     double distance4perStep_smooth;
; 0003 0119 
; 0003 011A // LEFT MOTOR - PORTD 4,5,6,7
; 0003 011B      PORTD&=0x0F;
	SBIW R28,8
;	distance4perStep -> Y+4
;	distance4perStep_smooth -> Y+0
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0003 011C      DDRD|=0xF0;
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
; 0003 011D 
; 0003 011E // RIGHT MOTOR - PORTE 4,5,6,7
; 0003 011F      PORTE&=0x0F;
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	OUT  0x3,R30
; 0003 0120      DDRE|=0xF0;
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
; 0003 0121 
; 0003 0122 // Timer/Counter 1 initialization
; 0003 0123 // Clock source: System Clock
; 0003 0124 // Clock value: 62.500 kHz
; 0003 0125 // Mode: Normal top=FFFFh
; 0003 0126 // OC1A output: Discon.
; 0003 0127 // OC1B output: Discon.
; 0003 0128 // OC1C output: Discon.
; 0003 0129 // Noise Canceler: Off
; 0003 012A // Input Capture on Falling Edge
; 0003 012B // Timer 1 Overflow Interrupt: On
; 0003 012C // Input Capture Interrupt: Off
; 0003 012D // Compare A Match Interrupt: Off
; 0003 012E // Compare B Match Interrupt: Off
; 0003 012F // Compare C Match Interrupt: Off
; 0003 0130      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0003 0131      TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0003 0132      TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0003 0133      TCNT1L=0x00;
	OUT  0x2C,R30
; 0003 0134      ICR1H=0x00;
	OUT  0x27,R30
; 0003 0135      ICR1L=0x00;
	OUT  0x26,R30
; 0003 0136      OCR1AH=0x00;
	OUT  0x2B,R30
; 0003 0137      OCR1AL=0x00;
	OUT  0x2A,R30
; 0003 0138      OCR1BH=0x00;
	OUT  0x29,R30
; 0003 0139      OCR1BL=0x00;
	OUT  0x28,R30
; 0003 013A      OCR1CH=0x00;
	STS  121,R30
; 0003 013B      OCR1CL=0x00;
	STS  120,R30
; 0003 013C 
; 0003 013D // Timer/Counter 3 initialization
; 0003 013E // Clock source: System Clock
; 0003 013F // Clock value: 62.500 kHz
; 0003 0140 // Mode: Normal top=FFFFh
; 0003 0141 // OC3A output: Discon.
; 0003 0142 // OC3B output: Discon.
; 0003 0143 // OC3C output: Discon.
; 0003 0144 // Noise Canceler: Off
; 0003 0145 // Input Capture on Falling Edge
; 0003 0146 // Timer 3 Overflow Interrupt: On
; 0003 0147 // Input Capture Interrupt: Off
; 0003 0148 // Compare A Match Interrupt: Off
; 0003 0149 // Compare B Match Interrupt: Off
; 0003 014A // Compare C Match Interrupt: Off
; 0003 014B      TCCR3A=0x00;
	STS  139,R30
; 0003 014C      TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0003 014D      TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0003 014E      TCNT3L=0x00;
	STS  136,R30
; 0003 014F      ICR3H=0x00;
	STS  129,R30
; 0003 0150      ICR3L=0x00;
	STS  128,R30
; 0003 0151      OCR3AH=0x00;
	STS  135,R30
; 0003 0152      OCR3AL=0x00;
	STS  134,R30
; 0003 0153      OCR3BH=0x00;
	STS  133,R30
; 0003 0154      OCR3BL=0x00;
	STS  132,R30
; 0003 0155      OCR3CH=0x00;
	STS  131,R30
; 0003 0156      OCR3CL=0x00;
	STS  130,R30
; 0003 0157 
; 0003 0158 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0003 0159      TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0003 015A      ETIMSK=0x04;
	STS  125,R30
; 0003 015B 
; 0003 015C 	LeftstepCount = 0;
	CLR  R4
	CLR  R5
; 0003 015D     RightstepCount = 0;
	CLR  R6
	CLR  R7
; 0003 015E     vel_counter_high = 65400;
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	STS  _vel_counter_high,R30
	STS  _vel_counter_high+1,R31
; 0003 015F     VelocityLeftmotorTCNT1 = vel_counter_high;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1E
; 0003 0160     VelocityRightmotorTCNT3 = vel_counter_high;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x20
; 0003 0161 // LEFT MOTOR - PORTD 4,5,6,7
; 0003 0162 	PORTD&=0x0F;
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0003 0163 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0003 0164 	TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0003 0165 	ETIMSK=0x04;
	STS  125,R30
; 0003 0166 
; 0003 0167 	distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	__GETD1N 0x3ECD154B
	__PUTD1S 4
; 0003 0168     distance4perStep_smooth = (double)(PI * TIRE_RAD2 / (double)MOTOR_STEP);
	__GETD1N 0x3ED11ABA
	CALL __PUTD1S0
; 0003 0169 
; 0003 016A 	Information.nStep4perBlock = (int)((double)185. / distance4perStep);
	CALL SUBOPT_0x32
	__GETD2N 0x43390000
	CALL SUBOPT_0x33
	STS  _Information,R30
	STS  _Information+1,R31
; 0003 016B 	Information.nStep4Turn90forRight = (int)((PI*MOUSE_WIDTH/3.55)/distance4perStep);
	CALL SUBOPT_0x32
	__GETD2N 0x429121FB
	CALL SUBOPT_0x33
	__PUTW1MN _Information,2
; 0003 016C 	Information.nStep4Turn90forLeft = (int)((PI*MOUSE_WIDTH/3.85)/distance4perStep);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	__PUTW1MN _Information,4
; 0003 016D     Information.nStep4Turn90_smooth = (int)((PI*MOUSE_WIDTH/3.85)/distance4perStep_smooth);
	CALL __GETD1S0
	CALL SUBOPT_0x34
	__PUTW1MN _Information,6
; 0003 016E }
	ADIW R28,8
	RET
;
;void Direction(int mode)
; 0003 0171 {
_Direction:
; 0003 0172      int LStepCount = 0, RStepCount = 0;
; 0003 0173 
; 0003 0174      TCCR1B = 0x04;
	CALL __SAVELOCR4
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0003 0175      TCCR3B = 0x04;
	STS  138,R30
; 0003 0176 
; 0003 0177      direction_control = mode;
	LDD  R9,Y+4
; 0003 0178 
; 0003 0179      Flag.LmotorRun = FALSE;
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0003 017A      Flag.RmotorRun = FALSE;
	__PUTB1MN _Flag,1
; 0003 017B 
; 0003 017C      switch(mode)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0003 017D      {
; 0003 017E      case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6003F
; 0003 017F           while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
_0x60040:
	CALL SUBOPT_0x35
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60043
	CALL SUBOPT_0x35
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60042
_0x60043:
; 0003 0180           {
; 0003 0181               adjustmouse();  // 직진으로 진행하며 좌우 보정을 진행해야 하기에 코드 첫 부분에 삽입했다.
	RCALL _adjustmouse
; 0003 0182               VelocityLeftmotorTCNT1=vel_counter_high_L;
	CALL SUBOPT_0x29
; 0003 0183               VelocityRightmotorTCNT3=vel_counter_high_R;
; 0003 0184                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60045
; 0003 0185                {
; 0003 0186                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 0187                     Flag.LmotorRun = FALSE;
; 0003 0188                }
; 0003 0189                if(Flag.RmotorRun)
_0x60045:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60046
; 0003 018A                {
; 0003 018B                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 018C                     Flag.RmotorRun = FALSE;
; 0003 018D                }
; 0003 018E           }
_0x60046:
	RJMP _0x60040
_0x60042:
; 0003 018F           break;
	RJMP _0x6003E
; 0003 0190      case HALF:
_0x6003F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60047
; 0003 0191           while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
_0x60048:
	CALL SUBOPT_0x35
	ASR  R31
	ROR  R30
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x6004B
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6004A
_0x6004B:
; 0003 0192           {
; 0003 0193                if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])
	CALL SUBOPT_0x6
	MOVW R0,R30
	CALL SUBOPT_0x15
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x6004A
; 0003 0194                break;   // 오차가 누적되어 전방에 벽이 있을 경우 바로 멈추게 함.
; 0003 0195 
; 0003 0196                if(Flag.LmotorRun || Flag.RmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x6004F
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6004E
_0x6004F:
; 0003 0197                {    // Step이 진행될 때 마다 보정이 진행되게끔 한다.
; 0003 0198                     vel_counter_high_L= VelocityLeftmotorTCNT1;
	CALL SUBOPT_0x38
; 0003 0199                     vel_counter_high_R =VelocityRightmotorTCNT3;
; 0003 019A                     adjustmouse_Super();
; 0003 019B                     VelocityLeftmotorTCNT1 =  vel_counter_high_L;
; 0003 019C                     VelocityRightmotorTCNT3 = vel_counter_high_R;
; 0003 019D                }
; 0003 019E 
; 0003 019F 
; 0003 01A0                if(Flag.LmotorRun)
_0x6004E:
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60051
; 0003 01A1                {
; 0003 01A2                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 01A3                     Flag.LmotorRun = FALSE;
; 0003 01A4                }
; 0003 01A5                if(Flag.RmotorRun)
_0x60051:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60052
; 0003 01A6                {
; 0003 01A7                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 01A8                     Flag.RmotorRun = FALSE;
; 0003 01A9                }
; 0003 01AA           }
_0x60052:
	RJMP _0x60048
_0x6004A:
; 0003 01AB           break;
	RJMP _0x6003E
; 0003 01AC 
; 0003 01AD      case Quarter:
_0x60047:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x60053
; 0003 01AE           while(LStepCount<((Information.nStep4perBlock>>2)) || RStepCount<((Information.nStep4perBlock>>2)))
_0x60054:
	CALL SUBOPT_0x35
	CALL __ASRW2
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60057
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60056
_0x60057:
; 0003 01AF           {
; 0003 01B0                if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])
	CALL SUBOPT_0x6
	MOVW R0,R30
	CALL SUBOPT_0x15
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x60056
; 0003 01B1                break;   // 오차가 누적되어 전방에 벽이 있을 경우 바로 멈추게 함.
; 0003 01B2 
; 0003 01B3                if(Flag.LmotorRun || Flag.RmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x6005B
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6005A
_0x6005B:
; 0003 01B4                {    // Step이 진행될 때 마다 보정이 진행되게끔 한다.
; 0003 01B5                     vel_counter_high_L = VelocityLeftmotorTCNT1;
	CALL SUBOPT_0x38
; 0003 01B6                     vel_counter_high_R = VelocityRightmotorTCNT3;
; 0003 01B7                     adjustmouse_Super();
; 0003 01B8                     VelocityLeftmotorTCNT1 =  vel_counter_high_L;
; 0003 01B9                     VelocityRightmotorTCNT3 = vel_counter_high_R;
; 0003 01BA                }
; 0003 01BB 
; 0003 01BC                if(Flag.LmotorRun)
_0x6005A:
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x6005D
; 0003 01BD                {
; 0003 01BE                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 01BF                     Flag.LmotorRun = FALSE;
; 0003 01C0                }
; 0003 01C1                if(Flag.RmotorRun)
_0x6005D:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6005E
; 0003 01C2                {
; 0003 01C3                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 01C4                     Flag.RmotorRun = FALSE;
; 0003 01C5                }
; 0003 01C6           }
_0x6005E:
	RJMP _0x60054
_0x60056:
; 0003 01C7           break;
	RJMP _0x6003E
; 0003 01C8 
; 0003 01C9      case HexaStep:
_0x60053:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x6005F
; 0003 01CA           while(LStepCount<(Information.nStep4perBlock>>3) || RStepCount<(Information.nStep4perBlock>>3))
_0x60060:
	CALL SUBOPT_0x35
	CALL __ASRW3
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60063
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60062
_0x60063:
; 0003 01CB           {
; 0003 01CC            //   adjustmouse_Super();  // 보정 함수는 앞으로 가면서 보정을 하기 때문에 삽입한다.
; 0003 01CD            //   VelocityLeftmotorTCNT1=vel_counter_high_L;
; 0003 01CE            //   VelocityRightmotorTCNT3=vel_counter_high_R;
; 0003 01CF 
; 0003 01D0                if(readSensor(FRONT_SENSOR)>=CenterStandardSensor[0])
	CALL SUBOPT_0x6
	MOVW R0,R30
	CALL SUBOPT_0x15
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x60062
; 0003 01D1                break;                                                 //전방 보정 : 전방에 벽 있는 경우 정지
; 0003 01D2 
; 0003 01D3                if(Flag.LmotorRun || Flag.RmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x60067
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60066
_0x60067:
; 0003 01D4                {
; 0003 01D5                     vel_counter_high_L= VelocityLeftmotorTCNT1;
	CALL SUBOPT_0x38
; 0003 01D6                     vel_counter_high_R =VelocityRightmotorTCNT3;
; 0003 01D7                     adjustmouse_Super();                                  //마우스 자세 보정
; 0003 01D8                     VelocityLeftmotorTCNT1 =  vel_counter_high_L;
; 0003 01D9                     VelocityRightmotorTCNT3 = vel_counter_high_R;
; 0003 01DA                }
; 0003 01DB 
; 0003 01DC                if(Flag.LmotorRun)
_0x60066:
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60069
; 0003 01DD                {
; 0003 01DE                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 01DF                     Flag.LmotorRun = FALSE;
; 0003 01E0                }
; 0003 01E1                if(Flag.RmotorRun)
_0x60069:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6006A
; 0003 01E2                {
; 0003 01E3                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 01E4                     Flag.RmotorRun = FALSE;
; 0003 01E5                }
; 0003 01E6           }
_0x6006A:
	RJMP _0x60060
_0x60062:
; 0003 01E7           break;
	RJMP _0x6003E
; 0003 01E8 
; 0003 01E9      case SmoothR:
_0x6005F:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ _0x6006C
; 0003 01EA      case SmoothL:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x6006D
_0x6006C:
; 0003 01EB           while(RStepCount<Information.nStep4Turn90_smooth || LStepCount<Information.nStep4Turn90_smooth)
_0x6006E:
	__GETW1MN _Information,6
	CP   R18,R30
	CPC  R19,R31
	BRLT _0x60071
	__GETW1MN _Information,6
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60070
_0x60071:
; 0003 01EC           {
; 0003 01ED             if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60073
; 0003 01EE             {
; 0003 01EF                 LStepCount++;
	CALL SUBOPT_0x36
; 0003 01F0                 Flag.LmotorRun = FALSE;
; 0003 01F1             }
; 0003 01F2 
; 0003 01F3             if(Flag.RmotorRun)
_0x60073:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60074
; 0003 01F4             {
; 0003 01F5                 RStepCount++;
	CALL SUBOPT_0x37
; 0003 01F6                 Flag.RmotorRun = FALSE;
; 0003 01F7             }
; 0003 01F8           }
_0x60074:
	RJMP _0x6006E
_0x60070:
; 0003 01F9           break;
	RJMP _0x6003E
; 0003 01FA      case LEFT:
_0x6006D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ _0x60076
; 0003 01FB      case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60077
_0x60076:
; 0003 01FC           while(LStepCount<Information.nStep4Turn90forLeft || RStepCount<Information.nStep4Turn90forRight)
_0x60078:
	__GETW1MN _Information,4
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x6007B
	__GETW1MN _Information,2
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6007A
_0x6007B:
; 0003 01FD           {
; 0003 01FE                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x6007D
; 0003 01FF                {
; 0003 0200                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 0201                     Flag.LmotorRun = FALSE;
; 0003 0202                }
; 0003 0203                if(Flag.RmotorRun)
_0x6007D:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6007E
; 0003 0204                {
; 0003 0205                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 0206                     Flag.RmotorRun = FALSE;
; 0003 0207                }
; 0003 0208           }
_0x6007E:
	RJMP _0x60078
_0x6007A:
; 0003 0209           break;
	RJMP _0x6003E
; 0003 020A      case BACK:
_0x60077:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6003E
; 0003 020B           while(LStepCount<(Information.nStep4Turn90_smooth*2) || RStepCount<(Information.nStep4Turn90_smooth*2))
_0x60080:
	__GETW2MN _Information,6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60083
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60082
_0x60083:
; 0003 020C           {
; 0003 020D                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60085
; 0003 020E                {
; 0003 020F                     LStepCount++;
	CALL SUBOPT_0x36
; 0003 0210                     Flag.LmotorRun = FALSE;
; 0003 0211                }
; 0003 0212                if(Flag.RmotorRun)
_0x60085:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60086
; 0003 0213                {
; 0003 0214                     RStepCount++;
	CALL SUBOPT_0x37
; 0003 0215                     Flag.RmotorRun = FALSE;
; 0003 0216                }
; 0003 0217           }
_0x60086:
	RJMP _0x60080
_0x60082:
; 0003 0218           break;
; 0003 0219      }
_0x6003E:
; 0003 021A      TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0003 021B      TCCR3B = 0x00;
	STS  138,R30
; 0003 021C }
	CALL __LOADLOCR4
_0x20A0004:
	ADIW R28,6
	RET
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0003 0220 {
_timer1_ovf_isr:
	CALL SUBOPT_0x39
; 0003 0221 // Place your code here
; 0003 0222      switch(direction_control)
; 0003 0223      {
; 0003 0224           case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6008A
; 0003 0225                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x3A
	OR   R30,R0
	OUT  0x12,R30
; 0003 0226                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x3A
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0003 0227                LeftstepCount--;
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0003 0228                if(LeftstepCount < 0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x6008B
; 0003 0229                     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0003 022A                break;
_0x6008B:
	RJMP _0x60089
; 0003 022B           case RIGHT:
_0x6008A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x6008D
; 0003 022C           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6008E
_0x6008D:
; 0003 022D           case Quarter:
	RJMP _0x6008F
_0x6008E:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x60090
_0x6008F:
; 0003 022E           case ACCEL:
	RJMP _0x60091
_0x60090:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x60092
_0x60091:
; 0003 022F           case FORWARD:
	RJMP _0x60093
_0x60092:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60094
_0x60093:
; 0003 0230           case HALF:
	RJMP _0x60095
_0x60094:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60096
_0x60095:
; 0003 0231           case SmoothR:
	RJMP _0x60097
_0x60096:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x60098
_0x60097:
; 0003 0232                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x3A
	OR   R30,R0
	OUT  0x12,R30
; 0003 0233                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x3A
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0003 0234                LeftstepCount++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0003 0235                LeftstepCount %= sizeof(rotateL);
	MOVW R26,R4
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R4,R30
; 0003 0236                break;
; 0003 0237           case SmoothL:
_0x60098:
; 0003 0238           break;
; 0003 0239      }
_0x60089:
; 0003 023A      Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0003 023B 
; 0003 023C      TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	LDS  R30,_VelocityLeftmotorTCNT1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0003 023D      TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	LDS  R30,_VelocityLeftmotorTCNT1
	OUT  0x2C,R30
; 0003 023E }
	RJMP _0x600AD
;
;// Timer 3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0003 0242 {
_timer3_ovf_isr:
	CALL SUBOPT_0x39
; 0003 0243 // Place your code here
; 0003 0244      switch(direction_control)
; 0003 0245      {
; 0003 0246           case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x6009E
; 0003 0247           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6009F
_0x6009E:
; 0003 0248                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x3B
	OR   R30,R0
	OUT  0x3,R30
; 0003 0249                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x3B
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0003 024A                RightstepCount--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0003 024B                if(RightstepCount < 0)
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x600A0
; 0003 024C                     RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R6,R30
; 0003 024D                break;
_0x600A0:
	RJMP _0x6009C
; 0003 024E           case ACCEL:
_0x6009F:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ _0x600A2
; 0003 024F           case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x600A3
_0x600A2:
; 0003 0250           case HALF:
	RJMP _0x600A4
_0x600A3:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x600A5
_0x600A4:
; 0003 0251           case Quarter:
	RJMP _0x600A6
_0x600A5:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x600A7
_0x600A6:
; 0003 0252           case LEFT:
	RJMP _0x600A8
_0x600A7:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x600A9
_0x600A8:
; 0003 0253           case SmoothL:
	RJMP _0x600AA
_0x600A9:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x600AB
_0x600AA:
; 0003 0254                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x3B
	OR   R30,R0
	OUT  0x3,R30
; 0003 0255                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x3B
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0003 0256                RightstepCount++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0003 0257                RightstepCount %= sizeof(rotateR);
	MOVW R26,R6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R6,R30
; 0003 0258                break;
; 0003 0259           case SmoothR:
_0x600AB:
; 0003 025A           break;
; 0003 025B      }
_0x6009C:
; 0003 025C      Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0003 025D 
; 0003 025E      TCNT3H = VelocityRightmotorTCNT3 >> 8;
	LDS  R30,_VelocityRightmotorTCNT3+1
	STS  137,R30
; 0003 025F      TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	LDS  R30,_VelocityRightmotorTCNT3
	STS  136,R30
; 0003 0260 }
_0x600AD:
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
;#include "switch.h"
;#include "LED.h"
;
;// Declare your global variables here
;struct Buttons{
;    char SW1;
;    char SW2;
;}Button;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0004 000D {

	.CSEG
_ext_int0_isr:
	ST   -Y,R30
; 0004 000E // Place your code here
; 0004 000F      Button.SW1 = TRUE;
	LDI  R30,LOW(1)
	STS  _Button,R30
; 0004 0010 }
	RJMP _0x80003
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0004 0014 {
_ext_int1_isr:
	ST   -Y,R30
; 0004 0015 // Place your code here
; 0004 0016      Button.SW2 = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Button,1
; 0004 0017 }
_0x80003:
	LD   R30,Y+
	RETI
;
;void InitializeSwitch(void)
; 0004 001A {
_InitializeSwitch:
; 0004 001B // 스위치 PORTD 0,1
; 0004 001C      PORTD &= 0xfc;
	IN   R30,0x12
	ANDI R30,LOW(0xFC)
	OUT  0x12,R30
; 0004 001D      DDRD &= 0xfc;
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
; 0004 001E 
; 0004 001F      EICRA=0x0A;
	LDI  R30,LOW(10)
	STS  106,R30
; 0004 0020      EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0004 0021      EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0004 0022      EIFR=0x03;
	OUT  0x38,R30
; 0004 0023 }
	RET
;char SW1(void)
; 0004 0025 {
_SW1:
; 0004 0026      char ret;
; 0004 0027 
; 0004 0028      ret = Button.SW1;
	ST   -Y,R17
;	ret -> R17
	LDS  R17,_Button
; 0004 0029      Button.SW1 = FALSE;
	LDI  R30,LOW(0)
	STS  _Button,R30
; 0004 002A 
; 0004 002B      return ret;
	RJMP _0x20A0003
; 0004 002C }
;
;char SW2(void)
; 0004 002F {
_SW2:
; 0004 0030      char ret;
; 0004 0031 
; 0004 0032      ret = Button.SW2;
	ST   -Y,R17
;	ret -> R17
	__GETBRMN 17,_Button,1
; 0004 0033      Button.SW2 = FALSE;
	LDI  R30,LOW(0)
	__PUTB1MN _Button,1
; 0004 0034 
; 0004 0035      return ret;
_0x20A0003:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0004 0036 }
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

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0002:
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0001:
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x3C
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x3C
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x3D
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3E
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x40
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x3C
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3E
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.ESEG
_StandardSensor:
	.BYTE 0x6
_CenterStandardSensor:
	.BYTE 0x6

	.DSEG
_VelocityLeftmotorTCNT1:
	.BYTE 0x2
_VelocityRightmotorTCNT3:
	.BYTE 0x2
_rotateR:
	.BYTE 0x8
_rotateL:
	.BYTE 0x8
_vel_counter_high:
	.BYTE 0x2
_Information:
	.BYTE 0x8
_Flag:
	.BYTE 0x2
_Button:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_OFF

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	CALL _A
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	CALL __EEPROMWRW
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xD:
	__POINTW1FN _0x0,40
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__POINTW2MN _StandardSensor,2
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__POINTW2MN _StandardSensor,4
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__POINTW2MN _CenterStandardSensor,2
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	__POINTW2MN _CenterStandardSensor,4
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,24
	CALL _printf
	ADIW R28,26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	__POINTW2MN _StandardSensor,2
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	MOVW R26,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11:
	MOVW R26,R22
	CALL __EEPROMWRW
	__GETWRN 16,17,0
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	__POINTW2MN _StandardSensor,4
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	__POINTW2MN _CenterStandardSensor,2
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	__POINTW2MN _CenterStandardSensor,4
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	__DELAY_USW 200
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _read_adc
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDS  R26,_VelocityLeftmotorTCNT1
	LDS  R27,_VelocityLeftmotorTCNT1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R26,_VelocityRightmotorTCNT3
	LDS  R27,_VelocityRightmotorTCNT3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __SAVELOCR6
	__GETWRN 20,21,0
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	MOVW R18,R30
	__GETWRMN 10,11,0,_VelocityLeftmotorTCNT1
	__GETWRMN 12,13,0,_VelocityRightmotorTCNT3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	__GETWRMN 10,11,0,_vel_counter_high
	__GETWRMN 12,13,0,_vel_counter_high
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD2N 0x40200000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40200000
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R12,R30
	LDS  R30,_vel_counter_high
	LDS  R31,_vel_counter_high+1
	ADIW R30,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:91 WORDS
SUBOPT_0x28:
	LDS  R30,_vel_counter_high
	LDS  R31,_vel_counter_high+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	__PUTWMRN _VelocityLeftmotorTCNT1,0,10,11
	__PUTWMRN _VelocityRightmotorTCNT3,0,12,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2A:
	MOVW R30,R10
	SBIW R30,2
	MOVW R10,R30
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RCALL SUBOPT_0x28
	ADIW R30,20
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0x28
	ADIW R30,20
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x28
	SBIW R30,20
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x28
	SBIW R30,20
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2E:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	MOVW R30,R12
	SBIW R30,2
	MOVW R12,R30
	RCALL SUBOPT_0x28
	ADIW R30,20
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x28
	ADIW R30,20
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x28
	SBIW R30,20
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x28
	SBIW R30,20
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL __DIVF21
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD2N 0x4285D2DD
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDS  R30,_Information
	LDS  R31,_Information+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x36:
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	STS  _Flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x37:
	__ADDWRN 18,19,1
	LDI  R30,LOW(0)
	__PUTB1MN _Flag,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x38:
	__GETWRMN 10,11,0,_VelocityLeftmotorTCNT1
	__GETWRMN 12,13,0,_VelocityRightmotorTCNT3
	CALL _adjustmouse_Super
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x39:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	MOV  R30,R9
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3A:
	IN   R0,18
	LDI  R26,LOW(_rotateL)
	LDI  R27,HIGH(_rotateL)
	ADD  R26,R4
	ADC  R27,R5
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3B:
	IN   R0,3
	LDI  R26,LOW(_rotateR)
	LDI  R27,HIGH(_rotateR)
	ADD  R26,R6
	ADC  R27,R7
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3C:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
