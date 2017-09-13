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
wavelength = sample_spectrum.data(1:(end-40),1);
absorbance(:,i) = sample_spectrum.data(1:(end-40),2);
norm_absorbance(:,i) = sample_spectrum.data(1:(end-40),2)/max(sample_spectrum.data(1:(end-40),2));
i=i+1;


%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'jpg');

end

line_colour = ['r','b','k','g','m','y','c'];
figure(1)
for plot_num = 1:i-1
line_h = plot(wavelength,norm_absorbance(:,plot_num),line_colour(plot_num));
set(line_h,'LineWidth',2);
hold on;
%xlim([min(sample_spectrum.data(:,1)), max(sample_spectrum.data(:,1))]);
end
%xlim([wav_min, wav_max])
xlim([650, 850])
    
set(gca,'FontSize',16);
%set(line_h,'LineWidth',3);
%title('Sample spectrum');
xlabel('Wavelength (nm)');
ylabel('Normalised Absorbance');
%legend(strtrim(filenames(plot_num,:)),'Second','Third','Location','NorthEast');
legend('After1', 'After2','After3','Before1','Before2','Location','South');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'fig');
%saveas(gcf,save_full_path(1:(end-extension_string_length)),'png');
%saveas(gcf,sample_full_path(1:(end-extension_string_length)),'bmp');
saveas(gcf,[save_pathname,'All_spectra_zoom_normalised'],'png');