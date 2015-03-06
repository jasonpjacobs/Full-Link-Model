function [ y t ] = ifft_t( Y, f)
%ifft_t Converts frequency domain data into its time domain representation
%   Y:  Frequency domain data, regularly spaced. Can be positive
%   frequencies (from transfer functions) or the full positive/negative
%   spectrum (from FFT outptus).

%   f:  The frequency data points.  Used to determine frequency spacing
%   and whether the spectrum is single or double sided.

% Convert single sided spectrum to double sided
if (min(f) >= 0)
    Y = [Y(1:end-1) -1*fliplr(Y(2:end))]
    f = [f(1:end-1) -1*fliplr(f(2:end))]
    %Y = [fliplr(Y(1:end-1)) Y];
    %f = [-1*fliplr(f(1:end-1)) f];
end

N = length(Y);
y = N*(ifft(Y));

% Calculate the time values
dt = 1/(2*max(f));
t = 0:dt:(N-1)*dt;



