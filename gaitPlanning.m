function [x, ceq] = gaitPlanning(l_edge,alpha_max,c,n,c_a_O,c_b_O,c_a_F,c_b_F)


alpha_O =  atan2(c_b_O(2)-c_a_O(2),c_b_O(1)-c_a_O(1));
alpha_F =  atan2(c_b_F(2)-c_a_F(2),c_b_F(1)-c_a_F(1));

% Optimization
A = [];
b = [];
Aeq = [];
beq = [];
lb = - alpha_max*ones(1,n);
ub = alpha_max*ones(1,n);
x0 = zeros(1,n);
% x0 = (lb + ub)/2;

% options = optimoptions('fmincon','ConstraintTolerance',1e-6);
if strcmp(c,'c_a')
    x = fmincon(@(x)norm(x),x0,A,b,Aeq,beq,lb,ub,@(x)constraints_c_a(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_a_O,alpha_O));
    [~,ceq] = constraints_c_a(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_b_O,alpha_O);
elseif strcmp(c,'c_b')
    x = fmincon(@(x)norm(x),x0,A,b,Aeq,beq,lb,ub,@(x)constraints_c_b(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_b_O,alpha_O));
    [~,ceq] = constraints_c_b(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_b_O,alpha_O);
end

% Functions
    function [c,ceq] = constraints_c_a(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_a_O,alpha_O)
        
        Sigma_j = 0;
        Sigma_i = [0 0].';
        
        % Rotation about c_a
        for i = 1:n
            for j = 1:i
                if j==1
                    Sigma_j = x(j) + alpha_O;
                else
                    Sigma_j = pi + (-1)^(j-1) * x(j) + Sigma_j;
                end
            end
            if i == n
                angle = Sigma_j - pi*(n-1);
            end
            Sigma_i = l_edge * [cos(Sigma_j) sin(Sigma_j)].' + Sigma_i;
            Sigma_j = 0;
        end
        if rem(n,2) == 1
            ceq(1:2) = Sigma_i + c_a_O - c_b_F;
        else
            ceq(1:2) = Sigma_i + c_a_O - c_a_F;
        end
        ceq(3) = angle - alpha_F;
        c = [];
    end

    function [c,ceq] = constraints_c_b(x,n,c_a_F,c_b_F,alpha_F,l_edge,c_b_O,alpha_O)
        
        Sigma_j = 0;
        Sigma_i = [0 0].';
        
        % Rotation about c_b
        for i = 1:n
            for j = 1:i
                if j==1
                    Sigma_j = pi  + alpha_O - x(j);
                else
                    Sigma_j = pi + (-1)^j * x(j) + Sigma_j;
                end
            end
            if i == n
                angle = Sigma_j - pi*n;
            end
            Sigma_i = l_edge * [cos(Sigma_j) sin(Sigma_j)].' + Sigma_i;
            Sigma_j = 0;
        end
        if rem(n,2) == 1
            ceq(1:2) = Sigma_i + c_b_O - c_a_F;
        else
            ceq(1:2) = Sigma_i + c_b_O - c_b_F;
        end
        ceq(3) = angle - alpha_F;
        c = [];
    end

end
