%auto_scale_it_v1p2
%
%Summary:
%Loads in a set of images (developed for TEM images) within a directory
%Calculating the length, width and aspect ratio of rod like structures
%for every image in a directory
%plotting a histogram for the length, width and aspect ratio
%Note: v1p2 now inlcudes better scaled histograms
% v1p2p1 adds images of the intermediate stages of every image in the folder
% 
% v1p3 - removes 2 pixels from length and width (as previously overestimates by 1 pixel on each side) 
% 	- and fixed scaling issue in the intermediate stages images
% 	also:
% 	-changes criteria for objects:
% 		- added criteria of width greater than 5nm
% 		- changed min length to 15nm (from 10nm)
% 		- changed min eccentricity to 0.7 (from 0.6)
% 		- added max length of 70nm
% 		- changed max width to 25nm (from 200 pix)
%
%v_1 reads in dm3 files only (which contains the scale factor for pixels
%to nm in it) -- for other file formats either amend code or contact David
%Harris-Birtill (birtil@hotmail.com)
%
%
%How to use:
%- Before running move all the data you want to analyse into a folder with
%only those dm3 data files in (this code assumes only dm3 files are in 
%this directory)
%- run this script (type: auto_scale_it_v1 into matlab when in this
%directory)
%- select your data folder
%- select the folder you would like to have the figures saved to
%- let it run (normally takes approx. 3 secs per image, therefore 20 images
%takes 1 min)
%- The histrograms will be plotted and displayed on your screen and
%automatically saved to the specified folder.
%
%
%Note: if the instrument is changed or the background level of the images
%changes then the threshold value (at top of this script) should be
%modified.
%
%
%Description of analysis of each image:
%- The image loaded in and the scale factors loaded (also converts scale to
%always be in nm (converts µm to nm)
%- The image is then thresholded, settng all values above a level to equal
%that level
%- The gradient of the thresholded image is taken in each direction
%the absolute of these matrixices are made (flipping -ve to +ve)
%- The sum of the gradient maps is taken (This provides high intensity at 
%the edges of objects all around the object)
%- The this gradient map is converted into a binary image (0&1)
%- An edge detection algorithm (Roberts method) is used on this binary map
%to find the edges of the objects
%- a watershed algorithm is used to segment the image into many objects
%- The length, width, area and eccentricity of these objects is measured
%- for each object the length and width are recorded if the below criteria
%for are satisfied for that object:
%-- The eccentricity is greater than 0.6 (this means it wont look at spheres only rods)
%-- The area is greater than 30 pixels (removes noise objects)
%-- The width is less than 200 pixels (removes crazy wide objects)
%-- The length is greater than 10nm (again removes unwanted tiny objects)
%-- The object does not touch the image border <<- first included in v1p1
%
%-The length and widths are converted from picels to nm using the loaded
%scale factors
%- Then the aspect ratio is calculated by dividing the length by the width
%
%Every image in the directory is loaded and analysed in this way and the
%values are recorded by appending arrays (creating a long table which
%includes all values for every image in one long list).
%
%Then histograms are plotted for the length, width and aspect ratio using
%the data from every image in the folder
%these histograms are saved into the folder specified by the user at run
%time
%
%
%
%Written by David Harris-Birtill
%Written on 17/04/2013 last amended on 13/05/2013
%contact: birtill@hotmail.com
%


%Variables:
%threshold_value = 1600;
%[level EM] = graythresh(I)

% [filename, pathname] = uigetfile('*.*','Choose your image');
% full_path = [pathname,filename]; %should iterate over all the filenames in a folder

%get data paths:
initial_folder = pwd;
pathname =  uigetdir(initial_folder, 'Choose your Data Directory');
pathname = [pathname,'\'];
filenames = ls(pathname);
filenames = filenames(3:end,:);
num_files = size(filenames,1);

%output_path = 'E:\David\Scale_it\outputs\test2\';
output_path =  uigetdir(initial_folder, 'Choose your Output Directory');
output_path = [output_path,'\'];

batch_name = 'sample';%can change this if you want to save many samples to the same output folder
out_batch_full_path = [output_path,batch_name];
%loop over all files and analyse
%loop

%initialize arrays:
length_pix_array = [];
length_nm_array = [];
width_pix_array = [];
width_nm_array = [];
aspect_ratio_array = [];

duff_obj_counter = 0;
good_obj_counter = 0;
total_obj_counter = 0;
right_type_obj_counter = 0;
txtprogressbar;% Set starting time
for file_num = 1:num_files
    %specify full path
    current_filename = strtrim(filenames(file_num,:));
    full_path = [pathname,current_filename];
    
    %analyse data
    %analyse_TEM_data;
    analyse_single_image_v5;
    
    %save data to matrices
    num_objects_array(file_num) = obj_i;
    length_pix_array = cat(2,length_pix_array,length_pix);
    length_nm_array = cat(2,length_nm_array,length_nm);
    width_pix_array = cat(2,width_pix_array,width_pix);
    width_nm_array = cat(2,width_nm_array,width_nm);
    aspect_ratio_array = cat(2,aspect_ratio_array,aspect_ratio);
    
    x_units_list(:,file_num) = x_units;
    y_units_list(:,file_num) = x_units;
    x_scale_nm_array(file_num) = x_scale*x_scale_factor;
    y_scale_nm_array(file_num) = y_scale*y_scale_factor;
    
    %plot intermediate stage images figures
    plot_intermidiate_stage_images_v2;
    
    
    txtprogressbar(file_num/num_files); % Update text
    
    %clear arrays used for this image
    clear length_pix length_nm width_pix width_nm aspect_ratio x_scale y_scale x_scale_factor y_scale_factor stats* good_obj_number
    
end
%merge data from same samples
num_objects_array_ind = cumsum(num_objects_array);

%calculate means and std
aspect_ratio_mean = mean(aspect_ratio_array);
aspect_ratio_std = std(aspect_ratio_array);
length_nm_mean = mean(length_nm_array);
length_nm_std = std(length_nm_array);
width_nm_mean = mean(width_nm_array);
width_nm_std = std(width_nm_array);

%plot results
figure, hist(aspect_ratio_array,0.5:0.25:13), xlim([1  6]);
set(gca,'FontSize',16);
xlabel('Aspect Ratio (L/W)');
ylabel('Counts');
title(['Mean = ', num2str(aspect_ratio_mean), ' +- 1std: ', num2str(aspect_ratio_std)]);
saveas(gcf,[out_batch_full_path,'_aspect_ratio'],'png');

%plot results
figure, hist(length_nm_array,1:80), xlim([0  70]);
set(gca,'FontSize',16);
xlabel('Length (nm)');
ylabel('Counts');
title(['Mean = ', num2str(length_nm_mean), ' +- 1std: ', num2str(length_nm_std)]);
saveas(gcf,[out_batch_full_path,'_length'],'png');

%plot results
figure, hist(width_nm_array,1:50), xlim([0  25]);
set(gca,'FontSize',16);
xlabel('Width (nm)');
ylabel('Counts');
title(['Mean = ', num2str(width_nm_mean), ' +- 1std: ', num2str(width_nm_std)]);
saveas(gcf,[out_batch_full_path,'_width'],'png');