%% fI
close all; clear all;
fontSize = 50;
rd = 2;
fI = @(r)1*(r-rd).*(r-rd<0);
xmin = -2; xmax=7; ymin=-1.5*rd; ymax=0.8*rd;
r = [0:xmax];   
figure(1);
plot(r,fI(r),'k','lineWidth',4);
axis([xmin xmax ymin ymax]);
axh = gca; % use current axes
% axis lines
line(get(axh,'XLim'), [0 0], 'Color', 'k','lineWidth',2);
line([0 0], get(axh,'YLim'), 'Color', 'k','lineWidth',2);
% labels
text(xmax*0.95, -0.25,'$x$','fontSize',fontSize, 'Interpreter','latex');
text(rd, -0.35,'$r_{d}$','fontSize',fontSize, 'Interpreter','latex');
text(-2.0, ymax*0.8,'$f_{I}(x)$','fontSize',0.9*fontSize, 'Interpreter','latex');
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