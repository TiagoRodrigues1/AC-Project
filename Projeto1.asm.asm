#Projeto Realizado por: Miguel Costa 38573 e José Rodrigues 38099
.data
menuTitulo: .asciiz "\n\tJogo 4-in-row!\n"
menuMsg: .asciiz "\n[j]-jogar\n[e]-Pontuações\n[f]-Finalizar Programa\n"
menuMsgErro: .asciiz "\nIntroduza um caracter valido!\n"
Vitorias: .asciiz "\tWins: "
Empates: .asciiz "\n\t\t\t\tDraws: "
Pontos: .asciiz "\tPontos: " 
Player1Pontos: .asciiz "\nJogador 1: "
Player2Pontos: .asciiz "Jogador 2: "
TabuleiroLimpo: .asciiz "\tTabuleiro Limpo\n"
Empate: .asciiz "O jogo ficou empatado!\n"
Player1Zero: .asciiz "Jogador 1 tem 0 Pontos\n"
Player2Zero: .asciiz "Jogador 2 tem 0 Pontos\n"
Player1: .asciiz "Jogador 1 a jogar:\n"
Player2: .asciiz "Jogador 2 a jogar:\n"
OpcaoCol: .asciiz "Escolha uma coluna para colucar a peça(1-7):\n"
Confirmacao: .asciiz "Existe algum 4 em linha?\n (Sim(1) ou Nao(0)\n"
EndGameMsg: .asciiz "Partidade terminada\n"
Player1Winner: .asciiz "\tJogador 1 venceu!\n"
Player2Winner: .asciiz "\tJogador 2 venceu!\n"
mensagemErroColuna: .asciiz "Esta coluna ja esta cheia!\nInserir outra\n"
PointsP1: .asciiz "Pontos do Jogador 1:\n"
PointsP2: .asciiz "Pontos do Jogador 2:\n "
ErroOpcaoCol:.asciiz "#ERRO#\nIntroduza um valor entre 1-7:\n "
ErroOpcaoWinner: .asciiz "#Erro\n Introduza um valor valido (1) para SIM ou (0) para NAO\n"
ilusColunas: .asciiz"\n(1)\t(2)\t(3)\t(4)\t(5)\t(6)\t(7)\t\n"
mat:	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
p1score: .word 0 				#Numero de pontos do jogador 1
p2score: .word 0	 			#Numero de pontos do jogador 2
VitP1: .word 0					#Numero de vitorias do jogador 1
VitP2: .word 0					#Numero de vitorias do jogador 2
Draws: .word 0
matriz: .space 168	
linhas:	.word	6				#Numero de linhas
colunas: .word 7				#Numero de colunas
counter: .word 0				#Counter para numero de jogadas
endline: .asciiz	"\n"			#Paragrafo entre as linhas
tab:	.asciiz	"\t"				#Espaço entre os numeros
separador: .asciiz "-----------------------------------------"
Fim: .asciiz "\nPrograma terminado\n"
	.text
main:
	j menu
	
menu:
	li $v0, 4
	la $a0, menuTitulo
	syscall
	li $v0, 4
	la $a0, menuMsg
	syscall
	li $v0, 12
	syscall
	beq $v0,'j', jogo		
	beq $v0,'e', printPoints
	beq $v0,'f', exit
	j ErroMenu	
	
	
	j menu
	
ErroMenu:
	li $v0, 4
	la , $a0, menuMsgErro
	syscall
	j menu
	
jogo:				
	jal Layout
	jal mat_print
	j PlayJogador1
	
	
#-----------------------------------------------------------------------------------------------------------------------------------#		
mat_print:						#Esta função faz print das linhas ao contrario
	la	$a0, mat	 			#Load do adress da matriz
	lw 	$a1, linhas				#Load do numero de linhas
	lw 	$a2, colunas				#Load do numero de colunas	
	add	$t3, $zero, $a0	 			#t3=a0 (indice da matriz)
	addi	$t0, $zero, 5				#index[i] =5 (linhas-1)
			

	mat_print_while1:	
		 		
		slti 	$t7, $t0, 0	 		#While(i>=0);		
		bne	$t7, $0, mat_print_end		#Quando acaba primeiro ciclo significada que a matriz ja foi toda impressa
		add	$t1, $zero, $zero 		#index[j] =0;
				
		 
	
	mat_print_while2: 				#Salta para o 2 clico, ciclos das coluns
				
		slt	$t6, $t1, $a2			#(j<Colunas);			
		beq	$t6, $zero, mat_print_end_line	#Se estivermos no fim da primeira linha, salta para a funcao \n
		mul	$t5, $t0, $a2			# $t5= $t0(Index[i] x NColunas
		add	$t5, $t5, $t1			#$t5= $t5+[i]Index
		sll	$t4, $t5, 2			#$t4=$t5x4bytes
		add	$t5, $t4, $t3	 		#$t5=v[i][j]=addr= BaseAdress(a0/t3)+(([i]Index/t0)*Colunas(a1)+([j]Index/t0))*TamanhoInteiros(4)/t4		
		li	$v0, 1				#Carregar um inteiro
		lw	$a0, 0($t5)			#Mete o inteiro na posicao [i][j]/adress	
		syscall 
		li	$v0, 4 				#Dar print de um tab entro os numeros apenas para estetica.
		la	$a0, tab					
		syscall
		addi	$t1, $t1, 1			#Proximo index mat[i][j+1]	
		j	mat_print_while2

	mat_print_end_line:					
		li	$v0, 4
		la	$a0, endline 			#Dar print de um \n entre as linhas apenas para estetica.
		syscall
		subi 	$t0, $t0, 1			#i=i-1;		
		j	mat_print_while1		#Salta para o primeiro ciclo.
			
	mat_print_end:						
		jr	$ra
#-----------------------------------------------------------------------------------------------------------------------------------#

PlayJogador1:
	li  $v0,4     					#Print da mensagem para jogador 1 jogar.
	la  $a0,Player1
	syscall 
	li $v0, 4 					#Print da mensagem para escolher a coluna.
	la $a0,OpcaoCol
	syscall
	li $v0,5 					#Recolhe a coluna do jogador 1.
	syscall
	addi $v0,$v0,-1 				#Subtrai -1 à coluna obtida pq no array2d começa em posições 0.
        mul $t0,$v0,4					#Multiplica por 4 por causa do tamanho do inteiro que ocupa 4 bytes
        move $a0,$v0 					#a0 fica com o valor introduzido pelo jogador.
	jal ValidacaoP1 				#salta para a função de validação do numero.
	beq $v0,0, ColunaInvalidaPlayer1 		#Se o valor retornado da função "Validacao" for 0, ele ira imprimir mag de erro e volta a pedir outra coluna.
	li $t5,1 					#t5 será a peça , onde o jogador 1 terá a peça (1)
	jal VerificaoColuna 				#Salta para a função para verificar se a celula é valida ou nao
	sw $t5,mat($v0) 				#Coloca o numero na matriz.
        jal Layout					#Apenas imprime os numeros da coluna
        jal mat_print   				#Imprime matriz modificada
        jal CounterJogadas				#Salta para a funcao de contar jogada (count ++)
	blt $a0, 7, PlayJogador2			#Caso o numero de jogadas seja inferior a 7 (count=7), o programa nem vai perguntar se existe algum vencedor , pois ainda n existe peças sufecientes para tal 
        jal AskWinner					#Caso o numero de jogadas seja superior a 7, a função irá perguntar se ja existe um vencedor, esta função retorna (1) ou (0)
      	beq $v0,1,Player1Win				#Se o V0 retornado da função "AskWinner" for 1(ou seja o jogador1 ganhou), salta para a função "Player1Win"
	j PlayJogador2					#Caso ainda nao exista um vencedor, salta para o proximo jogador.
       
        
PlayJogador2:
	li  $v0,4     					#Print da mensagem para jogador 1 jogar.
	la  $a0,Player2
	syscall 
	li $v0, 4 					#Print da mensagem para escolher a coluna.
	la $a0,OpcaoCol
	syscall
	li $v0,5 					#Recolhe a coluna do jogador 2.
	syscall
	addi $v0,$v0,-1 				#Subtrai -1 à coluna obtida pq no array2d começa em posições 0
        mul $t0,$v0,4					#Multiplica por 4 por causa da memoria
        move $a0,$v0 					#a0 fica com o valor introduzido pelo jogador
	jal ValidacaoP2					#salta para a função de validação da Coluna
	beq $v0,0, ColunaInvalidaPlayer2 		#Se o valor retornado da função "Validacao" for 0, ele ira imprimir mag de erro e volta a pedir outra coluna.
	li $t5,2 					#t5 será a peça , onde o jogador 1 terá a peça (1)
	jal VerificaoColuna 				#Salta para a função para verificar se a celula é valida ou nao
	sw $t5,mat($v0) 				#Coloca o numero na matriz.
	jal Layout					##Apenas imprime os numeros da coluna
	jal mat_print					#Imprime matriz modificada
	jal CounterJogadas				#Salta para a funcao de contar jogada (count ++)
	blt $a0, 7, PlayJogador1			#Caso o numero de jogadas seja inferior a 7 (count=7), o programa nem vai perguntar se existe algum vencedor , pois ainda n existe peças sufecientes para tal 
       	beq $a0, 42, AskWinnerDraw			
        beq $v0, 0, draw
        beq $v0,1,Player2Win
       	jal AskWinner					#Caso o numero de jogadas seja superior a 7, a função irá perguntar se ja existe um vencedor, esta função retorna (1) ou (0)
       	beq $v0,1,Player2Win				#Se o V0 retornado da função "AskWinner" for 1(ou seja o jogador 2 ganhou), salta para a função "Player2Win"
	j PlayJogador1					#Caso ainda nao exista um vencedor, salta para o proximo jogador.
	
	
	
ValidacaoP1:
	bgt $a0,6, Invalido 				#Se o numero introduzido for maior que 6, salta para funcao "Invalido"
        blt $a0,0, Invalido 				#Ou se o numero for menor que 0 , tambam salta para a funcao "Invalido"
        addi $t7,$a0,35					#Numero de Posições totais do array
        mul $t7,$t7,4 					#Multiplica cada numero por 4 bytes
        lw $t6,mat($t7) 				##Carrega o valor que está na celula da matriz
      	bne $t6 ,0 , ColunaCheiaP1 			#Se o valor que está na celula ultima celula da coluna for diferente de 0, salta para a funcao ColunaCheia
        li $v0,1 					#Se o valor for 0, a função retorna 1
        jr $ra 						#return 1;
        
ValidacaoP2:
	bgt $a0,6,Invalido 				#Se o numero introduzido for maior que 6, salta para funcao "Invalido"
        blt $a0,0,Invalido 				#Ou se o numero for menor que 0 , tambam salta para a funcao "Invalido"
        addi $t7,$a0,35					#t7 fica com o valor do ultima indice da matriz, mat[5][ColunaIntroduzida].
        mul $t7,$t7,4 					#Multiplica numero por 4 bytes
        lw $t6,mat($t7) 				#Carrega o valor que está na celula da matriz.
    	bne $t6 ,0 , ColunaCheiaP2  			#Se o valor que está na celula ultima celula da coluna for diferente de 0, salta para a funcao ColunaCheia
        li $v0,1 					#Se o valor for 0, a função retorna 1
        jr $ra 						#return 1;

Invalido:
        li $v0,0 					#Se a celula estiver preenchida (ou seja diferente de 0) a função retorna 0
        jr $ra 						#return 0;
                
ColunaInvalidaPlayer1:
	li $v0, 4
	la $a0, ErroOpcaoCol 				#Imprime Mensagem de erro da coluna e salta para o jogador 1
	syscall 	
	j PlayJogador1
		
ColunaInvalidaPlayer2:
	li $v0, 4
	la $a0, ErroOpcaoCol 				#Imprime mensagem de erro da coluna e salta para jogador 2
	syscall	
	j PlayJogador2
	
	
ColunaCheiaP1:
	li $v0, 4
	la $a0, mensagemErroColuna 			#Imprime que a coluna está cheia e salta para o jogador 1
	syscall
	

	j PlayJogador1
	
ColunaCheiaP2:
	li $v0, 4
	la $a0, mensagemErroColuna 			#Imprime que a coluna está cheia e salta para o jogador 2
	syscall
	j PlayJogador2
		
		
VerificaoColuna:					
        li $t4,0 					#Inicializa t4 = 0; 
        add $t4,$t4,$t0					#Coloca t4 com o valor de t0, Indexi
               
        loop1:
         	lw $t2,mat($t4)				#t2 fica com o valor que existe na posiçao da matriz			
                beq $t2,0,end1				#Se o valor na posicão for 0 for 0, salta para o fim		
         	addi $t4,$t4,28	                	#Vai para a posição acima da coluna			
         	j loop1					#Volta para o loop
        end1:
        	addi $v0,$t4,0				
                jr $ra					#return v0;
                

AskWinner:				
		li $v0, 4				#Imprime pergunta se existe 4 em linha ou não
		la $a0, Confirmacao
		syscall 
		li $v0, 5 				#Lê o valor introduzido
		syscall
		bgt $v0,1, ErroAskWinner
		blt $v0, 0, ErroAskWinner
		jr $ra 					#Dá return ao valor intruzido (1 ou 0).
		
		
ErroAskWinner:					
		li $v0, 4
		la $a0, ErroOpcaoWinner			#Imprime Msg de Erro.
		syscall
		j AskWinner
		
CounterJogadas:
		lw $a0, counter($t9)			#Armazena o primeiro valor do count
		addi $a0, $a0, 1			#count=count+1;
		sw $a0, counter($t9)			#Armazena o novo valor de count
						
		jr $ra					#return a3;
		

AskWinnerDraw:	
		li $v0, 4				#Imprime pergunta se existe 4 em linha ou não
		la $a0, Confirmacao
		syscall 
		li $v0, 5 				#Lê o valor introduzido
		syscall
							#Dá return ao valor intruzido (1 ou 0).
		jr $ra


Layout:
	li $v0, 4
	la $a0, ilusColunas     			#Apenas imprima o numero das colunas para facilitar a colocação das peças
	syscall	
	jr $ra
	
Player1Win:
		li $v0, 4						
		la $a0, Player1Winner			#Dá print à string			
		syscall
		lw $t0,VitP1				#Da load ao numero de vitorias do jogador 2
		addi $t0,$t0,1				#Adiciona +1 ao numero de vitorias
		sw $t0,VitP1				#Guarda o valor com a nova vitoria
		lw $t1,p1score				#Da load ao numero de pontos do jogador 2
		addi $t1,$t1,3				#Adiciona +3  ao numero de pontos
		sw $t1,p1score				#Guarda o numero de pontos
		lw $t0,p2score				#Da load ao numero de pontos do jogador 1
		beq $t0,0 zerop2points 			#Se o numero de pontos do jogador 1 já for 0, salta para a função zerop1points 
		addi $t0,$t0,-1				#Caso nao seja 0, subtrai 1
		sw $t0, p2score				#Guarda o numero de pontos do jogador 2
		j pontosend				#Salta para o fim

Player2Win:
		li $v0, 4						
		la $a0, Player2Winner			#Dá print à string			
		syscall
		lw $t0,VitP2				#Da load ao numero de vitorias do jogador 2
		addi $t0,$t0,1				#Adiciona +1 ao numero de vitorias
		sw $t0,VitP2				#Guarda o valor com a nova vitoria
		lw $t0,p2score				#Da load ao numero de pontos do jogador 2
		addi $t0,$t0,3				#Adiciona +3  ao numero de pontos
		sw $t0,p2score				#Guarda o numero de pontos
		lw $t0,p1score				#Da load ao numero de pontos do jogador 1
		beq $t0,0 zerop1points 			#Se o numero de pontos do jogador 1 já for 0, salta para a função zerop1points 
		addi $t0,$t0,-1				#Caso nao seja 0, subtrai 1
		sw $t0, p1score				#Guarda o numero de pontos do jogador 2
		j pontosend				#Salta para o fim
	
draw: 
	li $v0,4
	la $a0,Empate					#Da print à string
	syscall
	lw $t0,Draws					#Carrega numero de empates
	add $t0,$t0,1					#Adiciona mais 1
	sw $t0,Draws					#Da save
	lw $t0,p1score					#Carrega numero de pontos do jogador 1
	add $t0,$t0,1					#Adiociona mais 1
	sw $t0,p1score					#Da save ao numero de pontos
	lw $t0,p2score					#Carrega numero de pontos do jogador 2
	add $t0,$t0,1					#Adiciona mais 1 
	sw $t0, p2score					#Da save
	jal CleanMatriz					#Limpa matriz
	jal printPoints					#Imprime pontos
	j main						#Volta ao inicio
zerop2points:				
	li $t0, 0					#Se a pontuação do jogador 2 ja for 0, entao fica 0, nao podendo ser negativa
	sw $t0, p2score					
	syscall
	j pontosend					#Salta para o fim
zerop1points:						#Se a pontuação do jogador 1 ja for 0, entao fica 0, nao podendo ser negativa
	li $t0, 0
	sw $t0, p1score
	syscall
	j pontosend					#Salta para o fim
	
pontosend:
	jal printPoints					#Chama a função de imprimir todas as stats.
	jal CleanMatriz					#Chama função de limpar matriz.
	li $v0, 4
	la $a0, separador				#Imprime separador
	syscall
	j main

CleanMatriz: 
	li $v0,4 
	la $a0,TabuleiroLimpo 				#Da print á string 
	syscall
	add $t0,$0,$0 					#t0 = 0
	loop: 
		beq $t0, 168, end 			#Quando t0 = 168(7x6x4), ou seja, quando atingir mos 168 teremos percorrido o array todo,vamos para o fim
		lw $t1,mat($t0) 			#Carregar end matriz para t1 na pos t0
		add $t1,$0,$0   			#t1 = 0
		sw $t1,mat($t0)				#Guardar 0 na pos t0 da matriz
		addi $t0,$t0,4 				#t0 tem de andar de 4 em 4 pq cd int é 4 bytes
		j loop
	end:
	lw $t3,counter					#Carrega o valor do count atual
   	add $t3,$0,$0					#Mete o count a 0
    	sw $t3,counter					#Depois de limpar a matriz o programa da reset ao count tambem.
	jr $ra
printPoints:
	li $v0,4
	la $a0,Player1Pontos				#Da print à string
	syscall
	li $v0,4
	la $a0,Pontos					#Da print à string
	syscall
	lw $t0,p1score					#Da print  ao numero de pontos do jogador 1
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,Vitorias					#Da print à string
	syscall
	lw $t0,VitP1					#Da print ao numero de vitorias do jogador 1
	li $v0,1
	move $a0, $t0
	syscall
	li $v0,4
	la $a0,endline					#Da print a um \n
	syscall
	li $v0,4
	la $a0,Player2Pontos				#Da print à string
	syscall
	li $v0,4
	la $a0,Pontos					#Da print à string
	syscall
	lw $t0,p2score					#Da print  ao numero de pontos do jogador 2
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0,Vitorias					#Da print à string
	syscall
	lw $t0,VitP2					#Da print ao numero de vitorias do jogador 2
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,4
	la $a0, Empates					#Da print à string
	syscall
	lw $t0, Draws					#Carrega numero de empates
	li $v0,1
	move $a0, $t0
	syscall	
	li $v0,4			
	la $a0,endline					#Da print a um \n		
	syscall
	jr $ra



exit:
	li $v0, 4
	la $a0, Fim					#Imprime Mensagem de fim do programa.
	syscall
	li $v0, 10
	syscall
	




