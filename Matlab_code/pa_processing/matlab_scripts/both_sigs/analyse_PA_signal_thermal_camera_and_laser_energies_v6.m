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
laser_folder = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\CTAB_samples\laser_energy\';
pa_signal_folder = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\pasig_51213\CTAB_samples\';
thermal_cam_folder = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\CTAB_samples\Thermal_images_matlab\';
processed_results_folder = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\Processed_all_results\ROI_19_Gate_19\';

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
    repeat_click3 = 0;
    repeat_click4 = 0;
    repeat_click5 = 0;
    repeat_click6 = 0;
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
    %set(data_start_h,'DisplayStyle','datatip','SnapToData','off');%stopped
    %working in matlab 2014b
    set(data_start_h,'DisplayStyle','datatip','SnapToDataVertex','off');

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
        if last_time_gate_index == first_time_gate_index
            repeat_click2=0;
            disp('You selected the same point as last time please choose again!');
        end
    end
    
    while repeat_click3 ~=1
        disp('Please click on the figure your first time gate location');
        repeat_click3 = ask_yes_no_question('Are you happy with this location for the time gate?');
        data_start_val2 = getCursorInfo(data_start_h);
        first_time_gate_index2 = data_start_val2.DataIndex;
        disp(['you chosen the start index as: ',num2str(first_time_gate_index2)]);
    end
    while repeat_click4 ~=1
        disp('Please click on the figure your last time gate location');
        repeat_click4 = ask_yes_no_question('Are you happy with this location for the time gate?');
        data_end_val2 = getCursorInfo(data_start_h);
        last_time_gate_index2 = data_end_val2.DataIndex;
        disp(['you chose the end index as: ',num2str(last_time_gate_index2)]);
        if last_time_gate_index2 == first_time_gate_index2
            repeat_click4=0;
            disp('You selected the same point as last time please choose again!');
        end
    end
    
    while repeat_click5 ~=1
        disp('Please click on the figure your first background time gate location');
        repeat_click5 = ask_yes_no_question('Are you happy with this location for the time gate?');
        backgrnd_start_val = getCursorInfo(data_start_h);
        backgrnd_first_time_gate_index = backgrnd_start_val.DataIndex;
        disp(['you chosen the background start index as: ',num2str(backgrnd_first_time_gate_index)]);
    end
    while repeat_click6 ~=1
        disp('Please click on the figure your last background time gate location');
        repeat_click6 = ask_yes_no_question('Are you happy with this location for the time gate?');
        backgrnd_end_val = getCursorInfo(data_start_h);
        backgrnd_last_time_gate_index = backgrnd_end_val.DataIndex;
        disp(['you chose the background end index as: ',num2str(backgrnd_last_time_gate_index)]);
        if backgrnd_last_time_gate_index == backgrnd_first_time_gate_index
            repeat_click6=0;
            disp('You selected the same point as last time please choose again!');
        end
    end
    
    %make sure gates are the right way around:
    if last_time_gate_index < first_time_gate_index
        tmp = first_time_gate_index;
        first_time_gate_index = last_time_gate_index;
        last_time_gate_index = tmp;
    end
    if last_time_gate_index2 < first_time_gate_index2
        tmp = first_time_gate_index2;
        first_time_gate_index2 = last_time_gate_index2;
        last_time_gate_index2 = tmp;
    end
    if backgrnd_last_time_gate_index < backgrnd_first_time_gate_index
        tmp = backgrnd_first_time_gate_index;
        backgrnd_first_time_gate_index = backgrnd_last_time_gate_index;
        backgrnd_last_time_gate_index = tmp;
    end
    
    %display the gate info on a figure and re-check user happy with gate
    figure(1),
    subplot(2,1,1),plot(first_pa_signal.data(:,1),first_pa_signal.data(:,2),'r');
    set(gca,'FontSize',16);
    xlabel('time (seconds)'), ylabel('PA signal (V)');
    xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
    hold on
    plot(last_pa_signal.data(:,1),last_pa_signal.data(:,2),'b');
    hold on, plot([first_pa_signal.data(first_time_gate_index,1) first_pa_signal.data(first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
    hold on, plot([first_pa_signal.data(last_time_gate_index,1) first_pa_signal.data(last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
    hold on, plot([first_pa_signal.data(first_time_gate_index2,1) first_pa_signal.data(first_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
    hold on, plot([first_pa_signal.data(last_time_gate_index2,1) first_pa_signal.data(last_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1) first_pa_signal.data(backgrnd_first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1) first_pa_signal.data(backgrnd_last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
    
    subplot(2,1,2),plot(first_pa_signal.data(:,1),first_pa_filtered_signal,'r')
    hold on
    plot(last_pa_signal.data(:,1),last_pa_filtered_signal,'b')
    hold on, plot([first_pa_signal.data(first_time_gate_index,1) first_pa_signal.data(first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
    hold on, plot([first_pa_signal.data(last_time_gate_index,1) first_pa_signal.data(last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
    hold on, plot([first_pa_signal.data(first_time_gate_index2,1) first_pa_signal.data(first_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
    hold on, plot([first_pa_signal.data(last_time_gate_index2,1) first_pa_signal.data(last_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1) first_pa_signal.data(backgrnd_first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1) first_pa_signal.data(backgrnd_last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
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
    Ir_cam_load_and_extract_data_v2;
    %plot heating over time in an ROI
    Ir_cam_plot_data;
    
    all_time_elapsed(:,folder_num) = time_elapsed;
    all_sample_temps(:,folder_num) = roi_pix_mean;
    all_temp_rise_due_to_laser_abs(:,folder_num)= temp_rise_due_to_laser_abs;
    
    
    
    %load PA signal over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %loop over all data
    i=1;
    num_files = filenumber_end-filenumber_begin+1;
    txtprogressbar;% Set starting time
    for filenum = filenumber_begin:filenumber_end
        pa_signal = importdata([pa_signal_folder,subdir_name,'\',pa_signal_name_start,num2zeros_n_nums(filenum,5),'.txt'],',',5);
        pa_sig_sum(i) = sum(abs(pa_signal.data(pa_sig_start_index:pa_sig_end_index,2)));
        pa_sig_sum2(i) = sum(abs(pa_signal.data(first_time_gate_index2:last_time_gate_index2,2)));
        pa_backgnd_sig_sum(i) = sum(abs(pa_signal.data(backgrnd_first_time_gate_index:backgrnd_last_time_gate_index,2)));
        
        filtered_signal = low_pass_filter(pa_signal.data(:,1),pa_signal.data(:,2),low_pass_filter_cutoff_freq);
        pa_sig_filtered_sum(i) = sum(abs(filtered_signal(pa_sig_start_index:pa_sig_end_index)));
        pa_sig_filtered_sum2(i) = sum(abs(filtered_signal(first_time_gate_index2:last_time_gate_index2)));
        pa_backgnd_filtered_sig_sum(i) = sum(abs(filtered_signal(backgrnd_first_time_gate_index:backgrnd_last_time_gate_index)));
        
        i=i+1;
        txtprogressbar(filenum/num_files); % Update text
    end
    
    pa_sig_sum_per_sample = pa_sig_sum/(pa_sig_end_index-pa_sig_start_index);
    pa_sig_sum_per_sample2 = pa_sig_sum2/(last_time_gate_index2-first_time_gate_index2);
    
    pa_backgnd_sig_sum_per_sample = pa_backgnd_sig_sum/(backgrnd_last_time_gate_index-backgrnd_first_time_gate_index);
    pa_sig_sum_backgnrd_subtracted = pa_sig_sum_per_sample-pa_backgnd_sig_sum_per_sample;
    pa_sig_sum_backgnrd_subtracted2 = pa_sig_sum_per_sample2-pa_backgnd_sig_sum_per_sample;
    pa_sig_sum_backgnrd_subtracted_combined = pa_sig_sum_per_sample + pa_sig_sum_per_sample2 - (2*(pa_backgnd_sig_sum_per_sample));
    
    pa_filtered_sig_sum_per_sample = pa_sig_filtered_sum/(pa_sig_end_index-pa_sig_start_index);
    pa_filtered_sig_sum_per_sample2 = pa_sig_filtered_sum2/(last_time_gate_index2-first_time_gate_index2);
    
    pa_backgnd_filtered_sig_sum_per_sample = pa_backgnd_filtered_sig_sum/(backgrnd_last_time_gate_index-backgrnd_first_time_gate_index);
    pa_filtered_sig_sum_backgnrd_subtracted = pa_filtered_sig_sum_per_sample-pa_backgnd_filtered_sig_sum_per_sample;
    pa_filtered_sig_sum_backgnrd_subtracted2 = pa_filtered_sig_sum_per_sample2-pa_backgnd_filtered_sig_sum_per_sample;
    pa_filtered_sig_sum_backgnrd_subtracted_combined = pa_filtered_sig_sum_per_sample + pa_filtered_sig_sum_per_sample2 - (2*(pa_backgnd_filtered_sig_sum_per_sample));
    
    
    all_pa_filtered_sig_sum_backgnrd_subtracted(:,folder_num) = pa_filtered_sig_sum_backgnrd_subtracted;
    all_pa_filtered_sig_sum_backgnrd_subtracted2(:,folder_num) = pa_filtered_sig_sum_backgnrd_subtracted2;
    all_pa_filtered_sig_sum_backgnrd_subtracted_combined(:,folder_num) = pa_filtered_sig_sum_backgnrd_subtracted_combined;
    
    
    all_pa_sig_sum_backgnrd_subtracted(:,folder_num) = pa_sig_sum_backgnrd_subtracted;
    all_pa_sig_sum_backgnrd_subtracted2(:,folder_num) = pa_sig_sum_backgnrd_subtracted2;
    all_pa_sig_sum_backgnrd_subtracted_combined(:,folder_num) = pa_sig_sum_backgnrd_subtracted_combined;
    
    
    
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
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1) first_pa_signal.data(backgrnd_first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--');
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1) first_pa_signal.data(backgrnd_last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--');
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
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1) first_pa_signal.data(backgrnd_first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--');
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1) first_pa_signal.data(backgrnd_last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--');
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
    
    
    figure;
    plot(pa_sig_sum_per_sample, 'r')
    hold on
    plot(pa_backgnd_sig_sum_per_sample, 'b')
    hold on
    plot(pa_sig_sum_backgnrd_subtracted, 'k')
    set(gca,'FontSize',16);
    legend('Sig. sum','Bgrnd sig. sum', 'Sig. - Bgrnd sum', 'Location', 'NorthOutside');
    ylabel('Photoacoustic signal sum per sample (V)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum_av'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum_av'],'png');
    
    figure;
    plot(pa_filtered_sig_sum_per_sample, 'r')
    hold on
    plot(pa_backgnd_filtered_sig_sum_per_sample, 'b')
    hold on
    plot(pa_filtered_sig_sum_backgnrd_subtracted, 'k')
    set(gca,'FontSize',16);
    legend('Sig. sum','Bgrnd sig. sum', 'Sig. - Bgrnd sum', 'Location', 'NorthOutside');
    ylabel('Photoacoustic signal sum per sample (V)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_filtered_sig_sum_av'],'png');
    saveas(gcf, [summary_full_path,'_PA_filtered_sig_sum_av'],'png');
    
    
    %load PA laser energy over time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    laser_energy_filename = 'laser_energy.txt';
    laser_energy = importdata([laser_folder,subdir_name,'\',laser_energy_filename]);
    cropped_laser_energy = laser_energy(filenumber_begin:filenumber_end);
    all_laser_energy(:,folder_num) = cropped_laser_energy;
    
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
    
    pa_filtered_sig_sum_backgnrd_subtracted_norm_to_laser_energy = pa_filtered_sig_sum_backgnrd_subtracted./cropped_laser_energy';
    pa_sig_sum_backgnrd_subtracted_norm_to_laser_energy = pa_sig_sum_backgnrd_subtracted./cropped_laser_energy';
    
    pa_filtered_sig_sum_backgnrd_subtracted_norm_to_laser_energy_cb = pa_filtered_sig_sum_backgnrd_subtracted_combined./cropped_laser_energy';
    pa_sig_sum_backgnrd_subtracted_norm_to_laser_energy_cb = pa_sig_sum_backgnrd_subtracted_combined./cropped_laser_energy';
    
    all_pa_filtered_sig_sum_backgnrd_subtr_norm_to_laser_energy(:,folder_num) = pa_filtered_sig_sum_backgnrd_subtracted_norm_to_laser_energy;
    all_pa_sig_sum_backgnrd_subtr_norm_to_laser_energy(:,folder_num) = pa_sig_sum_backgnrd_subtracted_norm_to_laser_energy;
    
    all_pa_filtered_sig_sum_backstr_norm_to_laser_energy_cb(:,folder_num) = pa_filtered_sig_sum_backgnrd_subtracted_norm_to_laser_energy_cb;
    all_pa_sig_sum_backgnrd_subtr_norm_to_laser_energy_cb(:,folder_num) = pa_sig_sum_backgnrd_subtracted_norm_to_laser_energy_cb;
    
    figure;
    plot(pa_sig_sum_norm_to_laser_energy);
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum_norm'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum_norm'],'png');
    
    figure;
    plot(pa_sig_sum_backgnrd_subtracted_norm_to_laser_energy);
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum_bkgnd_subtr_norm'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum_bkgnd_subtr_norm'],'png');
    
    figure;
    plot(pa_filtered_sig_sum_backgnrd_subtracted_norm_to_laser_energy);
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_filtered_sig_sum_bkgnd_subtr_norm'],'png');
    saveas(gcf, [summary_full_path,'_PA_filtered_sig_sum_bkgnd_subtr_norm'],'png');
    
    
    %plot thermal heating vs norm pa sig sum
    figure;
    plot(temp_rise_due_to_laser_abs,pa_sig_sum_norm_to_laser_energy,'r+');
    set(gca,'FontSize',16);
    ylabel('Normalised photoacoustic signal sum (arb)');
    xlabel('Temperature rise due to laser (K)');
    saveas(gcf, [output_directory,'Temp_vs_PA_sig_sum_norm'],'png');
    saveas(gcf, [summary_full_path,'_Temp_vs_PA_sig_sum_norm'],'png');
    
end

%do grueneisen correction
pa_sigs_energy_corr = all_pa_filtered_sig_sum_backstr_norm_to_laser_energy_cb;
for sample_num = 1:size(all_temp_rise_due_to_laser_abs,2)
    temp_vals(:,sample_num) = all_temp_rise_due_to_laser_abs(:,sample_num)+all_sample_temps(1,sample_num);
end
%grueneisen_corr = 0.1125*(temp_vals-274.15) + 6.75;%got eq from reading graph in 'Photoacoustic temperature measurements for monitoring of thermal therapy' paper
%grueneisen_corr = 0.1125*(temp_vals-274.15);%got eq from reading graph in 'Photoacoustic temperature measurements for monitoring of thermal therapy' paper
%grueneisen_corr =5.926*all_temp_rise_due_to_laser_abs;% got from eq on grtaph in "Photoacoustic imaging and temperature measurement for photothermal cancer therapy" paper (at 8 deg sig change 35%) 1.35*PA sig = 8*Temp change, therefore PA_sig = (8/1.35)Temp_change, ie PA_sig = 5.926*Temp _change
grueneisen_corr =0.16875*all_temp_rise_due_to_laser_abs;% got from eq on grtaph in "Photoacoustic imaging and temperature measurement for photothermal cancer therapy" paper (at 8 deg sig change 35%) 1.35*PA sig = 8*Temp change, therefore PA_sig = (1.35/8)Temp_change, ie PA_sig = 0.16875*Temp _change


%PA_sigs_gruen_corrected =pa_sigs_energy_corr./grueneisen_corr;

PA_sigs_gruen_corrected =pa_sigs_energy_corr-(pa_sigs_energy_corr.*grueneisen_corr);


line_style_array = [':';'-';':';'-';':';'-';':';'-'];
line_colour_array = ['r';'r';'b';'b';'g';'g';'k';'k'];

figure;
grun_corr_h = plot(all_time_elapsed,grueneisen_corr);
for line_num = 1:size(grun_corr_h,1)
    set(grun_corr_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(grun_corr_h(line_num),'Color',line_colour_array(line_num,:));
    set(grun_corr_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Gruenisen correction (arb)');
xlabel('Time elapsed (seconds)');
xlim([0 max(all_time_elapsed(end,:))]);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_grun_corr'],'png');

figure;
tvals_h = plot(all_time_elapsed,temp_vals-274.15);
for line_num = 1:size(tvals_h,1)
    set(tvals_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(tvals_h(line_num),'Color',line_colour_array(line_num,:));
    set(tvals_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Temperature (C)');
xlabel('Time elapsed (seconds)');
xlim([0 max(all_time_elapsed(end,:))]);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_tempvals'],'png');

figure;
npfsa_h = plot(pa_sigs_energy_corr);
for line_num = 1:size(npfsa_h,1)
    set(npfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_pa_sigs_energy_corr'],'png');

figure;
npfsa_h = plot(PA_sigs_gruen_corrected);
for line_num = 1:size(npfsa_h,1)
    set(npfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_pa_sigs_energy_corr_grueneisen_corr'],'png');

%try to combined when all CW laser is on
%and all when CW laser is off
all_0W_sigs = zeros(size(pa_sigs_energy_corr,1),1);
all_7W_sigs = zeros(size(pa_sigs_energy_corr,1),1);
i=0;
j=0;
for comb_loop = 1: size(pa_sigs_energy_corr,2)
    current_dataset = pa_sigs_energy_corr(:,comb_loop);
    if mod(comb_loop,2)==0
        i=i+1;
        all_7W_sigs(:,i) = current_dataset;
    end
    if mod(comb_loop,2)~=0
        j=j+1;
        all_0W_sigs(:,j) = current_dataset;
    end
end

mean_0W_sigs = mean(all_0W_sigs,2);
mean_7W_sigs = mean(all_7W_sigs,2);
std_0W_sigs = std(all_0W_sigs,0,2);
std_7W_sigs = std(all_7W_sigs,0,2);

%*************************************************************
%standard error
%using the std of the spread of mean of the top and bottom of the samples
figure;
mcnpfsaserr_0W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_0W_sigs,std_0W_sigs/sqrt(3),{'-c','LineWidth',2},1);
hold on
mcnpfsaserr_7W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_7W_sigs,std_7W_sigs/sqrt(3),{'-k','LineWidth',2},1);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
%legend('PA laser','PA laser & CW laser','Location','NorthEastOutside');
legend([mcnpfsaserr_0W_h.mainLine,mcnpfsaserr_7W_h.mainLine],'PA laser','PA laser & CW laser');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_standerr_diff_colour'],'png');



all_0W_sigs_gruncorr = zeros(size(PA_sigs_gruen_corrected,1),1);
all_7W_sigs_gruncorr = zeros(size(PA_sigs_gruen_corrected,1),1);
i=0;
j=0;
for comb_loop = 1: size(PA_sigs_gruen_corrected,2)
    current_dataset = PA_sigs_gruen_corrected(:,comb_loop);
    if mod(comb_loop,2)==0
        i=i+1;
        all_7W_sigs_gruncorr(:,i) = current_dataset;
    end
    if mod(comb_loop,2)~=0
        j=j+1;
        all_0W_sigs_gruncorr(:,j) = current_dataset;
    end
end

mean_0W_sigs_gruncorr = mean(all_0W_sigs_gruncorr,2);
mean_7W_sigs_gruncorr = mean(all_7W_sigs_gruncorr,2);
std_0W_sigs_gruncorr = std(all_0W_sigs_gruncorr,0,2);
std_7W_sigs_gruncorr = std(all_7W_sigs_gruncorr,0,2);

%standard error
%using the std of the spread of mean of the top and bottom of the samples
figure;
mcnpfsaserr_0W_h = shadedErrorBar(0:(length(mean_0W_sigs_gruncorr)-1),mean_0W_sigs_gruncorr,std_0W_sigs_gruncorr/sqrt(3),{'-c','LineWidth',2},1);
hold on
mcnpfsaserr_7W_h = shadedErrorBar(0:(length(mean_0W_sigs_gruncorr)-1),mean_7W_sigs_gruncorr,std_7W_sigs_gruncorr/sqrt(3),{'-k','LineWidth',2},1);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_standerr_grun_corr'],'png');



str = strrep(pathnames_list, '_', ' ');
pat = '\s+';
pathnames_split = regexp(str, pat, 'split');

for subfolder_num = 1:num_subfolders
    pathname_lengend(:,subfolder_num) = [pathnames_split{subfolder_num}{2},' ',pathnames_split{subfolder_num}{4}];
end

line_style_array = [':';'-';':';'-';':';'-';':';'-'];
%line_style_array = ['--';'-';'--';'-';'--';'-';'--';'-'];
line_colour_array = ['r';'r';'b';'b';'g';'g';'k';'k'];

%*************************************************************
%plot data
%plot heating over time in an ROI --done
temp_rise_fig = figure;
atr_h = plot(all_time_elapsed,all_temp_rise_due_to_laser_abs);

for line_num = 1:size(atr_h,1)
    set(atr_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(atr_h(line_num),'Color',line_colour_array(line_num,:));
    set(atr_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Temperature rise (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 max(all_time_elapsed(end,:))]);%************************************************************************************
% ah1 = gca;
% legend(ah1,atr_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,atr_h(4:6),pathname_lengend(:,4:6)',2);
legend('\alpha during PA laser','\alpha during PA & CW laser','\beta during PA laser','\beta during PA & CW laser','\gamma during PA laser','\gamma during PA & CW laser','Location','NorthEastOutside');
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_temp_rise'],'png');
set(temp_rise_fig, 'PaperPositionMode','auto')     %# WYSIWYG
print(temp_rise_fig, '-dpng', [summary_full_path,'All_temp_rise_highres'])

%plot PA signal over time -- done
figure,
pfsa_h = plot(all_pa_filtered_sig_sum_backgnrd_subtracted);

for line_num = 1:size(pfsa_h,1)
    set(pfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(pfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(pfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
%legend('Sig. sum','Bgrnd sig. sum', 'Sig. - Bgrnd sum', 'Location', 'NorthOutside');
ylabel('Photoacoustic signal sum per sample (V)');
xlabel('Time elapsed (seconds)')
% ah1 = gca;
% legend(ah1,pfsa_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,pfsa_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_av'],'png');

figure;
psa_h = plot(all_pa_sig_sum_backgnrd_subtracted);
for line_num = 1:size(psa_h,1)
    set(psa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(psa_h(line_num),'Color',line_colour_array(line_num,:));
    set(psa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
%legend('Sig. sum','Bgrnd sig. sum', 'Sig. - Bgrnd sum', 'Location', 'NorthOutside');
ylabel('Photoacoustic signal sum per sample (V)');
xlabel('Time elapsed (seconds)')
% ah1 = gca;
% legend(ah1,psa_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,psa_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_PA_sig_sum_av'],'png');

figure;
npsa_h = plot(all_pa_sig_sum_backgnrd_subtr_norm_to_laser_energy);
for line_num = 1:size(npsa_h,1)
    set(npsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
% ah1 = gca;
% legend(ah1,npsa_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,npsa_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_PA_sig_sum_bkgnd_subtr_norm'],'png');

figure;
npfsa_h = plot(all_pa_filtered_sig_sum_backgnrd_subtr_norm_to_laser_energy);
for line_num = 1:size(npfsa_h,1)
    set(npfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
% ah1 = gca;
% legend(ah1,npfsa_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,npfsa_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
%legend(pathname_lengend','Location','NorthOutside');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm2'],'png');

%*************************************************************
%plot PA laser energy over time --done
%plot laser energy
energy_fig  = figure;
ale_h = plot(all_laser_energy*1000);
for line_num = 1:size(ale_h,1)
    set(ale_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(ale_h(line_num),'Color',line_colour_array(line_num,:));
    set(ale_h(line_num),'LineWidth',2);
    
end
set(gca,'FontSize',16);
ylabel('Laser energy (mJ)');
xlabel('Time elapsed (seconds)');
% ah1 = gca;
% legend(ah1,ale_h(1:3),pathname_lengend(:,1:3)',1);
% ah2=axes('position',get(gca,'position'), 'visible','off');
% legend(ah2,ale_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
legend('\alpha during PA laser','\alpha during PA & CW laser','\beta during PA laser','\beta during PA & CW laser','\gamma during PA laser','\gamma during PA & CW laser','Location','SouthEast');%,'Location','NorthEastOutside'
saveas(gcf, [summary_full_path,'All_Laser_energy_over_time'],'png');
set(energy_fig, 'PaperPositionMode','auto')     %# WYSIWYG
print(energy_fig, '-dpng', [summary_full_path,'All_Laser_energy_over_time_highres'])

%plot PA signal normalised to PA laser energy over time --done
%plot PA signal normalised to PA laser energy vs heating (for corresponding
%time point) --done




%save all variables in mat file
save([processed_results_folder,'all_variables']);




%All combined  key plots


%filtered and non filtered signal example with both top and bottom signal
%gates

figure;
plot(current_first_pa_signal.data(:,1)*1000000,current_first_pa_signal.data(:,2),'b');
% set(gca,'FontSize',16);
% xlabel('time (seconds)'), ylabel('PA signal (V)');
% xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
% hold on
% plot(last_pa_signal.data(:,1),last_pa_signal.data(:,2),'b');
hold on, plot([first_pa_signal.data(first_time_gate_index,1)*1000000 first_pa_signal.data(first_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([first_pa_signal.data(last_time_gate_index,1)*1000000 first_pa_signal.data(last_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([first_pa_signal.data(first_time_gate_index2,1)*1000000 first_pa_signal.data(first_time_gate_index2,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([first_pa_signal.data(last_time_gate_index2,1)*1000000 first_pa_signal.data(last_time_gate_index2,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(current_first_pa_signal.data(:,1))*1000000, max(current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_signal_first_with_both_gate_times_used_milli'],'png');

figure;
plot(current_first_pa_signal.data(:,1)*1000000,current_first_pa_filtered_signal,'b');
% hold on, plot([first_pa_signal.data(first_time_gate_index,1) first_pa_signal.data(first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
% hold on, plot([first_pa_signal.data(last_time_gate_index,1) first_pa_signal.data(last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'k--','LineWidth',2);
% hold on, plot([first_pa_signal.data(first_time_gate_index2,1) first_pa_signal.data(first_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
% hold on, plot([first_pa_signal.data(last_time_gate_index2,1) first_pa_signal.data(last_time_gate_index2,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
% hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1) first_pa_signal.data(backgrnd_first_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
% hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1) first_pa_signal.data(backgrnd_last_time_gate_index,1)],[min(first_pa_signal.data(:,2)), max(first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([first_pa_signal.data(first_time_gate_index,1)*1000000 first_pa_signal.data(first_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--','LineWidth',2);
hold on, plot([first_pa_signal.data(last_time_gate_index,1)*1000000 first_pa_signal.data(last_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--','LineWidth',2);
hold on, plot([first_pa_signal.data(first_time_gate_index2,1)*1000000 first_pa_signal.data(first_time_gate_index2,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([first_pa_signal.data(last_time_gate_index2,1)*1000000 first_pa_signal.data(last_time_gate_index2,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'm--','LineWidth',2);
hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'm--','LineWidth',2);
% set(gca,'FontSize',16);
% xlabel('Time (seconds)'), ylabel('PA signal (V)');
% xlim([min(first_pa_signal.data(:,1)), max(first_pa_signal.data(:,1))]);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(current_first_pa_signal.data(:,1))*1000000, max(current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_filtered_signal_first_with_both_gate_times_used_milli'],'png');





