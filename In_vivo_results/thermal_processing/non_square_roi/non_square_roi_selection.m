function [mean_roi_val,std_roi_val] = non_square_roi_selection(image_to_process)
%load clown;

figure(1);
imagesc(image_to_process);
colorbar;
colormap(hot);

[points_x,points_y] = getpts(gcf);%left click as man points as you like then right click to finish

%close the loop ensuring last point ontop of first point
points_x(end+1) = points_x(1);
points_y(end+1) = points_y(1);
num_of_points = size(points_x,1);

%display line on image
hold on, plot(points_x, points_y);

roi_map = roipoly(image_to_process,points_x,points_y);
roi_image = image_to_process.*roi_map;

figure(2);
imagesc(roi_image);
colormap(hot);
colorbar;

%make a list of all on zero values:
roi_value_array = roi_image(:);
roi_value_array(roi_value_array==0)=[];
mean_roi_val = mean(roi_value_array);
std_roi_val = std(roi_value_array);



