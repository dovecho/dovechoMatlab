function [xpre f] = lfmPrecompensate(ref, meas, fs)
%LFMPRECOMPENSATE calculate pre-compensated LFM signal 
%   LFMPRECOMPENSATE(REF, MEAS, FS) calculate pre-compensated LFM signal,
%   according to reference signal REF and measured (distorted) signal MEAS,
%   using FFT. FS is the time-domain sampling rate.
% 
%   In time domain, y(t) = x(t) * h(t), is the measured, or distorted
%   signal, generated from the ideal reference x(t) and the non-ideal
%   transfer function h(t) of any system. To pre-correct the non-ideal
%   transfer function h(t) and generate pure and ideal LFM signal, one need
%   to calculate the desired x'(t) that satisfy x(t) = x'(t) * h(t).
% 
%   It is often calculated in frequency domain, where Y(w) = X(w)H(w), and
%   X(w)=X'(w)H(w). We can find that X'(w) = X(w)^2 / Y(w). So we can
%   calculate x'(t).
% 
%   [XPRE F] = LFMPRECOMPENSATE(...) returns the pre-compensated signal
% 
%   See also, LINEARFM, LFMPULSECOMPRESS, PULSEANALYSIS

%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-02-01 20:37:22 $

narginchk(3,3);

% ToDo: Check vector size between ref and meas

% Parameters for caluclation
L = length(ref);
FFTLength = 2^nextpow2(L);
f = fs/2*linspace(0,1,FFTLength/2+1);   % FFT分析的频率基

% Calculate FFT of input
X = fft(([ref;zeros(FFTLength-L,1)]), FFTLength);
Y = fft(([meas;zeros(FFTLength-L,1)]), FFTLength);

% Calculate pre-compensated signal
XPRE = X.*X./Y;

% Time domain signal
xpre = ifft((XPRE));
xpre = real(xpre(1:L));
% plot(xpre);