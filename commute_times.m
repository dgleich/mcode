function C = commute_times(A)
% COMMUTE_TIMES Return the matrix of commute times.
%
% This computation involves a dense pseudo-inverse.

L = diag(sum(A)) - A;
pL = pinv(full(L));
C = zeros(size(A,1));
vol = sum(sum(A));
for i=1:size(A,1)
    for j=i+1:size(A,1)
        C(i,j) = vol*(pL(i,i)+pL(j,j) - 2*pL(i,j));
    end
end
C = C + C';
