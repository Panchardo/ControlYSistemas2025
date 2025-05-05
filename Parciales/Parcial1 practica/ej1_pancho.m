%% Se mide aceleraciones que se componen de dos componentes sinusoidales de
%% 1 y 2 Hz. Durante la medición hay fuerte ruido de línea que contamina la 
%% señal con otra componente de 60 Hz. La aceleración medida será sub-
%% muestreada de 300 Hz a 50 Hz (decimando cada 6), con lo cual la 
%% componente de ruido de línea debería desaparecer (f_N=fs/2=25 < 60). 
%% Sin embargo, aún está presente.
%% Arregle la sección Filtering de manera tal que se maximice la SNR. Note
%% que la definición de SNR utilizada para evaluar su solución tiene en
%% cuenta la fase.

clc
close all
clear

ti = 0 % s
tf2 = 2 % s
fs = 300 % Hz
t = ti:1/fs:tf2;

f_signal_1 = 1 % Hz
f_signal_2 = 2 % Hz
f_noise = 70 % Hz
actual_accel = sin(2*pi*f_signal_1*t) +  sin(2*pi*f_signal_2*t);
noise = 2*sin(2*pi*f_noise*t);%% + 2*sin(2*pi*70*t) ;
measured_accel = actual_accel + noise;


%% Filtering

% lambda = 0.9;
% b = 1-lambda;
% a = [1 -lambda];
% 
% filtered_measured_accel = filter(b,a,measured_accel);
% Hd = chebyPancho;
% %Hd = kaiser_pancho;
% [b,a] = tf(Hd);
% 
% filtered_measured_accel = filter(b, a, measured_accel);
% 
% figure
% bode(filt(b, a, 1/fs))

f_co = 35;% Elijo frecuencia de corte
F_CO =f_co/fs;%Normalizo la frecuencia de corte
M = round(1/(2*F_CO))%Calculo el orden

b = (1/M)*ones(1,M);
a = 1;

filtered_measured_accel = filter(b, a, measured_accel);

% f_co = 35;% Elijo frecuencia de corte
% F_CO =f_co/fs;%Normalizo la frecuencia de corte
% M = round(1/(2*F_CO))%Calculo el orden
% 
% b = (1/M)*ones(1,M);
% a = 1;
% 
% filtered_measured_accel = filter(b, a, filtered_measured_accel);
% 
figure
bode(filt(b, a, 1/fs))



%% Subsampling
fs_new = 50 % Hz
subsampled_filtered_measured_accel = filtered_measured_accel(1:round(fs/fs_new):end);
subsampled_t = t(1:round(fs/fs_new):end);


X = abs(fft(measured_accel));
X_filt = abs(fft(filtered_measured_accel));
figure
hold on
plot(linspace(0, fs/2, round(length(X)/2)), X(1:round(length(X)/2)), 'linewidth', 2);
plot(linspace(0, fs/2, round(length(X_filt)/2)), X_filt(1:round(length(X_filt)/2)), 'linewidth', 2);
legend('measured accel', 'filtered accel')
xlabel('f (Hz)')


figure
hold on
plot(t, [measured_accel; actual_accel], 'linewidth', 2)
plot(subsampled_t, subsampled_filtered_measured_accel, 'linewidth', 2)
xlabel('t (s)')
legend('measured accel', 'actual accel', 'subsampled measured accel')


%% Evaluation
subsampled_actual_accel = actual_accel(1:round(fs/fs_new):end);
SNR = 20*log10(rms(subsampled_actual_accel)/rms(subsampled_filtered_measured_accel - subsampled_actual_accel))

if SNR < 10
    disp(['Nota Ej 1 = 2'])
elseif SNR < 13
    disp(['Nota Ej 1 = 3'])
elseif SNR < 16
    disp(['Nota Ej 1 = 4'])
elseif SNR < 19
    disp(['Nota Ej 1 = 5'])
elseif SNR < 22
    disp(['Nota Ej 1 = 6'])
else
    disp(['Nota Ej 1 = 7'])
end