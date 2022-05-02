%% Projecting force Dubins - force threshold
clear all;
xmin = -2.6; xmax=2.6; ymin=-1.8; ymax=1.8;
vertX = 2*[-1 -1 1 1 -1];
vertY = [-1  1 1 -1 -1];
theta = pi/8;
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
ui = [1; -2];
ui_proj = ui*0.5;
%rotating
vert = R*[vertX;vertY];
vertX = vert(1,:);
vertY = vert(2,:);
ui = R*ui;
ui_proj = R*ui_proj;
close all;
%set(gcf, 'Position',  [100, 100, 450, 450]);
figure(1); hold on;
plot(vertX,vertY,'k','LineWidth',2.5);
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
quiver([0],[0],[ui(1)],[ui(2)],1,'linewidth',3, 'Color', blue);
text(1.4,-1.0,'$\frac{dv_i}{dt}$', 'Interpreter','latex','fontSize',30);
quiver([0],[0],[ui_proj(1)],[ui_proj(2)],1,'linewidth',3, 'Color', red);
text(0.7,-0.45,'$\hat{u}_i$', 'Interpreter','latex','fontSize',25);
box on;
text(-0.8,1.5,'$\frac{dv_{y}}{dt}$', 'Interpreter','latex','fontSize',30);
text(2.0,0.4,'$\frac{dv_{x}}{dt}$', 'Interpreter','latex','fontSize',30);
text(-1.6,-0.8,0,'$S(\theta_{i},s_i)$', 'Interpreter','latex','fontSize',25);
% center axis
plot([0,(vertX(3)+vertX(4))/2],[0,(vertY(3)+vertY(4))/2],'k.-','linewidth',1.2);
plot([0,(vertX(2)+vertX(3))/2],[0,(vertY(2)+vertY(3))/2],'k.-','linewidth',1.2);
h = text((vertX(3)+vertX(4))/4-0.4,(vertY(3)+vertY(4))/4+0.1,'$u_{s_{max}}$',...
    'Interpreter','latex','fontSize',25);
set(h,'Rotation',theta*(180/pi));
h = text((vertX(2)+vertX(3))/4-1.1,(vertY(2)+vertY(3))/4-0.3,...
    '$s_iu_{\theta_{max}}$', 'Interpreter','latex','fontSize',25);
set(h,'Rotation',theta*(180/pi));
% ploting angle arc
tt = 0:0.1:1.2*theta;
rr = 0.8;
plot(rr*cos(tt),rr*sin(tt),'k-','linewidth',1.2);
text(0.8,0.2,'$-\theta_{i}$', 'Interpreter','latex','fontSize',18);
axis equal;
%axis tight;
ax = gca; % use current axes
% axis lines
line([xmin,xmax], [0 0], 'Color', 'k','lineWidth',2);
line([0 0], [ymin,ymax], 'Color', 'k','lineWidth',2);
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
% the arrows
xO = 0.2;  
yO = 0.1;
xmax = xmax + xO;
ymax = ymax + yO;
%
patch([xmax-xO -yO; xmax-xO +yO; xmax 0.0], ...
    [yO ymax-xO; -yO ymax-xO; 0 ymax], 'k', 'clipping', 'off');
set(gca, 'visible', 'off');
axis tight;
