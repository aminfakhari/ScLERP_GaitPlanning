function PQ = quatProduct(P, Q)

p_0 = P(1);
q_0 = Q(1);
p_r = P(2:4);
q_r = Q(2:4);
scalarPart = p_0*q_0 - dot(p_r,q_r);
vectorPart = p_0*q_r + q_0*p_r + cross(p_r,q_r);
PQ = [scalarPart vectorPart];

end