function [lambda x] = powmtd(A,optionsu)
% POWMTD Dominant eigenvalue and eigenvector using the power method.
%
% [lambda x] = powmtd(A) computes lambda_max and correspondong x_max
% assuming that power iterations converge.  
%
% If you use the non-simple method, this function may return multiple
% eigenvalues and vectors.
%
% You can provide a structure with options to change the behavior
% of this functions.
%
% tol - convergence tolerance [positive scalar] (default = sqrt(eps))
% shift - optional shift for the iteration [scalar] (default = 0)
% simple - if 'yes', then don't use the modified power method for 
%   matrices with multiple dominant eigenvalues.  
% maxiter - maximum number of iterations [positive integer] 
%   (default = 1000)
% x0 - initial guess [vector]
% tol1 - a secondary tolerance used in the modified power method
%   [positive scalar] (default = sqrt(eps))
% modifiedinitits - initial modified power iterations to detect which 
%   method to use [positive integer] (default = 100)

[m n] = size(A);
if (m ~= n)
    error('powmtd:invalidParameter', 'matrix must be square');
end

% default options
options = struct('shift', 0, 'tol', sqrt(eps(1)), 'maxiter', 1000, ...
    'x0', [], 'simple', 'yes', 'tol1', sqrt(eps(1)), ...
    'modifiedinitits', 100);

% merge user options if specified
if exist('optionsu','var')
    for fi = fieldnames(options)'
        if isfield(optionsu,fi), options.(fi) = optionsu.(fi); end
    end
end

x = options.x0;
if isempty(x), x = rand(n,1); end

% normalize initial guess
x = x./norm(x);

lambda = 1;
iter = 1;

simple = strcmpi(options.simple, 'yes');
maxiter = options.maxiter;
modifiediter = options.modifiedinitits;
tol = options.tol;
tol1 = options.tol1;

% always start with one iteration
delta = options.tol + 1;

if options.shift == 0 && simple
    % simple iteration w/o shift
    while iter < maxiter && delta > tol
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end
elseif simple
    % simple iteration with shift
    sigma = options.shift;
    while iter < maxiter && delta > tol
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x - sigma*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end
else
    iter = 1;
    while iter < maxiter && iter < modifiediter && delta > tol
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end
    
    detW = det([Ax'*Ax Ax'*x; Ax'*x x'*x]);
    cold = zeros(2,1);
    
    % modified power iteration to get complex eigenvalues
    while iter < maxiter && delta > tol
        % save previous iteration
        xp = x;
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        %delta = norm(x*sign(x(1)) - x2*sign(x2(1)));

        W = [Ax'*Ax Ax'*x; Ax'*x x'*x];
        detW = det(W);
        if det(W) < tol1 || rcond(W) < tol1
            break
        end

        w = A*Ax;
        c = W \ -([Ax'*w; x'*w]);
        delta = norm(c - cold);
        cold = c;

        % switch x
        x = x2;

        iter = iter+1;
    end;
    
    % fall through to simple mode
    if detW < tol1 || rcond(W) < tol1
        % turn off simple mode...
        simple = 1;
        
        % should probably have made this a subroutine...
        while iter < maxiter && delta > tol
            % can be done with two in place iterations if memory is a concern...
            Ax = A*x;
            lambda = x'*Ax;
            x2 = Ax ./ norm(Ax);
            % normalize the sign before doing the difference
            delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
            x = x2;

            iter = iter+1;
        end
    end
end

if iter ==  options.maxiter && delta > options.tol
    warning('powmtd:didNotConverge', ...
        ['power iterations did not converge after %i iterations\n'
         'to %e tolerance; achieved tolerance %e'], ...
        options.maxiter, options.tol, delta);
end

lambda = x'*(A*x);

if ~simple
    % the method converged, so compute the eigenvalues/eigenvectors
    
    p = c(1);
    q = c(2);

    l1 = (-p + sqrt(p^2 - 4*q))/2;
    l2 = (-p - sqrt(p^2 - 4*q))/2;
    
    lambda = diag([l1 l2]);
    x = [Ax - l2*x  Ax - l1*x];
    x = x * diag(1./sqrt(sum(x.^2)));
end
