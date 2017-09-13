%v2 includes a routine to not allow particles which touch the image border
%ie if pixel location x==0 or y==0 or x ==
%(number of xpix) or y==(number of ypix)

% %Variables:
% threshold_value = 1600;
% 
% [filename, pathname] = uigetfile('*.*','Choose your image');
% full_path = [pathname,filename]; %should iterate over all the filenames in a folder
%good_obj_counter = 0;
%duff_obj_counter = 0;
%total_obj_counter = 0;

%Load image
current_data = DM3Import(full_path);
loaded_image = current_data.image_data;
x_scale = current_data.xaxis.scale;
y_scale = current_data.yaxis.scale;

x_units = current_data.xaxis.units;
y_units = current_data.yaxis.units;

if strcmp(x_units, '')
x_units = 'nm';
end
if strcmp(y_units, '')
y_units = 'nm';
end

if strcmp(x_units,'µm')
    x_scale_factor = 1000;
elseif strcmp(x_units,'nm')
    x_scale_factor = 1;
else
    disp('The x scale factor is not nm or µm (check and add that scale unit in code)');
end
if strcmp(y_units,'µm')
    y_scale_factor = 1000;
elseif strcmp(y_units, 'nm')
    y_scale_factor = 1;
else
    disp('The y scale factor is not nm or µm (check and add that scale unit in code)');
end

%make array for pixel to nm in each axis
y_axis_nm = y_scale*[1:size(loaded_image,2)]*y_scale_factor;
x_axis_nm = x_scale*[1:size(loaded_image,1)]*x_scale_factor;

%Analyse data *************************************************

%calculate threshold value (added in auto_scale_it_v1p4)
%[threshold_value threshold_value_EM] = graythresh(loaded_image);
threshold_value = func_threshold(loaded_image);
disp(['Threshold value = ', num2str(threshold_value)]);


%Threshold image
thresholded_image_threshold = loaded_image;
thresholded_image_threshold(thresholded_image_threshold>threshold_value) = threshold_value;

%calculate the magnitude of the gradient of the thesholded image:
test_grad  = gradient(double(thresholded_image_threshold));%one direction
test_grad2  = gradient(double(thresholded_image_threshold'));%the other direction

%calculate the magnitude in each direcion (-ve becomes +ve)
test_grad_abs = abs(test_grad);
test_grad2_abs = abs(test_grad2');

%calculate the sum of the mag of the gradient from each direction
test_grad_mag = test_grad_abs+ test_grad2_abs;

%calculate a B&W image for the gradient map
bw_test_grad_mag= im2bw(test_grad_mag);

%calculate the edges of the b&w image of the magnitude of the gradient
[test_edges5, thres_edgse1] = edge(bw_test_grad_mag,'roberts',0);%could use canny

%Calculate watershed (split the image into many objects of interest) of
%edge detected of gradient of thresholded image
watershed_test2 = watershed(test_edges5,4);

%calculate the length and the width (and aspect ratio)
%of each object (rod/sphere)

num_objects = max(watershed_test2(:));
%object_num = 12;%iterate over this
obj_i = 0;


stats_length = regionprops(watershed_test2,'MajorAxisLength');
stats_width = regionprops(watershed_test2,'MinorAxisLength');
stats_area = regionprops(watershed_test2,'Area');
stats_eccentricity = regionprops(watershed_test2,'Eccentricity');
stats_boundingbox = regionprops(watershed_test2,'BoundingBox');


for obj_num = 1:num_objects
    if stats_eccentricity(obj_num).Eccentricity > 0.7
        if stats_area(obj_num).Area > 30
            if ((stats_width(obj_num).MinorAxisLength)*y_scale*y_scale_factor) < 25
                if ((stats_width(obj_num).MinorAxisLength)*y_scale*y_scale_factor) > 5%added
                    if ((stats_length(obj_num).MajorAxisLength)*y_scale*y_scale_factor) > 15
                        if ((stats_length(obj_num).MajorAxisLength)*y_scale*y_scale_factor) < 70%added
                            right_type_obj_counter = right_type_obj_counter+1;
                            if (stats_boundingbox(obj_num).BoundingBox(1) > 1) && (stats_boundingbox(obj_num).BoundingBox(2) > 1) && ((stats_boundingbox(obj_num).BoundingBox(1) + stats_boundingbox(obj_num).BoundingBox(3)) < size(watershed_test2,2)) && ((stats_boundingbox(obj_num).BoundingBox(2) + stats_boundingbox(obj_num).BoundingBox(4)) < size(watershed_test2,1))
                                obj_i = obj_i+1;
                                length_pix(obj_i) = stats_length(obj_num).MajorAxisLength -2;%subtracts 2 as previously overestimates by 1 on each side
                                width_pix(obj_i) = stats_width(obj_num).MinorAxisLength -2;
                                good_obj_counter = good_obj_counter+1;
                                good_obj_number(obj_i) = obj_num;
                            end
                        end
                    end
                end
            end
        end
    else
        duff_obj_counter = duff_obj_counter+1;
    end
    total_obj_counter = total_obj_counter+1;
end

if obj_i==0
 length_pix =[];
 width_pix = [];
end

length_nm = length_pix*y_scale*y_scale_factor;%assumes x and y scale factor the same
width_nm = width_pix*y_scale*y_scale_factor;

aspect_ratio = length_pix./width_pix;