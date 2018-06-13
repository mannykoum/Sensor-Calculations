function area_range = area(x,y,z)
sorted_dims = sort([x,y,z]);
min_area = sorted_dims(1)*sorted_dims(2);
ave_area = (x*y + y*z + x*z)/3;
max_area = sorted_dims(2)*sorted_dims(3);

area_range = [min_area, ave_area, max_area];
end