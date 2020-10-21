function plot3D(x,y,z,s,R,p,P)

% Cuboid
Rec_Cuboid = [...
    x/2 -x/2 -x/2  x/2 x/2  x/2  x/2  x/2  x/2 -x/2 -x/2  x/2 -x/2 -x/2 -x/2 -x/2
    y/2  y/2  y/2  y/2 y/2 -y/2 -y/2  y/2 -y/2 -y/2 -y/2 -y/2 -y/2  y/2  y/2 -y/2
    z/2  z/2 -z/2 -z/2 z/2  z/2 -z/2 -z/2 -z/2 -z/2  z/2  z/2  z/2  z/2 -z/2 -z/2];
Vertices = [-x/2 -y/2 -z/2; -x/2 y/2 -z/2; x/2 y/2 -z/2; x/2 -y/2 -z/2; -x/2 -y/2 z/2; -x/2 y/2 z/2; x/2 y/2 z/2; x/2 -y/2 z/2].';
Faces = [1 2 3 4;5 6 7 8;3 4 8 7;1 2 6 5;2 3 7 6;1 4 8 5];

% ========= End Effectors Positions =========
EE1 = [-x/2*3/4 -x/2*4/3;y/2 y/2*4/3;0 0];
EE2 = [-x/2*3/4 -x/2*4/3;-y/2 -y/2*4/3;0 0];
% ===========================================

figure

% Supporting plane
XL = [-1 3];
YL = [-3.5 5];
ZL = [0 4];
patch('Faces',[1 2 3 4],'Vertices',[XL(1) YL(1) 0; XL(2) YL(1) 0; XL(2) YL(2) 0; XL(1) YL(2) 0],'FaceColor',[0,0,0] + 0.9)
hold on

% Contact edges
plot3(P(1,:),P(2,:),P(3,:),'b','LineWidth',2)
hold on

for i = 1:length(s)
    
    % ------- Configuration (i) -------
    verts_i = R(:,:,i) * Vertices + p(:,i);
    h_Faces(i) = patch('Faces',Faces,'Vertices',verts_i.','FaceColor',[1 1 1],'EdgeColor','k','LineWidth',1);
    
    % ========= End Effectors =========
    EE1_i = R(:,:,i) * EE1 + p(:,i);
    EE2_i = R(:,:,i) * EE2 + p(:,i);
    h_EE1(i) = plot3(EE1_i(1,:),EE1_i(2,:),EE1_i(3,:),'Color','k','LineWidth',2);
    hold on
    h_EE2(i) = plot3(EE2_i(1,:),EE2_i(2,:),EE2_i(3,:),'Color','k','LineWidth',2);
    hold on
    
    EE1_P(:,i) = R(:,:,i) * EE1(:,2) + p(:,i);
    EE2_P(:,i) = R(:,:,i) * EE2(:,2) + p(:,i);
    % =================================
    
    axis equal
    axis([XL YL ZL])
    set(gcf,'Color',[1 1 1]);
    axis off
    view(-75,25)
    pause(0.03)
    if i~=1 && i~=length(s)
        delete(h_Faces(i))
        delete(h_EE1(i))
        delete(h_EE2(i))
    end
end

% ========= End Effectors =========
hold on
plot3(EE1_P(1,:),EE1_P(2,:),EE1_P(3,:),'-.','Color','b','LineWidth',1);
hold on
plot3(EE2_P(1,:),EE2_P(2,:),EE2_P(3,:),'-.','Color','b','LineWidth',1);
% =================================

end