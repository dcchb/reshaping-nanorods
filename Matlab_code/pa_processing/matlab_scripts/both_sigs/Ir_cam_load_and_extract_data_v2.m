
%load in all files and extract relevant data ****************************
disp('Now analysing data...');
i=1;
for filenum = filenumber_begin:filenumber_end
   %specify the filename:
   if filenum <= 9999 
   current_filename = [initial_filename,num2zeros_n_nums(filenum,4)];
   current_full_path = [data_directory,current_filename,'.MAT'];
   elseif filenum > 9999 && filenum <= 99999
   current_filename = [initial_filename,num2zeros_n_nums(filenum,5)];
   current_full_path = [data_directory,current_filename,'.MAT'];
   else
      disp('something went wrong with your specified number of files'); 
      return
   end
   %Load in the data:
   current_dataset = loadStructFromFile(current_full_path,current_filename);
   
   %load_in_the time_info
   current_data_time = loadStructFromFile(current_full_path,[current_filename,'_DateTime']);
   data_time_seconds = current_data_time(1:6);
   data_time_seconds(6) = data_time_seconds(6) + (current_data_time(7)*0.001);
   data_time_accurate(:,i) = data_time_seconds;
   time_elapsed(i) = etime(data_time_seconds, data_time_accurate(:,1)');
   
   
   %extract out the data needed from the file
   %where roi_rectangle = [xmin ymin width height];
   roi_sample_image = current_dataset.*roi_sample_map;
   %make a list of all on zero values:
   roi_sample_value_array = roi_sample_image(:);
   roi_sample_value_array(roi_sample_value_array==0)=[];
   roi_pix_mean(i)= mean(roi_sample_value_array);
   roi_pix_std(i) = std(roi_sample_value_array);
   
   %roi_of_current_dataset = current_dataset(roi_rectangle(2):(roi_rectangle(2)+roi_rectangle(4)),roi_rectangle(1):(roi_rectangle(1)+roi_rectangle(3)));
   %roi_background_map, roi_sample_map
  
%    roi_pix_mean(i) = mean(roi_of_current_dataset(:));
%    roi_pix_std(i) = std(roi_of_current_dataset(:));
   
   %extract data from background roi
   roi_background_image = current_dataset.*roi_background_map;
   %make a list of all on zero values:
   roi_background_value_array = roi_background_image(:);
   roi_background_value_array(roi_background_value_array==0)=[];
   background_roi_pix_mean(i)= mean(roi_background_value_array);
   background_roi_pix_std(i) = std(roi_background_value_array);
   %    background_roi_of_current_dataset = current_dataset(roi_background_rectangle(2):(roi_background_rectangle(2)+roi_background_rectangle(4)),roi_background_rectangle(1):(roi_background_rectangle(1)+roi_background_rectangle(3)));
%    background_roi_pix_mean(i) = mean(background_roi_of_current_dataset(:));
%    background_roi_pix_std(i) = std(background_roi_of_current_dataset(:));
   
%    %show the image for that file
%    figure(2)
%    imagesc((current_dataset-272.15)),colormap(gray),colorbar;
   i=i+1;
end
