%plot intermediate stage images figures

figure_output_path = [output_path,current_filename(1:(end-4))];

%y_axis_nm, x_axis_nm
figure, imagesc(y_axis_nm, x_axis_nm, loaded_image);
colorbar;
axis xy;
colormap(gray);
set(gca,'FontSize',16);
xlabel('Distance (nm)');
ylabel('Distance (nm)');
saveas(gcf,[figure_output_path,'_loaded_image'],'png');

figure, imagesc(y_axis_nm, x_axis_nm, thresholded_image_threshold);
colorbar;
axis xy;
colormap(gray);
set(gca,'FontSize',16);
xlabel('Distance (nm)');
ylabel('Distance (nm)');
saveas(gcf,[figure_output_path,'_thresholded_image'],'png');

figure, imagesc(y_axis_nm, x_axis_nm, test_grad_mag);
colorbar;
axis xy;
colormap(gray);
set(gca,'FontSize',16);
xlabel('Distance (nm)');
ylabel('Distance (nm)');
saveas(gcf,[figure_output_path,'_grad_mag_image'],'png');

figure, imagesc(y_axis_nm, x_axis_nm, test_edges5);
colorbar;
axis xy;
colormap(gray);
set(gca,'FontSize',16);
xlabel('Distance (nm)');
ylabel('Distance (nm)');
saveas(gcf,[figure_output_path,'_edge_detected_image'],'png');

detected_objects_image = watershed_test2;

bad_objects = 1:num_objects;
for good_obj_num = 1:obj_i
   % a(find(a==0)) = [];
    bad_objects(bad_objects==good_obj_number(good_obj_num)) = [];
end
number_of_bad_objects = size(bad_objects,2);

for bad_obj_num = 1:number_of_bad_objects
    detected_objects_image(detected_objects_image==bad_objects(bad_obj_num)) = 0;
end

for good_obj_num = 1:obj_i
    detected_objects_image(detected_objects_image==good_obj_number(good_obj_num)) = good_obj_num;
end

figure, imagesc(y_axis_nm, x_axis_nm, detected_objects_image);
colorbar;
axis xy;
colormap(jet);
set(gca,'FontSize',16);
xlabel('Distance (nm)');
ylabel('Distance (nm)');
saveas(gcf,[figure_output_path,'_detected_objects_image'],'png');

% %Threshold image
% thresholded_image_threshold = loaded_image;
% thresholded_image_threshold(thresholded_image_threshold>threshold_value) = threshold_value;
% 
% %calculate the magnitude of the gradient of the thesholded image:
% test_grad  = gradient(double(thresholded_image_threshold));%one direction
% test_grad2  = gradient(double(thresholded_image_threshold'));%the other direction
% 
% %calculate the magnitude in each direcion (-ve becomes +ve)
% test_grad_abs = abs(test_grad);
% test_grad2_abs = abs(test_grad2');
% 
% %calculate the sum of the mag of the gradient from each direction
% test_grad_mag = test_grad_abs+ test_grad2_abs;
% 
% %calculate a B&W image for the gradient map
% bw_test_grad_mag= im2bw(test_grad_mag);
% 
% %calculate the edges of the b&w image of the magnitude of the gradient
% [test_edges5, thres_edgse1] = edge(bw_test_grad_mag,'roberts',0);%could use canny
% 
% %Calculate watershed (split the image into many objects of interest) of
% %edge detected of gradient of thresholded image
% watershed_test2 = watershed(test_edges5,4);