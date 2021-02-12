% Computes dynamic range from read noise and well capacity
%
% Inputs:   optics - structure with fields
%                  full_well - capacity of a single pixel (electrons)
%                  read_noise - noise per pixel inherent to sensor readout (e (RMS))
%
% Outputs:  dynamic_range - dynamic range of sensor (dB)

function dynamic_range = ComputeDynamicRange(optics)

full_well = optics.full_well; % e 
dynamic_range = optics.dynamic_range; % e

dynamic_range = 20*log10(full_well/dynamic_range);

end
