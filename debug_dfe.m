function debug_dfe( n, x, y, z, y_h, e, c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %fprintf('X = %s\n', num2str(x(n)));
    %fprintf('Y = %s\n', num2str(y(n)));
    %fprintf('Z = %s\n', num2str(z(n)));
    
    %z(n) = y(n) - sum(w.*y_h(n-1:-1:n-N_taps));
    w = c(n,:);
    figure(3);
    clf;
    
    subplot(2,1,1);
    stairs(n-5:n+1, y(n-5:n+1));
    hold on;
    stem(n-5:n+1, y(n-5:n+1));
    
    title('Y(n)');
    
    subplot(2,1,2);
    stairs(n-5:n+1, z(n-5:n+1));
    title('DFE Output');
    hold on;
    
    stem(n,z(n),'*b');

    fprintf('Z(n) = %f\n', z(n));
    fprintf('     = %4.3f - %4.3f\n', y(n), sum(w*y_h(n-1:-1:n-4)));
    for k= 1:4
        dw = sign(e(n))*sign(y_h(n-1 : -1 : n - 4));
        d=y_h(n-k);
        c = w(k);
        dac = c*d;
        fprintf('    (%d):  %4.3f  :  %4.3f*%d  (w+=%d)\n', k, dac, c, d, dw(k));
        %
        stem(n-k,dac,'or');
        
    end
    for k= 1:1
        fprintf('    X=%4.3f, Y=%4.3f, Z=%4.3f, E=%3.4f\n', x(n), y(n), z(n), e(n));
    end    
    
    hold off;
    
end

