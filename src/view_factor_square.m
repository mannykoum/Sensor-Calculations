% Computes the view factor between two coaxial square plates
%
% W1            side of radiating surface
% W2            side of receiving surface
% H             distance between the two plates
% Output: vf    the view factor b/w the two plates

function vf = view_factor_square(W1, W2, H)

w1 = W1/H;
w2 = W2/H;

x = w2 - w1;
y = w2 + w1;

p = (w1^2 + w2^2 + 2)^2;
q = (x^2 +2)*(y^2 + 2);

u = sqrt(x^2 + 4);
v = sqrt(y^2 + 4);

s = u*(x*atan(x/u) - y*atan(y/u));
t = v*(x*atan(x/v) - y*atan(y/v));

vf = (1/(pi*w1^2))*(log(p/q)+s-t);
end
