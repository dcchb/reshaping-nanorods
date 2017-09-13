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
pa_sig_start_index = 33000; 
pa_sig_end_index = 38000;


%load in data
%set folders:
laser_folder = 'H:\Data\PA_monitoring_of_nanorod_heating\raw_data\laser_energies\';
pa_signal_folder = 'H:\Data\PA_monitoring_of_nanorod_heating\raw_data\PA_signals\';
thermal_cam_folder = 'H:\Data\PA_monitoring_of_nanorod_heating\raw_data\heating_cam_mat_files\';
processed_results_folder = 'H:\Data\PA_monitoring_of_nanorod_heating\processed_results\';



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
    pa_signal_name_start = 'C2pa_signal';
    num_files = filenumber_end-filenumber_begin+1;
    txtprogressbar;% Set starting time
    for filenum = filenumber_begin:filenumber_end
        pa_signal = importdata([pa_signal_folder,subdir_name,'\',pa_signal_name_start,num2zeros_n_nums(filenum,5),'.txt'],',',5);
        
        pa_sig_sum(i) = sum(abs(pa_signal.data(pa_sig_start_index:pa_sig_end_index,2)));
        i=i+1;
        %         figure(1);
        %         plot(pa_signal.data(pa_sig_start_index:pa_sig_end_index,2));
        txtprogressbar(filenum/num_files); % Update text
    end
    figure;
    plot(pa_sig_sum);
    set(gca,'FontSize',16);
    ylabel('Photoacoustic signal sum (V)');
    xlabel('Time elapsed (seconds)');
    saveas(gcf, [output_directory,'PA_sig_sum'],'png');
    saveas(gcf, [summary_full_path,'_PA_sig_sum'],'png');


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
%plot PA signal over time
%plot PA laser energy over time
%plot PA signal normalised to PA laser energy over time
%plot PA signal normalised to PA laser energy vs heating (for corresponding time point)




%save all variables in mat file
   % save([processed_results_folder,'all_variables']);
