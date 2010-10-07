function flag=strendswith(str,suffix,varargin)
% STRENDSWITH Determine is a string ends with a suffix
%   STRENDSWITH(STR,SUFFIX) is 1 if SUFFIX is the last set of
%   characters for string STR.  The function returns 0 otherwise.
%
%   STRENDSWITH(STR,SUFFIX,'ignorecase') or
%   STRENDSWITH(STR,SUFFIX,1) does the comparison to be
%   done in a case insensitive manner.
%
%   See also STRSTARTSWITH
%   

% David F. Gleich, Copyright 2009
% University of British Columbia

% History
% :2009-12-09: Initial coding.  This function is inspired by
%   python's str.startswith/endswith functions

if nargin<3, sensitive=true; 
elseif varargin{1}==1 || strcmpi(varargin{1},'ignorecase'), sensitive=false;
end

lensuf = length(suffix);
lenstr = length(str);
if lensuf>lenstr, flag=false; return; end

if sensitive
    for i=1:lensuf
        if suffix(i)~=str(lenstr-lensuf+i), flag = false; return; end
    end
    flag = true;
else
    for i=1:lensuf
        if lower(suffix(i))~=lower(str(lenstr-lensuf+i))
             flag = false; return;
        end
    end
    flag = true;
end
