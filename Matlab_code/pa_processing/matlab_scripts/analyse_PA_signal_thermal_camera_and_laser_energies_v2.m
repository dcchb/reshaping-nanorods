%load in PA signal, laer energy and thermal images over time
%analyse them
%plot heating over time in an ROI
%plot PA signal over time
%plot PA laser energy over time
%plot PA signal normalised to PA laser energy over time
%plot PA signal normalised to PA laser energy vs heating (for corresponding time point)

%set variables:

%thermal camera variables:
initial_filename = 'NEW';
filenumber_begin = 1;
filenumber_end = 300;
batch_name = 'thermal_image';
roi_filenum_to_load = 1;
roi_default_full_path = 'H:\Data\PA_monitoring_of_nanorod_heating\';

%pa signal variables:
pa_signal_name_start = 'C2pa_data_';
low_pass_filter_cutoff_freq = 15;%MHz

%load in data
%set folders:
laser_folder = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\CTAB_samples\laser_energy\';
pa_signal_folder = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\pasig_51213\CTAB_samples\';
thermal_cam_folder = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\CTAB_samples\Thermal_images_matlab\';
processed_results_folder = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\Processed_all_results\ROI_8_Gate_8\';

%load subdir folders:
%NOTE: this assumes all folders (laser and pa and themal cam) have same
%subfolder names
root_dir = thermal_cam_folder;
contents_of_root_dir = dir(root_dir);
indices_of_directories = [contents_of_root_dir(:).isdir];
pathnames_list = {contents_of_root_dir(indices_of_directories).name}';
pathnames_list(ismember(pathnames_list,{'.','..'})) = [];%removes current and up dir false dirs in the list

num_subfolders = size(pathnames_list,1);

[mkdir_sum_success,mkdir__sum_message,mkdir_sum_messageid] = mkdir(processed_results_folder, 'summary');
summary_folder = [processed_results_folder, 'summary\'];

%specify IR cam ROI:
dir_num=1;
data_directory = [thermal_cam_folder, cell2mat(pathnames_list(dir_num)),'\'];
output_directory = [processed_results_folder, cell2mat(pathnames_list(dir_num)),'\'];
Ir_cam_roi_v2;


%locate pa signal start and end gate times
filenum = filenumber_begin;
first_pa_signal = importdata([pa_signal_folder,cell2mat(pathnames_list(dir_num)),'\',pa_signal_name_start,num2zeros_n_nums(filenum,5),'.txt'],',',5);
filenum = filenumber_end;
last_pa_signal = importdata([pa_signal_folder,cell2mat(pathnames_list(dir_num)),'\',pa_signal_name_start,num2zeros_n_nums(filenum,5),'.txt'],',',5);

first_pa_filtered_signal = low_pass_filter(first_pa_signal.data(:,1),first_pa_signal.data(:,2),low_pass_filter_cutoff_freq);
last_pa_filtered_signal = low_pass_filter(last_pa_signal.data(:,1),last_pa_signal.data(:,2),low_pass_filter_cutoff_freq);


%load the first&last pa dataset and plot them
repeat_all_clicks = 0;
while repeat_all_clicks ~=1
    repeat_click1 = 0;
    repeat_click2 = 0;
    figure(1)
    subplot(2,1,1),plot(first_pa_signal.data(:,1),first_pa_signal.data(:,2),'r');
    set(gca,'FontSize',16);
    xlabel('Time (seconds)'), ylabel('PA signal (V)');
    xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
    hold on
    plot(last_pa_signal.data(:,1),last_pa_signal.data(:,2),'b');
    subplot(2,1,2),plot(first_pa_signal.data(:,1),first_pa_filtered_signal,'r')
    hold on
    plot(last_pa_signal.data(:,1),last_pa_filtered_signal,'b')
    set(gca,'FontSize',16);
    xlabel('Time (seconds)'), ylabel('PA signal (V)');
    xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
    
    data_start_h = datacursormode;
    set(data_start_h,'DisplayStyle','datatip','SnapToData','off');
    while repeat_click1 ~=1
        disp('Please click on the figure your first time gate location');
        repeat_click1 = ask_yes_no_question('Are you happy with this location for the time gate?');
        data_start_val = getCursorInfo(data_start_h);
        first_time_gate_index = data_start_val.DataIndex;
        disp(['you chosen the start index as: ',num2str(first_time_gate_index)]);
    end
    while repeat_click2 ~=1
        disp('Please click on the figure your last time gate location');
        repeat_click2 = ask_yes_no_question('Are you happy with this location for the time gate?');
        data_end_val = getCursorInfo(data_start_h);
        last_time_gate_index = data_end_val.DataIndex;
        disp(['you chose the end index as: ',num2str(last_time_gate_index)]);
    end
    
    %display the gate info on a figure and re-check user happy with gate
    figure(1),
    subplot(2,1,1),plot(first_pa_signal.data(:,1),first_pa_signal.data(:,2),'r');
    set(gca,'FontSize',16);
    xlabel('time (seconds)'), ylabel('PA signal (V)');
    xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
    hold on
    plot(last_pa_signal.data(:,1),last_pa_signal.data(:,2),'b');
    hold on, plot([first_pa_signal.data(first_time_gate_index,1) first_pa_signal.data(first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'r--');
    hold on, plot([first_pa_signal.data(last_time_gate_index,1) first_pa_signal.data(last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'r--');
    subplot(2,1,2),plot(first_pa_signal.data(:,1),first_pa_filtered_signal,'r')
    hold on
    plot(last_pa_signal.data(:,1),last_pa_filtered_signal,'b')
    hold on, plot([first_pa_signal.data(first_time_gate_index,1) first_pa_signal.data(first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'r--');
    hold on, plot([first_pa_signal.data(last_time_gate_index,1) first_pa_signal.data(last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'r--');
    set(gca,'FontSize',16);
    xlabel('Time (seconds)'), ylabel('PA signal (V)');
    xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
    saveas(gcf, [processed_results_folder,'PA_signal_with_gate_times_used'],'png');
    
    repeat_all_clicks = ask_yes_no_question('Are you happy with these locations (red dotted lines) for the time gates?');
end

%let user specify start and end times

%pa signal variables:
pa_sig_start_index = first_time_gate_index;
pa_sig_end_index = last_time_gate_index;
% pa_sig_start_index = 33000;
% pa_sig_end_index = 38000;



for folder_num = 1:num_subfolders
    disp(['Analysing folder ',num2str(folder_num),' of ',num2str(num_subfolders)]);
    subdir_name = cell2mat(pathnames_list(folder_num));
    
    %load heating over time in an ROI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data_directory = [thermal_cam_folder, subdir_name,'\'];
    output_directory = [processed_results_folder, subdir_name,'\'];
    %create the subfolder in the output directory
    [mkdir_success,mkdir_message,mkdir_messageid] = mkdir(processed_results_folder, cell2mat(pathnames_list(folder_num)));
    if mkdir_success ==0
        disp(['an error occurred when creating directory:', processed_results_folder, cell2mat(pathnames_list(folder_num))])
        return
    elseif mkdir_success ==1
        disp(['created directory:', processed_results_folder, cell2mat(pathnames_list(folder_num))])
    else
        disp(['Something strange happened when creating directory (', processed_results_folder, cell2mat(pathnames_list(folder_num)),') now quitting...'])
        return
    end
    Ir_cam_load_and_extract_data;
    %plot heating over time in an ROI
    Ir_cam_plot_data;
    
    
    
    %load PA signal over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %loop over all data
    i=1;
    num_files = filenumber_end-filenumber_begin+1;
    txtprogressbar;% Set starting time
    for filenum = filenumber_begin:filenumber_end
        pa_signal = importdata([pa_signal_folder,subdir_name,'\',pa_signal_name_start,num2zeros_n_nums(filenum,5),'.txt'],',',5);
        pa_sig_sum(i) = sum(abs(pa_signal.data(pa_sig_start_index:pa_sig_end_index,2)));

        filtered_signal = low_pass_filter(pa_signal.data(:,1),pa_signal.data(:,2),low_pass_filter_cutoff_freq);
        pa_sig_filtered_sum(i) = sum(abs(filtered_signal(pa_sig_start_index:pa_sig_end_index)));
   
        i=i+1;
        %         figure(1);
        %         plot(pa_signal.data(pa_sig_start_index:pa_sig_end_index,2));
        txtprogressbar(filenum/num_files); % Update text
    end
    
    
    %plot the first and last signal with the gates used
    current_first_pa_signal = importdata([pa_signal_folder,subdir_name,'\',pa_signal_name_start,num2zeros_n_nums(filenumber_begin,5),'.txt'],',',5);
    current_last_pa_signal = importdata([pa_signal_folder,subdir_name,'\',pa_signal_name_start,num2zeros_n_nums(filenumber_end,5),'.txt'],',',5);
    
    current_first_pa_filtered_signal = low_pass_filter(current_first_pa_signal.data(:,1),current_first_pa_signal.data(:,2),low_pass_filter_cutoff_freq);
    current_last_pa_filtered_signal = low_pass_filter(current_last_pa_signal.data(:,1),current_last_pa_signal.data(:,2),low_pass_filter_cutoff_freq);
    
    
    figure;
    plot(current_first_pa_signal.data(:,1),current_first_pa_signal.data(:,2),'r');
    hold on
    plot(current_last_pa_signal.data(:,1),current_last_pa_signal.data(:,2),'b');
    legend
    hold on, plot([current_first_pa_signal.data(first_time_gate_index,1) current_first_pa_signal.data(first_time_gate_index,1)],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--');
    hold on, plot([current_first_pa_signal.data(last_time_gate_index,1) current_first_pa_signal.data(last_time_gate_index,1)],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--');
    set(gca,'FontSize',16);
    xlabel('Time (seconds)'), ylabel('PA signal (V)');
    xlim([min(current_first_pa_signal.data(:,1)), max(current_first_pa_signal.data(:,1))]);
    legend('First signal','Last signal', 'Location', 'SouthWest');
    saveas(gcf, [output_directory,'PA_signal_first_and_last_with_gate_times_used'],'png');
    
    figure;
    plot(current_first_pa_signal.data(:,1),current_first_pa_filtered_signal,'r');
    hold on
    plot(current_last_pa_signal.data(:,1),current_last_pa_filtered_signal,'b');
    legend
    hold on, plot([current_first_pa_signal.data(first_time_gate_index,1) current_first_pa_signal.data(first_time_gate_index,1)],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--');
    hold on, plot([current_first_pa_signal.data(last_time_gate_index,1) current_first_pa_signal.data(last_time_gate_index,1)],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--');
    set(gca,'FontSize',16);
    xlabel('Time (seconds)'), ylabel('PA signal (V)');
    xlim([min(current_first_pa_signal.data(:,1)), max(current_first_pa_signal.data(:,1))]);
    legend('First signal','Last signal', 'Location', 'SouthWest');
    saveas(gcf, [output_directory,'PA_filtered_signal_first_and_last_with_gate_times_used'],'png');
    
    figure;
    plot(pa_sig_sum);
    set(gca,'FontSize',16);
    ylabel('Photoacoustic signal sum (V)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum'],'png');
    
    
    figure;
    plot(pa_sig_filtered_sum);
    set(gca,'FontSize',16);
    ylabel('Photoacoustic signal sum (V)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_filtered_sum'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_filtered_sum'],'png');
    
    
    %load PA laser energy over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    laser_energy_filename = 'laser_energy.txt';
    laser_energy = importdata([laser_folder,subdir_name,'\',laser_energy_filename]);
    cropped_laser_energy = laser_energy(filenumber_begin:filenumber_end);
    
    %plot laser energy
    figure;
    plot(cropped_laser_energy*1000);
    set(gca,'FontSize',16);
    ylabel('Laser energy (mJ)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'Laser_energy_over_time'],'png');
    saveas(gcf, [summary_full_path,'_Laser_energy_over_time'],'png');
    
    
    %calculate normalised pa sum:
    pa_sig_sum_norm_to_laser_energy = pa_sig_sum./cropped_laser_energy';
    figure;
    plot(pa_sig_sum_norm_to_laser_energy);
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum_norm'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum_norm'],'png');
    
    %plot thermal heating vs norm pa sig sum
    figure;
    plot(temp_rise_due_to_laser_abs,pa_sig_sum_norm_to_laser_energy,'r+');
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Temperature rise due to laser (K)');
    saveas(gcf, [output_directory,'Temp_vs_PA_sig_sum_norm'],'png');
    saveas(gcf, [summary_full_path,'_Temp_vs_PA_sig_sum_norm'],'png');
    
end





%plot data
%plot heating over time in an ROI --done
%plot PA signal over time -- done
%plot PA laser energy over time --done
%plot PA signal normalised to PA laser energy over time --done
%plot PA signal normalised to PA laser energy vs heating (for corresponding
%time point) --done




%save all variables in mat file
save([processed_results_folder,'all_variables']);
