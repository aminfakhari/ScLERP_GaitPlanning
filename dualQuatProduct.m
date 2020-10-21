function AB = dualQuatProduct(A,B)

P_A = A(1:4);
Q_A = A(5:8);
P_B = B(1:4);
Q_B = B(5:8);
AB = [quatProduct(P_A,P_B) quatProduct(P_A,Q_B)+quatProduct(Q_A,P_B)];

end