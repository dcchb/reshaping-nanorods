clear all, close all, clc;

%define variables:
n_header_lines = 88;
%extension_string_length = 4;%including the '.' (eg .txt =4)
extension_string_length = 11;%including the '.' (eg .txt =4)


%get data paths:
initial_folder = pwd;
%pathname =  uigetdir(initial_folder, 'Choose your Data Directory');
%pathname = [pathname,'\'];
pathname = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\spectra\raw_data\CTAB_GNR_Spectra_before_and_after_laser_with_PA_monitoring\';

%save_pathname =  uigetdir(initial_folder, 'Choose your Save Directory');
%save_pathname = [save_pathname,'\'];
save_pathname = 'C:\David\Data\PA_exp_with_heating_GNRS_5th_dec_13\spectra\for_paper\output4\';

filenames = ls(pathname);
filenames = filenames(3:end,:);
num_files = size(filenames,1);
i=1;
for file_num = 1:num_files
    %specify full path
    current_filename = strtrim(filenames(file_num,:));
    sample_full_path = [pathname,current_filename];
    save_full_path = [save_pathname,current_filename];



%[sample_filename, sample_pathname, sample_filterindex] = uigetfile({'*.txt;*.ProcSpec', 'All spectrum files(*.txt, *.ProcSpec)'; '*.*', 'All files (*.*)'}, 'Pick a spectrum file for your sample', 'MultiSelect', 'on');
%sample_full_path = [sample_pathname,sample_filename];

[sample_spectrum, sample_delim, sample_nhlines] = importdata(sample_full_path, '\t', n_header_lines);
%spectrum in: sample_spectrum.data;
% [ref_spectrum, ref_delim, ref_nhlines] = importdata(ref_full_path, '\t');
% %spectrum in: ref_spectrum.data;

wav_min = min(sample_spectrum.data(:,1));%400;%nm
wav_max = max(sample_spectrum.data(:,1));%890;%nm

% wav_min = 650;%400;%nm
% wav_max = 660;%890;%nm
wavelength = sample_spectrum.data(:,1);
absorbance(:,i) = sample_spectrum.data(:,2);
i=i+1;


%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'jpg');

end

%line_colour = ['-m';'-r';':r';'-b';':b';'-g';':g';'-r';'-k';'-k';'-g';'-m';'-y';'-c';'-r';'-b';'-k';'-g';'-m';'-y';'-c'];
line_colour = ['r';'m';'r';'r';'b';'b';'b';'g';'g';'g';'k';'k';'k';'k';'k';'k';'k';'k';'k';'k';'k';'k';'k';'k'];
%line_style_cells = {'-.','-','-',':','-.','-',':','-.','-',':','-.','-',':','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o'};
line_style_cells = {'--','-','-',':','--','-',':','--','-',':','--','-',':','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o'};
%line_style = ['-.',':','-',':','-',':','-','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o','o'];
sample_num_array = [4,1,3,2,7,5,6,10,8,9];
spectrum_fig = figure(1);
for sample_i = 1:i-1
    plot_num = sample_num_array(sample_i);
    line_h = plot(wavelength,absorbance(:,plot_num),line_colour(plot_num,:));
    set(line_h,'LineWidth',4);
    set(line_h,'LineStyle',line_style_cells{plot_num});
    hold on;
    %xlim([min(sample_spectrum.data(:,1)), max(sample_spectrum.data(:,1))]);
end
%laser_line_h = plot(808:808,0:0.01:max(absorbance(:)),'LineWidth',3);
laser_line_h = line([808 808],[0 max(absorbance(:))]);
set(laser_line_h,'LineWidth',3);
set(laser_line_h,'LineStyle','--');
set(laser_line_h,'Color','k');
%xlim([wav_min, wav_max])
xlim([400, 1100])
    
set(gca,'FontSize',16);
%set(line_h,'LineWidth',3);
%title('Sample spectrum');
xlabel('Wavelength (nm)');
ylabel('Absorbance');
legend('\alpha pre-laser','\alpha after PA laser','\alpha after CW laser','\alpha after CW laser 2x fluence','\beta pre-laser','\beta after PA laser','\beta after CW laser','\gamma pre-laser','\gamma after PA laser','\gamma after CW laser','Location','NorthEastOutside');
% legend('After1', 'After2','After3','Before1','Before2','Location','South');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'fig');
%saveas(gcf,save_full_path(1:(end-extension_string_length)),'png');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'bmp');
saveas(gcf,[save_pathname,'All_spectra_with_laser_line'],'png');
set(spectrum_fig, 'PaperPositionMode','auto')     %# WYSIWYG
print(spectrum_fig, '-dpng', [save_pathname,'All_spectra_with_laser_line6'])
%saveas(gcf,[save_pathname,'All_spectra_with_laser_line2'],'png');