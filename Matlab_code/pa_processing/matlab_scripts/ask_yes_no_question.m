%ask_yes_no_question
%
%Asks the user a yes or no question and returns the binary answer
% the user may onbly type 'Y' or 'y' for yes and 'N' or 'N' for no
%
%if no question is placed as a function input the default question: 
%"Are you happy with this?" is asked.
%
%written by David Harris-Birtill
%on 28/01/2014
%email: birtill@hotmail.com
%
%you can insert your own question eg:
%run: ask_yes_no_question('Test question: did this work?')
%which will show:
%Test question: did this work? (Y/y if yes, N/n if no): 
%then you may reply with a Y or y which returns 1 or N or n which returns
%0;

function happy_with_quest = ask_yes_no_question(question_to_ask)
switch nargin
       case 0
             question_to_ask = 'Are you happy with this?';
end
y_n_loop_back = 1;
    while y_n_loop_back == 1
        yes_no_to_contune = input([question_to_ask,' (Y/y if yes, N/n if no): '], 's');
        if yes_no_to_contune == 'Y'
            happy_with_quest=1;
            y_n_loop_back = 0;
        elseif yes_no_to_contune == 'y'
            happy_with_quest=1;
            y_n_loop_back = 0;
        elseif yes_no_to_contune == 'n'
            happy_with_quest=0;
            y_n_loop_back = 0;
        elseif yes_no_to_contune == 'N'
            happy_with_quest=0;
            y_n_loop_back = 0;
        else
            y_n_loop_back = 1;
            disp('Please only type a: y or Y, or n or N');
        end
        
    end