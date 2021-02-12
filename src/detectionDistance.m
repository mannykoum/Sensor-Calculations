function [detection_distance,det_power] = detectionDistance(...
    optics, target_dims, exposure, dist_arr)
%DETECTIONDISTANCE Summary of this function goes here
%   Detailed explanation goes here
detection_distance = 0;
% intrsct_flag = false;

if nargin < 4
    dist_arr = logspace(-1, 9, 200); % Relative distance in m [1m, 10e+5m]
end

l = length(dist_arr);
ctr = 1;
target_detection_SNR = 2.0;

% Preallocating
wpp = zeros(1, l); % Incident power in watts per pixel
detection_intensity = zeros(1, l); % Array w/ detection intensity  
p = 0;

for i = 1:l
%     Cubesat
    wpp(i) = dist_to_watts(dist_arr(i),...
        target_dims, 0.85, ...
        optics.focal_length, optics.s_s, ...
        optics.f_number, optics.d_coc_pix, ...
        optics.pix_pitch)*10^12; % incident power per pixel in pW
end

optics.integration_time = exposure; % in s
optics.watts_per_pixel = ComputeSaturationIntensity(optics);
optics.read_noise = ComputeReadNoise(optics);
optics.maxSNR = ComputeSNR(optics);
optics.detection_watts_per_pixel = ComputeIntensityAtTargetSNR(...
    optics, target_detection_SNR);
detection(ctr,:) = ones([1 l])*optics.detection_watts_per_pixel.*10^12;

[detection_distance,det_power] = intersections(dist_arr, wpp, ...
    dist_arr, detection(ctr,:), 1);


end

