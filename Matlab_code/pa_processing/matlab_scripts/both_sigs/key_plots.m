%replot the key figures with thicker lines


line_style_cell_array = {':';'-';':';'-';':';'-';':';'-'};
line_style_array = [':';'-';':';'-';':';'-';':';'-'];
line_colour_array = ['r';'r';'b';'b';'g';'g';'k';'k'];


%plot PA laser energy over time --done
%plot laser energy
figure;
ale_h = plot(all_laser_energy*1000);
for line_num = 1:size(ale_h,1)
set(ale_h(line_num),'LineStyle',line_style_cell_array{line_num});
set(ale_h(line_num),'Color',line_colour_array(line_num,:));
set(ale_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Laser energy (mJ)');
xlabel('Time elapsed (seconds)');
ah1 = gca;
legend(ah1,ale_h(1:3),pathname_lengend(:,1:3)',1);
ah2=axes('position',get(gca,'position'), 'visible','off');
legend(ah2,ale_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_Laser_energy_over_time_thicklines'],'png');



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
ah1 = gca;
legend(ah1,npfsa_h(1:3),pathname_lengend(:,1:3)',1);
ah2=axes('position',get(gca,'position'), 'visible','off');
legend(ah2,npfsa_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
%legend(pathname_lengend','Location','NorthOutside');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm2_thickline'],'png');


%plot data
%plot heating over time in an ROI --done
figure;
atr_h = plot(all_time_elapsed,all_temp_rise_due_to_laser_abs);

for line_num = 1:size(atr_h,1)
set(atr_h(line_num),'LineStyle',line_style_array(line_num,:));
set(atr_h(line_num),'Color',line_colour_array(line_num,:));
set(atr_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Temperature rise (degrees C)');
xlabel('Time elapsed (seconds)');
xlim([0 time_elapsed(i-1)]);
ah1 = gca;
legend(ah1,atr_h(1:3),pathname_lengend(:,1:3)',1);
ah2=axes('position',get(gca,'position'), 'visible','off');
legend(ah2,atr_h(4:6),pathname_lengend(:,4:6)',2);
set(gca,'FontSize',16);
saveas(gcf, [summary_full_path,'All_temp_rise_thickline'],'png');


    figure;
    plot(current_first_pa_signal.data(:,1)*1000000,current_first_pa_signal.data(:,2),'r');
    hold on
    plot(current_last_pa_signal.data(:,1)*1000000,current_last_pa_signal.data(:,2),'b');
    legend
    hold on, plot([current_first_pa_signal.data(first_time_gate_index,1)*1000000 current_first_pa_signal.data(first_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--');
    hold on, plot([current_first_pa_signal.data(last_time_gate_index,1)*1000000 current_first_pa_signal.data(last_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'k--');
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'm--');
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000],[min(current_first_pa_signal.data(:,2)), max(current_first_pa_signal.data(:,2))], 'm--');    
    set(gca,'FontSize',16);
    xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
    xlim([min(current_first_pa_signal.data(:,1))*1000000, max(current_first_pa_signal.data(:,1))*1000000]);
    legend('First signal','Last signal', 'Location', 'SouthWest');
    saveas(gcf, [summary_full_path,'PA_signal_first_and_last_with_gate_times_used_milli'],'png');
    
    figure;
    plot(current_first_pa_signal.data(:,1)*1000000,current_first_pa_filtered_signal,'r');
    hold on
    plot(current_last_pa_signal.data(:,1)*1000000,current_last_pa_filtered_signal,'b');
    legend
    hold on, plot([current_first_pa_signal.data(first_time_gate_index,1)*1000000 current_first_pa_signal.data(first_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--');
    hold on, plot([current_first_pa_signal.data(last_time_gate_index,1)*1000000 current_first_pa_signal.data(last_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'k--');
    hold on, plot([first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_first_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'm--');
    hold on, plot([first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000 first_pa_signal.data(backgrnd_last_time_gate_index,1)*1000000],[min(current_first_pa_filtered_signal), max(current_first_pa_filtered_signal)], 'm--');
    set(gca,'FontSize',16);
    xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
    xlim([min(current_first_pa_signal.data(:,1))*1000000, max(current_first_pa_signal.data(:,1))*1000000]);
    legend('First signal','Last signal', 'Location', 'SouthWest');
    saveas(gcf, [summary_full_path,'PA_filtered_signal_first_and_last_with_gate_times_used_milli'],'png');
