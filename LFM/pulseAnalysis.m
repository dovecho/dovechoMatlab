function [pks, locs, w, p] = pulseAnalysis(y, fs, varargin)
%PULSEANALYSIS analyze the compressed pulse
%   PULSEANALYSIS(Y, FS) analyze the compressed pulse Y with sampling rate
%   FS. By default, time vector T is calculated internally.
% 
%   PULSEANALYSIS(Y, FS, T) analyze the waveform with given time vector T. 
% 
%   This function will find the compressed peaks

%
%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-01-28 20:10:40 $

% narginchk(2,4);

L = max(size(y));

% if nargin == 2
    t = (0:L-1)/fs;
    t = (t-mean(t)-0.5/fs);
% end

dby = mag2db(abs(y)/length(y));

% if nargin == 2
%     MPH = -30;
%     MPD = 1e-9;
% elseif nargin == 3
%     MPH = -abs(level);
%     MPD = 1e-9;
% elseif nargin == 4
%     MPH = -abs(level);
%     MPD = mptd;
% end
% 
%#function dspopts.findpeaks
defaultMinPeakHeight = -inf;
defaultMinPeakProminence = 0;
defaultMinPeakWidth = 0;
defaultMaxPeakWidth = Inf;
defaultMinPeakDistance = 0;
defaultThreshold = 0;
defaultNPeaks = [];
defaultSortStr = 'descend';
defaultAnnotate = 'peaks';
defaultWidthReference = 'halfprom';

p = inputParser;
addParameter(p,'MinPeakHeight',defaultMinPeakHeight);
addParameter(p,'MinPeakProminence',defaultMinPeakProminence);
addParameter(p,'MinPeakWidth',defaultMinPeakWidth);
addParameter(p,'MaxPeakWidth',defaultMaxPeakWidth);
addParameter(p,'MinPeakDistance',defaultMinPeakDistance);
addParameter(p,'Threshold',defaultThreshold);
addParameter(p,'NPeaks',defaultNPeaks);
addParameter(p,'SortStr',defaultSortStr);
addParameter(p,'Annotate',defaultAnnotate);
addParameter(p,'WidthReference',defaultWidthReference);
parse(p,varargin{1:end});
Ph = -abs(p.Results.MinPeakHeight);
Pp = p.Results.MinPeakProminence;
Wmin = p.Results.MinPeakWidth;
Wmax = p.Results.MaxPeakWidth;
Pd = p.Results.MinPeakDistance;
Th = p.Results.Threshold;
Np = p.Results.NPeaks;
Str = p.Results.SortStr;
Ann = p.Results.Annotate;
Ref = p.Results.WidthReference;


[zz1, zz2, w, p] = findpeaks(abs(y)/length(y),  'SortStr', 'descend', 'MinPeakHeight', db2mag(Ph), ...
    'MinPeakDistance', Pd*fs, 'NPeaks', Np);

[pks, locs] = findpeaks(dby,  'SortStr', 'descend', 'MinPeakHeight', Ph, ...
    'MinPeakDistance', Pd*fs, 'NPeaks', Np);
Npks = length(pks);

% Print result 
fprintf('============================================\n')
fprintf('The first %d peaks at %d dB level\n', Npks, Ph);
fprintf('--------------------------------------------\n')
fprintf('\tid\tTime (ns)\tPos (m)\t\tPwr(dB)  \tFWHM (ns)\tProm.\n');
for ipk = 1 : Npks
    if ipk == 1
        fprintf('\t%2d\t%+.5f\t%+.5f\t%+.3f  \t%+.3f\t\t%+.3f\n', ipk, ...
            t(locs(ipk))*1e9, t(locs(ipk))*3e8, pks(ipk), w(ipk)*1e9/fs, p(ipk));
    else
        fprintf('\t%2d\t%+.5f\t%+.5f\t%+.3f  \t%+.3f\t\t%+.3f Rel.1\n', ipk, ...
            t(locs(ipk))*1e9, t(locs(ipk))*3e8, pks(ipk), w(ipk)*1e9/fs, p(ipk)/p(1));
    end
end
fprintf('============================================\n')

% plot full range
% findpeaks(dby, t*1e6,  'SortStr', 'descend', 'MinPeakHeight', MPH);
% xlabel('Time (\mus)');ylabel('Norm Amplitude (dB)');

% plot subrange around maxima peak
r1 = min(locs)-500;r2 = max(locs)+500;
findpeaks(dby(r1:r2), t(r1:r2)*1e9,  'SortStr', 'descend', ...
    'MinPeakHeight', Ph, 'MinPeakDistance', Pd*1e9, 'NPeaks', Np);
xlabel('Time (ns)');ylabel('Norm Amplitude (dB)');
ylim([-100, 10]);
text(t(locs(1))*1e9+2e7*(t(r2)-t(r1)), pks(1), sprintf('%.3f',pks(1)) );
% 
