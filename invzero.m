function v = invzero(v)
% INVZERO Compute the inverse elements of a vector with zero entries.
%
% iv = invzero(v) 
%
%   iv is 1./v except where v = 0, in which case it is 0.
%

%
% invzero.m
% David Gleich
%
% Revision 1.00
% 19 Octoboer 2005
%

% sparse input are easy to handle
if (issparse(v))
    [m n] = size(v);
    [i j val] = find(v);
    val = 1./val;
    v = sparse(i,j,val,m,n);
    return;
end;

% so are dense input
 
% compute the 0 mask
zm = abs(v) > eps(1);

% invert all non-zeros
v(zm) = 1./v(zm);
