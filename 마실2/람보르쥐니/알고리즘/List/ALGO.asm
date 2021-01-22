
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
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

	#pragma AVRPART ADMIN PART_NAME ATmega128
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
	.DEF _mode=R4
	.DEF _vel_counter_high_L=R6
	.DEF _vel_counter_high_R=R8
	.DEF _count=R10
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2B:
	.DB  0x0,0x0
_0x60003:
	.DB  0x78,0xFF
_0x60004:
	.DB  0x78,0xFF
_0x60005:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x60006:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x6007C:
	.DB  0x2,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  _0x2B*2

	.DW  0x02
	.DW  _vel_counter_high1
	.DW  _0x60003*2

	.DW  0x02
	.DW  _vel_counter_high2
	.DW  _0x60004*2

	.DW  0x08
	.DW  _rotateR
	.DW  _0x60005*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x60006*2

	.DW  0x02
	.DW  0x0A
	.DW  _0x6007C*2

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
;
;#include<mega128.h>
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
;#include<delay.h>
;#include<mega128.h>
;#include"LED.h"
;#include<delay.h>
;
;#include<mega128.h>
;#include<delay.h>
;#include<mega128.h>
;#include"LED.h"
;#include<delay.h>
;#include<stdio.h>
;#include"switch.h"
;#include"Sensor.h"
;#include"Motor.h"
;#include"ALGO.h"
;int R[4];
;int mode=0;
;extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
;extern int LeftstepCount, RightstepCount,aflag,vel_counter_high2,vel_counter_high1,ado;
;
;eeprom int StandardSensor[3], CenterStandardSensor[3],acc;
;
;void main(void)
; 0000 001A {

	.CSEG
_main:
; 0000 001B // Declare your local variables here
; 0000 001C       UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 001D UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 001E UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 001F UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0020 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 0021 
; 0000 0022 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 0023 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 0024 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0025 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0026 UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 0027 
; 0000 0028 
; 0000 0029 InitializeStepMotor();
	CALL _InitializeStepMotor
; 0000 002A InitializeSensor();
	CALL _InitializeSensor
; 0000 002B InitializeLED();
	RCALL _InitializeLED
; 0000 002C InitializeSwitch();
	CALL _InitializeSwitch
; 0000 002D LeftstepCount = 0; // 왼쪽 모터의 스텝 초기화
	LDI  R30,LOW(0)
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R30
; 0000 002E RightstepCount = 0; // 오른쪽 모터의 스텝 초기화
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R30
; 0000 002F 
; 0000 0030 // Global enable interrupts
; 0000 0031 #asm("sei")
	sei
; 0000 0032 
; 0000 0033 VelocityLeftmotorTCNT1 = 65400; // 왼쪽 모터의 속도 (65200 ~ 65535)
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
; 0000 0034 VelocityRightmotorTCNT3 = 65400; // 오른쪽 모터의 속도 (65200 ~ 65535)
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
; 0000 0035 
; 0000 0036 
; 0000 0037 
; 0000 0038 
; 0000 0039 while(1)
_0x3:
; 0000 003A {
; 0000 003B if(SW1() == TRUE)
	CALL _SW1
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x6
; 0000 003C {
; 0000 003D mode++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 003E mode%=8;
	MOVW R26,R4
	CALL SUBOPT_0x0
	MOVW R4,R30
; 0000 003F LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 0040 switch(mode)
	MOVW R30,R4
; 0000 0041 {
; 0000 0042 case 0: LED_ON(LED1); break;                   //좌측 스탠
	SBIW R30,0
	BRNE _0xA
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x29
; 0000 0043 case 1: LED_ON(LED2); break;                  //우측 스탠다
_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP _0x29
; 0000 0044 case 2: LED_ON(LED2);LED_ON(LED1); break;    ///acc
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC
	CALL SUBOPT_0x2
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x29
; 0000 0045 case 3: LED_ON(LED3); break;                                //좌수법
_0xC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x29
; 0000 0046 case 4: LED_ON(LED1);LED_ON(LED3);break;           //전좌 스탠다
_0xD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE
	CALL SUBOPT_0x3
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x29
; 0000 0047 case 5: LED_ON(LED2);LED_ON(LED3);break;          //전방 센터값
_0xE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF
	CALL SUBOPT_0x2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x29
; 0000 0048 case 6: LED_ON(LED1);LED_ON(LED2);LED_ON(LED3);break;  //좌측
_0xF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x10
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x29
; 0000 0049 case 7: LED_ON(LED4);break;                             //우
_0x10:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x9
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
_0x29:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LED_ON
; 0000 004A }
_0x9:
; 0000 004B }
; 0000 004C if(SW2() == TRUE)
_0x6:
	CALL _SW2
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x12
; 0000 004D {
; 0000 004E switch(mode)
	MOVW R30,R4
; 0000 004F {
; 0000 0050 case 0:
	SBIW R30,0
	BRNE _0x16
; 0000 0051   /*
; 0000 0052 Direction(HALF); // 반블럭 전진
; 0000 0053 Direction(HALF); // 반블럭 전진
; 0000 0054 Direction(HALF); // 반블럭 전진
; 0000 0055 Direction(HALF); // 반블럭 전진
; 0000 0056 Direction(HALF); // 반블럭 전진
; 0000 0057 Direction(HALF); // 반블럭 전진
; 0000 0058 
; 0000 0059 
; 0000 005A CenterStandardSensor[0]=10000;
; 0000 005B Direction(HALF);
; 0000 005C acc=readSensor(FRONT_SENSOR);
; 0000 005D Direction(HALF);
; 0000 005E delay_ms(500); */
; 0000 005F R[0]= readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0060  Direction(HALF);
; 0000 0061  R[1]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 0062   Direction(HALF);
; 0000 0063  R[2]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
; 0000 0064   Direction(HALF);
; 0000 0065  R[3]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x8
; 0000 0066 StandardSensor[1] = (R[1]+R[2]+R[3])/3;   //좌측 벽 정
	__POINTWRMN 22,23,_StandardSensor,2
	CALL SUBOPT_0x9
	MOVW R26,R22
	CALL SUBOPT_0xA
; 0000 0067 delay_ms(500);
; 0000 0068 LED_OFF(LED1 | LED2 | LED3 | LED4);
; 0000 0069 LED_ON(LED2);
	CALL SUBOPT_0x2
; 0000 006A 
; 0000 006B break;
	RJMP _0x15
; 0000 006C 
; 0000 006D case 1:
_0x16:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17
; 0000 006E 
; 0000 006F  Direction(HALF);
	CALL SUBOPT_0xB
; 0000 0070  R[1]=readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x6
; 0000 0071   Direction(HALF);
; 0000 0072 
; 0000 0073 StandardSensor[2] = R[1]; // 우 벽 정보
	__POINTW2MN _StandardSensor,4
	__GETW1MN _R,2
	CALL __EEPROMWRW
; 0000 0074 
; 0000 0075 LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 0076 LED_ON(LED3);
	CALL SUBOPT_0xD
; 0000 0077 
; 0000 0078 /*
; 0000 0079 Direction(LEFT); // 반블럭 전진
; 0000 007A Direction(LEFT); // 반블럭 전진
; 0000 007B Direction(LEFT); // 반블럭 전진
; 0000 007C Direction(LEFT); // 반블럭 전진
; 0000 007D delay_ms(200);
; 0000 007E while(!SW2());
; 0000 007F Direction(RIGHT); // 반블럭 전진
; 0000 0080 Direction(RIGHT); // 반블럭 전진
; 0000 0081 Direction(RIGHT); // 반블럭 전진
; 0000 0082 Direction(RIGHT); // 반블럭 전진 */
; 0000 0083   /*
; 0000 0084 while(1)
; 0000 0085 {
; 0000 0086 
; 0000 0087 printf("중앙 : %d  %d  %d 좌측 : %d  %d  %d 우측 : %d  %d  %d\r\n",readSensor(FRONT_SENSOR),StandardSensor[0],CenterStandardSensor[0],readSensor(LEFT_SENSOR),StandardSensor[1],CenterStandardSensor[1],readSensor(RIGHT_SENSOR),StandardSensor[2],CenterStandardSensor[2]);
; 0000 0088 Direction(HALF);
; 0000 0089 }
; 0000 008A     */
; 0000 008B 
; 0000 008C //jDirection(HALF);
; 0000 008D    /*
; 0000 008E Direction(LEFT);
; 0000 008F Direction(LEFT);
; 0000 0090 Direction(LEFT);
; 0000 0091 Direction(LEFT);
; 0000 0092 delay_ms(500);
; 0000 0093 while(!SW2());
; 0000 0094 Direction(RIGHT);
; 0000 0095 Direction(RIGHT);
; 0000 0096 Direction(RIGHT);
; 0000 0097 Direction(RIGHT);
; 0000 0098 delay_ms(500);
; 0000 0099 while(!SW2());
; 0000 009A 
; 0000 009B Direction(HALF);
; 0000 009C Direction(HALF);
; 0000 009D Direction(HALF);
; 0000 009E Direction(HALF);
; 0000 009F Direction(HALF);
; 0000 00A0 delay_ms(100);
; 0000 00A1 while(!SW2());  */
; 0000 00A2 break;
	RJMP _0x15
; 0000 00A3 case 2:
_0x17:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x18
; 0000 00A4 LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 00A5 
; 0000 00A6 CenterStandardSensor[0]=10000;
	CALL SUBOPT_0xE
; 0000 00A7 Direction(HALF);
	CALL SUBOPT_0xB
; 0000 00A8 acc=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	LDI  R26,LOW(_acc)
	LDI  R27,HIGH(_acc)
	CALL __EEPROMWRW
; 0000 00A9 Direction(HALF);
	CALL SUBOPT_0xB
; 0000 00AA delay_ms(500);
	CALL SUBOPT_0x10
; 0000 00AB break;
	RJMP _0x15
; 0000 00AC case 4:
_0x18:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x19
; 0000 00AD CenterStandardSensor[0]=10000;
	CALL SUBOPT_0xE
; 0000 00AE R[0]= readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x5
; 0000 00AF  Direction(HALF);
; 0000 00B0  R[1]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x6
; 0000 00B1   Direction(HALF);
; 0000 00B2  R[2]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
; 0000 00B3   Direction(HALF);
; 0000 00B4  R[3]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x8
; 0000 00B5 StandardSensor[0] = (R[1]+R[2]+R[3])/3; // 전방 벽 정보
	CALL SUBOPT_0x9
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL SUBOPT_0xA
; 0000 00B6 delay_ms(500);
; 0000 00B7 LED_OFF(LED1 | LED2 | LED3 | LED4);
; 0000 00B8 LED_ON(LED1);
	CALL SUBOPT_0x3
; 0000 00B9 break;
	RJMP _0x15
; 0000 00BA 
; 0000 00BB case 5:
_0x19:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1A
; 0000 00BC LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 00BD R[0]= readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x5
; 0000 00BE  Direction(HALF);
; 0000 00BF  R[1]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x6
; 0000 00C0   Direction(HALF);
; 0000 00C1  R[2]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
; 0000 00C2   Direction(HALF);
; 0000 00C3  R[3]=readSensor(FRONT_SENSOR);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x8
; 0000 00C4 CenterStandardSensor[0] = (R[1]+R[2]+R[3])/3; // 자세보정 전 벽 정보
	CALL SUBOPT_0x9
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMWRW
; 0000 00C5 delay_ms(500);
	CALL SUBOPT_0x10
; 0000 00C6 LED_ON(LED1);
	CALL SUBOPT_0x3
; 0000 00C7 break;
	RJMP _0x15
; 0000 00C8 case 6:
_0x1A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1B
; 0000 00C9  LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 00CA R[0]= readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 00CB  Direction(HALF);
; 0000 00CC  R[1]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
; 0000 00CD   Direction(HALF);
; 0000 00CE  R[2]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
; 0000 00CF   Direction(HALF);
; 0000 00D0  R[3]=readSensor(LEFT_SENSOR);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x8
; 0000 00D1 CenterStandardSensor[1] = (R[1]+R[2]+R[3])/3; // 자세보정 왼쪽 벽 정보
	__POINTWRMN 22,23,_CenterStandardSensor,2
	CALL SUBOPT_0x9
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 00D2 LED_ON(LED2);
	CALL SUBOPT_0x2
; 0000 00D3 break;
	RJMP _0x15
; 0000 00D4 case 7:
_0x1B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1C
; 0000 00D5 R[0]= readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x5
; 0000 00D6  Direction(HALF);
; 0000 00D7  R[1]=readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x6
; 0000 00D8   Direction(HALF);
; 0000 00D9  R[2]=readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x7
; 0000 00DA   Direction(HALF);
; 0000 00DB  R[3]=readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	CALL SUBOPT_0x8
; 0000 00DC CenterStandardSensor[2] = (R[1]+R[2]+R[3])/3;// 자세보정 오른쪽 벽 정보
	__POINTWRMN 22,23,_CenterStandardSensor,4
	CALL SUBOPT_0x9
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 00DD LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 00DE LED_ON(LED3);
	CALL SUBOPT_0xD
; 0000 00DF break;
	RJMP _0x15
; 0000 00E0    case 3:
_0x1C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x15
; 0000 00E1         {    vel_counter_high1=65400;
	CALL SUBOPT_0x11
; 0000 00E2             vel_counter_high2=65400;
; 0000 00E3 
; 0000 00E4                while (1)
_0x1E:
; 0000 00E5                {
; 0000 00E6 
; 0000 00E7                     if(readSensor(LEFT_SENSOR) < StandardSensor[1])     //StandardSensor[1]
	CALL SUBOPT_0x4
	MOVW R0,R30
	__POINTW2MN _StandardSensor,2
	CALL SUBOPT_0x12
	BRSH _0x21
; 0000 00E8                     {   vel_counter_high1=65400;
	CALL SUBOPT_0x11
; 0000 00E9                          vel_counter_high2=65400;
; 0000 00EA                         ado=0;
	CALL SUBOPT_0x13
; 0000 00EB                         LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x1
; 0000 00EC                         LED_ON(LED1);
	CALL SUBOPT_0x3
; 0000 00ED                          Direction(HALF);
	CALL SUBOPT_0xB
; 0000 00EE                          Direction(LEFT);
	CALL SUBOPT_0x14
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 
; 0000 00F2                          Direction(HALF);
	CALL SUBOPT_0xB
; 0000 00F3 
; 0000 00F4 
; 0000 00F5                     }
; 0000 00F6                     else if(readSensor(FRONT_SENSOR) > StandardSensor[0])
	RJMP _0x22
_0x21:
	CALL SUBOPT_0xF
	MOVW R0,R30
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL SUBOPT_0x15
	BRSH _0x23
; 0000 00F7                     {
; 0000 00F8                          if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
	CALL SUBOPT_0xC
	MOVW R0,R30
	__POINTW2MN _StandardSensor,4
	CALL SUBOPT_0x12
	BRSH _0x24
; 0000 00F9                          {     vel_counter_high1=65400;
	CALL SUBOPT_0x11
; 0000 00FA                                 vel_counter_high2=65400;
; 0000 00FB                                ado=0;
	CALL SUBOPT_0x13
; 0000 00FC                               LED_OFF(LED3);
	CALL SUBOPT_0x16
; 0000 00FD                               LED_ON(LED4);
	RCALL _LED_ON
; 0000 00FE                                 Direction(HALF);
	CALL SUBOPT_0xB
; 0000 00FF                               Direction(RIGHT);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Direction
; 0000 0100 
; 0000 0101                               LED_OFF(LED3);
	CALL SUBOPT_0x16
; 0000 0102                               LED_OFF(LED4);
	RCALL _LED_OFF
; 0000 0103                               Direction(HALF);
	RJMP _0x2A
; 0000 0104 
; 0000 0105                          }
; 0000 0106                          else
_0x24:
; 0000 0107                          {     vel_counter_high1=65400;
	CALL SUBOPT_0x11
; 0000 0108                                 vel_counter_high2=65400;
; 0000 0109                                 ado=0;
	CALL SUBOPT_0x13
; 0000 010A                               LED_ON(LED3);
	CALL SUBOPT_0xD
; 0000 010B                               LED_ON(LED4);
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LED_ON
; 0000 010C                              Direction(HALF);
	CALL SUBOPT_0xB
; 0000 010D                               Direction(LEFT);
	CALL SUBOPT_0x14
; 0000 010E                               Direction(LEFT);
	CALL SUBOPT_0x14
; 0000 010F                              Direction(HALF);
_0x2A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Direction
; 0000 0110 
; 0000 0111                          }
; 0000 0112                     }
; 0000 0113                     else
	RJMP _0x26
_0x23:
; 0000 0114                     {
; 0000 0115                          LED_OFF(LED3);
	CALL SUBOPT_0x16
; 0000 0116                          LED_OFF(LED4);
	RCALL _LED_OFF
; 0000 0117                          Direction(HALF);
	CALL SUBOPT_0xB
; 0000 0118                          if(aflag==1)
	LDS  R26,_aflag
	LDS  R27,_aflag+1
	SBIW R26,1
	BRNE _0x27
; 0000 0119                          {
; 0000 011A                          ado++;
	LDI  R26,LOW(_ado)
	LDI  R27,HIGH(_ado)
	CALL SUBOPT_0x17
; 0000 011B                          }
; 0000 011C 
; 0000 011D 
; 0000 011E                     }
_0x27:
_0x26:
_0x22:
; 0000 011F                }
	RJMP _0x1E
; 0000 0120           }
; 0000 0121 
; 0000 0122         break;
; 0000 0123 }
_0x15:
; 0000 0124 }
; 0000 0125 }
_0x12:
	RJMP _0x3
; 0000 0126 
; 0000 0127 }
_0x28:
	RJMP _0x28
;
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
;void LED_OFF(int nLED)
; 0001 000C {
_LED_OFF:
; 0001 000D      PORTF |= nLED;
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R30,X
	LD   R26,Y
	OR   R30,R26
	RJMP _0x20A0003
; 0001 000E }
;
;void LED_ON(int nLED)
; 0001 0011 {
_LED_ON:
; 0001 0012      PORTF &= ~(nLED);
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R26,X
	LD   R30,Y
	COM  R30
	AND  R30,R26
_0x20A0003:
	MOV  R26,R0
	ST   X,R30
; 0001 0013 }
	ADIW R28,2
	RET
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
;// Standard Input/Output functions
;#include <stdio.h>
;#include "Sensor.h"
;
;void InitializeSensor(void)
; 0002 0009 {

	.CSEG
_InitializeSensor:
; 0002 000A      // 발광센서 PORTB 5,6,7
; 0002 000B      PORTB &= 0x1f;
	IN   R30,0x18
	ANDI R30,LOW(0x1F)
	OUT  0x18,R30
; 0002 000C      DDRB |= 0xe0;
	IN   R30,0x17
	ORI  R30,LOW(0xE0)
	OUT  0x17,R30
; 0002 000D      // 수광센서 PORTF 0,1,2
; 0002 000E      PORTF &= 0xf8;
	LDS  R30,98
	ANDI R30,LOW(0xF8)
	STS  98,R30
; 0002 000F      DDRF &= 0xf8;
	LDS  R30,97
	ANDI R30,LOW(0xF8)
	STS  97,R30
; 0002 0010 
; 0002 0011 // ADC initialization
; 0002 0012 // ADC Clock frequency: 125.000 kHz
; 0002 0013 // ADC Voltage Reference: AVCC pin
; 0002 0014      ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0002 0015      ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0002 0016 }
	RET
;
;
;unsigned int read_adc(unsigned char adc_input)
; 0002 001A {
_read_adc:
; 0002 001B ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0002 001C // Delay needed for the stabilization of the ADC input voltage
; 0002 001D delay_us(10);
	__DELAY_USB 53
; 0002 001E // Start the AD conversion
; 0002 001F ADCSRA|=0x40;
	SBI  0x6,6
; 0002 0020 // Wait for the AD conversion to complete
; 0002 0021 while ((ADCSRA & 0x10)==0);
_0x40003:
	SBIS 0x6,4
	RJMP _0x40003
; 0002 0022 ADCSRA|=0x10;
	SBI  0x6,4
; 0002 0023 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0002 0024 }
;
;
;
;unsigned int readSensor(char si)
; 0002 0029 {
_readSensor:
; 0002 002A      unsigned int ret;
; 0002 002B 
; 0002 002C      switch(si)
	ST   -Y,R17
	ST   -Y,R16
;	si -> Y+2
;	ret -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
; 0002 002D      {
; 0002 002E           case FRONT_SENSOR:
	SBIW R30,0
	BRNE _0x40009
; 0002 002F                PORTB.5=1;
	SBI  0x18,5
; 0002 0030                delay_us(50);
	CALL SUBOPT_0x18
; 0002 0031                ret=read_adc(si);
; 0002 0032                PORTB.5=0;
	CBI  0x18,5
; 0002 0033                break;
	RJMP _0x40008
; 0002 0034           case LEFT_SENSOR:
_0x40009:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4000E
; 0002 0035                PORTB.6=1;
	SBI  0x18,6
; 0002 0036                delay_us(50);
	CALL SUBOPT_0x18
; 0002 0037                ret=read_adc(si);
; 0002 0038                PORTB.6=0;
	CBI  0x18,6
; 0002 0039                break;
	RJMP _0x40008
; 0002 003A           case RIGHT_SENSOR:
_0x4000E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x40008
; 0002 003B                PORTB.7=1;
	SBI  0x18,7
; 0002 003C                delay_us(50);
	CALL SUBOPT_0x18
; 0002 003D                ret=read_adc(si);
; 0002 003E                PORTB.7=0;
	CBI  0x18,7
; 0002 003F                break;
; 0002 0040      }
_0x40008:
; 0002 0041      return ret;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 0002 0042 }
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
;#include<stdio.h>
;#include <math.h>
;#include "Motor.h"
;#include "Sensor.h"
;#include "LED.h"
;
;int vel_counter_high_L;
;int vel_counter_high_R;
;int aflag=0;
;int ado=0;
;int vel_counter_high1=65400;

	.DSEG
;int vel_counter_high2=65400;
;extern eeprom int StandardSensor[3], CenterStandardSensor[3],acc;
;int count=2;
;
;char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
;char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
;int LeftstepCount, RightstepCount;        // rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
;unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;    // 왼쪽과 오른쪽 모터의 TCNT 속도
;unsigned char direction_control;        // 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
;
;     struct {
;          int nStep4perBlock;            // 한 블록 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn91;
;          int nStep4Turn90;            // 90도 턴 이동시 필요한 모터회전 스텝 정보
;     } Information;
;     struct {
;          char LmotorRun;            // 왼쪽 모터가 회전했는지에 대한 Flag
;          char RmotorRun;            // 오른쪽 모터가 회전했는지에 대한 Flag
;     } Flag;
;
;
;//main문 대신 초기선언 해야 할 변수만 참고 할 것. (c파일은 main문 없음)
;//LeftstepCount = 0;        // 왼쪽 모터의 스텝 초기화
;//RightstepCount = 0;        // 오른쪽 모터의 스텝 초기화
;//#asm("sei")
;//VelocityLeftmotorTCNT1 = 65400;    // 왼쪽 모터의 속도 (65200 ~ 65535)
;//VelocityRightmotorTCNT3 = 65400;    // 오른쪽 모터의 속도 (65200 ~ 65535)
;
;
;void InitializeStepMotor(void)
; 0003 002B {

	.CSEG
_InitializeStepMotor:
; 0003 002C double distance4perStep;
; 0003 002D // LEFT MOTOR - PORTD 4,5,6,7
; 0003 002E      PORTD&=0x0F;
	SBIW R28,4
;	distance4perStep -> Y+0
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0003 002F      DDRD|=0xF0;
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
; 0003 0030 
; 0003 0031 // RIGHT MOTOR - PORTE 4,5,6,7
; 0003 0032      PORTE&=0x0F;
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	OUT  0x3,R30
; 0003 0033      DDRE|=0xF0;
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
; 0003 0034 
; 0003 0035 // Timer/Counter 1 initialization
; 0003 0036 // Clock source: System Clock
; 0003 0037 // Clock value: 62.500 kHz
; 0003 0038 // Mode: Normal top=FFFFh
; 0003 0039 // OC1A output: Discon.
; 0003 003A // OC1B output: Discon.
; 0003 003B // OC1C output: Discon.
; 0003 003C // Noise Canceler: Off
; 0003 003D // Input Capture on Falling Edge
; 0003 003E // Timer 1 Overflow Interrupt: On
; 0003 003F // Input Capture Interrupt: Off
; 0003 0040 // Compare A Match Interrupt: Off
; 0003 0041 // Compare B Match Interrupt: Off
; 0003 0042 // Compare C Match Interrupt: Off
; 0003 0043      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0003 0044      TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0003 0045      TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0003 0046      TCNT1L=0x00;
	OUT  0x2C,R30
; 0003 0047      ICR1H=0x00;
	OUT  0x27,R30
; 0003 0048      ICR1L=0x00;
	OUT  0x26,R30
; 0003 0049      OCR1AH=0x00;
	OUT  0x2B,R30
; 0003 004A      OCR1AL=0x00;
	OUT  0x2A,R30
; 0003 004B      OCR1BH=0x00;
	OUT  0x29,R30
; 0003 004C      OCR1BL=0x00;
	OUT  0x28,R30
; 0003 004D      OCR1CH=0x00;
	STS  121,R30
; 0003 004E      OCR1CL=0x00;
	STS  120,R30
; 0003 004F 
; 0003 0050 // Timer/Counter 3 initialization
; 0003 0051 // Clock source: System Clock
; 0003 0052 // Clock value: 62.500 kHz
; 0003 0053 // Mode: Normal top=FFFFh
; 0003 0054 // OC3A output: Discon.
; 0003 0055 // OC3B output: Discon.
; 0003 0056 // OC3C output: Discon.
; 0003 0057 // Noise Canceler: Off
; 0003 0058 // Input Capture on Falling Edge
; 0003 0059 // Timer 3 Overflow Interrupt: On
; 0003 005A // Input Capture Interrupt: Off
; 0003 005B // Compare A Match Interrupt: Off
; 0003 005C // Compare B Match Interrupt: Off
; 0003 005D // Compare C Match Interrupt: Off
; 0003 005E      TCCR3A=0x00;
	STS  139,R30
; 0003 005F      TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0003 0060      TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0003 0061      TCNT3L=0x00;
	STS  136,R30
; 0003 0062      ICR3H=0x00;
	STS  129,R30
; 0003 0063      ICR3L=0x00;
	STS  128,R30
; 0003 0064      OCR3AH=0x00;
	STS  135,R30
; 0003 0065      OCR3AL=0x00;
	STS  134,R30
; 0003 0066      OCR3BH=0x00;
	STS  133,R30
; 0003 0067      OCR3BL=0x00;
	STS  132,R30
; 0003 0068      OCR3CH=0x00;
	STS  131,R30
; 0003 0069      OCR3CL=0x00;
	STS  130,R30
; 0003 006A 
; 0003 006B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0003 006C      TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0003 006D      ETIMSK=0x04;
	STS  125,R30
; 0003 006E      distance4perStep = (double)(PI * TIRE_RAD / (double)MOTOR_STEP);
	__GETD1N 0x3ECD154B
	CALL __PUTD1S0
; 0003 006F 
; 0003 0070     Information.nStep4perBlock = (int)((double)153 / distance4perStep);
	__GETD2N 0x43190000
	CALL __DIVF21
	CALL __CFD1
	STS  _Information,R30
	STS  _Information+1,R31
; 0003 0071 
; 0003 0072 
; 0003 0073     Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/3.902)/distance4perStep);   //3.902
	CALL __GETD1S0
	__GETD2N 0x42840A50
	CALL __DIVF21
	CALL __CFD1
	__PUTW1MN _Information,4
; 0003 0074 
; 0003 0075    /*     Information.nStep4perBlock = (int)((double)171 / distance4perStep);
; 0003 0076 
; 0003 0077     Information.nStep4Turn91= (int)((PI*MOUSE_WIDTH/4.14)/distance4perStep);
; 0003 0078 
; 0003 0079     Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/4.05)/distance4perStep);     */
; 0003 007A 
; 0003 007B 
; 0003 007C }
	ADIW R28,4
	RET
;
;
;int adjustmouse(void)
; 0003 0080 {
_adjustmouse:
; 0003 0081 	int adjLeftSensor,adjRightSensor;
; 0003 0082 	int adjflagcnt = 0;
; 0003 0083 
; 0003 0084 	adjLeftSensor = readSensor(LEFT_SENSOR);
	CALL __SAVELOCR6
;	adjLeftSensor -> R16,R17
;	adjRightSensor -> R18,R19
;	adjflagcnt -> R20,R21
	__GETWRN 20,21,0
	CALL SUBOPT_0x4
	MOVW R16,R30
; 0003 0085 	adjRightSensor = readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0xC
	MOVW R18,R30
; 0003 0086 
; 0003 0087 	if((adjRightSensor < CenterStandardSensor[2]+2)	&&(adjRightSensor > CenterStandardSensor[2]-50)&& (adjLeftSensor < CenterStandardSensor[1]+2))		// 왼쪽 벽이 존재하지 않을 경우    if((adjRightSensor < (StandardSensor[2]))	|| (adjLeftSensor < (StandardSensor[1])))
	CALL SUBOPT_0x19
	MOVW R26,R30
	ADIW R30,2
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60008
	MOVW R30,R26
	SBIW R30,50
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x60008
	CALL SUBOPT_0x1A
	ADIW R30,2
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60009
_0x60008:
	RJMP _0x60007
_0x60009:
; 0003 0088 	{
; 0003 0089 		vel_counter_high_L = vel_counter_high1;	// 속도를 같게하고 리턴
	CALL SUBOPT_0x1B
; 0003 008A 		vel_counter_high_R = vel_counter_high2;
; 0003 008B 		return 0;
	RJMP _0x20A0002
; 0003 008C 	}
; 0003 008D 
; 0003 008E 	if(adjRightSensor > CenterStandardSensor[2])	// 오른쪽 벽이 멀 경우
_0x60007:
	CALL SUBOPT_0x19
	CP   R30,R18
	CPC  R31,R19
	BRGE _0x6000A
; 0003 008F 	{                               //
; 0003 0090 		vel_counter_high_L-=2;
	MOVW R30,R6
	SBIW R30,2
	MOVW R6,R30
; 0003 0091 		vel_counter_high_R+=2;
	MOVW R30,R8
	ADIW R30,2
	CALL SUBOPT_0x1C
; 0003 0092 		if(vel_counter_high_L < (vel_counter_high1-20))
	BRGE _0x6000B
; 0003 0093 		{
; 0003 0094 			vel_counter_high_L = vel_counter_high1-20;
	CALL SUBOPT_0x1D
	SBIW R30,20
	MOVW R6,R30
; 0003 0095 		}
; 0003 0096 
; 0003 0097 		if(vel_counter_high_R > (vel_counter_high2 + 20))
_0x6000B:
	CALL SUBOPT_0x1E
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x6000C
; 0003 0098 		{
; 0003 0099 			vel_counter_high_R = vel_counter_high2 + 20;
	CALL SUBOPT_0x1E
	MOVW R8,R30
; 0003 009A 		}
; 0003 009B 	}
_0x6000C:
; 0003 009C 	else if((adjRightSensor < CenterStandardSensor[2])&&(adjRightSensor>CenterStandardSensor[1]))
	RJMP _0x6000D
_0x6000A:
	CALL SUBOPT_0x19
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6000F
	CALL SUBOPT_0x1A
	CP   R30,R18
	CPC  R31,R19
	BRLT _0x60010
_0x6000F:
	RJMP _0x6000E
_0x60010:
; 0003 009D 	adjflagcnt++;
	__ADDWRN 20,21,1
; 0003 009E 
; 0003 009F 	if(adjLeftSensor >CenterStandardSensor[1])	// 왼쪽 벽이 멀 경우
_0x6000E:
_0x6000D:
	CALL SUBOPT_0x1A
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x60011
; 0003 00A0 	{
; 0003 00A1 
; 0003 00A2 		vel_counter_high_L+=2;
	MOVW R30,R6
	ADIW R30,2
	MOVW R6,R30
; 0003 00A3 		vel_counter_high_R-=2;
	MOVW R30,R8
	SBIW R30,2
	CALL SUBOPT_0x1F
; 0003 00A4 		if(vel_counter_high_R < (vel_counter_high2-20))
	BRGE _0x60012
; 0003 00A5 		{
; 0003 00A6 			vel_counter_high_R = vel_counter_high2-20;
	CALL SUBOPT_0x20
; 0003 00A7 		}
; 0003 00A8 		if(vel_counter_high_L > (vel_counter_high1 +20))
_0x60012:
	CALL SUBOPT_0x1D
	ADIW R30,20
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x60013
; 0003 00A9 		{
; 0003 00AA 			vel_counter_high_L = vel_counter_high1 +20;
	CALL SUBOPT_0x1D
	ADIW R30,20
	MOVW R6,R30
; 0003 00AB 		}
; 0003 00AC 	}
_0x60013:
; 0003 00AD 	else if((adjLeftSensor < CenterStandardSensor[1])&&(adjRightSensor>CenterStandardSensor[2]))
	RJMP _0x60014
_0x60011:
	CALL SUBOPT_0x1A
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60016
	CALL SUBOPT_0x19
	CP   R30,R18
	CPC  R31,R19
	BRLT _0x60017
_0x60016:
	RJMP _0x60015
_0x60017:
; 0003 00AE 	adjflagcnt++;
	__ADDWRN 20,21,1
; 0003 00AF    /* if((adjLeftSensor < CenterStandardSensor[1])&&(adjRightSensor < (CenterStandardSensor[2]-100)))                                              /////////////
; 0003 00B0     {                               //
; 0003 00B1 		vel_counter_high_L-=2;
; 0003 00B2 		vel_counter_high_R+=2;
; 0003 00B3 		if(vel_counter_high_L < (vel_counter_high1-20))
; 0003 00B4 		{
; 0003 00B5 			vel_counter_high_L = vel_counter_high1-20;
; 0003 00B6 		}
; 0003 00B7 
; 0003 00B8 		if(vel_counter_high_R > (vel_counter_high2 + 20))
; 0003 00B9 		{
; 0003 00BA 			vel_counter_high_R = vel_counter_high2 + 20;
; 0003 00BB 		}   */
; 0003 00BC         if((adjLeftSensor<CenterStandardSensor[1])&&(adjLeftSensor>(CenterStandardSensor[1]-100)))
_0x60015:
_0x60014:
	CALL SUBOPT_0x1A
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x60019
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	CP   R30,R16
	CPC  R31,R17
	BRLT _0x6001A
_0x60019:
	RJMP _0x60018
_0x6001A:
; 0003 00BD          {                               //
; 0003 00BE 		vel_counter_high_L-=10;
	MOVW R30,R6
	SBIW R30,10
	MOVW R6,R30
; 0003 00BF 		vel_counter_high_R+=10;
	MOVW R30,R8
	ADIW R30,10
	CALL SUBOPT_0x1C
; 0003 00C0 		if(vel_counter_high_L < (vel_counter_high1-20))
	BRGE _0x6001B
; 0003 00C1 		{
; 0003 00C2 			vel_counter_high_L = vel_counter_high1-20;
	CALL SUBOPT_0x1D
	SBIW R30,20
	MOVW R6,R30
; 0003 00C3 		}
; 0003 00C4 
; 0003 00C5 		if(vel_counter_high_R > (vel_counter_high2 + 20))
_0x6001B:
	CALL SUBOPT_0x1E
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x6001C
; 0003 00C6 		{
; 0003 00C7 			vel_counter_high_R = vel_counter_high2 + 20;
	CALL SUBOPT_0x1E
	MOVW R8,R30
; 0003 00C8 		}
; 0003 00C9         return 0;
_0x6001C:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RJMP _0x20A0002
; 0003 00CA           if((adjRightSensor<CenterStandardSensor[2])&&(adjRightSensor>(CenterStandardSensor[2]-100)))
; 0003 00CB          {                               //
; 0003 00CC 		vel_counter_high_L+=10;
; 0003 00CD 		vel_counter_high_R-=10;
; 0003 00CE 		if(vel_counter_high_R < (vel_counter_high2-20))
; 0003 00CF 		{
; 0003 00D0 			vel_counter_high_R = vel_counter_high2-20;
; 0003 00D1 		}
; 0003 00D2 		if(vel_counter_high_L > (vel_counter_high1 +20))
; 0003 00D3 		{
; 0003 00D4 			vel_counter_high_L = vel_counter_high1 +20;
; 0003 00D5 		}
; 0003 00D6         return 0;
_0x60021:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RJMP _0x20A0002
; 0003 00D7         }
; 0003 00D8 	}
; 0003 00D9 	if(adjflagcnt == 2)				// 오른쪽 벽과 왼쪽 벽이 둘다 멀지 않을 경우
_0x60018:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x60022
; 0003 00DA 	{							// 속도 동일하게
; 0003 00DB 		vel_counter_high_L = vel_counter_high1;
	CALL SUBOPT_0x1B
; 0003 00DC 		vel_counter_high_R = vel_counter_high2;
; 0003 00DD 		return 0;
	RJMP _0x20A0002
; 0003 00DE 	}
; 0003 00DF 		return 1;
_0x60022:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __LOADLOCR6
	RJMP _0x20A0002
; 0003 00E0 }
;void Direction(int mode)
; 0003 00E2 {
_Direction:
; 0003 00E3      int LStepCount = 0, RStepCount = 0;
; 0003 00E4 
; 0003 00E5      TCCR1B = 0x04;
	CALL __SAVELOCR4
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0003 00E6      TCCR3B = 0x04;
	STS  138,R30
; 0003 00E7 
; 0003 00E8      direction_control = mode;
	LDD  R13,Y+4
; 0003 00E9 
; 0003 00EA      Flag.LmotorRun = FALSE;
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0003 00EB      Flag.RmotorRun = FALSE;
	__PUTB1MN _Flag,1
; 0003 00EC 
; 0003 00ED      switch(mode)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0003 00EE      {
; 0003 00EF      case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60026
; 0003 00F0           while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
_0x60027:
	CALL SUBOPT_0x21
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x6002A
	CALL SUBOPT_0x21
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60029
_0x6002A:
; 0003 00F1           {
; 0003 00F2                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x6002C
; 0003 00F3                {
; 0003 00F4                     LStepCount++;
	CALL SUBOPT_0x22
; 0003 00F5                     Flag.LmotorRun = FALSE;
; 0003 00F6                }
; 0003 00F7                if(Flag.RmotorRun)
_0x6002C:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6002D
; 0003 00F8                {
; 0003 00F9                     RStepCount++;
	CALL SUBOPT_0x23
; 0003 00FA                     Flag.RmotorRun = FALSE;
; 0003 00FB                }
; 0003 00FC           }
_0x6002D:
	RJMP _0x60027
_0x60029:
; 0003 00FD           break;
	RJMP _0x60025
; 0003 00FE      case HALF:
_0x60026:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x6002E
; 0003 00FF 
; 0003 0100       while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
_0x6002F:
	CALL SUBOPT_0x21
	ASR  R31
	ROR  R30
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60032
	CP   R18,R30
	CPC  R19,R31
	BRLT _0x60032
	RJMP _0x60031
_0x60032:
; 0003 0101           {       if(readSensor(FRONT_SENSOR)>CenterStandardSensor[0])
	CALL SUBOPT_0xF
	CALL SUBOPT_0x24
	BRSH _0x60034
; 0003 0102                     {break;}
	RJMP _0x60031
; 0003 0103                     count=count%50;
_0x60034:
	MOVW R26,R10
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __MODW21
	MOVW R10,R30
; 0003 0104                  if(count==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x60035
; 0003 0105                {
; 0003 0106                if((readSensor(FRONT_SENSOR)<acc)||(ado<3))
	CALL SUBOPT_0xF
	MOVW R0,R30
	LDI  R26,LOW(_acc)
	LDI  R27,HIGH(_acc)
	CALL SUBOPT_0x12
	BRLO _0x60037
	LDS  R26,_ado
	LDS  R27,_ado+1
	SBIW R26,3
	BRGE _0x60036
_0x60037:
; 0003 0107                vel_counter_high2+=1;
	LDS  R30,_vel_counter_high2
	LDS  R31,_vel_counter_high2+1
	ADIW R30,1
	CALL SUBOPT_0x25
; 0003 0108                vel_counter_high1+=1;
_0x60036:
	CALL SUBOPT_0x1D
	ADIW R30,1
	CALL SUBOPT_0x26
; 0003 0109                if(vel_counter_high2>65500)
	LDS  R26,_vel_counter_high2
	LDS  R27,_vel_counter_high2+1
	CPI  R26,LOW(0xFFDD)
	LDI  R30,HIGH(0xFFDD)
	CPC  R27,R30
	BRLO _0x60039
; 0003 010A                vel_counter_high2=65500;
	LDI  R30,LOW(65500)
	LDI  R31,HIGH(65500)
	CALL SUBOPT_0x25
; 0003 010B                if(vel_counter_high1>65500)   /////////
_0x60039:
	LDS  R26,_vel_counter_high1
	LDS  R27,_vel_counter_high1+1
	CPI  R26,LOW(0xFFDD)
	LDI  R30,HIGH(0xFFDD)
	CPC  R27,R30
	BRLO _0x6003A
; 0003 010C                vel_counter_high1=65500;
	LDI  R30,LOW(65500)
	LDI  R31,HIGH(65500)
	CALL SUBOPT_0x26
; 0003 010D                aflag=1;
_0x6003A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _aflag,R30
	STS  _aflag+1,R31
; 0003 010E                 }
; 0003 010F                count++;
_0x60035:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0003 0110                if((readSensor(FRONT_SENSOR)>acc)&&(ado>=3))
	CALL SUBOPT_0xF
	MOVW R0,R30
	LDI  R26,LOW(_acc)
	LDI  R27,HIGH(_acc)
	CALL SUBOPT_0x15
	BRSH _0x6003C
	LDS  R26,_ado
	LDS  R27,_ado+1
	SBIW R26,3
	BRGE _0x6003D
_0x6003C:
	RJMP _0x6003B
_0x6003D:
; 0003 0111                {
; 0003 0112                if(count==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x6003E
; 0003 0113                 {vel_counter_high2-=4;
	LDS  R30,_vel_counter_high2
	LDS  R31,_vel_counter_high2+1
	SBIW R30,4
	CALL SUBOPT_0x25
; 0003 0114                vel_counter_high1-=4;
	CALL SUBOPT_0x1D
	SBIW R30,4
	CALL SUBOPT_0x26
; 0003 0115                if(vel_counter_high2<65401)
	LDS  R26,_vel_counter_high2
	LDS  R27,_vel_counter_high2+1
	CPI  R26,LOW(0xFF79)
	LDI  R30,HIGH(0xFF79)
	CPC  R27,R30
	BRSH _0x6003F
; 0003 0116                vel_counter_high2=65400;
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	CALL SUBOPT_0x25
; 0003 0117                if(vel_counter_high1<65401)   /////////
_0x6003F:
	LDS  R26,_vel_counter_high1
	LDS  R27,_vel_counter_high1+1
	CPI  R26,LOW(0xFF79)
	LDI  R30,HIGH(0xFF79)
	CPC  R27,R30
	BRSH _0x60040
; 0003 0118                vel_counter_high1=65400;
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	CALL SUBOPT_0x26
; 0003 0119                aflag=0;
_0x60040:
	LDI  R30,LOW(0)
	STS  _aflag,R30
	STS  _aflag+1,R30
; 0003 011A 
; 0003 011B                }
; 0003 011C                }
_0x6003E:
; 0003 011D 
; 0003 011E             if(Flag.LmotorRun||Flag.RmotorRun)
_0x6003B:
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x60042
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60041
_0x60042:
; 0003 011F                {
; 0003 0120                     if(readSensor(FRONT_SENSOR)>CenterStandardSensor[0])
	CALL SUBOPT_0xF
	CALL SUBOPT_0x24
	BRLO _0x60031
; 0003 0121                     break;
; 0003 0122                LED_OFF(LED1||LED2||LED3||LED4);
	LDI  R30,LOW(16)
	CPI  R30,0
	BRNE _0x60045
	LDI  R30,LOW(32)
	CPI  R30,0
	BRNE _0x60045
	LDI  R30,LOW(64)
	CPI  R30,0
	BRNE _0x60045
	LDI  R30,LOW(128)
	CPI  R30,0
	BRNE _0x60045
	LDI  R30,0
	RJMP _0x60046
_0x60045:
	LDI  R30,1
_0x60046:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _LED_OFF
; 0003 0123 
; 0003 0124                adjustmouse();
	CALL SUBOPT_0x27
; 0003 0125 
; 0003 0126                VelocityLeftmotorTCNT1=vel_counter_high_L;
; 0003 0127                VelocityRightmotorTCNT3=vel_counter_high_R;
; 0003 0128                LED_ON(LED3);
	CALL SUBOPT_0xD
; 0003 0129                }
; 0003 012A                if(Flag.LmotorRun)
_0x60041:
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60047
; 0003 012B                {  if(readSensor(FRONT_SENSOR)>CenterStandardSensor[0])
	CALL SUBOPT_0xF
	CALL SUBOPT_0x24
	BRLO _0x60031
; 0003 012C                     break;
; 0003 012D                     LStepCount++;
	CALL SUBOPT_0x22
; 0003 012E                     Flag.LmotorRun = FALSE;
; 0003 012F                     adjustmouse();
	CALL SUBOPT_0x27
; 0003 0130 
; 0003 0131                VelocityLeftmotorTCNT1=vel_counter_high_L;
; 0003 0132                VelocityRightmotorTCNT3=vel_counter_high_R;
; 0003 0133                }
; 0003 0134                if(Flag.RmotorRun)
_0x60047:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60049
; 0003 0135                {  if(readSensor(FRONT_SENSOR)>CenterStandardSensor[0])
	CALL SUBOPT_0xF
	CALL SUBOPT_0x24
	BRLO _0x60031
; 0003 0136                     break;
; 0003 0137                     RStepCount++;
	CALL SUBOPT_0x23
; 0003 0138                     Flag.RmotorRun = FALSE;
; 0003 0139                     adjustmouse();
	CALL SUBOPT_0x27
; 0003 013A 
; 0003 013B                VelocityLeftmotorTCNT1=vel_counter_high_L;
; 0003 013C                VelocityRightmotorTCNT3=vel_counter_high_R;
; 0003 013D                }
; 0003 013E 
; 0003 013F           }
_0x60049:
	RJMP _0x6002F
_0x60031:
; 0003 0140           break;
	RJMP _0x60025
; 0003 0141      case LEFT:
_0x6002E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6004B
; 0003 0142      while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
_0x6004C:
	CALL SUBOPT_0x28
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x6004F
	CALL SUBOPT_0x28
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6004E
_0x6004F:
; 0003 0143           {
; 0003 0144                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60051
; 0003 0145                {
; 0003 0146                     LStepCount++;
	CALL SUBOPT_0x22
; 0003 0147                     Flag.LmotorRun = FALSE;
; 0003 0148                }
; 0003 0149                if(Flag.RmotorRun)
_0x60051:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60052
; 0003 014A                {
; 0003 014B                     RStepCount++;
	CALL SUBOPT_0x23
; 0003 014C                     Flag.RmotorRun = FALSE;
; 0003 014D                }
; 0003 014E           }
_0x60052:
	RJMP _0x6004C
_0x6004E:
; 0003 014F           break;
	RJMP _0x60025
; 0003 0150      case RIGHT:
_0x6004B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60053
; 0003 0151           while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
_0x60054:
	CALL SUBOPT_0x28
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x60057
	CALL SUBOPT_0x28
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x60056
_0x60057:
; 0003 0152           {
; 0003 0153                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60059
; 0003 0154                {
; 0003 0155                     LStepCount++;
	CALL SUBOPT_0x22
; 0003 0156                     Flag.LmotorRun = FALSE;
; 0003 0157                }
; 0003 0158                if(Flag.RmotorRun)
_0x60059:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x6005A
; 0003 0159                {
; 0003 015A                     RStepCount++;
	CALL SUBOPT_0x23
; 0003 015B                     Flag.RmotorRun = FALSE;
; 0003 015C                }
; 0003 015D           }
_0x6005A:
	RJMP _0x60054
_0x60056:
; 0003 015E           break;
	RJMP _0x60025
; 0003 015F      case BACK:
_0x60053:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60025
; 0003 0160           while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
_0x6005C:
	__GETW2MN _Information,4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x6005F
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x6005E
_0x6005F:
; 0003 0161           {
; 0003 0162                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x60061
; 0003 0163                {
; 0003 0164                     LStepCount++;
	CALL SUBOPT_0x22
; 0003 0165                     Flag.LmotorRun = FALSE;
; 0003 0166                }
; 0003 0167                if(Flag.RmotorRun)
_0x60061:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x60062
; 0003 0168                {
; 0003 0169                     RStepCount++;
	CALL SUBOPT_0x23
; 0003 016A                     Flag.RmotorRun = FALSE;
; 0003 016B                }
; 0003 016C           }
_0x60062:
	RJMP _0x6005C
_0x6005E:
; 0003 016D           break;
; 0003 016E      }
_0x60025:
; 0003 016F      TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0003 0170      TCCR3B = 0x00;
	STS  138,R30
; 0003 0171 }
	CALL __LOADLOCR4
_0x20A0002:
	ADIW R28,6
	RET
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0003 0175 {
_timer1_ovf_isr:
	CALL SUBOPT_0x29
; 0003 0176 // Place your code here
; 0003 0177      switch(direction_control)
; 0003 0178      {
; 0003 0179           case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60066
; 0003 017A                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x2A
	OR   R30,R26
	OUT  0x12,R30
; 0003 017B                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x2A
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x12,R30
; 0003 017C                LeftstepCount--;
	LDI  R26,LOW(_LeftstepCount)
	LDI  R27,HIGH(_LeftstepCount)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0003 017D                if(LeftstepCount < 0)
	LDS  R26,_LeftstepCount+1
	TST  R26
	BRPL _0x60067
; 0003 017E                     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R31
; 0003 017F                break;
_0x60067:
	RJMP _0x60065
; 0003 0180           case RIGHT:
_0x60066:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x60069
; 0003 0181           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6006A
_0x60069:
; 0003 0182           case FORWARD:
	RJMP _0x6006B
_0x6006A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6006C
_0x6006B:
; 0003 0183           case HALF:
	RJMP _0x6006D
_0x6006C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60065
_0x6006D:
; 0003 0184                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0x2A
	OR   R30,R26
	OUT  0x12,R30
; 0003 0185                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0x2A
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x12,R30
; 0003 0186                LeftstepCount++;
	LDI  R26,LOW(_LeftstepCount)
	LDI  R27,HIGH(_LeftstepCount)
	CALL SUBOPT_0x17
; 0003 0187                LeftstepCount %= sizeof(rotateL);
	LDS  R26,_LeftstepCount
	LDS  R27,_LeftstepCount+1
	CALL SUBOPT_0x0
	STS  _LeftstepCount,R30
	STS  _LeftstepCount+1,R31
; 0003 0188                break;
; 0003 0189      }
_0x60065:
; 0003 018A      Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0003 018B 
; 0003 018C      TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	LDS  R30,_VelocityLeftmotorTCNT1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0003 018D      TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	LDS  R30,_VelocityLeftmotorTCNT1
	OUT  0x2C,R30
; 0003 018E }
	RJMP _0x6007B
;
;// Timer 3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0003 0192 {
_timer3_ovf_isr:
	CALL SUBOPT_0x29
; 0003 0193 // Place your code here
; 0003 0194      switch(direction_control)
; 0003 0195      {
; 0003 0196           case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x60073
; 0003 0197           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60074
_0x60073:
; 0003 0198                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x2B
	OR   R30,R26
	OUT  0x3,R30
; 0003 0199                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x2B
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x3,R30
; 0003 019A                RightstepCount--;
	LDI  R26,LOW(_RightstepCount)
	LDI  R27,HIGH(_RightstepCount)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0003 019B                if(RightstepCount < 0)
	LDS  R26,_RightstepCount+1
	TST  R26
	BRPL _0x60075
; 0003 019C                     RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R31
; 0003 019D                break;
_0x60075:
	RJMP _0x60071
; 0003 019E           case FORWARD:
_0x60074:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x60077
; 0003 019F           case HALF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x60078
_0x60077:
; 0003 01A0           case LEFT:
	RJMP _0x60079
_0x60078:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60071
_0x60079:
; 0003 01A1                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0x2B
	OR   R30,R26
	OUT  0x3,R30
; 0003 01A2                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0x2B
	SUBI R30,-LOW(15)
	AND  R30,R26
	OUT  0x3,R30
; 0003 01A3                RightstepCount++;
	LDI  R26,LOW(_RightstepCount)
	LDI  R27,HIGH(_RightstepCount)
	CALL SUBOPT_0x17
; 0003 01A4                RightstepCount %= sizeof(rotateR);
	LDS  R26,_RightstepCount
	LDS  R27,_RightstepCount+1
	CALL SUBOPT_0x0
	STS  _RightstepCount,R30
	STS  _RightstepCount+1,R31
; 0003 01A5                break;
; 0003 01A6      }
_0x60071:
; 0003 01A7      Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0003 01A8 
; 0003 01A9      TCNT3H = VelocityRightmotorTCNT3 >> 8;
	LDS  R30,_VelocityRightmotorTCNT3+1
	STS  137,R30
; 0003 01AA      TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	LDS  R30,_VelocityRightmotorTCNT3
	STS  136,R30
; 0003 01AB }
_0x6007B:
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
;          char SW1;
;          char SW2;
;          } ;
;struct Buttons Button;
;
;
;void InitializeSwitch(void)
; 0004 000F {

	.CSEG
_InitializeSwitch:
; 0004 0010 // 스위치 PORTD 0,1
; 0004 0011      PORTD &= 0xfc;
	IN   R30,0x12
	ANDI R30,LOW(0xFC)
	OUT  0x12,R30
; 0004 0012      DDRD &= 0xfc;
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
; 0004 0013 
; 0004 0014 // External Interrupt(s) initialization
; 0004 0015 // INT0: On
; 0004 0016 // INT0 Mode: Falling Edge
; 0004 0017 // INT1: On
; 0004 0018 // INT1 Mode: Falling Edge
; 0004 0019 // INT2: Off
; 0004 001A // INT3: Off
; 0004 001B // INT4: Off
; 0004 001C // INT5: Off
; 0004 001D // INT6: Off
; 0004 001E // INT7: Off
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
;
;
;char SW1(void)
; 0004 0027 {
_SW1:
; 0004 0028      char ret;
; 0004 0029 
; 0004 002A      ret = Button.SW1;
	ST   -Y,R17
;	ret -> R17
	LDS  R17,_Button
; 0004 002B      Button.SW1 = FALSE;
	LDI  R30,LOW(0)
	STS  _Button,R30
; 0004 002C 
; 0004 002D      return ret;
	RJMP _0x20A0001
; 0004 002E }
;
;char SW2(void)
; 0004 0031 {
_SW2:
; 0004 0032      char ret;
; 0004 0033 
; 0004 0034      ret = Button.SW2;
	ST   -Y,R17
;	ret -> R17
	__GETBRMN 17,_Button,1
; 0004 0035      Button.SW2 = FALSE;
	LDI  R30,LOW(0)
	__PUTB1MN _Button,1
; 0004 0036 
; 0004 0037      return ret;
_0x20A0001:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0004 0038 }
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0004 003B {
_ext_int0_isr:
	ST   -Y,R30
; 0004 003C // Place your code here
; 0004 003D      Button.SW1 = TRUE;
	LDI  R30,LOW(1)
	STS  _Button,R30
; 0004 003E      // flag++;                //flag=flag+1
; 0004 003F }
	RJMP _0x80003
;
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0004 0044 {
_ext_int1_isr:
	ST   -Y,R30
; 0004 0045 // Place your code here
; 0004 0046      Button.SW2 = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Button,1
; 0004 0047     // n2++;            //n2=n2+1
; 0004 0048 }
_0x80003:
	LD   R30,Y+
	RETI
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_R:
	.BYTE 0x8
_VelocityLeftmotorTCNT1:
	.BYTE 0x2
_VelocityRightmotorTCNT3:
	.BYTE 0x2
_LeftstepCount:
	.BYTE 0x2
_RightstepCount:
	.BYTE 0x2
_aflag:
	.BYTE 0x2
_vel_counter_high2:
	.BYTE 0x2
_vel_counter_high1:
	.BYTE 0x2
_ado:
	.BYTE 0x2

	.ESEG
_StandardSensor:
	.BYTE 0x6
_CenterStandardSensor:
	.BYTE 0x6
_acc:
	.BYTE 0x2

	.DSEG
_rotateR:
	.BYTE 0x8
_rotateL:
	.BYTE 0x8
_Information:
	.BYTE 0x6
_Flag:
	.BYTE 0x2
_Button:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_OFF

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x5:
	STS  _R,R30
	STS  _R+1,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x6:
	__PUTW1MN _R,2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x7:
	__PUTW1MN _R,4
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__PUTW1MN _R,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x9:
	__GETW2MN _R,2
	__GETW1MN _R,4
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _R,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	CALL __EEPROMWRW
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(65400)
	LDI  R31,HIGH(65400)
	STS  _vel_counter_high1,R30
	STS  _vel_counter_high1+1,R31
	STS  _vel_counter_high2,R30
	STS  _vel_counter_high2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _ado,R30
	STS  _ado+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	CALL _LED_OFF
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	__DELAY_USW 200
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _read_adc
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	__POINTW2MN _CenterStandardSensor,4
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	__POINTW2MN _CenterStandardSensor,2
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	__GETWRMN 6,7,0,_vel_counter_high1
	__GETWRMN 8,9,0,_vel_counter_high2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	MOVW R8,R30
	LDS  R30,_vel_counter_high1
	LDS  R31,_vel_counter_high1+1
	SBIW R30,20
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	LDS  R30,_vel_counter_high1
	LDS  R31,_vel_counter_high1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDS  R30,_vel_counter_high2
	LDS  R31,_vel_counter_high2+1
	ADIW R30,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	MOVW R8,R30
	LDS  R30,_vel_counter_high2
	LDS  R31,_vel_counter_high2+1
	SBIW R30,20
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDS  R30,_vel_counter_high2
	LDS  R31,_vel_counter_high2+1
	SBIW R30,20
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R30,_Information
	LDS  R31,_Information+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	STS  _Flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	__ADDWRN 18,19,1
	LDI  R30,LOW(0)
	__PUTB1MN _Flag,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	MOVW R0,R30
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	STS  _vel_counter_high2,R30
	STS  _vel_counter_high2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	STS  _vel_counter_high1,R30
	STS  _vel_counter_high1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x27:
	CALL _adjustmouse
	__PUTWMRN _VelocityLeftmotorTCNT1,0,6,7
	__PUTWMRN _VelocityRightmotorTCNT3,0,8,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	__GETW1MN _Information,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x29:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2A:
	IN   R30,0x12
	MOV  R26,R30
	LDS  R30,_LeftstepCount
	LDS  R31,_LeftstepCount+1
	SUBI R30,LOW(-_rotateL)
	SBCI R31,HIGH(-_rotateL)
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2B:
	IN   R30,0x3
	MOV  R26,R30
	LDS  R30,_RightstepCount
	LDS  R31,_RightstepCount+1
	SUBI R30,LOW(-_rotateR)
	SBCI R31,HIGH(-_rotateR)
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
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
