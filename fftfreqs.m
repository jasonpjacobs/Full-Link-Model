function results = fftfreqs(varargin)
%FFTFREQS Summary of this function goes here
%   Detailed explanation goes here
    n = varargin{1};
    if (nargin == 2)
        d = varargin{2};
    else
        d = 1;
    end
    val = 1.0 / (n * d);
    results = zeros(n,1);
    N = floor((n-1)/2) + 1;
    p1 = 0:N;
    results(1:N+1) = p1;
    p2 = ceil(-n/2):-1;
    results(N+1:end) = p2;
    results = results' * val;
    %results = fliplr(results);

end

