%low_pass_filter
%
%takes a signal and removes high frequency components above a cutoff 
%frequncy using fft
%
%the time_series is the time axis usually signal(:,1) in the signal (with a
%unit of seconds)
%the signal is the amplitude over time axis, usually signal(:,2)
%the freq_cutoff_MHz is the cutoff frequncy in MHz of the filter, above
%which all frequncy components are set to 0 in the frequncy domain
%
%written by David Harris-Birtill
%on 30/01/2014

function sig_filtered = low_pass_filter(time_series, signal, freq_cutoff_MHz)
    
    number_of_samples = size(time_series,1);
    time_elapsed_in_one_signal = time_series(end,1)-time_series(1,1);
    sampling_frequency = number_of_samples/time_elapsed_in_one_signal;    
    fft_signal = fft(signal);
    
    %low pass filter settings:
    freq_cutoff = freq_cutoff_MHz*1000000;%20MHz
    freq_per_bin = sampling_frequency/number_of_samples;
    freq_cutoff_ind = round(freq_cutoff/freq_per_bin);
    start_filter_ind = freq_cutoff_ind;
    end_filter_ind = number_of_samples - freq_cutoff_ind;
    
    filtered_fft_signal = fft_signal;
    filtered_fft_signal(start_filter_ind:end_filter_ind) = 0;
    
    %final result
    sig_filtered = real(ifft(filtered_fft_signal));
    
%     %plots
%     
%     %plot input:
%     %signal
%     figure('Units','normalized','Position',[0 0 1 1])%this makes the figure fullscreen
%     subplot(2,1,1)
%     plot(time_series, signal,'b');
%     set(gca,'FontSize',16);
%     xlim([min(time_series), max(time_series)])
%     xlabel('Time (seconds)');
%     ylabel('Amplitude (V)')
%     title('Original signal')
%     subplot(2,1,2)
%     plot(time_series, sig_filtered,'r')
%     set(gca,'FontSize',16);
%     xlim([min(time_series), max(time_series)])
%     xlabel('Time (seconds)');
%     ylabel('Amplitude (V)')
%     title('Low pass filtered signal')
%     
%     %plot freq domain:
%     freq_domain_max_samples = number_of_samples/2;
%     freq_array = (sampling_frequency/(2*freq_domain_max_samples))*[0:(freq_domain_max_samples-1)];
%     fft_mag_signal = abs(fft_signal);
%     fft_mag_filtered_signal = abs(filtered_fft_signal);
%     
%     figure,
%     subplot(2,1,1)
%     plot(freq_array,fft_mag_signal(1:(end/2)));
%     set(gca,'FontSize',16);
%     xlabel('Frequncy  (Hz)');
%     ylabel('Magnitude (arb)');
%     title('Original Frequency spectrum');
%     subplot(2,1,2)
%     plot(freq_array,fft_mag_filtered_signal(1:(end/2)));
%     set(gca,'FontSize',16);
%     xlabel('Frequncy  (Hz)');
%     ylabel('Magnitude (arb)');
%     title('Filtered Frequency spectrum');