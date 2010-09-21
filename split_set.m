function s = split_set(n,k)
% Split a set of n things into k almost equally sized integer pieces
% and return indices
% TODO add better documentation, test

% History
% :2010-08-30: Initial version
sizes = floor(n/k)+double(mod(n,k)>=(1:k));
s = cell(k,1);
curind = 1;
for i=1:k
    s{i} = curind:curind+sizes(i)-1;
    curind = curind+sizes(i);
end

