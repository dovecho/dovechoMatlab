function [cp, t] = lfmPulseCompress(ref, meas, fs, window, isplot)
%LFMPULSECOMPRESS compress pulses with linear frequency modulated wave
%   LFMPULSECOMPRESS(REF, MEAS, FS) calculate the convolution (pulse
%   compress) between REF and MEAS, using FFT-IFFT method under a sampling
%   rate of FS.
%
%   LFMPULSECOMPRESS(REF, MEAS, FS, WINDOW) calculate the compressed
%   waveform using a specified time-domain WINDOW, with the same size as
%   REF and MEAS. If WINDOW = 0, no window will be added.
% 
%   LFMPULSECOMPRESS(..., ISPLOT) can control the plot funcitons. Function
%   will plot waveforms when ISPLOT = 1, and ignore all plot operations
%   when ISPLOT = 0.
% 
%   [CP, T] = LFMPULSECOMPRESS(...) returns the compressed waveform CP and
%   the corresponding time vector T.

%
%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: Update some comments
%   $Version: 1.0.1 $	$Date: 2017-02-01 21:09:29 $

narginchk(3,5);

if nargin < 5
    isplot = 1;
end

if nargin == 3
    window = ones(size(ref));
elseif window == 0
    window = ones(size(ref));
end

%% Check input format
% REF, MEAS and WINDOW must be vectors with the same length

%% 时域特征
L = max(size(ref));
t = (0:L-1)/fs;          % 脉冲的时间基    

%% 频域特征
% * 参考波形幅度谱

f = fs/2*linspace(0,1,L/2+1);   % FFT分析的频率基
REFWave = fftshift(fft(hilbert(ref)));

%% 
% * 待测波形加窗幅度谱
MEASWave = fftshift(fft(hilbert(meas.*window)));

%% 脉冲压缩
% * 不加窗的脉冲压缩，即矩形窗
PCWave = MEASWave.*(conj(REFWave));
cp = fftshift(ifft(PCWave));
mag_pc_data = mag2db(abs(cp)/length(cp));

%% Plot figures
if isplot == 1
    % Spectrogram for input waveform to be compressed
    set(gcf, 'Outerposition', [100,100,510,300]);
    spectrogram(ref,kaiser(2^nextpow2(L/500),6),round(L/1000),2^nextpow2(L/100),fs,'yaxis');
    title('Reference Waveform');
    spectrogram(meas,kaiser(2^nextpow2(L/500),6),round(L/1000),2^nextpow2(L/100),fs,'yaxis');
    title('Waveform to be Compress');snapnow;

    % Frequency domain figures
    plot(f/1e9,2*abs(REFWave(L/2:end)));
    xlabel('Frequency (GHz)');ylabel('|S(f)|');
    plot(f/1e9,2*abs(MEASWave(L/2:end)));
    xlabel('Frequency (GHz)');ylabel('|S(f)|');

    % Compressed waveform
    set(gcf, 'Outerposition', [100,100,340,300]);
    % Full range
    plot((t-mean(t)-0.5/fs)*1e6, mag_pc_data);
    ylabel('Normalized Amplitude');xlabel('Time (\mus)'); 
    title('Full range');axis tight;snapnow;

    % show tighter range
    plot((t-mean(t)-0.5/fs)*1e9, mag_pc_data);
    ylabel('Normalized Amplitude');xlabel('Time (ns)'); 
    range=0; scale = 5;
    xlim([-1 1]*scale+range);ylim([-60 0]+max(mag_pc_data))
    title('Closer look');drawnow;snapnow;
    %
    range=0; scale = 0.5;
    xlim([-1 1]*scale+range);ylim([-6 0]+max(mag_pc_data));grid on;
    title('Closer look');drawnow;snapnow;
end
