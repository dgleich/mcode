function str=strjoin(strs,delimiters)
% STRJOIN Join a set of strings with a delimiter
%   STRJOIN(STRS) returns a string where each string 
%   from STRS is concatenated with a space in between.
%
%   STRJOIN(STRS,DELIMITER) returns a string where each string 
%   from STRS is concatenated with DELIMITER in between.
%

% David F. Gleich, Copyright 2009
% University of British Columbia

% History
% :2009-12-09: Initial coding.  This function is inspired by
%   python's join function

if nargin<2, delimiters=[]; end
%if isempty(delimiters), delimiters=' \n\t'; end

if length(strs)<1, str=''; return; end

str = strs{1};
if isempty(delimiters)
    for i=2:length(strs)
        str=sprintf('%s %s',str,strs{i});
    end
else
    for i=2:length(strs)
        str=sprintf('%s%s%s',str,delimiters,strs{i});
    end
end



