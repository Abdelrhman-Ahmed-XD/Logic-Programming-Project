% === Tic Tac Toe: Player vs AI ===

% Ask player to choose their symbol (x or o)
choose_player_symbol(PlayerSymbol) :-
    write('Choose your symbol (x or o): '), nl,
    read(PlayerSymbol),
    (PlayerSymbol = x ; PlayerSymbol = o), !.

% If invalid symbol, ask again
choose_player_symbol(PlayerSymbol) :-
    write('Invalid symbol! Please choose x or o.'), nl,
    choose_player_symbol(PlayerSymbol).

% Ask player who should start (player or ai)
choose_who_starts(Starter) :-
    write('Who should start? (player or ai): '), nl,
    read(Starter),
    (Starter = player ; Starter = ai), !.

% If invalid starter, ask again
choose_who_starts(Starter) :-
    write('Invalid choice! Please choose player or ai.'), nl,
    choose_who_starts(Starter).

% Start the game
play :-
    choose_player_symbol(PlayerSymbol),
    opponent(PlayerSymbol, AISymbol),
    choose_who_starts(Starter),
    print_game([]), % Show empty board
    play_turn(Starter, [], PlayerSymbol, AISymbol).

% Play turn for the player
play_turn(player, Game, PlayerSymbol, AISymbol) :-
    ( game_over(Game, Winner, PlayerSymbol, AISymbol) ->
        announce_winner(Winner)
    ;
        valid_moves(Moves, Game, PlayerSymbol),
        (Moves = [] -> (write('It\'s a draw!'), nl);
         (write('Available moves: '), write(Moves), nl,
          ask_move(Move, Moves, PlayerSymbol),
          NextGame = [Move | Game],
          print_game(NextGame),
          play_turn(ai, NextGame, PlayerSymbol, AISymbol)))
    ).

% Play turn for the AI
play_turn(ai, Game, PlayerSymbol, AISymbol) :-
    ( game_over(Game, Winner, PlayerSymbol, AISymbol) ->
        announce_winner(Winner)
    ;
        valid_moves(Moves, Game, AISymbol),
        (Moves = [] -> (write('It\'s a draw!'), nl);
         (write('AI is thinking...'), nl,
          random_move(Moves, Move),
          NextGame = [Move | Game],
          format('AI chooses ~w~n', [Move]),
          print_game(NextGame),
          play_turn(player, NextGame, PlayerSymbol, AISymbol)))
    ).

% Ask player to input a move in the format move(Player, X, Y)
ask_move(Move, ValidMoves, PlayerSymbol) :-
    write('Enter your move (e.g., move(o, 0, 0) for top-left): '), nl,
    read(Move),
    Move = move(PlayerSymbol, _, _),
    member(Move, ValidMoves), !.

% If move is invalid, ask again
ask_move(Move, ValidMoves, PlayerSymbol) :-
    write('Invalid move. Try again.'), nl,
    ask_move(Move, ValidMoves, PlayerSymbol).

% AI picks a random move from valid moves
random_move(Moves, Move) :-
    length(Moves, NumMoves),
    random(0, NumMoves, Index),
    nth0(Index, Moves, Move).

% Check if the game is over
game_over(Game, Winner, PlayerSymbol, AISymbol) :-
    ( winner(Game, PlayerSymbol) -> Winner = player
    ; winner(Game, AISymbol) -> Winner = ai
    ; \+ valid_moves(_, Game, PlayerSymbol), \+ valid_moves(_, Game, AISymbol) -> Winner = draw
    ).

% Announce the winner or draw
announce_winner(draw) :-
    write('It\'s a draw!'), nl.
announce_winner(player) :-
    write('You win! Congrats!'), nl.
announce_winner(ai) :-
    write('AI wins!'), nl.

% Check if a player has won
winner(Game, Player) :-
    % Three in a row
    (X = 0; X = 1; X = 2),
    member(move(Player, X, 0), Game),
    member(move(Player, X, 1), Game),
    member(move(Player, X, 2), Game).

winner(Game, Player) :-
    % Three in a column
    (Y = 0; Y = 1; Y = 2),
    member(move(Player, 0, Y), Game),
    member(move(Player, 1, Y), Game),
    member(move(Player, 2, Y), Game).

winner(Game, Player) :-
    % Diagonal top-left to bottom-right
    member(move(Player, 0, 0), Game),
    member(move(Player, 1, 1), Game),
    member(move(Player, 2, 2), Game).

winner(Game, Player) :-
    % Diagonal top-right to bottom-left
    member(move(Player, 0, 2), Game),
    member(move(Player, 1, 1), Game),
    member(move(Player, 2, 0), Game).

% Find all valid moves
valid_moves(Moves, Game, Turn) :-
    findall(move(Turn, X, Y),
            (between(0, 2, X), between(0, 2, Y), \+ member(move(_, X, Y), Game)),
            Moves).

% Print the game board with X and Y labels
print_game(Game) :-
    write('  0 1 2'), nl, % Column headers
    print_row(0, Game),
    print_row(1, Game),
    print_row(2, Game).

print_row(X, Game) :-
    write(X), write(' '), % Row header
    plot(Game, X, 0),
    write(' '),
    plot(Game, X, 1),
    write(' '),
    plot(Game, X, 2),
    nl.

plot(Game, X, Y) :-
    (member(move(P, X, Y), Game), ground(P)) -> write(P) ; write('.').

% Define opponent symbols (if player is x, AI is o, and vice versa)
opponent(x, o).
opponent(o, x).











