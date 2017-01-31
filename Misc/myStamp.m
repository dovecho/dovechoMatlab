function strStamp = myStamp(varargin)
%myStamp   To generate editing and revising information
%   myStamp(revSTR, VER) print revision string revSTR and version number
%   VER to screen with default author name.
%
%   myStamp(revSTR, VER, fid) print revision string revSTR and version number
%   VER to a file handled by FID, with default author name.
%
%   myStamp(revSTR, VER, fid, authorName) print revision string revSTR and version number
%   VER to a file handled by FID, with specified author name.
%
%   revSTR STRing that contains revising information
%   VER Version in 'x.x.x.x' format

%   Copyright (c) 2012 - 2015, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: Change print methof of YEAR due to MATLAB updates
%   $Version: 1.3 $	$Date: 2015-11-19 22:00:55 $

if nargin == 2
    revSTR = varargin{1};
    ver = varargin{2};
    fid = 1;
    strAuthorName = 'Shangyuan Li';
elseif nargin == 3
    revSTR = varargin{1};
    ver = varargin{2};
    fid = varargin{3};
    strAuthorName = varargin{3};
elseif nargin == 3
    revSTR = varargin{1};
    ver = varargin{2};
    fid = varargin{3};
    strAuthorName = varargin{4};
else
    error('Please refer to function usage!');
end


strStamp = sprintf('%%\n');
strStamp = [strStamp sprintf('%%   Copyright (c) 2012 - %s, LONMP, Tsinghua University,\n', datestr(now, 'YYYY'))];
strStamp = [strStamp sprintf('%%   Written by %s,\n', strAuthorName)];
strStamp = [strStamp sprintf('%%\n')];

strStamp = [strStamp sprintf('%%   Revision Note: %s\n', revSTR)];
strStamp = [strStamp sprintf('%%   $Version: %s $\t', ver)];
strStamp = [strStamp sprintf('$Date: %s $\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'))];

fprintf(fid, '%s', strStamp);
