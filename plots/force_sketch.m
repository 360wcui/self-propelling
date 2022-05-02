%% Forces sketch
clear all;
% vertX = [-sqrt(3)/2 0 sqrt(3)/2 -sqrt(3)/2];
% vertY = [-1/2, sqrt(3)/2 -1/2 -1/2];
vertX = [2, -2.0, -1.0 0, 2];
vertY = [-0.7, -0.7, 0.5, sqrt(3)/2, -0.7];
pi = [2,1];
pj = [0.05,2];

p3 = [-1,1];

close all;
%set(gcf, 'Position',  [100, 100, 450, 450]);
figure(1); hold on;
plot(vertX,vertY,'k','LineWidth',3);
[hi, x_proji,y_proji] = poly_dist(pi(1),pi(2),vertX,vertY);
[hj, x_projj,y_projj] = poly_dist(pj(1),pj(2),vertX,vertY);
s = 30;
plot(pi(1),pi(2),'.k','MarkerSize',s);
plot(pj(1),pj(2),'.k','MarkerSize',s);

plot(x_proji,y_proji,'.k','MarkerSize',s);
plot(x_projj,y_projj,'.k','MarkerSize',s);

plot([x_proji,pi(1)],[y_proji,pi(2)],'--k','LineWidth',3);
plot([x_projj,pj(1)],[y_projj,pj(2)],'--k','LineWidth',3);

plot([pi(1),pj(1)],[pi(2),pj(2)],'--k','LineWidth',3);
Hi=([x_proji,y_proji]-pi)/hi;
Hj=([x_projj,y_projj]-pj)/hj;
pij = pi-pj;
ui = Hi+0.2*pij;
uj = Hj-0.2*pij;
k = 0.5;
quiver([pi(1),pj(1)],[pi(2),pj(2)],k*[Hi(1),Hj(1)],k*[Hi(2),Hj(2)],0,'linewidth',3);

% quiver([pi(1)],[pi(2)],1.2*k*[ui(1) + 0.6],1.2*k*[ui(2)],0,'linewidth',3);

quiver([pi(1),pj(1)],[pi(2),pj(2)],1.2*k*[ui(1) + 0.6,0.5*(uj(1) - 1.2)],1.2*k*[ui(2),0.5* uj(2)],0,'linewidth',3);

quiver([pi(1),pj(1)],[pi(2),pj(2)],k*[pij(1),-pij(1)]/norm(pij),k*[pij(2),-pij(2)]/norm(pij),0,'linewidth',3);
%axis([-0.2,1.1,0.2,1.6])
%set(gca, 'visible', 'off');
box on;
text(pi(1),0.2+pi(2),'$p_i$', 'Interpreter','latex','fontSize',24);
text(pj(1),0.2+pj(2),'$p_j$', 'Interpreter','latex','fontSize',24);
text(-1+x_projj,y_projj,'$P_{\partial \Omega}(p_j)$', 'Interpreter','latex','fontSize',24);
text(0.15+x_proji,-0.05+y_proji,'$P_{\partial \Omega}(p_i)$', 'Interpreter','latex','fontSize',24);
text(0.05+pj(1),-0.6+pj(2),'-$\frac{h_{j}}{[[h_{j}]]}$', 'Interpreter','latex','fontSize',25);
text(-0.9+pi(1),-0.1+pi(2),'-$\frac{h_{i}}{[[h_{i}]]}$', 'Interpreter','latex','fontSize',25);
text(0.4+pi(1),0.1+pi(2),'$\frac{p_{ij}}{\left\Vert p_{ij}\right\Vert}$', 'Interpreter','latex','fontSize',28)
text(-1+pj(1),0.2+pj(2),'$\frac{p_{ji}}{\left\Vert p_{ji}\right\Vert}$', 'Interpreter','latex','fontSize',28)

text(pi(1),-0.6+pi(2),'$u_i$', 'Interpreter','latex','fontSize',25)
text(-0.7+pj(1),-0.3 + pj(2),'$u_j$', 'Interpreter','latex','fontSize',25)
text(-0.1,-0.2,0,'$\Omega$', 'Interpreter','latex','fontSize',35)
axis equal;
%axis tight;
ax = gca; % use current axes
% axis lines
%axis tight
%xlim(get(ax,'XLim')+[-0.2,0.5]);
%ylim(get(ax,'YLim')+[-0.2,0.35]);
grid on;
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
%axis tight;
set(gca, 'visible', 'off');
axis tight;