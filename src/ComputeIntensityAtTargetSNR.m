% Computes the incident power per pixel required to reach the specified SNR
% 
%   optics:                
%       quantum_efficiency      in number of electrons per number of photons  
%       read_noise              the readout noise in e
%       lambda                  wavelength of light in m
%       integration_time        time of exposure in s
%       full_well               full well (saturation) capacity in e
%   targetSNR                   the target signal-to-noise ratio               
% Output: watts_per_pixel       in W

function watts_per_pixel = ComputeIntensityAtTargetSNR(optics, targetSNR)
watts_per_pixel = optics.watts_per_pixel; % s
lambda = optics.lambda; % m (mean wavelength)
quantum_efficiency = optics.quantum_efficiency; % e/photon
full_well = optics.full_well; % e
read_noise = optics.read_noise; % e (RMS)
integration_time = optics.integration_time; % in s

h = 6.62607004e-34; % Js (Planck constant)
c = 299792458; % m/s (speed of light)

joules_per_photon = h*c/lambda; % Energy of one photon in J

if (targetSNR > optics.maxSNR)
    ME = MException('Target SNR %d ', ...
        'larget than maximum %d',targetSNR, optics.maxSNR);
    throw(ME)
end

target_signal = (targetSNR + sqrt(4 * (optics.read_noise^2) * ...
                (targetSNR^2) + targetSNR^4))/2;

photons_per_second_per_pixel = target_signal / (quantum_efficiency*integration_time);
            
watts_per_pixel = photons_per_second_per_pixel * joules_per_photon;

end
