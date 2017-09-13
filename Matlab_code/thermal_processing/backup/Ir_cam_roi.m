
%load_in_the_roi *****************************************************

%ask if wanted new roi specified:
y_n_loop_back = 1;
while y_n_loop_back == 1
    yes_no_to_contune = input('Do you want to specify your own non standard ROI? (Y/y if yes, N/n if no): ', 's');
    if yes_no_to_contune == 'Y'
        no_roi_loaded =1;
        y_n_loop_back = 0;
    elseif yes_no_to_contune == 'y'
        no_roi_loaded =1;
        y_n_loop_back = 0;
    elseif yes_no_to_contune == 'n'
        no_roi_loaded =0;
        y_n_loop_back = 0;
    elseif yes_no_to_contune == 'N'
        no_roi_loaded =0;
        y_n_loop_back = 0;
    else
        y_n_loop_back = 1;
        disp('Please only type a: y or Y, or n or N');
    end
    
end

%load in the file to display ROI on
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


%display ROIs
happy_with_roi = 0;
while happy_with_roi == 0
    
    if no_roi_loaded ==1
        %if wanted to specify now select the rois
        roi_selection_process;
    elseif no_roi_loaded ==0
        %load standard sample and background rois from a file
        load(roi_default_full_path);
    else
        disp('Something wierd is happening Im exiting now byeee');
        return
    end
    
    figure(1)
    imagesc((roi_dataset-272.15)),colormap(gray),colorbar, axis off;
    %draw sample roi rectangle on the image in red
    rectangle('Position', roi_rectangle, 'EdgeColor','r');
    %draw background roi rectangle on the image in blue
    rectangle('Position', roi_background_rectangle, 'EdgeColor','b');
    
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
            no_roi_loaded =1;
            happy_with_roi=0;
            y_n_loop_back = 0;
        elseif yes_no_to_contune == 'N'
            no_roi_loaded =1;
            happy_with_roi=0;
            y_n_loop_back = 0;
        else
            y_n_loop_back = 1;
            disp('Please only type a: y or Y, or n or N');
        end
        
    end
end


figure(1)
imagesc((roi_dataset-272.15)),colormap(gray),colorbar, axis off;
%draw sample roi rectangle on the image in red
rectangle('Position', roi_rectangle, 'EdgeColor','r');
%draw background roi rectangle on the image in blue
rectangle('Position', roi_background_rectangle, 'EdgeColor','b');
saveas(gcf, [output_root_directory,batch_name,'_roi_location'],'fig');
saveas(gcf, [output_root_directory,batch_name,'_roi_location'],'png');
saveas(gcf, [output_root_directory,batch_name,'_roi_location'],'jpg');