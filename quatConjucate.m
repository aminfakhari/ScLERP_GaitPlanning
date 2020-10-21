function quatConjucate = quatConjucate(Q)

q_0 = Q(1);
q_r = Q(2:4);
quatConjucate = [q_0 -q_r];

end