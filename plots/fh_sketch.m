%% fh with local min
close all; clear all;
fontSize = 50;
rd = 3;
b = 1;
fh = @(h)1*(h+rd/2).*(h-(-b*rd/2)>=0);
xmin = -5; xmax=3; ymin=-0.3*rd; ymax=2*rd;
r = [xmin-1:0.005:xmax];
figure(1);hold on;
plot(r,fh(r),'k.','MarkerSize',15);
plot(r,fh(r),'k:','lineWidth',4);
axis([xmin xmax ymin ymax]);
axh = gca; % use current axes
%axis lines
line(get(axh,'XLim'), [0 0], 'Color', 'k', 'lineWidth', 2);
line([0 0], get(axh,'YLim'), 'Color', 'k', 'lineWidth', 2);
%lables
text(-5.0, ymax*0.9,'$f_{h}([[x-\partial x]])$','fontSize',fontSize*0.9, 'Interpreter','latex');
text(xmax*0, 0.55,'$[[x-\partial x]]$','fontSize',fontSize, 'Interpreter','latex');
text(-rd/2-1.0, 0.8,'-$\frac{r_{d}}{2}$','fontSize',fontSize*1.2, 'Interpreter','latex')
%text(-rd/2-2.5, 0.45,'-$h_{0}$','fontSize',fontSize, 'Interpreter','latex')
set(gca, 'visible', 'off');
% thight axis
outerpos = axh.OuterPosition;
ti = axh.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
axh.Position = [left bottom ax_width ax_height];
% the arrows
xO = 0.2;  
yO = 0.1;
xmax = xmax + xO;
ymax = ymax + yO;
%
patch([xmax-xO -yO; xmax-xO +yO; xmax 0.0], ...
    [yO ymax-xO; -yO ymax-xO; 0 ymax], 'k', 'clipping', 'off');
axis tight;