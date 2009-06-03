%% Performance of normdiff vs. norm
function normdiff_perf(n,nrep)

if ~exist('n','var'), n=1e7; end
if ~exist('nrep','var'), nrep=15; end

s = randn('state');

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1);
    t0 = clock;
    sumdiffs = normdiff(x,y);
    dt = dt + etime(clock,t0);
end

ndsum = sumdiffs;
ndtime = dt;

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1);
    t0 = clock;
    x = x - y;
    sumdiffs = norm(x,1);
    dt = dt + etime(clock,t0);
end

nsum = sumdiffs;
ntime = dt;

randn('state',0); % set random state
sumdiffs = 0;
dt = 0;
for i=1:nrep
    x = randn(n,1); y = randn(n,1);
    t0 = clock;
    sumdiffs = norm(x-y,1);
    dt = dt + etime(clock,t0);
end

nssum = sumdiffs;
nstime = dt;

randn('state',s); % reset random state

fprintf('normdiff  took %8.4f sec and produced sum %18.16e\n', ndtime, ndsum);
fprintf('norm(x)   took %8.4f sec and produced sum %18.16e\n', ntime, nsum);
fprintf('norm(x-y) took %8.4f sec and produced sum %18.16e\n', nstime, nssum);

end