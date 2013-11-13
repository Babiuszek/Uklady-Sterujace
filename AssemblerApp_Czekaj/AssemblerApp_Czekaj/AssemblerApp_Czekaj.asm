/*
 * AssemblerApp_Czekaj.asm
 *
 *  Created: 2013-10-30 17:27:25
 *   Author: kmk
 */ 

  #include "m32def.inc"

  ;Funkcja czekaj¹ca @0 milisekund (w przybli¿eniu). Nie obs³uguje wiêcej ni¿ 255

  .DEF MILISECONDS = R16
  .DEF ITERATOR_I = R17
  .DEF ITERATOR_J = R18

 .MACRO CZEKAJ
	;£adowanie i przygotowanie rejestru g³ównego
	LDI MILISECONDS, @0

	;Aby na 16 megahercowym urz¹dzeniu poczekaæ jedn¹ milisekundê muszê "nic nie robiæ" przez dok³adnie 16.000 cykli
	;Staram siê osi¹gn¹æ jak najbli¿sz¹ liczbê tworz¹c dwie pentle - jedna wykonuje siê 16 razy i wywo³uje drug¹ pêtlê
	;wykonuj¹c¹ siê 100 razy i trwaj¹c¹ 10 cykli (ostatnia 10 jest zmniejszona o 2 cykle przez brak wykonania JMP)
	;Funkcja poprawnie wykonuje 16.000 cykli dla ka¿dej milisekundy. Pierwsza miulisekunda jest o 4 cykle d³u¿sza podczas
	;gdy ostatnia o 4 cykle krótsza.

	MACRO_BEGIN:
		;10 nopów ma za zadanie wyrównaæ ró¿nicê 10 cykli przejœcia jednej milisekundy
		;Razem z blokiem DEC/BREQ/LDI trwaj¹ dok³adnie 13 cykli. Razem z 3 cyklami ostatniego przejœcia pêtli daje równo 16
		;16 + 16*999 = 16.000, tak jak powinno
		;Funkcja g³ówna, sprawdzaj¹ca ile milisekund zosta³o do uœpienia
		DEC MILISECONDS
		BREQ MACRO_LAST_SECOND
		LDI ITERATOR_I, 17 ;Iterator pierwszej pêtli
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP

	MACRO_LOOP_BEGIN:
		;Pêtla wykonuj¹ca siê 16 razy i trwaj¹ca (razem z pêtl¹ poni¿sz¹) 999 cykli
		DEC ITERATOR_I
		BREQ MACRO_BEGIN;
		LDI ITERATOR_J, 100

	MACRO_LOOP:
		;Pêtla wykonuj¹ca siê sto razy i trwaj¹ca 10 cykli z wyj¹tkiem przejœcia ostatniego.
		;£¹cznie daje 996 cykli
		NOP
		NOP
		NOP
		DEC ITERATOR_J
		BREQ MACRO_LOOP_BEGIN
		NOP
		NOP
		JMP MACRO_LOOP

	MACRO_LAST_SECOND:
		;Koñczenie makra i przejœcie ostatniej sekundy. Powinna ona trwaæ idealnie 15.996 cykli
		;Pêtle daj¹ 16*999 cykli, LDI+NOPs+DEC+BREQ 12 co daje wymagan¹ iloœæ cykli.
		LDI ITERATOR_I, 17 ;Iterator pierwszej pêtli
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP

	MACRO_LAST_SECOND_LOOP_BEGIN:
		;Pêtla wykonuj¹ca siê 16 razy i trwaj¹ca (razem z pêtl¹ poni¿sz¹) 999 cykli
		DEC ITERATOR_I
		BREQ MACRO_END;
		LDI ITERATOR_J, 100

	MACRO_LAST_SECOND_LOOP:
		;Pêtla wykonuj¹ca siê sto razy i trwaj¹ca 10 cykli z wyj¹tkiem przejœcia ostatniego.
		;£¹cznie daje 996 cykli
		NOP
		NOP
		NOP
		DEC ITERATOR_J
		BREQ MACRO_LAST_SECOND_LOOP_BEGIN
		NOP
		NOP
		JMP MACRO_LAST_SECOND_LOOP

	MACRO_END:
 .ENDM

 LOOP:
	 CZEKAJ 1
	 OUT PORTA, R16
	 RJMP LOOP