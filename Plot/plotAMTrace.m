function h = plotAMTrace(x, y, ysmooth, carrierData, decTable, integralInfo)
%PLOTAMTRACE plot trace figure for amplitude modulated noise
%   PLOTAMTRACE(X, Y) plots amplitude modulated noise trace with frequency
%   X and amplitude Y.
% 
%   PLOTAMTRACE(X, Y, YSMOOTH) plots the smoothed trace, when YSMOOTH = 1, 
%   and ignore the smooth plot when YSMOOTH = 0. Also, the smoothed trace
%   can be plotted using given data when YSMOOTH is a vector with the same 
%   size as X and Y.
% 
%   PLOTAMTRACE(X, Y, YSMOOTH, CARRIERDATA) titled the figure with carrier
%   information stored in CARRIERDATA, with the format of [frequency,power]
% 
%   PLOTAMTRACE(..., DECTABLE, INTEGRALINFO) furhter shows the decade
%   table and integral information that measured on the figure. 
% 
%   H = PLOTAMTRACE(...) returns the handle of the figure
% 
%   See also SEMILOGX, PLOTSEMILOGXTRACE, PLOTAMTRACE, PLOTBBTRACE

narginchk(2,6);

if nargin == 2
    ysmooth=0;
    carrierData=0;
    decTable=0;
    integralInfo=0;
elseif nargin == 3
    carrierData=0;
    decTable=0;
    integralInfo=0;
elseif nargin == 4
    decTable=0;
    integralInfo=0;
elseif nargin == 5
    integralInfo=0;
elseif nargin == 6
end

h = plotSemilogXTrace(x, y, ysmooth, carrierData, decTable, integralInfo);

ylabel('AM Noise (dBc)');

