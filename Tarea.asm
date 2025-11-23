.data
msgBienvenida:    .asciiz "\n=== JUEGO DE LOS TESOROS ===\n"
msgTamTablero:    .asciiz "\nIngrese el tamaño del tablero (20 a 120): "
msgTamError:      .asciiz "Valor invalido. Debe estar entre 20 y 120.\n"

msgTurnoJug:      .asciiz "\n--- TURNO DEL JUGADOR ---\n"
msgTurnoMaq:      .asciiz "\n--- TURNO DE LA MAQUINA ---\n"
msgPasosJug:      .asciiz "Cuantas casillas desea avanzar? (1 a 6): "
msgPasosError:    .asciiz "Valor invalido. Debe estar entre 1 y 6.\n"

msgEstado:        .asciiz "\nEstado del juego:\n"
msgPosJug:        .asciiz "Posicion jugador: "
msgPosMaq:        .asciiz "Posicion maquina: "
msgDinJug:        .asciiz "Dinero jugador: "
msgDinMaq:        .asciiz "Dinero maquina: "
msgTesJug:        .asciiz "Tesoros jugador: "
msgTesMaq:        .asciiz "Tesoros maquina: "

msgTesoro:        .asciiz " ¡Encontro un TESORO!\n"
msgDineroG:       .asciiz " Gano dinero: "
msgNL:            .asciiz "\n"

msgMuerteJ:       .asciiz "\nEl jugador quedo sin dinero!\n"
msgMuerteM:       .asciiz "\nLa maquina quedo sin dinero!\n"

msgFin:           .asciiz "\n=== FIN DEL JUEGO ===\n"
msgGanJugador:    .asciiz "Gana el JUGADOR.\n"
msgGanMaquina:    .asciiz "Gana la MAQUINA.\n"
msgEmpate:        .asciiz "Empate total.\n"

msgTesFinalJ:     .asciiz "Tesoros finales jugador: "
msgTesFinalM:     .asciiz "Tesoros finales maquina: "
msgTotalGanado:   .asciiz "Dinero total ganado: "

boardSize:        .word 0
numTreasures:     .word 0

playerPos:        .word -1
machinePos:       .word -1

playerMoney:      .word 10
machineMoney:     .word 10

playerTreasures:  .word 0
machineTreasures: .word 0

winner:           .word 0
seed:             .word 1234567

tableroTipo:      .space 480     # 120 * 4 bytes
tableroDinero:    .space 480


.text
.globl main
main:

    # Bienvenida
    li $v0, 4
    la $a0, msgBienvenida
    syscall

# ============================
# LECTURA DEL TAMAÑO DEL TABLERO
# ============================
leer_tam:
    li $v0, 4
    la $a0, msgTamTablero
    syscall

    li $v0, 5
    syscall
    move $t0, $v0     # N

    li $t1, 20
    blt $t0, $t1, tam_invalido
    li $t1, 120
    bgt $t0, $t1, tam_invalido

    sw $t0, boardSize

    # numTes = N*30/100
    li $t1, 30
    mul $t2, $t0, $t1
    li $t3, 100
    div $t2, $t3
    mflo $t4
    sw $t4, numTreasures

    j init_tablero

tam_invalido:
    li $v0, 4
    la $a0, msgTamError
    syscall
    j leer_tam


# ============================
# INICIALIZAR TABLERO
# ============================
init_tablero:

    lw $t0, boardSize
    la $t1, tableroTipo
    la $t2, tableroDinero

    li $t3, 0
init_zero:
    beq $t3, $t0, colocar_tesoros

    sll $t4, $t3, 2

    add $t9, $t1, $t4
    sw $zero, 0($t9)

    add $t9, $t2, $t4
    sw $zero, 0($t9)

    addi $t3, $t3, 1
    j init_zero


# ============================
# COLOCAR TESOROS RANDOM
# ============================
colocar_tesoros:
    lw $t7, numTreasures
    li $t8, 0

colocar_loop:
    beq $t8, $t7, colocar_dinero

    li $a0, 0
    lw $a1, boardSize
    addi $a1, $a1, -1
    jal randomRange
    move $t9, $v0

    sll $t4, $t9, 2
    la $t1, tableroTipo
    add $t6, $t1, $t4
    lw $t5, 0($t6)

    bne $t5, $zero, colocar_loop  # si ya había tesoro

    li $t5, 1
    sw $t5, 0($t6)

    addi $t8, $t8, 1
    j colocar_loop


# ============================
# COLOCAR DINERO RANDOM
# ============================
colocar_dinero:

    lw $t0, boardSize
    la $t1, tableroTipo
    la $t2, tableroDinero

    li $t3, 0
dinero_loop:
    beq $t3, $t0, juego_loop

    sll $t4, $t3, 2

    add $t6, $t1, $t4
    lw $t5, 0($t6)

    bne $t5, $zero, dinero_next

    li $a0, 10
    li $a1, 100
    jal randomRange

    add $t6, $t2, $t4
    sw $v0, 0($t6)

dinero_next:
    addi $t3, $t3, 1
    j dinero_loop
    # =========================================
# BUCLE PRINCIPAL DEL JUEGO
# =========================================
juego_loop:

    lw $t5, playerMoney
    blez $t5, jugador_muere

    lw $t6, machineMoney
    blez $t6, maquina_muere

    lw $t3, playerTreasures
    li $t7, 3
    bge $t3, $t7, fin_juego

    lw $t4, machineTreasures
    bge $t4, $t7, fin_juego

    lw $t1, playerPos
    lw $t2, machinePos
    lw $t0, boardSize
    addi $t8, $t0, -1

    beq $t1, $t8, turno_maquina
    j turno_jugador


# ============ TURNO JUGADOR ============
turno_jugador:

    li $v0, 4
    la $a0, msgTurnoJug
    syscall

leer_pasos:
    li $v0, 4
    la $a0, msgPasosJug
    syscall

    li $v0, 5
    syscall
    move $t7, $v0

    li $t8, 1
    blt $t7, $t8, pasos_error
    li $t8, 6
    bgt $t7, $t8, pasos_error
    j jugador_avanza

pasos_error:
    li $v0, 4
    la $a0, msgPasosError
    syscall
    j leer_pasos

jugador_avanza:

    move $a0, $t7
    la $a1, playerPos
    la $a2, playerMoney
    la $a3, playerTreasures
    jal mover

    jal mostrar_estado

    lw $t5, playerMoney
    blez $t5, jugador_muere

    lw $t3, playerTreasures
    li $t7, 3
    bge $t3, $t7, fin_juego

    j turno_maquina


# ============ TURNO MAQUINA ============
turno_maquina:

    lw $t0, boardSize
    lw $t2, machinePos
    addi $t8, $t0, -1
    beq $t2, $t8, juego_loop

    li $v0, 4
    la $a0, msgTurnoMaq
    syscall

    li $a0, 1
    li $a1, 6
    jal randomRange
    move $t7, $v0

    move $a0, $t7
    la $a1, machinePos
    la $a2, machineMoney
    la $a3, machineTreasures
    jal mover

    jal mostrar_estado

    lw $t6, machineMoney
    blez $t6, maquina_muere

    lw $t4, machineTreasures
    li $t7, 3
    bge $t4, $t7, fin_juego

    j juego_loop


# ========================
# Muerte por dinero <= 0
# ========================
jugador_muere:
    li $v0, 4
    la $a0, msgMuerteJ
    syscall
    li $t7, 2       # maquina gana
    sw $t7, winner
    j fin_juego

maquina_muere:
    li $v0, 4
    la $a0, msgMuerteM
    syscall
    li $t7, 1       # jugador gana
    sw $t7, winner
    j fin_juego


# =========================================
# mover(pasos, &pos, &dinero, &tesoros)
# =========================================
mover:

    lw $t0, boardSize
    lw $t1, 0($a1)
    add $t1, $t1, $a0

    addi $t2, $t0, -1
    bgt $t1, $t2, clamp_fin
    j pos_ok

clamp_fin:
    move $t1, $t2

pos_ok:
    sw $t1, 0($a1)

    la $t3, tableroTipo
    sll $t4, $t1, 2
    add $t6, $t3, $t4
    lw $t5, 0($t6)

    bne $t5, $zero, es_tesoro

    la $t3, tableroDinero
    add $t6, $t3, $t4
    lw $t8, 0($t6)

    li $v0, 4
    la $a0, msgDineroG
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    li $v0, 4
    la $a0, msgNL
    syscall

    lw $t9, 0($a2)
    add $t9, $t9, $t8
    sw $t9, 0($a2)

    jr $ra

es_tesoro:

    li $v0, 4
    la $a0, msgTesoro
    syscall

    lw $t9, 0($a3)
    addi $t9, $t9, 1
    sw $t9, 0($a3)

    sw $zero, 0($t6)

    jr $ra


# =========================================
# mostrar_estado()
# =========================================
mostrar_estado:

    li $v0, 4
    la $a0, msgEstado
    syscall

    # pos jugador
    li $v0, 4
    la $a0, msgPosJug
    syscall
    lw $t1, playerPos
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    # pos maquina
    li $v0, 4
    la $a0, msgPosMaq
    syscall
    lw $t1, machinePos
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    # dinero jugador
    li $v0, 4
    la $a0, msgDinJug
    syscall
    lw $t1, playerMoney
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    # dinero maquina
    li $v0, 4
    la $a0, msgDinMaq
    syscall
    lw $t1, machineMoney
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    # tesoros jugador
    li $v0, 4
    la $a0, msgTesJug
    syscall
    lw $t1, playerTreasures
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    # tesoros maquina
    li $v0, 4
    la $a0, msgTesMaq
    syscall
    lw $t1, machineTreasures
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, msgNL
    syscall

    jr $ra
    # =========================================
# randomRange(lo, hi)
# Devuelve número aleatorio entre lo y hi
# =========================================
randomRange:

    lw  $t0, seed          # cargar semilla
    li  $t1, 1103515245
    mult $t0, $t1
    mflo $t2
    addi $t2, $t2, 12345    # LCG
    sw   $t2, seed          # guardar semilla nueva

    # hacerlo positivo
    lui  $t3, 0x7fff
    ori  $t3, $t3, 0xffff
    and  $t2, $t2, $t3

    # rango = hi-lo+1
    sub  $t4, $a1, $a0
    addi $t4, $t4, 1

    div  $t2, $t4
    mfhi $t5              # r = semilla % rango

    add  $v0, $a0, $t5    # lo + r
    jr   $ra


# =========================================
# FIN DEL JUEGO: determinar ganador
# =========================================
fin_juego:

    li $v0, 4
    la $a0, msgFin
    syscall

    lw $t7, winner

    beq $t7, 1, ganador_jugador
    beq $t7, 2, ganador_maquina
    j empate_total


ganador_jugador:

    li $v0, 4
    la $a0, msgGanJugador
    syscall
    j mostrar_final


ganador_maquina:

    li $v0, 4
    la $a0, msgGanMaquina
    syscall
    j mostrar_final


empate_total:

    li $v0, 4
    la $a0, msgEmpate
    syscall


# =========================================
# MOSTRAR ESTADÍSTICAS FINALES
# =========================================
mostrar_final:

    # Tesoros jugador
    li $v0, 4
    la $a0, msgTesFinalJ
    syscall

    lw $t1, playerTreasures
    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, msgNL
    syscall


    # Tesoros maquina
    li $v0, 4
    la $a0, msgTesFinalM
    syscall

    lw $t2, machineTreasures
    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 4
    la $a0, msgNL
    syscall


    # Dinero total ganado = suma
    lw $t3, playerMoney
    lw $t4, machineMoney
    add $t5, $t3, $t4

    li $v0, 4
    la $a0, msgTotalGanado
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    # Salida del programa
    li $v0, 10
    syscall


