/*
 * Assembler_ReverseString.asm
 *
 *  Created: 2013-11-11 06:14:09
 *   Author: kmk
 */ 

 
 #include "m32def.inc"
 
.DEF MyRegisterS = R16
.DEF MyRegisterCounter = R17
.DEF MyRegister0 = R0

.CSEG                           ;wszystkie dalsze zapisy dotycz¹ pamiêci programu (pamiêæ FLASH)
.ORG 0                          
MyString: .DB "Hello World!",0  ;rezerwacja zasobyow w pamiêci programu; string zostanie zakonczony 0     


;inicjalizacja stosu - ustawienie wskaznika stosu
;rejestry stosu to SPH:SPL
LDI MyRegisterS, HIGH(RAMEND) ;RAMEND - najwyszczy adres w pamieci SRAM
OUT SPH,MyRegisterS           ;ustawienie poczatku stosu na najwyzszy adres pamieci SRAM (stos rosnie w dol) 
LDI MyRegisterS, LOW(RAMEND) 
OUT SPL,MyRegisterS 


;FLASH do SRAM
;czytanie pamieci FLASH za pomoca wskaznika Z
;ZL to R30, ZH to R31
copy:
;zapisanie obecnego stanyu rejestrow
PUSH MyRegister0
PUSH MyRegisterS
PUSH MyRegisterCounter
PUSH ZH
PUSH ZL

LDI MyRegisterCounter, 0 ;ustawienie na 0 licznika PUSH-ow na stos danych z napisu

;ustawienie wskaznika Z na poczatek i koniec napisu 
;adres (napis) pomnozony przez 2 ze wzgledu na word-wis organizacje pamieci 
LDI ZH, high(2*MyString) 
LDI ZL, low(2*MyString)

;kopionwanie napisu na stos (pamiec SRAM)
repeat:
LPM MyRegisterS, Z+   ;czyta do MyRegister2 bajt danych z pamieci FLASH wskazany przez Z ; inkrementacja Z
PUSH MyRegisterS
INC MyRegisterCounter ;zwiekszenie licznika polozonych na stosie bajtow danych wejsciowych 
TST MyRegisterS       ;ustawia flage Zero na 1 jesli MyRegisterS zawiera 0
BRNE repeat           ;powtorz jesli to jeszcze nie koniec napisu ; if (Z = 0) then PC ? PC + k + 1


;ponowne ustawienie wskaznika Z na poczatek i koniec napisu
ldi ZH, high(2*MyString)
ldi ZL, low(2*MyString)

;zdejmowanie napisu ze stosu i zapisanie jego odwroconej form w tym samym miejscu pamieci FLASH co poprzednio
repeat2:
;POP MyRegisterS
POP MyRegister0
SUBI MyRegisterCounter,1   ;zmniejszenie licznika polozonych na stosie bajtow danych wejsciowych
;ST Z+,MyRegisterS         ;zapisanie zawartosci MyRegisterS w pamiêci SRAM pod adresem wskazanym przez rejestr indeksowy ; inkrementacja Z
SPM Z+					   ;zapisanie zawartosci R0 w pamiêci FLASH pod adresem wskazanym przez rejestr indeksowy ; inkrementacja Z
TST MyRegisterCounter      ;ustawia flage Zero na 1 jesli MyRegisterCounter zawiera 0 - zdjeto caly napis ze stosu
BRNE repeat2               ;powtorz jesli nie zdjeto jeszcze calego napisu ze stosu

;przywrocenie poczatkowych wartosci rejestrow
POP ZL
POP ZH
POP MyRegisterCounter
POP MyRegisterS
POP MyRegister0

