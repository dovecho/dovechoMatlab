function h = plotSemilogXTrace(x, y, ysmooth, carrierData, decTable, integralInfo)
%PLOTSEMILOGXTRACE plot trace figure with semilog X axis
%   PLOTSEMILOGXTRACE(X, Y) plots semilog trace with frequency X and 
%   amplitude Y.
% 
%   PLOTSEMILOGXTRACE(X, Y, YSMOOTH) plots the smoothed trace, when
%   YSMOOTH = 1, and ignore the smooth plot when YSMOOTH = 0. Also, the
%   smoothed trace can be plotted using given data when YSMOOTH is a vector
%   with the same size as X and Y.
% 
%   PLOTSEMILOGXTRACE(X, Y, YSMOOTH, CARRIERDATA) titled the figure with 
%   carrier information stored in CARRIERDATA, with the format of 
%   [frequency,power]
% 
%   PLOTSEMILOGXTRACE(..., DECTABLE, INTEGRALINFO) furhter shows the decade
%   table and integral information that measured on the figure. 
% 
%   H = PLOTSEMILOGXTRACE(...) returns the handle of the figure
% 
%   See also SEMILOGX, PLOTPNTRACE, PLOTAMTRACE, PLOTBBTRACE
%
%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-01-28 19:12:18 $

narginchk(2,6);

% Plot ydata and ysmooth
if nargin == 2
    h = semilogx(x, y);
elseif nargin >= 3
    if ysmooth == 0
        h = semilogx(x, y);
    elseif ysmooth == 1
        ysmooth = pow2db(smooth(db2pow(y), 11));
        h = semilogx(x, y, x, ysmooth);
    elseif length(ysmooth) == length(x)
        h = semilogx(x, y, x, ysmooth);
    else
        error('PLOTPNTRACE: The SIZE of the smoothed trace, YSMOOTH, doesn''t equal XDATA!');
    end
end

% carrierData
if nargin >= 4
    if length(carrierData) == 2
        title(sprintf('Frequency: %sHz, Power: %.2f dBm',num2strEng(carrierData(1)), carrierData(2)));
    elseif carrierData == 0
    else
        error('PLOTPNTRACE: The SIZE of the carrier data, CARRIERDATA, must equals 2!');
    end
end

% decTable
if nargin >= 5
end

% integralInfo
if nargin == 6
end

xlabel('Offset Frequency (Hz)');


% set callback function when resizing the figure
set(gcf, 'ResizeFcn', @resizeXTickChange);

% Set xtick for the first time, parameters are useless
resizeXTickChange(0,0);

end

% ��Matlab���ڳߴ�仯ʱ����Ҫ���ݴ���XTick�ı仯ʵʱ����X������ı�ǩ
% ���磬�����ڱ��ʱ��XTick���{10e0, 10e2, 10e4...}��Ϊ{10e0, 10e1, 10e2...}
% ��ʱ��ǩҪ��Ӧ�Ĵ�{1Hz 100Hz 10kHz...}��Ϊ{1Hz 10Hz 100Hz...}

function resizeXTickChange(src, evt)
    ax = gca;
    ax.XTickLabelMode='auto';
    strTick = ax.XTickLabel;
    strNewTick = strTick;

    for itemp = 1 : length(strTick)
        tstr = strTick{itemp};
        tstr = num2strEng(10^sscanf(tstr(5:end),'%d'));
        strNewTick{itemp} = tstr;
    end
    
    ax.XTickLabel = strNewTick;
end