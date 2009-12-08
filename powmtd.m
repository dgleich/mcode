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
%


[m n] = size(A);
if (m ~= n)
    error('powmtd:invalidParameter', 'matrix must be square');
end;

% default options
options = struct('shift', 0, 'tol', sqrt(eps(1)), 'maxiter', 1000, ...
    'x0', rand(n,1), 'simple', 'yes', 'tol1', sqrt(eps(1)), ...
    'modifiedinitits', 100);

% merge user options if specified
if (nargin >= 2)
    options = merge_structs(optionsu, options);
end;

x = options.x0;

% normalize initial guess
x = x./norm(x);

lambda = 1;
iter = 1;

% always start with one iteration
delta = options.tol + 1;

if (options.shift == 0 && strcmpi(options.simple, 'yes'))
    % simple iteration w/o shift
    while (iter < options.maxiter && delta > options.tol)
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end;
    
elseif (strcmpi(options.simple, 'yes'))
    % simple iteration with shift
    while (iter < options.maxiter && delta > options.tol)
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x - options.shift.*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end;
else
    iter = 1;
    while (iter < options.maxiter && iter < options.modifiedinitits && ...
            delta > options.tol)
        % can be done with two in place iterations if memory is a concern...
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
        x = x2;
        
        iter = iter+1;
    end;
    
    detW = det([Ax'*Ax Ax'*x; Ax'*x x'*x]);
    cold = zeros(2,1);
    
    % modified power iteration
    while (iter < options.maxiter && delta > options.tol)
        % save previous iteration
        xp = x;
        Ax = A*x;
        lambda = x'*Ax;
        x2 = Ax ./ norm(Ax);
        % normalize the sign before doing the difference
        %delta = norm(x*sign(x(1)) - x2*sign(x2(1)));

        W = [Ax'*Ax Ax'*x; Ax'*x x'*x];
        detW = det(W);
        if (det(W) < options.tol1 || rcond(W) < options.tol1)
            break;
        end;

        w = A*Ax;
        c = W \ -([Ax'*w; x'*w]);
        delta = norm(c - cold);
        cold = c;

        % switch x
        x = x2;

        iter = iter+1;
    end;
    
    % fall through to simple mode
    if (detW < options.tol1 || rcond(W) < options.tol1)
        % turn off simple mode...
        options.simple = 'yes';
        
        % should probably have made this a subroutine...
        while (iter < options.maxiter && delta > options.tol)
            % can be done with two in place iterations if memory is a concern...
            Ax = A*x;
            lambda = x'*Ax;
            x2 = Ax ./ norm(Ax);
            % normalize the sign before doing the difference
            delta = norm(x*sign(x(1)) - x2*sign(x2(1)));
            x = x2;

            iter = iter+1;
        end;
    end;
end;

if (iter ==  options.maxiter && delta > options.tol)
    warning('powmtd:didNotConverge', ...
        'power iterations did not converge after %i iterations to %e tolerance; achieved tolerance %e', ...
        options.maxiter, options.tol, delta);
end;

lambda = x'*(A*x);

if (strcmpi(options.simple, 'yes') == 0)
    % the method converged, so compute the eigenvalues/eigenvectors
    
    p = c(1);
    q = c(2);

    l1 = (-p + sqrt(p^2 - 4*q))/2;
    l2 = (-p - sqrt(p^2 - 4*q))/2;
    
    lambda = diag([l1 l2]);
    x = [Ax - l2*x  Ax - l1*x];
    x = x * diag(1./sqrt(sum(x.^2)));
end;
