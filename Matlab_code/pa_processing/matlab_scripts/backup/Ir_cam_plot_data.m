
%plot the data
figure(2)
errorbar(time_elapsed,(roi_pix_mean-272.15),roi_pix_std);
set(gca,'FontSize',16);
ylabel('Temperature (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_roi_errorbars'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_errorbars'],'bmp');
saveas(gcf, [output_directory,batch_name,'_roi_errorbars'],'png');
%saveas(gcf, [output_directory,batch_name,'_roi_errorbars'],'jpg');


figure(3)
plot(time_elapsed,(roi_pix_mean-272.15));
set(gca,'FontSize',16);
ylabel('Temperature (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_roi_mean'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_mean'],'bmp');
saveas(gcf, [output_directory,batch_name,'_roi_mean'],'png');
%saveas(gcf, [output_directory,batch_name,'_roi_mean'],'jpg');

figure(4)
errorbar(time_elapsed,(background_roi_pix_mean-272.15),background_roi_pix_std);
set(gca,'FontSize',16);
ylabel('Temperature (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_roi_background_errorbars'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_background_errorbars'],'bmp');
saveas(gcf, [output_directory,batch_name,'_roi_background_errorbars'],'png');
%saveas(gcf, [output_directory,batch_name,'_roi_background_errorbars'],'jpg');

figure(5)
plot(time_elapsed,(background_roi_pix_mean-272.15));
set(gca,'FontSize',16);
ylabel('Temperature (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_roi_background_mean'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_background_mean'],'bmp');
saveas(gcf, [output_directory,batch_name,'_roi_background_mean'],'png');
%saveas(gcf, [output_directory,batch_name,'_roi_background_mean'],'jpg');

%Subtract the temp increase due to the background temp increase
background_mean_temp_increase = background_roi_pix_mean - background_roi_pix_mean(1);
background_subtracted_mean_temp = roi_pix_mean - background_mean_temp_increase;

temp_rise_due_to_laser_abs = background_subtracted_mean_temp - background_subtracted_mean_temp(1);

figure(6)
plot(time_elapsed,(background_subtracted_mean_temp-272.15));
set(gca,'FontSize',16);
ylabel('Temperature (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_roi_mean_background_subtracted'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_mean_background_subtracted'],'bmp');
saveas(gcf, [output_directory,batch_name,'_roi_mean_background_subtracted'],'png');

dir_num = folder_num;
summary_name = cell2mat(pathnames_list(dir_num));
summary_full_path = [summary_folder,summary_name];

figure(7)
plot(time_elapsed,temp_rise_due_to_laser_abs);
set(gca,'FontSize',16);
ylabel('Temperature rise (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
% xlim([0 i]);
saveas(gcf, [output_directory,batch_name,'_temp_rise_due_to_laser_abs'],'fig');
%saveas(gcf, [output_directory,batch_name,'_temp_rise_due_to_laser_abs'],'bmp');
saveas(gcf, [output_directory,batch_name,'_temp_rise_due_to_laser_abs'],'png');
saveas(gcf, [summary_full_path,'_temp_rise'],'png');



figure(8)
imagesc((current_dataset-272.15)),colormap(gray),colorbar, axis off;
%draw sample roi rectangle on the image in red
rectangle('Position', roi_rectangle, 'EdgeColor','r');
%draw background roi rectangle on the image in blue
rectangle('Position', roi_background_rectangle, 'EdgeColor','b');
saveas(gcf, [output_directory,batch_name,'_roi_location'],'fig');
saveas(gcf, [output_directory,batch_name,'_roi_location'],'png');
saveas(gcf, [output_directory,batch_name,'_roi_location'],'jpg');
saveas(gcf, [summary_full_path,'_roi_location'],'png');