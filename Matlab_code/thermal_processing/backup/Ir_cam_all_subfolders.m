%Ir_cam_all_subfolders
%
%Analyses pixel stats of a sample and background roi
%for the thermal imaging camera system
%
%Outputs of the mean temperature (in Celsius) over time for each ROI is given 
%
%Written by David Harris-Birtill
%modified from Ir_cam_analysis_v5 (also written by DHB)
%First created on 15/05/2013
%
%
%Other non standard functions and procedures used:
%loadStructFromFile.m
%roi_selection_process.m
%num2zeros_n_nums.m
%
%
%
Ir_cam_variables;

contents_of_root_dir = dir(root_dir);
indices_of_directories = [contents_of_root_dir(:).isdir];
pathnames_list = {contents_of_root_dir(indices_of_directories).name}';
pathnames_list(ismember(pathnames_list,{'.','..'})) = [];%removes current and up dir false dirs in the list

num_subfolders = size(pathnames_list,1);

dir_num=1;
data_directory = [root_dir, cell2mat(pathnames_list(dir_num)),'\'];
output_directory = [output_root_directory, cell2mat(pathnames_list(dir_num)),'\'];
Ir_cam_roi;

[mkdir_sum_success,mkdir__sum_message,mkdir_sum_messageid] = mkdir(output_root_directory, 'summary');
summary_folder = [output_root_directory, 'summary\'];

%loop through all subfolders
for dir_num = 1:num_subfolders
    
    data_directory = [root_dir, cell2mat(pathnames_list(dir_num)),'\'];
    output_directory = [output_root_directory, cell2mat(pathnames_list(dir_num)),'\'];
    %create the subfolder in the output directory
    [mkdir_success,mkdir_message,mkdir_messageid] = mkdir(output_root_directory, cell2mat(pathnames_list(dir_num)));
    if mkdir_success ==0
      disp(['an error occurred when creating directory:', output_root_directory, cell2mat(pathnames_list(dir_num))])
      return
    elseif mkdir_success ==1
        disp(['created directory:', output_root_directory, cell2mat(pathnames_list(dir_num))])
    else
        disp(['Something strange happened when creating directory (', output_root_directory, cell2mat(pathnames_list(dir_num)),') now quitting...'])
        return
    end
    
    Ir_cam_load_and_extract_data;
    
    Ir_cam_plot_data;
    
    save([output_directory,batch_name,'_all_variables']);
    disp('Finished :)');
end
