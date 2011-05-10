function L = nlaplacian(A,n)
% NLAPLACIAN Compute the normalized Laplacian matrix for the matrix A.
%
% L = nlaplacian(A) returns the normalized Laplacian matrix for a 
% matrix A.  This function works for both a dense A, a sparse A, and an
% operator A (passed as a function handle).  The return type is the same as
% the input type.  
%
% Formally, L = I - D^{-1/2} A D^{-1/2} where D = diag(A*e) is the diagonal
% matrix of degrees.  This formulation handles weighted graphs in the 
% natural way, i.e. the "degree" is the row-sum.
%
% If A is a function handle, then you MUST pass the additional argument "n"
% to denote the size.
%
% Example:
%  % Put in Laplacian eigenmaps example here...

% History
% :2011-03-10: Initial coding

if isa(A,'function_handle')
    e = ones(n,1);
    fhand = true;
    d = A(e);
else
    fhand = false;
    d = sum(A,2);
end

% handle possibly zero entries
d = full(d); 
d(d~=0) = 1./sqrt(d(d~=0));


if fhand
    L = @(x) x - d.*A(d.*x);
else
    if issparse(A)
        [i,j,v] = find(A);
        [m,n] = size(A);
        % todo integrate these two
        L = sparse(i,j,-v.*(d(i).*d(j)),m, n);
        L = L + speye(n); % note the negative above
    else
        L = eye(n) + diag(sparse(d))*A*diag(sparse(d));
    end
end
