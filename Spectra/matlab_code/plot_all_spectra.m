clear all, close all, clc;

%define variables:
n_header_lines = 88;
%extension_string_length = 4;%including the '.' (eg .txt =4)
extension_string_length = 11;%including the '.' (eg .txt =4)


%get data paths:
initial_folder = pwd;
pathname =  uigetdir(initial_folder, 'Choose your Data Directory');
pathname = [pathname,'\'];

save_pathname =  uigetdir(initial_folder, 'Choose your Save Directory');
save_pathname = [save_pathname,'\'];

filenames = ls(pathname);
filenames = filenames(3:end,:);
num_files = size(filenames,1);

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

% wav_min = min(sample_spectrum.data(:,1));%400;%nm
% wav_max = max(sample_spectrum.data(:,1));%890;%nm
wav_min = 400;%400;%nm
wav_max = 1100;%890;%nm


% wav_min = 650;%400;%nm
% wav_max = 660;%890;%nm


figure(1)
line_h = plot(sample_spectrum.data(:,1),sample_spectrum.data(:,2));
%xlim([min(sample_spectrum.data(:,1)), max(sample_spectrum.data(:,1))]);
xlim([wav_min, wav_max])
set(gca,'FontSize',16);
set(line_h,'LineWidth',3);
%title('Sample spectrum');
xlabel('Wavelength (nm)');
ylabel('Absorbance');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'fig');
saveas(gcf,save_full_path(1:(end-extension_string_length)),'png');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'bmp');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'jpg');

end