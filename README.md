# AINoughtsAndCrosses
Noughts and Crosses against an autonomous agent


https://github.com/user-attachments/assets/cd417ee7-b3cc-4254-9acd-4e2ea65b2369

Robot tree shows the agents decision making on the previous move. The numbers below each position represent the score the agent assigned to each move, where a higher score indicates a much better play. 

The model is a very simple scoring matrix. Each move has a position on the board, and either blocks a win move or allows the agent to win on the next move. Based on the weighting of each of these heuristics,
the agent assigns a score to that move and chooses the highest scoring move. 

There are 3 levels of difficulty with differnet weightings. 
