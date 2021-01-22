
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
	.DEF _VelocityLeftmotorTCNT1=R8
	.DEF _VelocityRightmotorTCNT3=R10
	.DEF _direction_control=R13

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x4:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _rotateR
	.DW  _0x3*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x4*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;#include <math.h>
;#include "LED.h"
;#include "Switch.h"
;#include "Sensor.h"
;#include "StepMotor.h"
;#include <delay.h>
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
;          int nStep4Turn90;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
;     } Information;
;     struct {
;          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
;          char RmotorRun;            // 오른쪽 모터가 회전했는지에 대한 Flag
;     } Flag;
;void InitializeStepmotor(void)
; 0000 0019 {

	.CSEG
_InitializeStepmotor:
; 0000 001A 	double distance4perStep;
; 0000 001B 
; 0000 001C // LEFT MOTOR - PORTD 4,5,6,7
; 0000 001D 	PORTD&=0x0F;
	SBIW R28,4
;	distance4perStep -> Y+0
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0000 001E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 001F 	TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 0020 	ETIMSK=0x04;
	STS  125,R30
; 0000 0021 
; 0000 0022 	distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	__GETD1N 0x3ECD154B
	CALL __PUTD1S0
; 0000 0023 	Information.nStep4perBlock = (int)((double)180. / distance4perStep);
	__GETD2N 0x43340000
	CALL __DIVF21
	CALL __CFD1
	STS  _Information,R30
	STS  _Information+1,R31
; 0000 0024 	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.)/distance4perStep);
	CALL __GETD1S0
	__GETD2N 0x4280CE28
	CALL __DIVF21
	CALL __CFD1
	__PUTW1MN _Information,2
; 0000 0025 }
	ADIW R28,4
	RET
;
;void Direction(int mode)
; 0000 0028 {
_Direction:
; 0000 0029      int LStepCount = 0, RStepCount = 0;
; 0000 002A 
; 0000 002B      TCCR1B = 0x04;
	CALL __SAVELOCR4
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 002C      TCCR3B = 0x04;
	STS  138,R30
; 0000 002D 
; 0000 002E      direction_control = mode;
	LDD  R13,Y+4
; 0000 002F 
; 0000 0030      Flag.LmotorRun = FALSE;
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0000 0031      Flag.RmotorRun = FALSE;
	__PUTB1MN _Flag,1
; 0000 0032 
; 0000 0033      switch(mode)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0000 0034      {
; 0000 0035      case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8
; 0000 0036           while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
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
; 0000 0037           {
; 0000 0038                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0xE
; 0000 0039                {
; 0000 003A                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 003B                     Flag.LmotorRun = FALSE;
; 0000 003C                }
; 0000 003D                if(Flag.RmotorRun)
_0xE:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0xF
; 0000 003E                {
; 0000 003F                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 0040                     Flag.RmotorRun = FALSE;
; 0000 0041                }
; 0000 0042           }
_0xF:
	RJMP _0x9
_0xB:
; 0000 0043           break;
	RJMP _0x7
; 0000 0044      case HALF:
_0x8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x10
; 0000 0045           while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
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
; 0000 0046           {
; 0000 0047                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x16
; 0000 0048                {
; 0000 0049                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 004A                     Flag.LmotorRun = FALSE;
; 0000 004B                }
; 0000 004C                if(Flag.RmotorRun)
_0x16:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x17
; 0000 004D                {
; 0000 004E                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 004F                     Flag.RmotorRun = FALSE;
; 0000 0050                }
; 0000 0051           }
_0x17:
	RJMP _0x11
_0x13:
; 0000 0052           break;
	RJMP _0x7
; 0000 0053      case LEFT:
_0x10:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ _0x19
; 0000 0054      case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1A
_0x19:
; 0000 0055           while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
_0x1B:
	__GETW1MN _Information,2
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x1E
	__GETW1MN _Information,2
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x1D
_0x1E:
; 0000 0056           {
; 0000 0057                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x20
; 0000 0058                {
; 0000 0059                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 005A                     Flag.LmotorRun = FALSE;
; 0000 005B                }
; 0000 005C                if(Flag.RmotorRun)
_0x20:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x21
; 0000 005D                {
; 0000 005E                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 005F                     Flag.RmotorRun = FALSE;
; 0000 0060                }
; 0000 0061           }
_0x21:
	RJMP _0x1B
_0x1D:
; 0000 0062           break;
	RJMP _0x7
; 0000 0063      case BACK:
_0x1A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x7
; 0000 0064           while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
_0x23:
	__GETW2MN _Information,2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x26
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x25
_0x26:
; 0000 0065           {
; 0000 0066                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x28
; 0000 0067                {
; 0000 0068                     LStepCount++;
	CALL SUBOPT_0x1
; 0000 0069                     Flag.LmotorRun = FALSE;
; 0000 006A                }
; 0000 006B                if(Flag.RmotorRun)
_0x28:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x29
; 0000 006C                {
; 0000 006D                     RStepCount++;
	CALL SUBOPT_0x2
; 0000 006E                     Flag.RmotorRun = FALSE;
; 0000 006F                }
; 0000 0070           }
_0x29:
	RJMP _0x23
_0x25:
; 0000 0071           break;
; 0000 0072      }
_0x7:
; 0000 0073      TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 0074      TCCR3B = 0x00;
	STS  138,R30
; 0000 0075 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0079 {
_timer1_ovf_isr:
	CALL SUBOPT_0x3
; 0000 007A // Place your code here
; 0000 007B      switch(direction_control)
; 0000 007C      {
; 0000 007D           case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2D
; 0000 007E                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x4
	OR   R30,R0
	OUT  0x12,R30
; 0000 007F                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0000 0080                LeftstepCount--;
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 0081                if(LeftstepCount < 0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x2E
; 0000 0082                     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R4,R30
; 0000 0083                break;
_0x2E:
	RJMP _0x2C
; 0000 0084           case RIGHT:
_0x2D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x30
; 0000 0085           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x31
_0x30:
; 0000 0086           case FORWARD:
	RJMP _0x32
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x33
_0x32:
; 0000 0087           case HALF:
	RJMP _0x34
_0x33:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2C
_0x34:
; 0000 0088                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x4
	OR   R30,R0
	OUT  0x12,R30
; 0000 0089                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0000 008A                LeftstepCount++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 008B                LeftstepCount %= sizeof(rotateL);
	MOVW R26,R4
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R4,R30
; 0000 008C                break;
; 0000 008D      }
_0x2C:
; 0000 008E      Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0000 008F 
; 0000 0090      TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	MOV  R30,R9
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0000 0091      TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	MOV  R30,R8
	OUT  0x2C,R30
; 0000 0092 }
	RJMP _0x46
;
;// Timer 3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 0096 {
_timer3_ovf_isr:
	CALL SUBOPT_0x3
; 0000 0097 // Place your code here
; 0000 0098      switch(direction_control)
; 0000 0099      {
; 0000 009A           case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x3A
; 0000 009B           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3B
_0x3A:
; 0000 009C                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R0
	OUT  0x3,R30
; 0000 009D                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0000 009E                RightstepCount--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 009F                if(RightstepCount < 0)
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x3C
; 0000 00A0                     RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R6,R30
; 0000 00A1                break;
_0x3C:
	RJMP _0x38
; 0000 00A2           case FORWARD:
_0x3B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x3E
; 0000 00A3           case HALF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3F
_0x3E:
; 0000 00A4           case LEFT:
	RJMP _0x40
_0x3F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x38
_0x40:
; 0000 00A5                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x5
	OR   R30,R0
	OUT  0x3,R30
; 0000 00A6                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x5
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0000 00A7                RightstepCount++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00A8                RightstepCount %= sizeof(rotateR);
	MOVW R26,R6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R6,R30
; 0000 00A9                break;
; 0000 00AA      }
_0x38:
; 0000 00AB      Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0000 00AC 
; 0000 00AD      TCNT3H = VelocityRightmotorTCNT3 >> 8;
	STS  137,R11
; 0000 00AE      TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	MOV  R30,R10
	STS  136,R30
; 0000 00AF }
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
;#include <mega128.h>
;#include <math.h>
;#include "LED.h"
;#include "Switch.h"
;#include "Sensor.h"
;#include "StepMotor.h"
;#include <delay.h>
;
;
;void main(void)
; 0000 00BA {
_main:
; 0000 00BB // Declare your local variables here
; 0000 00BC 
; 0000 00BD      InitializeStepmotor();
	RCALL _InitializeStepmotor
; 0000 00BE 
; 0000 00BF      LeftstepCount = 0;		// 왼쪽 모터의 스텝 초기화
	CLR  R4
	CLR  R5
; 0000 00C0      RightstepCount = 0;		// 오른쪽 모터의 스텝 초기화
	CLR  R6
	CLR  R7
; 0000 00C1 
; 0000 00C2 // Global enable interrupts
; 0000 00C3 #asm("sei")
	sei
; 0000 00C4 
; 0000 00C5      VelocityLeftmotorTCNT1 = 65400;    // 왼쪽 모터의 속도 (65200 ~ 65535)
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	MOVW R8,R30
; 0000 00C6      VelocityRightmotorTCNT3 = 65400;    // 오른쪽 모터의 속도 (65200 ~ 65535)
	MOVW R10,R30
; 0000 00C7 
; 0000 00C8      Direction(FORWARD);        // 한블럭 전진
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x6
; 0000 00C9      Direction(LEFT);        // 좌로 90도 턴
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x6
; 0000 00CA      Direction(RIGHT);		// 우로 90도 턴
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x6
; 0000 00CB      Direction(HALF);		// 반블럭 전진
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x6
; 0000 00CC 
; 0000 00CD 
; 0000 00CE while (1)
_0x42:
; 0000 00CF       {
; 0000 00D0       // Place your code here
; 0000 00D1 
; 0000 00D2       };
	RJMP _0x42
; 0000 00D3 }
_0x45:
	RJMP _0x45
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
; 0001 0007      // LED - PORTF 4,5,6,7
; 0001 0008      PORTF &= 0x0F;
; 0001 0009      DDRF |= 0xF0;
; 0001 000A }
;
;void LED_OFF(int nLED)
; 0001 000D {
; 0001 000E      PORTF |= nLED;
;	nLED -> Y+0
; 0001 000F }
;
;void LED_ON(int nLED)
; 0001 0012 {
; 0001 0013      PORTF &= ~(nLED);
;	nLED -> Y+0
; 0001 0014 }
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
;
;void InitializeSensor(void)
; 0002 0008 {

	.CSEG
; 0002 0009      // 발광센서 PORTB 5,6,7
; 0002 000A      PORTB &= 0x1f;
; 0002 000B      DDRB |= 0xe0;
; 0002 000C      // 수광센서 PORTF 0,1,2
; 0002 000D      PORTF &= 0xf8;
; 0002 000E      DDRF &= 0xf8;
; 0002 000F 
; 0002 0010 // ADC initialization
; 0002 0011 // ADC Clock frequency: 125.000 kHz
; 0002 0012 // ADC Voltage Reference: AVCC pin
; 0002 0013      ADMUX=ADC_VREF_TYPE;
; 0002 0014      ADCSRA=0x87;
; 0002 0015 }
;
;unsigned int read_adc(unsigned char adc_input)
; 0002 0018 {
; 0002 0019     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0002 001A     // Delay needed for the stabilization of the ADC input voltage
; 0002 001B     delay_us(10);
; 0002 001C     // Start the AD conversion
; 0002 001D     ADCSRA|=0x40;
; 0002 001E     // Wait for the AD conversion to complete
; 0002 001F     while ((ADCSRA & 0x10)==0);
; 0002 0020     ADCSRA|=0x10;
; 0002 0021     return ADCW;
; 0002 0022 }
;
;unsigned int readSensor(char si)
; 0002 0025 {
; 0002 0026      unsigned int ret;
; 0002 0027 
; 0002 0028      switch(si)
;	si -> Y+2
;	ret -> R16,R17
; 0002 0029      {
; 0002 002A           case FRONT_SENSOR:
; 0002 002B                PORTB.5=1;
; 0002 002C                delay_us(50);
; 0002 002D                ret=read_adc(si);
; 0002 002E                PORTB.5=0;
; 0002 002F                break;
; 0002 0030           case LEFT_SENSOR:
; 0002 0031                PORTB.6=1;
; 0002 0032                delay_us(50);
; 0002 0033                ret=read_adc(si);
; 0002 0034                PORTB.6=0;
; 0002 0035                break;
; 0002 0036           case RIGHT_SENSOR:
; 0002 0037                PORTB.7=1;
; 0002 0038                delay_us(50);
; 0002 0039                ret=read_adc(si);
; 0002 003A                PORTB.7=0;
; 0002 003B                break;
; 0002 003C      }
; 0002 003D      return ret;
; 0002 003E }
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
; 0003 000D {

	.CSEG
_ext_int0_isr:
	ST   -Y,R30
; 0003 000E // Place your code here
; 0003 000F      Button.SW1 = TRUE;
	LDI  R30,LOW(1)
	STS  _Button,R30
; 0003 0010 }
	RJMP _0x60003
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0003 0014 {
_ext_int1_isr:
	ST   -Y,R30
; 0003 0015 // Place your code here
; 0003 0016      Button.SW2 = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Button,1
; 0003 0017 }
_0x60003:
	LD   R30,Y+
	RETI
;
;void InitializeSwitch(void)
; 0003 001A {
; 0003 001B // 스위치 PORTD 0,1
; 0003 001C      PORTD &= 0xfc;
; 0003 001D      DDRD &= 0xfc;
; 0003 001E 
; 0003 001F      EICRA=0x0A;
; 0003 0020      EICRB=0x00;
; 0003 0021      EIMSK=0x03;
; 0003 0022      EIFR=0x03;
; 0003 0023 }
;char SW1(void)
; 0003 0025 {
; 0003 0026      char ret;
; 0003 0027 
; 0003 0028      ret = Button.SW1;
;	ret -> R17
; 0003 0029      Button.SW1 = FALSE;
; 0003 002A 
; 0003 002B      return ret;
; 0003 002C }
;
;char SW2(void)
; 0003 002F {
; 0003 0030      char ret;
; 0003 0031 
; 0003 0032      ret = Button.SW2;
;	ret -> R17
; 0003 0033      Button.SW2 = FALSE;
; 0003 0034 
; 0003 0035      return ret;
; 0003 0036 }

	.CSEG
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
_Information:
	.BYTE 0x4
_Flag:
	.BYTE 0x2
_Button:
	.BYTE 0x2
__seed_G102:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
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
	MOV  R30,R13
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
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
SUBOPT_0x5:
	IN   R0,3
	LDI  R26,LOW(_rotateR)
	LDI  R27,HIGH(_rotateR)
	ADD  R26,R6
	ADC  R27,R7
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
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
