function [alpha, n, c, P] = gaitPlanning_min(l_edge,alpha_max,c_a_O,c_b_O,c_a_F,c_b_F)

alpha_O =  atan2(c_b_O(2)-c_a_O(2),c_b_O(1)-c_a_O(1));

c = 'c_a';
for n_c_a = 1:100
    [x, ceq] = gaitPlanning(l_edge,alpha_max,c,n_c_a,c_a_O,c_b_O,c_a_F,c_b_F);
    if abs(ceq(2:3))< 1e-6
        alpha_c_a = x;
        break
    end
end

c = 'c_b';
for n_c_b = 1:100
    [x, ceq] = gaitPlanning(l_edge,alpha_max,c,n_c_b,c_a_O,c_b_O,c_a_F,c_b_F);
    if abs(ceq(2:3))< 1e-6
        alpha_c_b = x;
        break
    end
end

if n_c_a <= n_c_b
    alpha = alpha_c_a;
    n = n_c_a;
    c = 'c_a';
    P = contactVertices_c_a(n,alpha,c_a_O,c_b_O,l_edge,alpha_O);
else
    alpha = alpha_c_b;
    n = n_c_b;
    c = 'c_b';
    P = contactVertices_c_b(n,alpha,c_a_O,c_b_O,l_edge,alpha_O);
end

% Functions
    function P = contactVertices_c_a(n,x,c_a,c_b,l_edge,alpha_O)
        Sigma_j = 0;
        Sigma_i = [0 0].';
        for i = 1:n
            for j = 1:i
                if j==1
                    Sigma_j = x(j) + alpha_O;
                else
                    Sigma_j = pi + (-1)^(j-1) * x(j) + Sigma_j;
                end
            end
            Sigma_i = l_edge * [cos(Sigma_j) sin(Sigma_j)].' + Sigma_i;
            P(:,i) = Sigma_i + c_a;
            Sigma_j = 0;
        end
        P = [c_b c_a P];
        P(3,:) = 0;
        
    end

    function P = contactVertices_c_b(n,x,c_a,c_b,l_edge,alpha_O)
        Sigma_j = 0;
        Sigma_i = [0 0].';
        for i = 1:n
            for j = 1:i
                if j==1
                    Sigma_j = pi  + alpha_O - x(j);
                else
                    Sigma_j = pi + (-1)^j * x(j) + Sigma_j;
                end
            end
            Sigma_i = l_edge * [cos(Sigma_j) sin(Sigma_j)].' + Sigma_i;
            P(:,i) = Sigma_i + c_b;
            Sigma_j = 0;
        end
        P = [c_a c_b P];
        P(3,:) = 0;
    end

end