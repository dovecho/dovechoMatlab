function y = dbmean(x,dim)
%DBMEAN   Average or mean values in dB.
%   For vectors, DBMEAN(X) is the mean value of the elements in X of dB. 
%   For matrices, DBMEAN(X) is a row vector containing the mean value of
%   each column.  For N-D arrays, DBMEAN(X) is the mean value of the
%   elements along the first non-singleton dimension of X.
%
%   DBMEAN(X,DIM) takes the mean along the dimension DIM of X. 
%
%   Class support for input X:
%      float: double, single
%
%   See also MEAN, MEDIAN, STD, MIN, MAX, VAR, COV, MODE.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 5.17.4.5 $  $Date: 2010/09/02 13:35:22 $

%   Change from Matlab internal function MEAN
%
%   Copyright (c) 2012 - 2015, LONMP, Tsinghua University,
%   Written by Shangyuan Li,
%
%   Revision Note: Change Comments
%   $Version: 1.1 $	$Date: 2015-11-19 21:59:12 $

if nargin==1, 
    % Determine which dimension SUM will use
    dim = find(size(x)~=1, 1 );
    if isempty(dim), dim = 1; end
end
    
y = pow2db(mean(db2pow(x), dim));
