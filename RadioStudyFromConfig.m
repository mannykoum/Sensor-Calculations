% assume there is a sensor and a lens .mat file in configs

%% Initialization
% Make the calculations from 1 m to 1000 km
dist_arr = logspace(-1, 9, 200); % Relative distance in m [1m, 10e+9m]
times = [3.6506e-05, 2*3.6506e-05, 1e-04, 1e-01, 0.2, 1e-0]; % Exposure times in s
l = length(dist_arr);
t_l = length(times);
ctr = 1;
target_detection_SNR = 2.0;

% Preallocating
wpp = zeros(1, l); % Incident power in watts per pixel
saturation = zeros(t_l, l); % Array w/ saturation intensity  
p = zeros(1, t_l);

