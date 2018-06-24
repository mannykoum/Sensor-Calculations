% Computes the view factor between two coaxial parallel disks
%
% ri            radius of radiating surface
% rj            radius of receiving surface
% L             distance between the two plates
% Output: vf    the view factor b/w the two plates

function vf = view_factor(ri, rj, L)

Ri = double(ri)/double(L);
Rj = double(rj)/double(L);

S = 1 + (1 + Rj^2)/Ri^2;

vf = (1/2) * (S - sqrt(S^2 - 4*(rj/ri)^2));
% x=L;
% vf = 94.0596*x.^2 - 1.46492*10^-8*sqrt(4.12264*10^19*x.^4 + 4.38301*10^17*x.^2 + 1.16496*10^15) + 0.5;
end
