
% Computes integration time for saturation for specified quantum 
% efficiency, well capacity, wavelength, and intensity
%
% Inputs:   optics - structure with fields
%                  quantum_efficiency - quantum efficiency of sensor (e/photon)
%                  full_well          - capacity of a single pixel (electrons)
%                  watts_per_pixel    - intensity of light entering single  pixel (W)
%                  lambda             - mean wavelength of sensor (m)
%
% Outputs:  max_integration_time - time to achieve saturation (s)

function max_integration_time = ComputeSaturationIntegrationTime(optics)

quantum_efficiency = optics.quantum_efficiency; % e/photon
full_well = optics.full_well; % e (electrons)
watts_per_pixel = optics.watts_per_pixel; % s
lambda = optics.lambda; % m (mean wavelength)

h = 6.62607004e-34; % Js (Planck constant)
c = 299792458; % m/s (speed of light)

joules_per_photon = h*c/lambda;
photons_per_second_per_pixel = watts_per_pixel/joules_per_photon;

max_integration_time = full_well/(photons_per_second_per_pixel*quantum_efficiency);