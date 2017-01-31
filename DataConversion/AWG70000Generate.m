function AWG70000Generate(fname, fs, x, m1, m2)
%AWG70000GENERATE generate MAT file for Tektronix AWG70000
%   AWG70000GENERATE(FNAME, FS, X) convert the data sequence X to MAT file
%   with sample rate of FS and export to file with FNAME. This file can be
%   directly imported by any AWG70000 series arbitary waveform generator.
%
%   AWG70000GENERATE(..., M1) write to MAT file with M1 for both Marker1
%   and Marker2.
% 
%   AWG70000GENERATE(..., M1, M2) write to MAT file with M1 for Marker1 and
%   M2 for Marker2.
% 
%   Note that M1 and M2 should be UINT8

%
%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-01-28 19:02:08 $

narginchk(3,5);



if nargin == 3 % no marker
elseif nargin == 4 % with marker
    Waveform_M1_1 = m1; %already uint8 array 
    Waveform_M2_1 = m1;
elseif nargin == 5
    Waveform_M1_1 = m1; %already uint8 array 
    Waveform_M2_1 = m2;
end

Waveform_Name_1 = fname; 
Waveform_Data_1 = double( x ); %already a double array 
Waveform_Sampling_Rate_1 = fs;


save(sprintf('WFM_%s_%d.mat', Waveform_Name_1, round(fs/1e9)), '*_1', '-v7.3'); % MAT 7.3 Can save > 2GB 
 
