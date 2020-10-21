function [R, p, s] = rotationAboutCorner(c, alpha, beta, R_1, p_1, s)

R_2 =  R_1 * rot(beta,'x');
p_2 = ((R_1 - R_2) * c) + p_1;

R_3 =  rot(alpha,'z') * R_1;
p_3 = ((R_2 - R_3) * c) + p_2;

[R2, p2] = ScLERP_DQ(R_1,p_1,R_2,p_2,s);
[R3, p3] = ScLERP_DQ(R_2,p_2,R_3,p_3,s);

s = cat(1,s,s);
p = cat(2,p2,p3);
R = cat(3,R2,R3);

end