function [l, m, theta, d] = screwParameters(A)

P = A(1:4);
% Q = A(5:8);
[l, theta] = quat2AxisAngle(P);
if theta == 0 || theta == pi
    disp("Screw axis is at infinity!")
else
    [~, p] = dualQuat2Transformation(A);
    d = dot(p,l);
    m = 1/2 * (cross(p,l) + (p - d * l) * cot(theta/2));
end

end