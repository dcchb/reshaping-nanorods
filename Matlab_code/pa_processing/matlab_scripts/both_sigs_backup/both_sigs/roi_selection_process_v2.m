%define ROI
%load in file to specify ROI

if roi_filenum_to_load <= 9999
    current_filename = [initial_filename,num2zeros_n_nums(roi_filenum_to_load,4)];
    current_full_path = [data_directory,current_filename,'.MAT'];
elseif roi_filenum_to_load > 9999 && roi_filenum_to_load <= 99999
    current_filename = [initial_filename,num2zeros_n_nums(roi_filenum_to_load,5)];
    current_full_path = [data_directory,current_filename,'.MAT'];
else
    disp('something went wrong with your specified number of files');
    return
end
roi_dataset = loadStructFromFile(current_full_path,current_filename);

%define roi for sample:
happy_with_roi = 0;
while happy_with_roi == 0
figure(1)
imagesc((roi_dataset-272.15)),colormap(gray),colorbar, title('Position of sample ROI');
disp('Please select your roi using your mouse');
% roi_rectangle = getrect;%[xmin ymin width height]
% roi_rectangle = round(roi_rectangle);
[roi_polygon,xi,yi] = roipoly;

%Analysis is as follows:
roi_image = (roi_dataset.*roi_polygon);
roi_image(roi_image==0) =[];
roi_mean = mean(roi_image);
roi_std = std(roi_image);

%draw rectangle on the image in red
% rectangle('Position', roi_rectangle, 'EdgeColor','r');
% impoly(gca, roi_rectangle, 'EdgeColor','r');


y_n_loop_back = 1;
while y_n_loop_back == 1
yes_no_to_contune = input('Are you happy with this ROI? (Y/y if yes, N/n if no): ', 's');
if yes_no_to_contune == 'Y'  
happy_with_roi=1;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'y'
happy_with_roi=1;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'n'
happy_with_roi=0;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'N'
happy_with_roi=0;
y_n_loop_back = 0;
else
    y_n_loop_back = 1;
    disp('Please only type a: y or Y, or n or N');
end

end
end

%define roi for background
happy_with_roi = 0;
while happy_with_roi == 0
figure(1)
imagesc((roi_dataset-272.15)),colormap(gray),colorbar, title('Position of background ROI');
disp('Please select your background roi using your mouse');
% roi_background_rectangle = getrect;%[xmin ymin width height]
% roi_background_rectangle = round(roi_background_rectangle);

%draw rectangle on the image in blue
% rectangle('Position', roi_background_rectangle, 'EdgeColor','b');

y_n_loop_back = 1;
while y_n_loop_back == 1
yes_no_to_contune = input('Are you happy with this ROI? (Y/y if yes, N/n if no): ', 's');
if yes_no_to_contune == 'Y'  
happy_with_roi=1;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'y'
happy_with_roi=1;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'n'
happy_with_roi=0;
y_n_loop_back = 0;
elseif yes_no_to_contune == 'N'
happy_with_roi=0;
y_n_loop_back = 0;
else
    y_n_loop_back = 1;
    disp('Please only type a: y or Y, or n or N');
end

end
end