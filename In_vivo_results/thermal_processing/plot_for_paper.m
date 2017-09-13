load('C:\David\Papers\GNR_reshaping_paper\in_vivo_results_from_Mohan_and_Eli\Mouse24_output\in_vivo_24_all_variables.mat');

laser_off_time = 180;%seconds
figure(7)
plot(time_elapsed,temp_rise_due_to_laser_abs,'LineWidth',3);
set(gca,'FontSize',16);
ylabel('Temperature rise (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
axis_data = get(gca);
y_max = axis_data.YLim(2);
hold on, plot([laser_off_time,laser_off_time],[0,y_max-0.001*y_max],'k--','LineWidth',3);
saveas(gcf, 'Paper_temp_rise_due_to_laser_abs','fig');
saveas(gcf, 'Paper_temp_rise_due_to_laser_abs','png');