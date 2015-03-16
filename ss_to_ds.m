function [Yds fds] = ss_to_ds(Y, f)
    Yds = [Y(1:end)  j*fliplr(Y(2:end))];
    Yds = Yds/2.0;
    fds = [f(1:end)  -1*fliplr(f(2:end))];
    
    
    
    Yds = [Y conj(Y(end-1:-1:2))]/2;
    fds = [f(1:end)  -1*(f(end-1:-1:2))];
    %fds = fftshift(fds);
end