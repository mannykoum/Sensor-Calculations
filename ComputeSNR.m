
% Computes SNR per pixel for specified intensity per pixel, wavelength,
% integration time, quantum efficiency, well capacity, and read noise
%
% Inputs:   optics - structure with fields
%                  watts_per_pixel    - intensity of light entering single  pixel (W)
%                  lambda             - mean wavelength of sensor (m)
%                  quantum_efficiency - quantum efficiency of sensor (e/photon)
%                  full_well          - capacity of a single pixel (electrons)
%                  read_noise         - noise per pixel inherent to sensor readout (e (RMS))
%                  integration_time   - exposure time (seconds)
%
% Outputs:  SNR   - signal to noise ratio

function SNR = ComputeSNR(optics)

watts_per_pixel = optics.watts_per_pixel; % s
lambda = optics.lambda; % m (mean wavelength)
quantum_efficiency = optics.quantum_efficiency; % e/photon
full_well = optics.full_well; % e
read_noise = optics.read_noise; % e (RMS)
integration_time = optics.integration_time; % in s

h = 6.62607004e-34; % Js (Planck constant)
c = 299792458; % m/s (speed of light)

joules_per_photon = h*c/lambda;
photons_per_second_per_pixel = watts_per_pixel/joules_per_photon;

signal = min(photons_per_second_per_pixel*quantum_efficiency*integration_time,full_well);

SNR = signal/sqrt(signal+read_noise^2);