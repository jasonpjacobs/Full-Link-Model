classdef Channel
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        file_name; % Source s-parameter file
        freqs; % Frequencies used in the source s-parameter file
        s11; % Complex differential return loss
        s21; % Complex differential insertion loss
    end
    methods
        function obj=Channel(file_name)
            obj.file_name = file_name;
            data = read(rfdata.data, file_name);  % Requires RF Toolbox
            obj.freqs = data.Freq';
            s_params = data.S_Parameters;
            diff_s_params = s2sdd(s_params);

            s = diff_s_params(1,1,:);
            obj.s11 = reshape(s, [1, length(s)]);
            
            s = diff_s_params(2,1,:);
            obj.s21 = reshape(s, [1, length(s)]);
        end
        
        function varargout=impulse(obj, varargin)
            
            [h t] = ifft_t(obj.s21, obj.freqs);
            varargout{1} = h;
            if nargout == 2
                varargout{2} = t;
            end
        end
        function plot(obj, prop)
            if strcmp(prop, 's11')
                y = 20*log(abs(obj.s11));
                x = obj.freqs;
            elseif strcmp(prop, 's21')
                y = 20*log(abs(obj.s21));
                x = obj.freqs;
            end
            hold
            plot(x, y)
        end
        
        function h = imp2(obj)
            H = obj.s21;
            f = obj.freqs;
            
            % Break into phase and magnitude            
            Hm=abs(H);
            Hp=angle(H);
            
            % Make symmetric
            Hm_ds=[fliplr(Hm(1:end-1)) Hm];
            Hp_ds=[fliplr(-Hp(1:end-1)) 0 Hp];
            %fds_m=[-fliplr(f(1:end-1)) f];
            %fds_p=[-fliplr(f(1:end-1)) 0 f];
            
            % Shift
            Hm_ds_sh_orig=fftshift(Hm_ds);
            Hp_ds_sh_orig=fftshift(Hp_ds);    
            
            % Not interpolating, so just use the original
            Hm_ds_interp = Hm_ds;
            Hp_ds_interp = Hp_ds;
            
            
            num_fft_pts = length(Hm_ds);
            
            Hm_ds_interp_a(1:(2*num_fft_pts-size(Hm_ds_interp,2))/2)=0;
            Hm_ds_interp_a((2*num_fft_pts-size(Hm_ds_interp,2))/2+1:(2*num_fft_pts+size(Hm_ds_interp,2))/2)=Hm_ds_interp;
            Hm_ds_interp_a((2*num_fft_pts+size(Hm_ds_interp,2))/2+1:2*num_fft_pts)=0;

            Hp_ds_interp_a(1:(2*num_fft_pts-size(Hp_ds_interp,2))/2)=0;
            Hp_ds_interp_a((2*num_fft_pts-size(Hp_ds_interp,2))/2+1:(2*num_fft_pts+size(Hp_ds_interp,2))/2)=Hp_ds_interp;
            Hp_ds_interp_a((2*num_fft_pts+size(Hp_ds_interp,2))/2+1:2*num_fft_pts)=0;

            % Not sure what this does
            Hm_ds_interp_sh=fftshift(Hm_ds_interp_a);
            Hp_ds_interp_sh=fftshift(Hp_ds_interp_a);
            
            % Recombine into complex response
            H_ds_interp_sh=Hm_ds_interp_sh.*exp(j*Hp_ds_interp_sh);
            
            imp=ifft(H_ds_interp_sh);
            imp_r=real(imp);

            imp=imp_r;
            h=imp;
            
        end
    end
    
end

