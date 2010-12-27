;ESCOLA POLITECNICA DE PERNAMBUCO
;ALUNO DAVIDSON FELLIPE DA SILVA
;CURSO ENG. DA COMPUTACAO | PROF. DANIEL CHAVES
;QUESTAO 1 DA PROVA DE PROTOTIPACAO DE CI | RELOGIO DIGITAL UTILIZADO ASSEMBLY DO MICROCONTROLADOR 8051
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
MOV TMOD, #51h	;CONFIGURACAO DO TMOD #00110011
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INICIO_RELOGIO: LCALL CLEAR_RELOGIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXECUCAO_RELOGIO:  				   
				   LCALL DELAY_1_SEGUNDO				   
				   JMP INCREMENTA_UNIDADE_SEGUNDO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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