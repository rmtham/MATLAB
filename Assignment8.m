% Assignment 8 -- Creating a Puzzle
% AUTHOR: Ren-Hui Michelle Tham, 2021

%% Initialize Puzzle
% Ask for size of puzzle until user inputs a number greater than 2
invalid_size = true;
while invalid_size
    n = input( "\nWhat is the size of the puzzle? " );
    if n > 2
        break;
    else
        fprintf( "Please enter a number that is greater than 2" );
    end
end

% Randomize numbers
num_tiles = n ^ 2;
scrambled_num_tiles = randperm( num_tiles );

%% Begin Gameplay
play_game = true; 
num_correct = 0;
goal_configuration = 1:num_tiles;
while play_game
    % Print number of correctly placed tiles
    num_correct = count_num_correct(scrambled_num_tiles, goal_configuration, num_tiles);
    fprintf( "\nCurrent board: (#correct=%d)\n", num_correct );
    % Visualize Puzzle on Screen 
    count = 1;
    for i = 1:n
        for j = 1:n
            if scrambled_num_tiles( count ) == num_tiles
                white_space = " ";
                fprintf( "%+4s ", white_space );
            else
                fprintf( "%4d ", scrambled_num_tiles( count ) );
            end
            count = count + 1;
        end
        fprintf( "\n" );
    end
    % Ask user for input
    response = input( "What is your move? " );
    if isempty( response )
        % End game once user inputs nothing
        fprintf( "\nThank you for playing.\n" );
        break;
    elseif (response >= num_tiles) || (response < 1)
        % Tell user to enter in a valid tile value if the input value is
        % out of range
        fprintf( "\nPlease enter in a valid tile value." );
        continue;
    end
    
    % Get blank tile index
    blank_tile_index = get_tile_index( num_tiles, scrambled_num_tiles );
    % Get input tile index
    input_index = get_tile_index( response, scrambled_num_tiles );
    % Check that user input is valid
    corners_acceptable_tile = get_corner_acceptable_tile( blank_tile_index, input_index, n, num_tiles );
    sides_acceptable_tile = get_side_acceptable_tile( blank_tile_index, input_index, n, num_tiles );
    middle_acceptable_tile = get_middle_acceptable_tile( blank_tile_index, input_index, n );
    % Swap tiles if user entered valid tile
    if ( corners_acceptable_tile || sides_acceptable_tile || middle_acceptable_tile )
        a = scrambled_num_tiles( blank_tile_index );
        b = scrambled_num_tiles( input_index );
        scrambled_num_tiles( blank_tile_index ) = b;
        scrambled_num_tiles( input_index ) = a;
    else
        fprintf( "\nPlease choose a neighboring tile to the blank tile.\n" );
    end

    % If user solves puzzle, congratulate user and end game
    if num_correct == ( num_tiles - 1 )
        fprintf( "\nCongratulations, you have solved the puzzle!\n" );
        break;
    end
end

function tile_index = get_tile_index( tile_value, scrambled_num_tiles )
    % This function returns the tile index corresponding to the value of
    % the tile
    % INPUT:    tile_value -- value of the tile
    %           scrambled_num_tiles -- vector containing the scrambled
    %           numbers
    % OUTPUT:   tile_index -- index corresponding to the tile value 
    % Author:   Ren-Hui Michelle Tham, 2021
    
    for i=1:length(scrambled_num_tiles)
        if tile_value == scrambled_num_tiles( i )
            tile_index = i;
        end
    end
end

function corners_acceptable_tile = get_corner_acceptable_tile( bt_index, input_index, n, num_tiles )
    % This function returns a boolean variable which is true if the blank
    % tile is a corner tile and the user inputs a valid move
    % INPUT:    bt_index -- index of the blank tile
    %           input_index -- index of the value that the user input
    %           n -- size of the puzzle (e.g., n = 5 when puzzle is 5 x 5)
    %           num_tiles -- number of tiles in the puzzle 
    % OUTPUT:   corners_acceptable tile -- boolean that is true if the blank
    %           blank tile is a corner tile and the user inputs a valid 
    %           move, and is false if this condition is not met 
    % Author:   Ren-Hui Michelle Tham, 2021
    
    if bt_index == 1 && ( input_index == ( bt_index + 1 ) || input_index == ( bt_index + n ) )
        % Top Left Corner
        corners_acceptable_tile = true;
    elseif bt_index == n && ( input_index == ( bt_index - 1 ) || input_index == ( bt_index + n ) )
        % Top Right Corner
        corners_acceptable_tile = true;
    elseif bt_index == ( num_tiles - (n - 1) ) && ( input_index == ( bt_index - n ) ...
            || input_index == ( bt_index + 1 ) )
        % Bottom Left Corner
        corners_acceptable_tile = true;
    elseif bt_index == ( num_tiles ) && ( input_index == ( bt_index - n ) || ...
            input_index == ( bt_index - 1 ) || input_index == ( bt_index + n ) )
        % Bottom Right Corner
        corners_acceptable_tile = true;
    else
        corners_acceptable_tile = false;
    end
end

function sides_acceptable_tile = get_side_acceptable_tile( bt_index, input_index, n, num_tiles )
    % This function returns a boolean variable which is true if the blank
    % tile is a side tile and the user inputs a valid move
    % INPUT:    bt_index -- index of the blank tile
    %           input_index -- index of the value that the user input
    %           n -- size of the puzzle (e.g., n = 5 when puzzle is 5 x 5)
    %           num_tiles -- number of tiles in the puzzle 
    % OUTPUT:   side_acceptable tile -- boolean that is true if the blank
    %           blank tile is a side tile and the user inputs a valid 
    %           move, and is false if this condition is not met 
    % Author:   Ren-Hui Michelle Tham, 2021
    
    % Initialize sides_acceptable_tile to false
    sides_acceptable_tile = false;
    if( ( n > bt_index ) && ( bt_index > 1 ) ) && ( input_index == ( bt_index - 1 ) ...
            || input_index == ( bt_index + 1 ) ||  input_index == ( bt_index + n ) )
        % Top Side Slots
        sides_acceptable_tile = true;
    elseif ( ( num_tiles > bt_index ) && ( bt_index > num_tiles - ( n - 1 ) ) ) ...
            && ( input_index == ( bt_index - n) || input_index == ( bt_index - 1 ) ...
            || input_index == ( bt_index + 1 ) )
        % Bottom Side Slots
        sides_acceptable_tile = true;
    else
        % Left and Right Side Slots
        num_sides = n - 2;
        for i=1:num_sides
            if ( bt_index == ( ( i * n ) + 1 ) ) && ( input_index == ( bt_index - n ) ...
                    || input_index == ( bt_index + 1 ) || input_index == ( bt_index + n ) )
                % Left Side Slots
                sides_acceptable_tile = true;
            elseif ( bt_index == ( ( i + 1 ) * n ) ) && ( input_index == ( bt_index - n ) ...
                    || input_index == ( bt_index - 1 ) || input_index == ( bt_index + n ) )
                % Right Side Slots
                sides_acceptable_tile = true;
            end
        end
    end
end

function middle_acceptable_tile = get_middle_acceptable_tile( bt_index, input_index, n )
    % This function returns a boolean variable which is true if the blank
    % tile is a middle tile and the user inputs a valid move
    % INPUT:    bt_index -- index of the blank tile
    %           input_index -- index of the value that the user input
    %           n -- size of the puzzle (e.g., n = 5 when puzzle is 5 x 5)
    % OUTPUT:   middle_acceptable tile -- boolean that is true if the blank
    %           blank tile is a middle tile and the user inputs a valid 
    %           move, and is false if this condition is not met 
    % Author:   Ren-Hui Michelle Tham, 2021
    
    % Initialize middle_acceptable_tile to false
    middle_acceptable_tile = false;
    num_middle_rows = n - 2;
    for i=1:num_middle_rows
        if ( ( ( i + 1 ) * n ) > bt_index ) && ( bt_index > ( ( i * n ) + 1 ) ) ...
                && ( input_index == ( bt_index - n ) || input_index == ( bt_index - 1 ) ...
                || input_index == ( bt_index + 1 ) || input_index == ( bt_index + n ) )
            middle_acceptable_tile = true;
        end
    end
end
            
function num_correct = count_num_correct(scrambled_num_tiles, goal_configuration, num_tiles)
    % This function returns the number of correctly placed tiles in the
    % puzzle
    % INPUT:    scrambled_num_tiles -- vector containing the scrambled
    %           numbers
    %           goal_configuration -- vector containing the goal
    %           configuration of the puzzle
    % OUTPUT:   num_correct -- number of correctly placed tiles in the
    %           puzzle
    % Author:   Ren-Hui Michelle Tham, 2021
    
    count = 0;
    for i=1:length(scrambled_num_tiles)
        if ( scrambled_num_tiles(i) == goal_configuration(i) ) && ...
                ( scrambled_num_tiles(i) ~= num_tiles )
            count = count + 1;
        end
    end
    
    num_correct = count;
end