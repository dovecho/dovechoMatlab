function writeXilinxCOEFile(fname, data, width)
%WRITEXILINXCOEFILE  Write to COE formatted file for XILINX FPGA
%   WRITEXILINXCOEFILE(FNAME, DATA) converts the DATA vector to ASCII and
%   write to COE file with specified file fomrat that can be directly
%   imported by XILINX FPGA, for example, the ROM or RAM.
% 
%   WRITEXILINXCOEFILE(FNAME, DATA, WIDTH) convert the binary sequence DATA
%   to the COE format with specified data WIDTH. While converting, the DATA
%   is firstly parallelized according to WIDTH with MSB first order. Then
%   convert the WIDTH-bit binary vector to decimal, and write to COE file.

%   Copyright (c) 2012 - 2017, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: New function
%   $Version: 1.0 $	$Date: 2017-01-28 17:17:11 $

% Check number of input arguments
narginchk(2,3);

% Convert binary sequence DATA to decimal vector
if nargin == 3
    if width ~= 8 && width ~= 16 && width ~= 32 && width ~= 64
        error('WIDTH must be 8, 16, 32 and 64');
    end
    
    if mod(length(data), width) ~= 0
        error('DATA size must be integral multiples of WIDTH.');
    end

    dataWord = reshape(data, [length(data)/width, width]);
    datavec  = uint32(bin2dec(dataWord));
        
else
    datavec = data;
end

%% Write data for XILINX data import format
fid = fopen([fname '.coe'], 'w');

% file header
fwrite(fid, sprintf('memory_initialization_radix=10;\n'));
fwrite(fid, sprintf('memory_initialization_vector = \n'));
% file content
for jj = 1 : (length(datavec)-1)
    fwrite(fid, sprintf('%d,\n', datavec(jj)));
end
% last line of file
fwrite(fid, sprintf('%d;\n', datavec(length(datavec))));

fclose(fid);