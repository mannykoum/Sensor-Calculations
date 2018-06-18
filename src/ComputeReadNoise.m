
% Computes read noise from well capacity and dynamic range
%
% Inputs:   optics - structure with fields
%                  full_well          - capacity of a single pixel (electrons)
%                  dynamic_range      - dynamic range of sensor (dB)
%
% Outputs:  read_noise - noise per pixel inherent to sensor readout (e (RMS))

function read_noise = ComputeReadNoise(optics)

full_well = optics.full_well; % e 
dynamic_range = optics.dynamic_range; % dB

read_noise = full_well/(10^(dynamic_range/20));