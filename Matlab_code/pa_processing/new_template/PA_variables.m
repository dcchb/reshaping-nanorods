
%changeable variables:
initial_filename = 'C2pa_data_';
filenumber_begin = 1;
filenumber_end = 300;

%variables to select in program run:
root_dir = uigetdir('E:\David', 'Select a your Data Directory');
root_dir = [root_dir,'\'];

disp(['You selected for your input; ',root_dir]);

output_root_directory = uigetdir('E:\David', 'Select a your Output Directory');
output_root_directory = [output_root_directory,'\'];
disp(['You selected for your output; ',output_root_directory]);
%output_directory = 'E:\David\Results_from_ir_cam\';

%specify batch name:
batch_name = input('What is the name of your batch? (no spaces please use underscores): ', 's');