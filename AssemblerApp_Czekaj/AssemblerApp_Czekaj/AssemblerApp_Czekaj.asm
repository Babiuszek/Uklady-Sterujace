/*
 * AssemblerApp_Czekaj.asm
 *
 *  Created: 2013-10-30 17:27:25
 *   Author: kmk
 */ 

  #include "m32def.inc"

  ;Funkcja czekaj�ca @0 milisekund (w przybli�eniu). Nie obs�uguje wi�cej ni� 255

  .DEF MILISECONDS = R16
  .DEF ITERATOR_I = R17
  .DEF ITERATOR_J = R18

 .MACRO CZEKAJ
	;�adowanie i przygotowanie rejestru g��wnego
	LDI MILISECONDS, @0

	;Aby na 16 megahercowym urz�dzeniu poczeka� jedn� milisekund� musz� "nic nie robi�" przez dok�adnie 16.000 cykli
	;Staram si� osi�gn�� jak najbli�sz� liczb� tworz�c dwie pentle - jedna wykonuje si� 16 razy i wywo�uje drug� p�tl�
	;wykonuj�c� si� 100 razy i trwaj�c� 10 cykli (ostatnia 10 jest zmniejszona o 2 cykle przez brak wykonania JMP)
	;Funkcja poprawnie wykonuje 16.000 cykli dla ka�dej milisekundy. Pierwsza miulisekunda jest o 4 cykle d�u�sza podczas
	;gdy ostatnia o 4 cykle kr�tsza.

	MACRO_BEGIN:
		;10 nop�w ma za zadanie wyr�wna� r�nic� 10 cykli przej�cia jednej milisekundy
		;Razem z blokiem DEC/BREQ/LDI trwaj� dok�adnie 13 cykli. Razem z 3 cyklami ostatniego przej�cia p�tli daje r�wno 16
		;16 + 16*999 = 16.000, tak jak powinno
		;Funkcja g��wna, sprawdzaj�ca ile milisekund zosta�o do u�pienia
		DEC MILISECONDS
		BREQ MACRO_LAST_SECOND
		LDI ITERATOR_I, 17 ;Iterator pierwszej p�tli
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
		;P�tla wykonuj�ca si� 16 razy i trwaj�ca (razem z p�tl� poni�sz�) 999 cykli
		DEC ITERATOR_I
		BREQ MACRO_BEGIN;
		LDI ITERATOR_J, 100

	MACRO_LOOP:
		;P�tla wykonuj�ca si� sto razy i trwaj�ca 10 cykli z wyj�tkiem przej�cia ostatniego.
		;��cznie daje 996 cykli
		NOP
		NOP
		NOP
		DEC ITERATOR_J
		BREQ MACRO_LOOP_BEGIN
		NOP
		NOP
		JMP MACRO_LOOP

	MACRO_LAST_SECOND:
		;Ko�czenie makra i przej�cie ostatniej sekundy. Powinna ona trwa� idealnie 15.996 cykli
		;P�tle daj� 16*999 cykli, LDI+NOPs+DEC+BREQ 12 co daje wymagan� ilo�� cykli.
		LDI ITERATOR_I, 17 ;Iterator pierwszej p�tli
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP

	MACRO_LAST_SECOND_LOOP_BEGIN:
		;P�tla wykonuj�ca si� 16 razy i trwaj�ca (razem z p�tl� poni�sz�) 999 cykli
		DEC ITERATOR_I
		BREQ MACRO_END;
		LDI ITERATOR_J, 100

	MACRO_LAST_SECOND_LOOP:
		;P�tla wykonuj�ca si� sto razy i trwaj�ca 10 cykli z wyj�tkiem przej�cia ostatniego.
		;��cznie daje 996 cykli
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