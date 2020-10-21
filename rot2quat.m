function Q = rot2quat(R)

q_0 = 1/2*sqrt(trace(R)+1);
q_r = 1/2*[...
    sign(R(3,2) - R(2,3))*sqrt(R(1,1) - R(2,2) - R(3,3) + 1)
    sign(R(1,3) - R(3,1))*sqrt(R(2,2) - R(3,3) - R(1,1) + 1)
    sign(R(2,1) - R(1,2))*sqrt(R(3,3) - R(1,1) - R(2,2) + 1)];
Q = [q_0 q_r.'];

end