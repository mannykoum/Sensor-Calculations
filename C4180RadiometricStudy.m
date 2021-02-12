%%% Radiometric analysis of the Imperx C4180 camera [script]
% 
% Info that might be useful
% From a review
% Responsivity (V/lux-sec (@550 nm))        01.4
% Pixel Dynamic Range (dB)                  70.1
% SNR_MAX (dB)                              38.1
% Absolute sensitivity threshold (?)        13.0
% ^ How many photons are required to reach the read noise of the sensor
%
% max ratio of reflectivity ?	0.85 from Adam Koenig's camera report

clear all
close all

%% Initialization
% Make the calculations from 1 to 1000km
dist_arr = logspace(-1, 8, 10e6); % Relative distance in m [1m, 10e+6m]
times = [3.6506e-05, 2*3.6506e-05, 1e-04, 1e-03, 1e-02, 1e-01]; % Exposure times in s
l = length(dist_arr);
t_l = length(times);
ctr = 1;
target_detection_SNR = 2.0;

% Saturation/Detection flag: set it to true for detection figure, false for
% saturation figure
detection_flag = true; 

% Preallocating
wpp = zeros(1, l); % Incident power in watts per pixel
saturation = zeros(t_l, l); % Array w/ saturation intensity  
p = zeros(1, t_l);

% Sensor characteristics 
sensor_optics.quantum_efficiency = 0.50; % at 535 nm
sensor_optics.lambda = 535e-9; % 525 nm
sensor_optics.full_well = 12000; % in electrons
sensor_optics.dynamic_range = 59; % in dB
sensor_optics.pix_pitch = 4.5e-6; % 4.5 um

% Lens (Adcole MAI Aero Space Sextant)
sensor_optics.focal_length = 22.86e-3; % Focal length in m
sensor_optics.f_number = 1.2; % f-number
sensor_optics.s_s = 22.9217e-3; % Distance b/w sensor and lens in m
sensor_optics.d_coc_pix = 4.0; % Diameter of the circle of confusion in pixels

figure
colors = [[0,1,0.5]; [0,0.5,1]; [1,0.5,0]; [0.75,0,1]; [1,0,0.5]; [1,0.5,0.5]];
labels = {'Incident power per pixel from target', ...
      ['Saturation intensity for ',num2str(times(1)*1000),' ms exposure'],...
      ['Saturation intensity for ',num2str(times(2)*1000),' ms exposure'],...
      ['Saturation intensity for ',num2str(times(3)*1000),' ms exposure'],...
      ['Saturation intensity for ',num2str(times(4)*1000),' ms exposure'],...
      ['Saturation intensity for ',num2str(times(5)*1000),' ms exposure'],...
      ['Saturation intensity for ',num2str(times(6)*1000),' ms exposure']};
if (detection_flag)
    labels = {'Incident power per pixel from target', ...
      ['Detection intensity for ',num2str(times(1)*1000),' ms exposure'],...
      ['Detection intensity for ',num2str(times(2)*1000),' ms exposure'],...
      ['Detection intensity for ',num2str(times(3)*1000),' ms exposure'],...
      ['Detection intensity for ',num2str(times(4)*1000),' ms exposure'],...
      ['Detection intensity for ',num2str(times(5)*1000),' ms exposure'],...
      ['Detection intensity for ',num2str(times(6)*1000),' ms exposure']};
end
%% Determine the power per pixel
for i = 1:l
    wpp(i) = dist_to_watts(dist_arr(i),0.1,0.1,0.2,0.85, ...
        sensor_optics.focal_length, sensor_optics.s_s, ...
        sensor_optics.f_number, sensor_optics.d_coc_pix, ...
        sensor_optics.pix_pitch)*10^12;
end

figure('Visible','off')
set(gcf,'Visible','off','CreateFcn','set(gcf,''Visible'',''on'')')

pw = plot(dist_arr, wpp, 'b');
axis tight
grid on
grid minor
hold on

for t = times % logspace(-5, -1, 4)
    sensor_optics.integration_time = t; % in s
    sensor_optics.watts_per_pixel = ComputeSaturationIntensity(sensor_optics);
    sensor_optics.read_noise = ComputeReadNoise(sensor_optics);
    sensor_optics.maxSNR = ComputeSNR(sensor_optics);
    sensor_optics.detection_watts_per_pixel = ComputeIntensityAtTargetSNR(sensor_optics, target_detection_SNR);
    
    detection(ctr,:) = ones([1 l])*sensor_optics.detection_watts_per_pixel.*10^12;
    saturation(ctr,:) = ones([1 l])*sensor_optics.watts_per_pixel.*10^12; 
    % in pW/pix

% find the solutions for saturation + detection of the target
    [xout,yout] = intersections(dist_arr, wpp, ...
                                dist_arr, saturation(ctr,:), false);
    [det_xout,det_yout] = intersections(dist_arr, wpp, ...
                                dist_arr, detection(ctr,:), false);
    if (detection_flag)
        p(ctr) = plot(dist_arr, detection(ctr,:), 'Color', colors(ctr,:));
        plot(det_xout, det_yout, 'r.', 'MarkerSize', 8);
    else
        p(ctr) = plot(dist_arr, saturation(ctr,:), 'Color', colors(ctr,:));
        plot(xout, yout, 'r.', 'MarkerSize', 8);
    end
    
    hold on

    disp(['Exposure time: ', num2str(t*1000),' ms'])
    if (xout)
        disp(['At ',num2str(xout(1)),' m, the sensor saturates with ',...
                num2str(sensor_optics.watts_per_pixel*10^12),' pW/pix']);
    else
        disp(['The saturation intensity does not intersect with the ',...
            'incident power from the target satellite']);
    end
    if (det_xout)
        disp(['At ',num2str(det_xout(length(det_xout))),' m, the sensor detects the ',... 
            'target at incident power ', ...
            num2str(sensor_optics.detection_watts_per_pixel*10^12),' pW/pix']);
    else
        disp(['The detection intensity does not intersect with the ',...
            'incident power from the target satellite']);
    end
    disp(['maxSNR: ',num2str(sensor_optics.maxSNR)])
    disp(['Read noise: ',num2str(sensor_optics.read_noise)])
    disp(' ')
    ctr = ctr+1;
end

legend([pw, p], labels) 
title('Power per pixel vs distance')
xlabel('Relative distance (m)')
ylabel('Power per pixel (pW)')

savefig('Test.fig')
close