summary_full_path = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\Processed_all_results\Key_results_no_legends\combined\first_run\';

bottom_sig_path = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\Processed_all_results\ROI_13_Gate_13_bottom_of_sample\all_variables.mat';

top_sig_path = 'I:\Data\PA_exp_with_heating_GNRS_5th_dec_13\Processed_all_results\ROI_14_Gate_14_top_of_sample\all_variables.mat';

line_style_array = [':';'-';':';'-';':';'-';':';'-'];
line_colour_array = ['r';'r';'b';'b';'g';'g';'k';'k'];

bottom_sig = load(bottom_sig_path);
top_sig = load(top_sig_path);


combined_sig_vals = bottom_sig.all_pa_filtered_sig_sum_backgnrd_subtr_norm_to_laser_energy + top_sig.all_pa_filtered_sig_sum_backgnrd_subtr_norm_to_laser_energy;
combined_av_sig_vals = combined_sig_vals/2;

figure;
npfsa_h = plot(bottom_sig.all_pa_filtered_sig_sum_backgnrd_subtr_norm_to_laser_energy);
for line_num = 1:size(npfsa_h,1)
    set(npfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
ylim([0 0.2]);



figure;
npfsa_h = plot(combined_av_sig_vals);
for line_num = 1:size(npfsa_h,1)
    set(npfsa_h(line_num),'LineStyle',line_style_array(line_num,:));
    set(npfsa_h(line_num),'Color',line_colour_array(line_num,:));
    set(npfsa_h(line_num),'LineWidth',2);
end
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
ylim([0 0.2]);
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined'],'png');


%try to combined when all CW laser is on
%and all when CW laser is off
combined_0W_sigs = zeros(size(combined_av_sig_vals,1),1);
combined_7W_sigs = zeros(size(combined_av_sig_vals,1),1);
for comb_loop = 1: size(combined_av_sig_vals,2)
    current_dataset = combined_av_sig_vals(:,comb_loop);
    if mod(comb_loop,2)==0
        combined_7W_sigs = current_dataset +combined_7W_sigs;
    end
    if mod(comb_loop,2)~=0
        combined_0W_sigs = current_dataset +combined_0W_sigs;
    end
end

figure;
cnpfsa_0W_h = plot(combined_0W_sigs/3);
set(cnpfsa_0W_h,'LineStyle','-');
set(cnpfsa_0W_h,'Color','b');
set(cnpfsa_0W_h,'LineWidth',2);
hold on
cnpfsa_7W_h = plot(combined_7W_sigs/3);
set(cnpfsa_7W_h,'LineStyle','-');
set(cnpfsa_7W_h,'Color','r');
set(cnpfsa_7W_h,'LineWidth',2);

set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W'],'png');


%now include error bars on the plot:
%calculate std for each time point
all_0W_sigs = zeros(size(combined_av_sig_vals,1),1);
all_7W_sigs = zeros(size(combined_av_sig_vals,1),1);
i=0;
j=0;
for comb_loop = 1: size(combined_av_sig_vals,2)
    current_dataset = combined_av_sig_vals(:,comb_loop);
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


figure;
mcnpfsa_0W_h = errorbar(mean_0W_sigs,std_0W_sigs);
set(mcnpfsa_0W_h,'LineStyle',':');
set(mcnpfsa_0W_h,'Color','b');
set(mcnpfsa_0W_h,'LineWidth',2);
hold on
mcnpfsa_7W_h = errorbar(mean_7W_sigs,std_7W_sigs);
set(mcnpfsa_7W_h,'LineStyle',':');
set(mcnpfsa_7W_h,'Color','r');
set(mcnpfsa_7W_h,'LineWidth',2);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_errors'],'png');

%standarddeviation
figure;
mcnpfsa_0W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_0W_sigs,std_0W_sigs,{'-b','LineWidth',2},1);
hold on
mcnpfsa_7W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_7W_sigs,std_7W_sigs,{'-r','LineWidth',2},1);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_stdev'],'png');

%standard error
%using the std of the spread of mean of the top and bottom of the samples
figure;
mcnpfsaserr_0W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_0W_sigs,std_0W_sigs/sqrt(3),{'-b','LineWidth',2},1);
hold on
mcnpfsaserr_7W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_7W_sigs,std_7W_sigs/sqrt(3),{'-r','LineWidth',2},1);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_standerr'],'png');

%different colors
%standard error
%using the std of the spread of mean of the top and bottom of the samples
figure;
mcnpfsaserr_0W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_0W_sigs,std_0W_sigs/sqrt(3),{'-y','LineWidth',2},1);
hold on
mcnpfsaserr_7W_h = shadedErrorBar(0:(length(mean_0W_sigs)-1),mean_7W_sigs,std_7W_sigs/sqrt(3),{'-k','LineWidth',2},1);
xlim([0 300])
set(gca,'FontSize',16);
ylabel('Normalised photoacoustic signal sum (arb)');
xlabel('Time elapsed (seconds)');
saveas(gcf, [summary_full_path,'All_PA_filtered_sig_sum_bkgnd_subtr_norm_combined_0W_7W_standerr_diff_colour'],'png');



%filtered and non filtered signal examples with both top and bottom signal
%sets
figure;
plot(bottom_sig.current_first_pa_signal.data(:,1)*1000000,bottom_sig.current_first_pa_signal.data(:,2),'r');
hold on
plot(bottom_sig.current_last_pa_signal.data(:,1)*1000000,bottom_sig.current_last_pa_signal.data(:,2),'b');
%legend
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(bottom_sig.current_first_pa_signal.data(:,1))*1000000, max(bottom_sig.current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_signal_first_and_last_with_both_gate_times_used_milli'],'png');



%filtered and non filtered signal examples with both top and bottom signal
%sets
figure;
plot(bottom_sig.current_first_pa_signal.data(:,1)*1000000,bottom_sig.current_first_pa_filtered_signal,'r');
hold on
plot(bottom_sig.current_last_pa_signal.data(:,1)*1000000,bottom_sig.current_last_pa_filtered_signal,'b');
%legend
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(bottom_sig.current_first_pa_signal.data(:,1))*1000000, max(bottom_sig.current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_filtered_signal_first_and_last_with_both_gate_times_used_milli'],'png');






%Same plots but just Showing just one signal
figure;
plot(bottom_sig.current_first_pa_signal.data(:,1)*1000000,bottom_sig.current_first_pa_signal.data(:,2),'b');
%legend
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(bottom_sig.current_first_pa_signal.data(:,1))*1000000, max(bottom_sig.current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_signal_first_with_both_gate_times_used_milli'],'png');

%filtered and non filtered signal examples with both top and bottom signal
%sets
figure;
plot(bottom_sig.current_first_pa_signal.data(:,1)*1000000,bottom_sig.current_first_pa_filtered_signal,'b');
%legend
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000 bottom_sig.current_first_pa_signal.data(bottom_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], '--', 'Color',[0.5 0.5 0.5],'LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000 top_sig.current_first_pa_signal.data(top_sig.last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'k--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_first_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
hold on, plot([bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000 bottom_sig.first_pa_signal.data(bottom_sig.backgrnd_last_time_gate_index,1)*1000000],[min(bottom_sig.current_first_pa_signal.data(:,2)), max(bottom_sig.current_first_pa_signal.data(:,2))], 'm--','LineWidth',2);
set(gca,'FontSize',16);
xlabel('Time (milliseconds)'), ylabel('PA signal (V)');
xlim([min(bottom_sig.current_first_pa_signal.data(:,1))*1000000, max(bottom_sig.current_first_pa_signal.data(:,1))*1000000]);
ylim([-0.015 0.015]);
saveas(gcf, [summary_full_path,'PA_filtered_signal_first_with_both_gate_times_used_milli'],'png');

