function [n,S,S2] = streamstats(n,S,S2,x)
% STREAMSTATS Update streaming stats
%
% Example:
%  s=[]; s2=[]; n=0; for i=1:100, [n,s,s2]=streamstats(n,s,s2,randn(1)); end
%  [mean,std] = streamstats(n,s,s2);

% execution cases: 
%   s,s2 are null or n=0 => init and process the current update
%   only 2 args => finalize

if nargin == 3 % this means we are in a finalize situation
  nsamples = n;
  n = S;
  S = sqrt(S2./(nsamples-1));
elseif nargin==4 % this means we are in an update or init situation
  if isempty(S) || isempty(S2) || n==0, % init
    n = 0; S=zeros(size(x)); S2=zeros(size(x));
  end
  n=n+1;
  D=x-S;
  S=S+D./n;
  S2=S2+D.*(x-S);
end
  


