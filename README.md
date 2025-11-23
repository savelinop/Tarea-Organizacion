# 🏴‍☠️ Proyecto Primer Parcial  
## 🎮 Juego de los Tesoros

### 👥 Integrantes
- Paulo Tapia Loor
- Steven Avelino Palaguachi

---

## 🎯 Objetivos

- 🧠 Implementar un programa usando un lenguaje de nivel medio para comprender la ejecución de instrucciones del procesador.  
- 🔍 Investigar nuevas instrucciones para el uso de diferentes tipos y estructuras de datos.  
- ⚙️ Implementar funciones que mejoren el comportamiento y organización del código.

---

## 📌 Descripción General

El proyecto consiste en desarrollar un programa que simule un **juego de búsqueda de tesoros** entre un jugador y la máquina 🆚🤖.

El juego se desarrolla sobre un **tablero unidimensional** con casillas que pueden contener:

- 🏆 Tesoros
- 💰 Cantidades de dinero

Los jugadores avanzan por turnos y acumulan dinero según las casillas en las que caen.  
El programa deberá mostrar paso a paso el desarrollo del juego y determinar un ganador según las reglas establecidas.

---

## 🧾 Reglas del Juego

1. ▶️ Al iniciar el programa, el usuario elige el tamaño del tablero (20 a 120 casillas). ✅ *Debe validarse*
2. 🏆 El número de tesoros será el **30% del total de casillas**, ubicados aleatoriamente.
3. 💵 Las casillas sin tesoro contienen dinero aleatorio entre **$10 y $100**.
4. 🧍‍♂️ El jugador ingresa cuántas casillas avanzar (1 a 6). ✅ *Validar*
5. 🤖 La máquina avanza con un valor aleatorio (dado 1 a 6).
6. 👀 En cada turno se debe mostrar:
   - Posiciones
   - Dinero obtenido
   - Dinero acumulado
   - Tesoros encontrados
7. 🏁 El juego termina cuando:
   - Un jugador encuentra 3 tesoros  
     **o**
   - Ambos llegan al final del tablero
8. ⏩ Si un jugador llegó al final, el otro debe seguir avanzando hasta llegar también.
9. 🥇 Si nadie encuentra 3 tesoros, gana quien tenga más dinero acumulado.  
   En caso de empate → gana quien tenga más tesoros.
10. 💸 El ganador se lleva el dinero acumulado de ambos jugadores.
11. 📊 Al final se muestran estadísticas:
    - Ganador
    - Tesoros encontrados
    - Dinero ganado

---

## 🧱 Consideraciones

- 🎨 El diseño visual del juego es libre, pero debe mostrar toda la información requerida.
- ✅ Validar correctamente los datos ingresados por el usuario.

---

## 📦 Entregables

- 🧩 Código en ensamblador
- 📄 Documento de especificaciones que incluya:
  - ✅ Requisitos / pasos para ejecutar
  - 🖼️ Capturas de pantalla del programa funcionando
  - 🚀 Posibles mejoras
  - 📚 Referencias en formato IEEE
