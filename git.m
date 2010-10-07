function git(varargin)
% GIT Evaluate the git command line function
%
% git just mirrors all the arguments to the system git command.  It's just
% a way of skipping typing "!" to prefix all git commands in matlab.
%
% Example:
%   git status
%   git ls-files
%   git add 


% History
% :2010-08-12: Initial coding, used code from strjoin to elminate
% dependence on strjoin.m

strs = varargin;
str = strs{1};
for i=2:length(strs)
    str=sprintf('%s %s',str,strs{i});
end

eval(['!git ' str])

