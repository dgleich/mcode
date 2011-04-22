function [I, d] = incidence_matrix(A)
% INCIDENCE_MATRIX Return the incidence matrix for a graph A.

% get all the edges in the graph.
[i j d] = find(triu(A, 1));

k = length(i);

I = sparse([i; j], [(1:k)'; (1:k)'], [ones(k,1); -1*ones(k,1)], size(A,1), k);






