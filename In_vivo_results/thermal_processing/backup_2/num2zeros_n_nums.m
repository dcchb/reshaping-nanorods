%convert a number eg 12 into a strng number with x number of 0s before 
%eg 12 --> '0012'

function num_with_zeros = num2zeros_n_nums(number,total_digits)

current_number_of_digits = ceil(log10(number+1));
number_of_zeros = total_digits-current_number_of_digits;

zeros_string = num2str(zeros(1,number_of_zeros));
zeros_string(zeros_string==' ') = '';
num_with_zeros = [zeros_string,num2str(number)];