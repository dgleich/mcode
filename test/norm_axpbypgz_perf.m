%% Performance of normdiff vs. norm
function normdiff_perf(n,nrep)

if ~exist('n','var'), n=1e7; end
if ~exist('nrep','var'), nrep=15; end

s = randn('state');

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1); z = randn(n,1);
    t0 = clock;
    sumdiffs = norm_axpbypgz(x,y,z,1,1,-1);
    dt = dt + etime(clock,t0);
end

ndsum = sumdiffs;
ndtime = dt;

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1); z = randn(n,1);
    t0 = clock;
    x = x + y;
    x = x - z;
    sumdiffs = norm(x,1);
    dt = dt + etime(clock,t0);
end

nsum = sumdiffs;
ntime = dt;

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1); z = randn(n,1);
    t0 = clock;
    sumdiffs = norm(x+y-z,1);
    dt = dt + etime(clock,t0);
end

nssum = sumdiffs;
nstime = dt;

randn('state',s); % reset random state

fprintf('norm_axpbypgz  took %8.4f sec and produced sum %18.16e\n', ndtime, ndsum);
fprintf('norm(x)        took %8.4f sec and produced sum %18.16e\n', ntime, nsum);
fprintf('norm(x+y-z)    took %8.4f sec and produced sum %18.16e\n', nstime, nssum);

end