function [S,Z]=effective_resistance_sketch(A,k)
% Compute a sketch of the effective resistance probs via
%  Spielman/Srivastava
%  http://epubs.siam.org/doi/abs/10.1137/080734029
%  http://web.stanford.edu/group/mmds/slides2008/srivastava.pdf
% S is the matrix of sampling probabilities for each edge
% Z is the actual sketch
%
% Usage
%  P = effective_resistance_sketch(A);
%  [ei,ej,p] = find(triu(P,1));
%  n = size(A,1);
%  [ws,ids] = sample(p,ceil(10*n*log(n)));
%  S = sparse(ei(ids),ej(ids),1./ws,n,n);
%  S = (S + triu(S)');

% 2016-09-29: initial very crappy version


n = size(A,1);
L = diag(sum(A)) - A;    
B = incidence_matrix(A);
m = size(B,2); % number of edges

if nargin < 2
    k = ceil(10*log(m));
end

Q = B*(sign(2*rand(m,k)-1)/sqrt(k));
L1 = L(2:end,2:end);
Z1 = L1\Q(2:end,:);
Z = [zeros(1,k);Z1];
Z = Z - repmat(mean(Z),n,1);

[ei,ej,v] = find(A);
for i=1:length(ei)
    v(i) = norm(Z(ei(i),:)-Z(ej(i),:))^2;
end
S = sparse(ei,ej,v,n,n);