function [ Yss Fss] = ds_to_ss( Yds, Fds)
%DS_TO_SS Summary of this function goes here
%   Detailed explanation goes here


N = length(Yds);
Yss = Yds(1:floor(N/2));
Yss(2:end) = 2*Yss(2:end);
Fss = Fds(1:floor(N/2));




