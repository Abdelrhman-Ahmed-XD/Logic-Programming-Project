% Tic Tac Toe Game in Prolog

% Start the game
play :- my_turn([]).

% Computer's turn (x)
my_turn(Game) :-
    valid_moves(ValidMoves, Game, x), % Find all valid moves for x
    any_valid_moves(ValidMoves, Game).

% If no moves are available -> tie
any_valid_moves([], _) :-
    write('It is a tie'), nl.

% Otherwise, find good moves and make a decision
any_valid_moves([_|_], Game) :-
    findall(NextMove, game_analysis(x, Game, NextMove), MyMoves),
    do_a_decision(MyMoves, Game).

% Computer makes a move
% Picks a random good move, updates the game, prints the board
% Checks if won, else gives turn to player
do_a_decision(MyMoves, Game) :-
    not(MyMoves = []),
    length(MyMoves, MaxMove),
    random(0, MaxMove, ChosenMove),
    nth0(ChosenMove, MyMoves, X),
    NextGame = [X | Game],
    print_game(NextGame),
    (victory_condition(x, NextGame) ->
        (write('I won. You lose.'), nl);
        your_turn(NextGame), !).

% Player's turn (o)
your_turn(Game) :-
    valid_moves(ValidMoves, Game, o), % Find all valid moves for o
    (ValidMoves = [] -> (write('It is a tie'), nl); % No moves = tie
     (write('Available moves:'), write(ValidMoves), nl,
      ask_move(Y, ValidMoves), % Ask for player's move
      NextGame = [Y | Game],
      (victory_condition(o, NextGame) ->
        (write('I lose. You win.'), nl);
        my_turn(NextGame), !))).

% Ask player to input a move
ask_move(Move, ValidMoves) :-
    write('Enter your move: '), nl,
    read(Move),
    Move = move(o, _, _),
    member(Move, ValidMoves), !.

% If move is invalid, ask again
ask_move(Y, ValidMoves) :-
    write('Invalid move. Try again.'), nl,
    ask_move(Y, ValidMoves).

% Print the game board with X and Y labels and borders
print_game(Game) :-
    write('   0 1 2'), nl,
    write('  -------'), nl, % Top border
    plot_row(0, Game),
    write('  -------'), nl, % Middle border
    plot_row(1, Game),
    write('  -------'), nl, % Middle border
    plot_row(2, Game),
    write('  -------'), nl. % Bottom border

plot_row(X, Game) :-
    write(X), write(' |'), % Row header with left border
    plot(Game, X, 0),
    write('|'),
    plot(Game, X, 1),
    write('|'),
    plot(Game, X, 2),
    write('|'), nl. % Right border

plot(Game, X, Y) :-
    (member(move(P, X, Y), Game), ground(P)) -> write(P) ; write('.').

% Analyze the game for the best move
% Computer tries to find a move that does not lose

% If x already won
game_analysis(_, Game, _) :-
    victory_condition(Winner, Game),
    Winner = x.

% Otherwise, continue analyzing
game_analysis(Turn, Game, NextMove) :-
    not(victory_condition(_, Game)),
    game_analysis_continue(Turn, Game, NextMove).

% Continue looking for moves
game_analysis_continue(Turn, Game, NextMove) :-
    valid_moves(Moves, Game, Turn),
    game_analysis_search(Moves, Turn, Game, NextMove).

% Handle tie situations
game_analysis_search([], o, _, _).
game_analysis_search([], x, _, _).

% Opponent's turn logic
game_analysis_search([X|Z], o, Game, NextMove) :-
    NextGame = [X | Game],
    game_analysis_search(Z, o, Game, NextMove),
    game_analysis(x, NextGame, _), !.

% Computer's turn logic
game_analysis_search(Moves, x, Game, NextMove) :-
    game_analysis_search_x(Moves, Game, NextMove).

% Find a move where the computer doesn't lose
game_analysis_search_x([X|_], Game, X) :-
    NextGame = [X | Game],
    game_analysis(o, NextGame, _).
game_analysis_search_x([_|Z], Game, NextMove) :-
    game_analysis_search_x(Z, Game, NextMove).

% Winning conditions for x or o

% Three in a column
victory_condition(P, Game) :-
    (Y = 0; Y = 1; Y = 2),
    member(move(P, 0, Y), Game),
    member(move(P, 1, Y), Game),
    member(move(P, 2, Y), Game).

% Three in a row
victory_condition(P, Game) :-
    (X = 0; X = 1; X = 2),
    member(move(P, X, 0), Game),
    member(move(P, X, 1), Game),
    member(move(P, X, 2), Game).

% Diagonal top-right to bottom-left
victory_condition(P, Game) :-
    member(move(P, 0, 2), Game),
    member(move(P, 1, 1), Game),
    member(move(P, 2, 0), Game).

% Diagonal top-left to bottom-right
victory_condition(P, Game) :-
    member(move(P, 0, 0), Game),
    member(move(P, 1, 1), Game),
    member(move(P, 2, 2), Game).

% Find all valid moves on the board
valid_moves(Moves, Game, Turn) :-
    valid_moves_column(0, M1, [], Game, Turn),
    valid_moves_column(1, M2, M1, Game, Turn),
    valid_moves_column(2, Moves, M2, Game, Turn).

% Check each column
valid_moves_column(Y, M3, M0, Game, Turn) :-
    valid_moves_cell(0, Y, M1, M0, Game, Turn),
    valid_moves_cell(1, Y, M2, M1, Game, Turn),
    valid_moves_cell(2, Y, M3, M2, Game, Turn).

% Check each cell if it is empty, then it is a valid move
valid_moves_cell(X, Y, M1, M0, Game, Turn) :-
    member(move(_, X, Y), Game) -> M0 = M1 ; M1 = [move(Turn, X, Y) | M0].

% Switch turns between x and o
opponent(x, o).
opponent(o, x).





