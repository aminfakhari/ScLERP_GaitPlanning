function [R, p] = dualQuat2Transformation(A)

P = A(1:4);
Q = A(5:8);
R = quat2rot(P);
p_Q = 2 * quatProduct(Q, quatConjucate(P));
p = p_Q(2:4);

end