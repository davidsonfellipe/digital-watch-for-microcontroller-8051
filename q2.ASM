;ESCOLA POLITECNICA DE PERNAMBUCO
;ALUNO DAVIDSON FELLIPE DA SILVA
;CURSO ENG. DA COMPUTACAO | PROF. DANIEL CHAVES
;QUESTAO 2 DA PROVA DE PROTOTIPACAO DE CI | RELOGIO DIGITAL UTILIZADO ASSEMBLY DO MICROCONTROLADOR 8051
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 DEFINI플O DO REGISTRADOR UTILIZADO NA UNIDADE DE SEGUNDO
;R1 DEFINI플O DO REGISTRADOR UTILIZADO NA DEZENA DE SEGUNDO
;R2 DEFINI플O DO REGISTRADOR UTILIZADO NA UNIDADE DE MINUTO
;R3 DEFINI플O DO REGISTRADOR UTILIZADO NA DEZENA DE MINUTO
;R4 DEFINI플O DO REGISTRADOR UTILIZADO NA UNIDADE DE HORA
;R5 DEFINI플O DO REGISTRADOR UTILIZADO NA DEZENA DE HORA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEMPORIZADOR1	EQU TR0	
TEMPORIZADOR1_H	EQU TH0	
TEMPORIZADOR1_L	EQU TL0	
TEMPORIZADOR1_F	EQU TF0	
MOV TMOD, #51h						;CONFIGURACAO DO TMOD #00110011
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INICIO_RELOGIO: LCALL CLEAR_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXECUCAO_RELOGIO:  				
				   JNB P1.7, ATUALIZAR_RELOGIO ;PRESET DO RELOGIO	   				   
				   LCALL DELAY_1_SEGUNDO				   
				   JMP INCREMENTA_UNIDADE_SEGUNDO
CHECA_UNIDADE_SEGUNDO: 
					   CJNE R0, #10, EXECUCAO_RELOGIO
					   MOV R0, #0					   
					   JMP INCREMENTA_DEZENA_SEGUNDO
INCREMENTA_UNIDADE_SEGUNDO:
					   INC R0
					   JMP CHECA_24_HORAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECA_DEZENA_SEGUNDO:					   
					CJNE R1, #6, EXECUCAO_RELOGIO
					MOV R1, #0
					JMP INCREMENTA_UNIDADE_MINUTO
INCREMENTA_DEZENA_SEGUNDO:
					   INC R1
					   JMP CHECA_DEZENA_SEGUNDO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECA_UNIDADE_MINUTO:					   
					CJNE R2, #10, EXECUCAO_RELOGIO
					MOV R2, #0
					JMP INCREMENTA_DEZENA_MINUTO
INCREMENTA_UNIDADE_MINUTO:
					   INC R2
					   JMP CHECA_UNIDADE_MINUTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECA_DEZENA_MINUTO:					   
					CJNE R3, #6, EXECUCAO_RELOGIO
					MOV R3, #0
					JMP INCREMENTA_UNIDADE_HORA
INCREMENTA_DEZENA_MINUTO:
					   INC R3
					   JMP CHECA_DEZENA_MINUTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECA_UNIDADE_HORA:					   
					CJNE R4, #10, EXECUCAO_RELOGIO
					MOV R4, #0
					JMP INCREMENTA_DEZENA_HORA
INCREMENTA_UNIDADE_HORA:
					   INC R4
					   JMP CHECA_UNIDADE_HORA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCREMENTA_DEZENA_HORA:
					   INC R5
					   JMP EXECUCAO_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECA_24_HORAS: 
				CJNE R0, #9, CHECA_UNIDADE_SEGUNDO
				CJNE R1, #5, CHECA_UNIDADE_SEGUNDO 
				CJNE R2, #9, CHECA_UNIDADE_SEGUNDO 
				CJNE R3, #5, CHECA_UNIDADE_SEGUNDO
				CJNE R4, #3, CHECA_UNIDADE_SEGUNDO
				CJNE R5, #2, CHECA_UNIDADE_SEGUNDO
			    JMP INICIO_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			   
ATUALIZAR_RELOGIO:
		LCALL DELAY_300ms
		JNB P1.0, INC_MINUTOS 
		JNB P1.1, DEC_MINUTOS 		
		JNB P1.2, INC_HORA
		JNB P1.3, DEC_HORA
		JMP EXECUCAO_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INC_MINUTOS:
			INC R2	;INCREMENTA A UNIDADE DE MINUTO
			CJNE R2, #10, SAIR_PRESET
			JMP INC_DEZENA_MINUTO
INC_DEZENA_MINUTO: 
			MOV R2, #0		
			INC R3 ;INCREMENTA A DEZENA DE MINUTO
			CJNE R3, #6, SAIR_PRESET
			MOV R3, #0
			JMP SAIR_PRESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEC_MINUTOS:
			DEC R2	;DECREMENTAR A UNIDADE DE MINUTO
			CJNE R2, #0FFh, SAIR_PRESET
			JMP DEC_DEZENA_MINUTO
DEC_DEZENA_MINUTO: 
			MOV R2, #9		
			DEC R3 ;DECREMENTAR A DEZENA DE MINUTO
			CJNE R3, #0FFh, SAIR_PRESET
			MOV R3, #5
			JMP SAIR_PRESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INC_HORA:
			INC R4								;INCREMENTA A UNIDADE DE HORA
			JMP CHECA_PRESET_24_HORAS
INCREMENTA_OK:
			CJNE R4, #10, SAIR_PRESET
			JMP INC_DEZENA_HORA
INC_DEZENA_HORA: 
			MOV R4, #0		
			INC R5								;INCREMENTA A DEZENA DE HORA
		    JMP SAIR_PRESET
CHECA_PRESET_24_HORAS: 
				CJNE R5, #2, INCREMENTA_OK
				CJNE R4, #4, INCREMENTA_OK
				MOV R5, #0h
				MOV R4, #0h
			    JMP SAIR_PRESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DEC_HORA:
			DEC R4								;DECREMENTAR A UNIDADE DE HORA
			CJNE R4, #0FFh, SAIR_PRESET				
			JMP DEC_DEZENA_HORA
DEC_DEZENA_HORA: 
			MOV R4, #9		
			DEC R5 								;DECREMENTAR A DEZENA DE HORA
			CJNE R5, #0FFh, SAIR_PRESET
			MOV R5, #2
			MOV R4, #3
			JMP SAIR_PRESET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
SAIR_PRESET: JMP ATUALIZAR_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY_1_SEGUNDO: 
				MOV R6, #20 	  ;MOVE O DECIMAL 20 PARA O REGISTRADOR R0
REPETE: 
		MOV TEMPORIZADOR1_H, #03Ch ;CARREGAR NO TEMPORIZADOR O VALOR DE #15535 	
        MOV TEMPORIZADOR1_L, #0AFh ;O QUE EQUIVALE A 3CAF EM HEXADECIMAL 
        SETB TEMPORIZADOR1		  ;LIGA O TEMPORIZADOR
        JNB TEMPORIZADOR1_F, $ 	  ;ENQUANTO A CONTAGEM DE 15535 A 65535 NAO TERMINE FIQUE AQUI, CADA CICLO DURA 50ms       
        CLR TEMPORIZADOR1_F 		  ;RESETA O FLAG DO TIMER T1
        DJNZ R6, REPETE			  ;IRA EXECUTAR A ROTINA ROTINA REPETE POR 20 VEZES
	    CLR TEMPORIZADOR1          ;DESLIGA O TEMPORIZADOR
	    RET						  ;SAI DA DELAY_1_SEGUNDO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	    
DELAY_300ms: 
			MOV R6, #6 	           ;MOVE O DECIMAL 6 PARA O REGISTRADOR R0
LACO_300ms: 
		MOV TEMPORIZADOR1_H, #03Ch ;CARREGAR NO TEMPORIZADOR O VALOR DE #15535 	
        MOV TEMPORIZADOR1_L, #0AFh ;O QUE EQUIVALE A 3CAF EM HEXADECIMAL 
        SETB TEMPORIZADOR1		   ;LIGA O TEMPORIZADOR
        JNB TEMPORIZADOR1_F, $ 	   ;ENQUANTO A CONTAGEM DE 15535 A 65535 NAO TERMINE FIQUE AQUI, CADA CICLO DURA 50ms       
        CLR TEMPORIZADOR1_F 	   ;RESETA O FLAG DO TIMER T1
        DJNZ R6, LACO_300ms		   ;IRA EXECUTAR A ROTINA ROTINA LACO_300ms POR 6 VEZES
	    CLR TEMPORIZADOR1          ;DESLIGA O TEMPORIZADOR
	    RET						   ;SAI DA DELAY_300ms, E TEREMOS 300ms DE DELAY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	    
PARAR_TEMPORIZADOR_1: 
		CLR TEMPORIZADOR1	  ;DESLIGA O TEMPORIZADOR
		RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	    
CLEAR_RELOGIO: MOV R0, #0
			   MOV R1, #0
			   MOV R2, #0
			   MOV R3, #0
			   MOV R4, #0
			   MOV R5, #0			   
			   RET				   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			   
SAIR_DO_PROGRAMA:
END