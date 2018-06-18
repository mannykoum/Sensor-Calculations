
% Computes the incident power per pixel on the sensor given the relative
% distance between the camera and the target satellite
% 
% dist                  Relative distance in m
% x_dim, y_dim, z_dim   Dimensions of the target satellite
% alpha                 The ratio of reflectivity of the target's surface
% f                     Focal length in m
% s_s                   Distance b/w sensor and lens in m
% N                     f-number
% d_coc_pix             Diameter of the circle of confusion in pixels
% pix_pitch             Size of a pixel in m 
%
% Outputs: ave_watts    Power per pixel in W

function ave_watts = dist_to_watts(dist, x_dim, y_dim, z_dim,...
                        alpha, f, s_s, N, d_coc_pix, pix_pitch)
                    
sol_irr = 620; % Solar irradiance (W/m^2) in VIS spectrum

% Defocussing effects
coc_area = pi*(d_coc_pix*pix_pitch/2)^2; % area of CoC in m
n_pix_coc = coc_area/(pix_pitch^2); % area of CoC in pixels

% Calculate area
areas = ComputeArea(x_dim, y_dim, z_dim); % min_area, ave_area, max_area

% Pixels are discrete
% size of target on the sensor in pixels
n_pix = ceil((areas/(pix_pitch^2))*((s_s/dist)^2));
powers_per_pix = zeros(1,3);


aperture_radius = f/(2*N); % radius of the entrance pupil
aperture_area = pi * aperture_radius^2;

% Calculate the power
for i = [1, 2, 3]
    % min_power, ave_power, max_power emitted from the source in W
    power = sol_irr * alpha * areas(i);
    
    % Use the following equations/functions to divide by the view factor 
    irr_src = power/(4*pi*dist^2); % assumption: source is isotropic
%     irr_src = power*view_factor(sqrt(areas(2)/pi),aperture_radius,dist);
%     irr_src = power*view_factor_square(sqrt(areas(2)),sqrt(aperture_area),dist);
    
    powers_per_pix(i) = (irr_src * aperture_area)/n_pix(i);
    % Stop dividing the power once the target is big enough to cover the CoC 
    powers_per_pix(i) = powers_per_pix(i) / (max([(n_pix_coc/n_pix(i)) 1])); 
end
 
% min_watts = powers_per_pix(1);
ave_watts = powers_per_pix(2);
% max_watts = powers_per_pix(3);

end

