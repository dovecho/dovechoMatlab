function [IIP3 OIP3]= PlotTOI(x, y1, y3, inRange1, inRange3, isPlot)

%% Plot Third Order Intermodulation
%PLOTTOI plot third order intermodulation
%   PLOTTOI(X, Y1, Y3) plot First order harmonic (FOH) and Third order
%   intermodulation (TOI).
%
%   PLOTTOI(..., INRANGE1, INRANGE3) select a specific data range in 
%   Y1 and Y3, to get a better layout, or under other consideration.
%
%   PLOTTOI returns third order input intermodulation point (IIP3) and 
%   third order output intermodulation point (OIP3).
%
%	Copyright (c) 2012, LONMP, Tsinghua University,
%	Written by Shangyuan Li,
%
%	Revision Note: Build of this file
%	$Version: 1.0.0.1 $	$Date: 2012-11-12 16:41:59 $


%% Input argument process

if nargin < 3
    error('Not enough input arguments.');
elseif nargin == 3
    subRange1 = 1 : length(y1);
    subRange3 = 1 : length(y3);
    isPlot = 1;
elseif nargin == 4
    subRange1 = inRange1;
    subRange3 = inRange1;
    isPlot = 1;
elseif nargin == 5
    subRange1 = inRange1;
    subRange3 = inRange3;
    isPlot = 1;
elseif nargin == 6
    subRange1 = inRange1;
    subRange3 = inRange3;
else
    error('Too many input arguments.');
end

%% Curve fitting and calculating

% Curve fitting using linear fit.
f = fittype({'x','1'},'coefficients',{'a','b'});

[c1,gof1] = fit(x(subRange1)', y1(subRange1)',f);   % 1st order curve
[c2,gof2] = fit(x(subRange3)', y3(subRange3)',f);   % 3rd order curve

% Calculate IIP3 and OIP3 according to fitted curve.
IIP3 = (c2.b-c1.b)/(c1.a-c2.a);
OIP3 = c2(IIP3);


%% Plotting
if (isPlot == 1)
    clf;

    % Plot data points
    hp0 = plot(x(subRange1), y1(subRange1), 'bs', x(subRange3), y3(subRange3), 'k^',...
        IIP3, OIP3, 'ro');
    hold on;

    % Set axis
    xlim([5*floor((min(x) - 5)/5), 5*ceil((IIP3+ 5)/5)]);
    ylim([5*ceil((min(y3) - 10)/5), 5*ceil((OIP3 + 10)/5)]);

    % Plot fitted curve
    hp2 = plot(c1, 'b');
    hp3 = plot(c2, 'r');

    % Set layout formats
    set ([hp2 hp3], 'linewidth', 1.5);
    set (hp0(1), 'MarkerFaceColor',[0.5,0.5,1],'MarkerSize',8);
    set (hp0(2), 'MarkerFaceColor',[1,0.5,0.5],'MarkerSize',8);
    set (gca, 'Box', 'On');
    set(gcf, 'PaperPosition', [2 1 12 8]);

    %% Annotation
    xlabel('Input power (dBm)');
    ylabel('Output power (dBm)');

%     [x1,y1] = dsxy2figxy(gca, IIP3, OIP3);
%     [x2,y2] = dsxy2figxy(gca, IIP3, OIP3-10);
% 
     text(IIP3, OIP3-3, sprintf('IIP3/TOI = %.1f dBm', IIP3), 'FontSize',10);
     text(IIP3, OIP3-8, sprintf('OIP3 = %.1f dBm', OIP3), 'FontSize',10);

    legend('Fundemental', '3rd order intermoduation distortion', 'IP3',...
        'Location', 'Best');

end % isPlot
%% Layout
hold off;
fprintf('IIP3: %.2f, OIP3: %.2f, c1.a: %.3f, c1.rs: %.5f, c2.a: %.3f, c2.rs: %.5f\n', IIP3, OIP3, c1.a, gof1.rsquare, c2.a, gof2.rsquare);
