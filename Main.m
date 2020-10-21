clc
clearvars

% Dimensions of the Cuboid Object
x_L = 3;
y_W = 2;
z_H = 1;

%% Original and Initial Configurations

% =====> Original Configuration
% R_0 = eye(3);
% p_0 = [0 0 0].';

% =====> Initial Configuration
R_O = rot(90*pi/180,'z');
p_O = [y_W/2 -x_L/2 z_H/2].';

%% Edge Selection
% Coordinate of the contact vertices in frame {b}
c_a_BodyFrame = [x_L/2 y_W/2 -z_H/2].';
c_b_BodyFrame = [x_L/2 -y_W/2 -z_H/2].';

% Coordinate of the contact vertices in frame {s}
c_a_O_ = R_O * c_a_BodyFrame + p_O;
c_b_O_ = R_O * c_b_BodyFrame + p_O;
c_a_O = c_a_O_(1:2);
c_b_O = c_b_O_(1:2);

% =====> Intermediate Configuration 1
R_I1 = R_O * rot(70*pi/180,'y');
p_I1 = ((R_O - R_I1) * c_a_BodyFrame) + p_O;

%% Gait Planning
l_edge = y_W;
alpha_max = 40*pi/180;
beta = 15*pi/180;

% =====> Final Edge Configuration
c_a_F = [0 3].';
angle_F = -20*pi/180;
c_b_F = [l_edge*cos(angle_F) l_edge*sin(angle_F)].' + c_a_F;

[alpha, n, c, P] = gaitPlanning_min(l_edge,alpha_max,c_a_O,c_b_O,c_a_F,c_b_F);

for i = 1:n
    A(i) = (-1)^(i+1);
end

if strcmp(c,'c_a')
    alpha = alpha.*A;
    beta = - beta*A;
elseif strcmp(c,'c_b')
    alpha = - alpha.*A;
    beta = beta*A;
end

%% Screw Linear Interpolation (ScLERP)

s = (0:0.1:1).';
[R, p] = ScLERP_DQ(R_O,p_O,R_I1,p_I1,s);

% s = [];
% R = R_I1;
% p = p_I1;

s_i = (0:0.1:1).';
for i = 1:n
    if strcmp(c,'c_a')
        [R_, p_, s_] = rotationAboutCorner(rem(i,2) * c_a_BodyFrame + (1 - rem(i,2)) * c_b_BodyFrame, alpha(i), beta(i), R(:,:,end), p(:,end), s_i);
    elseif strcmp(c,'c_b')
        [R_, p_, s_] = rotationAboutCorner(rem(i,2) * c_b_BodyFrame + (1 - rem(i,2)) * c_a_BodyFrame, alpha(i), beta(i), R(:,:,end), p(:,end), s_i);
    end
    s = cat(1,s,s_);
    p = cat(2,p,p_);
    R = cat(3,R,R_);
end

% =====> Final Configuration
s_end = (0:0.1:1).';
R_end = R(:,:,end) * rot(20*pi/180,'y');
p_end = ((R(:,:,end) - R_end) * c_a_BodyFrame) + p(:,end);
[R_end_s, p_end_s] = ScLERP_DQ(R(:,:,end),p(:,end),R_end,p_end,s_end);

s = cat(1,s,s_end);
p = cat(2,p,p_end_s);
R = cat(3,R,R_end_s);

%% 3D Simulation
plot3D(x_L,y_W,z_H,s,R,p,P)
