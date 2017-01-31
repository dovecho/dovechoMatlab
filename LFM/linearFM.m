function [y t] = linearFM (f1, f2, fs, t0, dt)
%LINEARFM  Linear FM generator with adding 0
%   Y = LINEARFM(F1,F2,FS,T0) generates samples of a linear swept-frequency
%   signal from F1 Hertz to F2 Hertz at the sample rate of FS samples per
%   second. T0 has two possible meanings: 
%       1) T0 <= MAX_T0, which is 31 by default, is the duration time,
%       2) T0 > MAX_T0, is the total sample points of the waveform.
%
%   Y = LINEARFM(F1,F2,FS,T0,DT) generates signal with adding '0' at the
%   end of the signal. DT controls the length of the '0' by two meanings:
%       1) DT <= MAX_DT, which is 15 by default, is the duration time of 0,
%       2) DT > MAX_DT, is the total sample points of the adding '0'.
%
%   [Y T] = LINEARFM(...) returns the signal Y as well as the time array T.
%
%   See also CHIRP, GAUSPULS, SAWTOOTH, SINC, SQUARE.

%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-01-28 16:57:42 $

MAX_T0 = 31;
MAX_DT = 15;

error(nargchk(1,5,nargin,'struct'));

if nargin<5, dt=0; end

if t0 > MAX_T0, pts = round(t0); t0 = pts/fs; else pts = round(fs*t0);  end
if dt > MAX_DT, ptsdt = round(dt); dt = ptsdt/fs; else ptsdt = round(fs*dt); end

if f1 > fs/2, error('F1 is greater than FS/2');end
if f2 > fs/2, error('F2 is greater than FS/2');end


% generate signal
t = linspace(0,t0,pts);

% method 1, direct generate
f = f1 + (f2 - f1)/t0*t;
y1 = cos(2*pi*f.*t);
% method 2 using CHIRP function
y2 = chirp(t,f1,t0,f2);

% adding 0 at the end of the signal
y = [y2, zeros(1,ptsdt)];
