function filtwave = myIQdemod(iqwave, fc, fs, fbw, fsdown)


[r,c]=size(iqwave);
if r*c == 0,
    iqwave = []; return
end
if (r==1),   % convert row vector to column
    iqwave = iqwave(:);  len = c;
else
    len = r;
end

% timebase of the LFM wave
t = ((1 : len)-1)'./fs;
t_ref = t(:,ones(1,size(iqwave,2)));

%%
narginchk(3,5);

if nargin == 3
    flpf = fc/2;
else
    if fbw > fc/2
%         error('FBW should be < fc/2.');
    end
    flpf = fbw;
end

if nargin < 5
    fsdown = fs;
end

% LO for demod at frequency f0
sinWave = sin(2*pi*fc*t_ref);
cosWave = cos(2*pi*fc*t_ref);

% Generate I and Q wave
iwave = cosWave .* iqwave;
qwave = sinWave .* iqwave;

if nargin > 3
    % Generate low pass filter of the I/Q wave 
    hlpf = lpf4lfm(fs, flpf * 1.05, flpf * 1.25);

    ifilt = filter(hlpf, iwave);
    qfilt = filter(hlpf, qwave);
    filtwave = ifilt + 1j .* qfilt;
else
    filtwave = iwave + 1j .* qwave;
end
%% build complex baseband signal, I + jQ

if nargin == 5
    filtwave = resample(filtwave, fsdown, fs);
end


end

function Hd = lpf4lfm(Fs, Fpass, Fstop)
% All frequency values are in Hz.
% Fs = 40000000000;  % Sampling Frequency

% Fpass = 2100000000;      % Passband Frequency
% Fstop = 2500000000;      % Stopband Frequency
Dpass = 0.011512416822;  % Passband Ripple
Dstop = 0.01;            % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);
end
