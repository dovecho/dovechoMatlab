function [y t] = linearFMCorr (f1, f2, fs, t1, dt, dd, f)
%LINEARFMCORR  Linear FM generator with correction
%   Y = LINEARFMCORR(F1,F2,FS,T1) generates samples of a linear swept-frequency
%   signal from F1 Hertz to F2 Hertz at the sample rate of FS samples per
%   second. T1 has two possible meanings: 
%       1) T1 <= MAX_T1, which is 31 by default, is the duration time,
%       2) T1 > MAX_T1, is the total sample points of the waveform.
%
%   Y = LINEARFMCORR(F1,F2,FS,T1,DT) generates signal with adding '0' at the
%   end of the signal. DT controls the length of the '0' by two meanings:
%       1) DT <= MAX_DT, which is 15 by default, is the duration time of 0,
%       2) DT > MAX_DT, is the total sample points of the adding '0'.
%
%   Y = LINEARFMCORR(F1,F2,FS,T1,DT,DD,F) generates LFM waveform with
%   amplitude and phase correction DD and its corresponding frequency
%   indices F.
%
%   [Y T] = LINEARFMCORR(...) returns the signal Y as well as the time array T.
%
%   See also LINEARFM, CHIRP, GAUSPULS, SAWTOOTH, SINC, SQUARE.

%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-02-01 16:44:10 $

MAX_T0 = 31;
MAX_DT = 15;

narginchk(1,7);
if nargin == 6
    error('F should be given along with DD.')
end

if nargin<5, dt=0; end

if t1 > MAX_T0, pts = round(t1); t1 = pts/fs; else pts = round(fs*t1);  end
if dt > MAX_DT, ptsdt = round(dt); dt = ptsdt/fs; else ptsdt = round(fs*dt); end

if f1 > fs/2, error('F1 is greater than FS/2');end
if f2 > fs/2, error('F2 is greater than FS/2');end


% generate time base
t = linspace(0,t1,pts)';
fbase = f1 + (f2 - f1)/t1*t;

if nargin <= 5
    % method 1, direct generate
    y1 = cos(2*pi*fbase.*t);
    % method 2 using CHIRP function
    y2 = chirp(t,f1,t1,f2);
    
else
    % 暂时没用了……
    % calculate position in f for f1
    ind_f1U = find(f>f1,1,'first');
    ind_f1L = find(f<f1,1,'last');
    if ind_f1U - ind_f1L == 2
        ind_f1 = mean(ind_f1U, ind_f1L);
    else
        %hehe...
    end
    % calculate position in f for f2
    ind_f2U = find(f>f2,1,'first');
    ind_f2L = find(f<f2,1,'last');
    if ind_f2U - ind_f2L == 2
        ind_f2 = mean(ind_f2U, ind_f2L);
    else
        %hehe...
    end

    dd = dd(ind_f1:ind_f2-1);
    Ldd = length(dd);

    ddt = spline(1:Ldd, (dd), linspace(1,Ldd,length(t))');
%     plot(spline(1:Ldd, f(ind_f1:ind_f2-1), linspace(1,Ldd,length(t))),abs(ddtA),'.');
    plot(abs(dd));
    y0 = exp(2*1j*pi*fbase.*t) ./(ddt);
    y1 = real(y0);
end

y = [y1, zeros(1,ptsdt)];