function [n,x] = dhist(y)
% DHIST Discrete Histogram
%   [n,x] = dhist(y) returns the precise counts (n) for each discrete value 
%   x in y (dhist does not work for matrices at the moment).  That is
%   there are sum(y==x(i))=n(i).
%
%   dhist(y) produces a bar plot in the current axes.
%
%   See also HIST
%   

% TODO Check that y is discrete
y = y(:); % correct the shape

ymin = min(y);
ymax = max(y);

if (ymax-ymin)>2*numel(y)
    spaccum=true; % accumulate the entries into a sparse vector
else
    spaccum=false;
end    
yhist = accumarray(y-ymin+1,1,[],[],[],spaccum);
n = find(yhist)-1+ymin;
x = nonzeros(yhist);

if nargout==0
    bar(n,x);
    clear n x % prevent the return in this case
end

