function [x,inds]=sample(e,n,varargin)

% 2008-08-18: Fixed bug with picking first and last elements with unequal
% probabilities

N = numel(e);

opts = []; for i=1:2:length(varargin), opts.(varargin{i}) = varargin{i+1}; end
if ~isfield(opts,'prob'), p = ones(N,1); else p = opts.prob; end
if ~isfield(opts,'replace'), opts.replace = true; end

p = abs(p(:));
p = p/csum(p);
pt = [0; cumsum(p)];

rp = opts.replace;
if ~rp && n>N, 
  error('sample:argError','only N=%i samples allowed without replacement',N); end
if ~rp && n>0.1*N,
  warning('sample:inefficient','sampling without replacement is inefficient for %i/%i',n,N);
end

inds = zeros(1,n);

for i=1:n
  v = rand;
  % do a binary search to find the index
  l = 1; r = N+1;
  while l<r && ~(pt(l) <= v && v < pt(l+1))
    mid = l + ceil((r-l)/2);
    if pt(mid)>v, r=mid; else l=mid; end
  end
  ind = l;
  if rp
    inds(i) = ind;
  else
    if p(ind)<0, i=i-1; continue; end % already used this sample
    p(ind) = -1;
    inds(i) = ind;
  end
end
x = e(inds);
