function [l, theta] = quat2AxisAngle(Q)

q_0 = Q(1);
q_r = Q(2:4);
if (norm(q_r) <= 1e-12)
    % Null or full rotation, the angle is 0 (modulo 2*pi) --> singularity: The unit vector u is indeterminate.
    % By convention, set l to the default value [0, 0, 1].
    l = [0, 0, 1];
    theta = 0;
else
    l = q_r/norm(q_r);
    theta = 2*atan2(norm(q_r), q_0);
end

% To keep theta in [0 pi]
if theta > pi
    theta = 2* pi - theta ;
    l = -l;
end

end