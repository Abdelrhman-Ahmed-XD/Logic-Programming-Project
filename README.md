# 🧠 Logic-Based Tic-Tac-Toe AI (Prolog)

A smart Tic-Tac-Toe AI agent designed using **Prolog** and logic programming techniques to ensure optimal decision-making through game-tree search strategies. This project showcases how logical inference and dynamic reasoning can be applied to classic games.

---

## 🎯 Objective

To develop a Prolog-based AI that:
- Analyzes the game state
- Predicts all possible outcomes
- Chooses the best move
- Guarantees **a win or a tie** (never loses)

The system refuses to make a move if a provable win/tie path doesn't exist — mimicking proof-search in logic-based agents.

---

## 🧩 Key Features

✔️ Built entirely in **SWI-Prolog**  
✔️ Game-tree search for intelligent move prediction  
✔️ Logical proof-based decision-making  
✔️ Configurable behavior (e.g., force tie outcomes)  
✔️ Optimized to **never lose**

---

## 🛠️ Technologies Used

- **Language:** Prolog  
- **Environment:** SWI-Prolog  
- **Techniques:** Dialogical logic, game-tree search, inference rules

---

## 📂 Output

The system outputs each move decision through a traceable inference, ensuring transparency of logic steps.

---

## 🚀 Run Instructions

1. Install [SWI-Prolog](https://www.swi-prolog.org/Download.html)  
2. Open the `.pl` file in SWI-Prolog  
3. Load the file and run:  
   ```prolog
   play.
