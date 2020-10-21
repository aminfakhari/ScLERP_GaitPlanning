function R = rot(angle, axis)

if axis == 'z'
    R = [...
        cos(angle) -sin(angle) 0
        sin(angle) cos(angle)  0
        0          0           1];
    
elseif axis == 'y'
    R = [...
        cos(angle)  0  sin(angle)
        0           1 0
        -sin(angle) 0 cos(angle)];
    
elseif axis == 'x'
    R = [...
        1 0           0
        0 cos(angle) -sin(angle)
        0 sin(angle)  cos(angle)];
end

end