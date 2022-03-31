% Assignment 7 -- Visual Discrimination Task (Identifying Animal Types)
% AUTHOR:   Ren-Hui Michelle Tham

%% Ask participant for information (ID and number of trials) 
% Ask user for ID
id = input("Please enter your participant id: ");

% Ask for number of trials (n) in discrimination task until user inputs
% even number
while true
    n = input("Please enter the number of trials: ");
    if mod( n, 2 ) == 0
        break
    else
        disp("Please enter an even number.");
        continue
    end
end

%% Set up experiment conditions
% Randomly allocate n/2 signal events to the n trials 
% (1 means there is a signal, 0 means there is no signal)
conditions = [ ones( 1, n/2 ) zeros( 1, n/2 ) ];
rng( id )
r = randperm( n );
conditions = conditions( r );

%% Run experiment
hit = 0;
false_alarm = 0;
participant_responses = zeros( 1, n );
for i = 1:length(conditions)
    % create letters vector containing the first letters of the file names
    letters = [ 'k' 'd' ];
    letters_index = randperm( 2 );
    % create a random_number vector containing 1, 2, and 3 randomly ordered
    random_number = randperm( 6 );
    if conditions(i) == 1
        % Display Image 1 (same type of animal as in Image 1)
        subplot( 1, 2, 1 );
        display_image( letters, letters_index, random_number, 1, 1 )
        % Display Image 2 (same type of animal as in Image 2)
        subplot( 1, 2, 2 );
        display_image( letters, letters_index, random_number, 1, 2 )
        
        % Ask user question and store response in vector
        num_answer = input( "\n\nAre these the same type of animal? (1 = yes; 0 = no) " );
        participant_responses(i) = num_answer;
        % Provide feedback
        if num_answer == 1
            fprintf( "Yes, that is correct." );
            hit = hit + 1;
        else
            fprintf( "Unfortunately, this is incorrect. " );
        end
    else
        % Display Image 1 (different type of animal compared to Image 2)
        subplot( 1, 2, 1 );
        display_image( letters, letters_index, random_number, 1, 1 )
        % Display Image 2 (different type of animal compared to Image 1)
        subplot( 1, 2, 2 );
        display_image( letters, letters_index, random_number, 2, 2 )
        
        % Ask for response and store response in vector
        num_answer = input( "\n\nAre these the same type of animal? (1 = yes; 0 = no) " );
        participant_responses(i) = num_answer;
        % Provide feddback
        if num_answer == 0
            fprintf( "Yes, that is correct." );
        else
            fprintf( "\nUnfortunately, this is incorrect. " );
            false_alarm = false_alarm + 1;
        end
    end
end

%% Display experiment results
% Calculate probability of a hit and probability of a false alarm
num_signal_trials = n / 2;
num_noise_trials = n / 2;
probability_hit = hit / num_signal_trials;
probability_false_alarm = false_alarm / num_noise_trials;
% Replace empirical hit or false alarm rates of 0 and 1 with fixed values
% of 0.01 and 0.99 respectively 
if probability_hit == 0
    probability_hit = 0.01;
elseif probability_hit == 1
    probability_hit = 0.99;
end
        
if probability_false_alarm == 0
    probability_false_alarm = 0.01;
elseif probability_false_alarm == 1
    probability_false_alarm = 0.99;
end
% Calculate the z score corresponding to the hit probability
% and the z-score corresponding to the false alarm probability to find the
% sensitivity index
z_hit = norminv( probability_hit );
z_false_alarm = norminv( probability_false_alarm );
d = z_hit - z_false_alarm;
% Calculate the bias index
B = exp( ( norminv( probability_hit )^2 - norminv( probability_false_alarm )^2 ) / 2 );
% Print out the probability of a hit, probability of a false alarm, and
% sensitivity
fprintf( "\nThe probability a hit is: %3.2f", probability_hit );
fprintf( "\nThe probability a false alarm is: %3.2f", probability_false_alarm );
fprintf( "\nThe sensitivity index is: %3.2f", d );
fprintf( "\nThe bias index is: %3.2f\n", B );

%% Save the experiment results to a .mat file
file_name = sprintf( "s_%d.mat", id );
save( file_name, 'id', 'n', 'hit', 'false_alarm', 'conditions', 'participant_responses', 'probability_hit', 'probability_false_alarm', 'd', 'B' );

% display_image( letters, letters_index, random_number, i1, i2 )
% 
% This function displays the image of animal according to i1 and i2
%
% INPUT:    letters: a vector containing the letters 'k' and 'd', which
%           are the letters that begin the image file names
%           letters_index: a vector containing the numbers 1 and 2 in a 
%           a random order
%           random_number: a vector containing the numbers 1, 2, 3, 4, 5,  
%           and 6 in a random order. The numbers 1-6 follow either the 
%           letter 'k' or 'd' in the image file names
%           i1: the index that will be used to choose an element from
%           letters
%           i2: the index that will be used to choose an element from
%           random_numbers
function display_image( letters, letters_index, random_number, i1, i2 )
    file_type = "%s%d.tiff";
    animal_image = sprintf( file_type, letters( 1, letters_index( i1 ) ), random_number( i2 ) );
    [ animal_image, animal_image_map ] = imread( animal_image );
    image( animal_image );
    colormap( animal_image_map );
    axis off;
    axis image;
end