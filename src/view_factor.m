% Computes the view factor between two coaxial parallel disks
%
% ri            radius of radiating surface
% rj            radius of receiving surface
% L             distance between the two plates
% Output: vf    the view factor b/w the two plates

function vf = view_factor(ri, rj, L)

Ri = ri/L;
Rj = rj/L;

S = 1 + (1 + Rj^2)/Ri^2;

vf = (1/2) * (S - sqrt(S^2 - 4*(rj/ri)^2));
end
