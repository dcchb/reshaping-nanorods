function [roi_map, points_x, points_y] = roi_poly_select(image_to_process)

[points_x,points_y] = getpts(gcf);%left click as man points as you like then right click to finish

%close the loop ensuring last point ontop of first point
points_x(end+1) = points_x(1);
points_y(end+1) = points_y(1);
%num_of_points = size(points_x,1);

roi_map = roipoly(image_to_process,points_x,points_y);