function tm = simulateMultiVehicle(recordVideo, saveFigures, extraArgs)
% Simulates 2 quadrotors avoiding each other
rng(2);

addpath('..');


if nargin < 3
  extraArgs = struct();
end

% ---- Setting Extra Parameters ----

if isfield(extraArgs,'N')
    N = extraArgs.N;
else
    N = 16;
end


if isfield(extraArgs,'domainType')
    domainType = extraArgs.domainType;
else
    domainType = 'diamond';
end

if isfield(extraArgs,'vd')
    vd = extraArgs.vd;
else
    vd = @(t) [0;0];
end



if isfield(extraArgs, 'initialConfig')
    initialConfig = extraArgs.initialConfig;
else
    initialConfig = 'square'; % line
end

if isfield(extraArgs,'c_al')
    c_al = extraArgs.c_al;
else
    c_al = 1;
end

if isfield(extraArgs,'l_al_decay')
    %l_al_decay is the proportion of c_al that will be applied at r_d, e.g
    %0.5 means at rd the alignment force is 0.5 c_al.
    l_al_decay = extraArgs.l_al_decay;
else
    l_al_decay = 1;
end

if isfield(extraArgs, 'a_I')
    a_I = extraArgs.a_I;
else
    a_I = 2;
end

if isfield(extraArgs, 'a_h')
    a_h = extraArgs.a_h;
else
    a_h = 3;
end

if isfield(extraArgs, 'a_v')
    a_v = extraArgs.a_v;
else
    a_v = 2;
end

if isfield(extraArgs, 'tMax')
    tMax = extraArgs.tMax;
else
    tMax = 160;
end

if ~isfield(extraArgs, 'tailSize')
    extraArgs.tailSize = 50;
end
    

% screenShotsCount = 50;

% ---- Traffic Manager ----
tm = TM;
% setup speed limit
tm.speedLimit = 50;%10
% collision radius
tm.cr = 1;
% safety time (it will be safe during the next st seconds)
tm.safetyTime = 5;
% maximum force for vehicles
tm.uMax = 3;
% domain desired velocity
tm.vd = vd(0);
% inter vehicle alignement strength
tm.c_al = c_al;
% l_al decay, i.e. proportion of c_al that will be applied at r_d
tm.l_al_decay = l_al_decay;
% inter vehicle non zero slope
tm.a_I = a_I;
% vehicle domain non zero slope
tm.a_h = a_h;
% vehicle domain aligment stregth
tm.a_v = a_v;


% compute reachable set: It is not necessary as we can work with the
% analytical solution
% tm.computeRS('qr_qr_safe_V_circle');

% domain setup
switch domainType
    case 'circle'
        r = 10;
        ns = 100;
        t = linspace(0, 2*pi*(1-1/ns), ns);
        vertX = r * 50 * sin(t);
        vertY = r * 50 * cos(t);
    case 'diamond'
        r = 1;
        vertX = [-50, 0, 50, 0];
        vertY = [0, 80, 0, -80]*r;
    case 'square'
        r = 0.5;
        vertX = [-50,-50, 50, 50]*r;
        vertY = [-50, 50, 50, -50]*r;
    case 'L'
        vertX = [-50, 50, 50, 0, 0, -50];
        vertY = [-50, -50, 0, 0, 50, 50];
    case 'polygon'
        vertX = -[-50, 50, 0, 0];
        vertY = -[-50, 0, 0, 50];
    case 'triangle'
        ns = 3;
        t = linspace(0, 2*pi*(1-1/ns), ns);
        vertX = 5 * sin(t);
        vertY = 5 * cos(t);
    case 'pentagon'
        ns = 5;
        t = linspace(0, 2*pi*(1-1/ns), ns);
        vertX = 50 * sin(t);
        vertY = 50 * cos(t);
    case 'trianglePaper'
        r = 0.3;
        ns = 3;
        t = linspace(0, 2*pi*(1-1/ns), ns);
        vertX = 50 * sin(t)*r;
        vertY = 50 * cos(t)*r;
        vertY = vertY - (max(vertY)+min(vertY))/2;
    case 'triangleSmallPaper'
        r = 0.3*0.5;
        ns = 3;
        t = linspace(0, 2*pi*(1-1/ns), ns);
        vertX = 50 * sin(t)*r;
        vertY = 50 * cos(t)*r;
        vertY = vertY - (max(vertY)+min(vertY))/2;
    case 'squarePaper'
        r = 0.20;
        vertX = [-50,-50, 50, 50]*r;
        vertY = [-50, 50, 50, -50]*r;
    case 'arrowPaper'
        r = 0.3;
        vertX = r*[50, -50, 0, 0];
        vertY = r*[50, 0, 0, -50];
        %safetyTime = 5;
        %tm.speedLimit = 10;
        %N=9;
        %extraArgs.tailSize = -1;
end

domain = TargetDomain(vertX, vertY);
tm.addDomain(domain);

% figure setup
f = figure;
domain.domainPlot('blue', 'red');
hold on;
f.Children.FontSize = 16;
f.Position(1:2) = [100 100];
f.Position(3:4) = [750 750];
f.Color = 'white';
scale = 2;
xlim([min([vertX,vertY]) max([vertX,vertY])]*scale);
ylim([min([vertX,vertY]) max([vertX,vertY])]*scale);

title('t=0');
axis square;

% ---- Quadrotors ----
if strcmp(initialConfig,'line')
    px = linspace(-30,30,N)';
    py = -15*ones(N,1);
elseif strcmp(initialConfig, 'arrowPaper')
    xx = linspace(-10,10,N);
    px = xx-10;
    py = -1*xx-10;
elseif strcmp(initialConfig, 'random')
    px = -10 * rand(N,1);
    py = -10 * rand(N,1);
elseif strcmp(initialConfig, 'square')
    s = 1;
    px = 15*(mod(0:15,4)/3-0.5)+s*rand(1,16);
    py = 15*(floor([0:15]/4)/3-0.5)+s*rand(1,16);
end
vx = 0.01 * rand(N,1);
vy = 0.01 * rand(N,1);

% registering vehicles in traffic manager
uMin = -tm.uMax;
uMax = tm.uMax;

for j = 1:length(px)
  q = UTMQuad4D([px(j) vx(j) py(j) vy(j)], uMin, uMax, tm.speedLimit);
  tm.regVehicle(q);
end

% plotting initial conditions
colors = lines(length(tm.aas));
for j = 1:length(tm.aas)
  extraArgs.Color = colors(j,:);
  extraArgs.ArrowLength = 1; %j prev 1
  extraArgs.LineStyle = 'none';
  extraArgs.LineWidth = 0.1; %j
  tm.aas{j}.plotPosition(extraArgs);
end

drawnow

% Time integration
tm.dt = 0.1;
t = 0:tm.dt:tMax;



u = cell(size(tm.aas));
for i = 1:length(t)
  vert = [vertX;vertY];
%   thet a_d = 0;
%   vert = [cos(theta_d) -sin(theta_d); sin(theta_d) cos(theta_d)] * vert + domainPath(t(i));
  domain = TargetDomain(vert(1,:), vert(2,:));
  cla;
  domain.domainPlot('yellow', 'blue');
  f.Color = 'white';
  axis square;
  tm.addDomain(domain);
  tm.vd = vd(t(i));
  disp(['time: ', num2str(t(i))])
%   [safe, uSafeOptimal] = tm.checkAASafety;
  uCoverage = tm.coverageCtrl;
  
  for j = 1:length(tm.aas)
      u{j} = uCoverage{j};
    tm.aas{j}.updateState(u{j}, tm.dt);
    extraArgs.Color = colors(j,:);
     tm.aas{j}.plotPosition(extraArgs);
  end
  title(['t=' num2str(t(i))])
  drawnow;
 
end


end