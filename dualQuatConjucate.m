function dualQuatConjucate = dualQuatConjucate(A)

P = A(1:4);
Q = A(5:8);
dualQuatConjucate = [quatConjucate(P) quatConjucate(Q)];

end