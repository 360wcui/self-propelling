function simulateSingleIntruderSigleVehicle(save_figures, fig_formats)
% Simulates 2 quadrotors avoiding each other

addpath('..');

if nargin < 1
  save_figures = false;
end

if nargin < 2
  fig_formats = {'png'};
end

%% TM
% ---- Traffic Manager ----
tm = TM;
% setup speed limit
tm.speedLimit = 10;
% collision radius
tm.cr = 2;
% safety time (it will be safe during the next st seconds)
tm.safetyTime = 3;
% maximum force for vehicles
tm.uMax = 3;
% compute reachable set
tm.computeRS('qr_qr_safe_optimized_dp');

% plot
f = figure;
%dm.lpPlot;
hold on

f.Children.FontSize = 16;
f.Position(1:2) = [200 200];
f.Position(3:4) = [1000 750];
f.Color = 'white';

%% Quadrotors
%(1 vehicles)
n = 1;
%r = 1;
r = 0.1;
xs = zeros(n,1);
ys = zeros(size(xs));
theta = -pi/2*rand;
v0 = 3;
vq = [v0 0];
vq = rotate2D(vq, theta);

% Main Vehicle
for j = 1:length(xs)
  q = UTMQuad4D([xs(j) vq(1) ys(j) vq(2)]);
  tm.regVehicle(q);
end

% Intruder
pin = r*[250 50];
vin = [v0 0];
vin = rotate2D(vin, 9*pi/8);
pin = rotate2D(pin, theta);
vin = rotate2D(vin, theta);
intruder = UTMQuad4D([pin(1) vin(1) pin(2) vin(2)]);
tm.regVehicle(intruder);

colors = lines(length(tm.aas));
for j = 1:length(tm.aas)
  extraArgs.Color = colors(j,:);
  extraArgs.ArrowLength = 5;
  tm.aas{j}.plotPosition(extraArgs);
end

xlim([-50 200])
ylim([-200 50])
title('t=0')
axis square
drawnow

if save_figures
  fig_dir = [fileparts(mfilename('fullpath')) '\' mfilename '_figs'];
  if ~exist(fig_dir, 'dir')
    cmd = ['mkdir ' fig_dir];
    system(cmd)
  end
  
  for ii = 1:length(fig_formats)
    if strcmp(fig_formats{ii}, 'png')
      export_fig([fig_dir '/0'], '-png', '-m2', '-transparent')
    end
    
    if strcmp(fig_formats{ii}, 'pdf')
      export_fig([fig_dir '/0'], '-pdf', '-m2', '-transparent')
    end
    
    if strcmp(fig_formats{ii}, 'fig')
      savefig([fig_dir '/0.fig']);
    end
  end
end

%% Integration
tMax = 50;
t = 0:tm.dt:tMax;

u = cell(size(tm.aas));
for i = 1:length(t)
  disp(['time:', num2str(t(i))]);
  [safe, uSafeOptimal] = tm.checkAASafety;
  safe(length(tm.aas)) = 1;
  for j = 1:length(tm.aas)
    if safe(j)
      u{j} = controlLogic(tm, tm.aas{j});
    else
      u{j} = uSafeOptimal{j};
    end
    
    tm.aas{j}.updateState(u{j}, tm.dt);
    tm.aas{j}.plotPosition;
    
  end
    
  title(['t=' num2str(t(i))])
  drawnow

  if save_figures
    for ii = 1:length(fig_formats)
      if strcmp(fig_formats{ii}, 'png')
        export_fig([fig_dir '/' num2str(i)], '-png', '-m2', '-transparent')
      end

      if strcmp(fig_formats{ii}, 'pdf')
        export_fig([fig_dir '/' num2str(i)], '-pdf', '-m2', '-transparent')
      end

      if strcmp(fig_formats{ii}, 'fig')
        savefig([fig_dir '/' num2str(i) '.fig']);
      end
    end
  end
end

%tm.printBreadthFirst;
end

function u = controlLogic(tm, veh)
if strcmp(veh.q, 'Free')
  u = [0; 0];
  return
end
end
