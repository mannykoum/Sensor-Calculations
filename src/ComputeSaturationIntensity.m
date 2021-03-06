
% Computes saturation intensity for specified quantum efficiency, well
% capacity, integration time, and wavelength
%
% Inputs:   optics - structure with fields
%                  quantum_efficiency - quantum efficiency of sensor
%                  full_well          - capacity of a single pixel (electrons)
%                  integration_time   - exposure time (seconds)
%                  lambda             - mean wavelength of sensor (m)
%
% Outputs:  max_watts_per_pixel - saturation intensity (W/pix)

function max_watts_per_pixel = ComputeSaturationIntensity(optics)

quantum_efficiency = optics.quantum_efficiency;
full_well = optics.full_well; % e (electrons)
integration_time = optics.integration_time; % s
lambda = optics.lambda; % m (mean wavelength)

h = 6.62607004e-34; % Js (Planck constant)6.626176 x 10-34
c = 299792458; % m/s (speed of light)

joules_per_photon = h*c/lambda;

max_photons_per_second_per_pixel = full_well/(quantum_efficiency*integration_time);

max_watts_per_pixel = max_photons_per_second_per_pixel*joules_per_photon;
