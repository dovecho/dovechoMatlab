function h = plotPNTrace(x, y, ysmooth, carrierData, decTable, integralInfo)
%PLOTPNTRACE plot trace figure for phase noise
%   PLOTPNTRACE(X, Y) plots phase noise trace with frequency X and amplitude Y.
% 
%   PLOTPNTRACE(X, Y, YSMOOTH) plots the smoothed trace, when YSMOOTH = 1, 
%   and ignore the smooth plot when YSMOOTH = 0. Also, the smoothed trace
%   can be plotted using given data when YSMOOTH is a vector with the same 
%   size as X and Y.
% 
%   PLOTPNTRACE(X, Y, YSMOOTH, CARRIERDATA) titled the figure with carrier
%   information stored in CARRIERDATA, with the format of [frequency,power]
% 
%   PLOTPNTRACE(..., DECTABLE, INTEGRALINFO) furhter shows the decade
%   table and integral information that measured on the figure. 
% 
%   H = PLOTPNTRACE(...) returns the handle of the figure
% 
%   See also SEMILOGX, PLOTSEMILOGXTRACE, PLOTAMTRACE, PLOTBBTRACE

%
%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: Move main function to plotSemilogXTrace
%   $Version: 1.1 $	$Date: 2017-01-28 19:41:26 $


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

narginchk(2,6);


h = plotSemilogXTrace(x, y, ysmooth, carrierData, decTable, integralInfo);
ylabel('Phase Noise (dBc)');
