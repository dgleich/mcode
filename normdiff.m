function s=normdiff(x,y)
% normdiff Compute the 1-norm of the difference between two vectors.
%
% For large vectors, the native sum command in Matlab does not appear to
% use a compensated summation algorithm which can cause significant round
% off errors.
%
% This code implements a variant of Kahan's compensated summation algorithm
% which often takes about twice as long, but produces more accurate sums 
% when the number of elements is large.
%
% See also NORM
%
% Example:
%   x=rand(1e7,1); y=rand(1e7,1);
%   sum1 = normdiff(x,y);
%   sum2 = norm(x-y,1);
%   sum3
%   fprintf('sum1 = %18.16e\nsum2 = %18.16e\n', sum1, sum2);

% David Gleich
% Copyright, Stanford University, 2008-2009

% 2008-05-23: Initial version based on other codes.
%             Optimzied with abs() based on test/normdiff_perf.m
% 2009-06-03: Integrated version to work on big and small problems efficiently

s=0; e=0; temp=0; z=0; i=1; numelx= numel(x);
if numelx<2^31
    % for loops are a bit faster, when they work
    for i=1:numel(x)
        temp=s; 
        z = abs(x(i)-y(i))+e;
        s=temp+z; 
        e=(temp-s)+z;
    end
    s=s+e;
else
    % compensate for Matlab bug with for-loops
    while i<=numelx
        temp=s; 
        z = abs(x(i)-y(i))+e;
        s=temp+z; 
        e=(temp-s)+z;
        i=i+1;
    end
    s=s+e;
end
