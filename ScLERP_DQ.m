function [R, p] = ScLERP_DQ(R_A,p_A,R_B,p_B,tau)

% Configurations --> Unit Dual Quaternians
R_A_UQ = rot2quat(R_A);
p_A_Q = [0 p_A.'];
A_UDQ = [R_A_UQ, 1/2*quatProduct(p_A_Q , R_A_UQ)];

R_B_UQ = rot2quat(R_B);
p_B_Q = [0 p_B.'];
B_UDQ = [R_B_UQ, 1/2*quatProduct(p_B_Q , R_B_UQ)];

% Screw Linear Interpolation (ScLERP)
Transf = dualQuatProduct(dualQuatConjucate(A_UDQ), B_UDQ);
[l, m, theta, d] = screwParameters(Transf);

D = zeros(length(tau),8);
R = zeros(3,3,length(tau));
p = zeros(3,length(tau));
for i = 1:length(tau)
    P = [cos(tau(i)*theta/2) sin(tau(i)*theta/2)*l];
    Q = [-tau(i)*d/2*sin(tau(i)*theta/2) tau(i)*d/2*cos(tau(i)*theta/2)*l + sin(tau(i)*theta/2)*m];
    D(i,:) = dualQuatProduct(A_UDQ, [P Q]);
    [R(:,:,i), p(:,i)] = dualQuat2Transformation(D(i,:));
end

end