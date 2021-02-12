function hd = ComputeHyperfocal(optics)
%COMPUTEHYPERFOCAL Computes the hyperfocal distance in m
% Inputs:   optics - structure with fields
%                  focal_length     - focal length of the lens (m)
%                  f_number         - f-number N = f/D (dimensionless)
%                  d_coc_pix        - diameter of the circle of confusion
%                                     (pixels)
%                  pix_pitch        - pixel size (m)
%
% Outputs:  hd - hyperfocal distance (m)
f = optics.focal_length;
N = optics.f_number;
d_coc = optics.d_coc_pix*pix_pitch;
hd = f.^2/(N*d_coc) + f;
end

