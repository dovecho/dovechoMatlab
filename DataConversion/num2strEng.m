function xstr = num2strEng(x,varargin)
%NUM2STRENG(x,[n]) Convert data to engineering noted numbers
% XSTR = NUM2STRENG(x) Converts the vector of numbers in x to a string array with mantissa and
% metric prefix, e.g. 1e-10 -> '100 p'
%
% Numbers out of the range 1e-24 <= x < 1e27 are left unscaled
% Enforces a column result
%
% XSTR = NUM2STRENG(x, n) Convert data with an optionally specify length n for 
% num2str. For example, 

prefices={'Y','Z','E','P','T','G','M','k','','m','\mu','n','p','f','a','z','y'};

x=x(:);
logx=log10(x);
logbase=3*floor(logx/3);

inrange=(logbase>=-24)&(logbase<=24);
logbase(~inrange)=0;

ibase=1-(logbase-24)/3; %

if length(varargin)==1,
    n=varargin{1};
else
    n=-1;
end

xstr=[feval('num2str',x./10.^logbase,n) repmat(' ',length(x),1) strvcat(prefices{ibase})];



