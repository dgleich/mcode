function x=chebpts(N,varargin)
%CHEBPTS Compute a set of Chebyshev points on an interval
%
%The Chebyshev points (of the second kind) are defined on the interval
%[-1,1] by the equation (N+1 points)
%  x(i) = cos(pi*i/N) for i = 0:N.
%This function returns that set of points scaled to an arbitrary interval.
%
%x=chebpts(N) returns the N+1 Chebyshev points on [-1,1]
%x=chebpts(N,[a,b]) returns the N+1 Chebyshev points on [a,b]
%x=chebpts(N,[a,b],'falling'] returns N "half" Chebyshev points on [a,b] so
%    that [x(1)-x(end-1:-1:1) x] is a full set of 2N-1 Chebyshev points on
%    the interval [a-(b-a),b].  
%x=chebpts(N,[a,b],'rising'] returns N "half" Chebyshev points on [a,b] so
%    that [x x(1)+x(end-1:-1:1)] is a full set of 2N-1 Chebyshev points on
%    the interval [a,b+(b-a)].  
%x=chebpts(N,[a,b],'inner'] returns N "inner" Chebyshev points on (a,b) so
%    that [b x a] is a full set of N+3 Chebyshev points on [a,b]
%
% The 'rising' and 'falling' set correspond to the half set of Chebyshev
% points from the region [0,1] and [-1,0] respectively.
%
% Example: 
%   TODO
%

%
% History:
%   2007-07-02
%   Initial version based on cheb.m by Trefethen
%
%   2007-07-02
%   Handled rising and falling options
%   Reversed argument order


error(nargchk(1, 3, nargin, 'struct'));

ab = [-1 1];
ptset='none';

if length(varargin) == 1
    ab = varargin{1}; ab = ab(:);
elseif length(varargin) == 2
    ab = varargin{1}; ab = ab(:);
    ptset = varargin{2};
    switch ptset
        case 'full', 
        case 'rising', N = 2*N-1; case 'falling', N=2*N-1;
        case 'inner', N = N+2;
        otherwise, error('chebpts:unknownParameter',...
                '%s is not a valid Chebyshev point set',ptset);
    end
end

if N==0, x=1; return, end
x = cos(pi*(0:N)/N)'; % compute the set on [-1,1]
x=min(ab)+(ab(2)-ab(1))*(x+1)./2;

switch ptset
    case 'inner', x=x(2:end-1);
end