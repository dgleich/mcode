function flag=strstartswith(str,prefix,varargin)
% STRSTARTSWITH Determine is a string starts with a prefix
%   STRSTARTSWITH(STR,PREFIX) is 1 if PREFIX is the set of
%   leading characters for string STR.  The function
%   returns 0 otherwise.
%
%   STRSTARTSWITH(STR,PREFIX,'ignorecase') or
%   STRSTARTSWITH(STR,PREFIX,1) does the comparison to be
%   done in a case insensitive manner.
%
%   See also STRENDSWITH
%   

% David F. Gleich, Copyright 2009
% University of British Columbia

% History
% :2009-12-09: Initial coding.  This function is inspired by
%   python's str.startswith/endswith functions

if nargin<3, sensitive=true; 
elseif varargin{1}==1 || strcmpi(varargin{1},'ignorecase'), sensitive=false;
end

if sensitive
    flag=strncmp(str,prefix,length(prefix));
else
    flag=strncmpi(str,prefix,length(prefix));
end
