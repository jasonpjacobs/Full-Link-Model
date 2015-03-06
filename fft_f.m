function [ Y f ] = fft_f( y, dt )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    N = length(y);
    Y = fft(y)/N;
    f = fftfreqs(N, dt);
end

