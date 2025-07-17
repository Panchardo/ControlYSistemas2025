clear
clc
close all
% Parámetros
fs = 10000;      % frecuencia de muestreo [Hz]
T = 10;          % duración total [s]
t = (0:1/fs:T-1/fs)';  % vector de tiempo

% Generar señal
a = GeneradorPerfilPSD(t);
%a = a/rms(a)
rms(a)

% Graficar señal en el tiempo
figure;
plot(t, a);
xlabel('Tiempo [s]');
ylabel('Aceleración [g]');
title('Señal generada con perfil PSD');
grid on;

% Calcular PSD usando pwelch
figure;
[pxx, f] = pwelch(a, hamming(2048), [], [], fs);
plot(f, pxx, 'r', 'LineWidth', 1.2);
xlabel('Frecuencia [Hz]');
ylabel('PSD [g²/Hz]');
title('PSD estimada con pwelch');
grid on;
xlim([0 2500]);

function y = GeneradorPerfilPSD(t_vec)
% t_vec: vector de tiempos
% y: señal generada

persistent f_list A_list phi_list t0

% Definir perfil PSD solo una vez
if isempty(f_list)
    % Tramos del perfil (frecuencias en Hz)
    freqs = [20, 130, 800, 2000];
    psd_vals = [0.01125, 0.05625, 0.05625, 0.015]; % [g²/Hz]

    Ncomp = 100;
    rng(1);  % semilla fija

    f_list = linspace(freqs(1), freqs(end), Ncomp);

    % Perfil escalonado
    psd_interp = zeros(size(f_list));
    for i = 1:length(freqs)-1
        idx = (f_list >= freqs(i)) & (f_list < freqs(i+1));
        psd_interp(idx) = psd_vals(i);
    end
    psd_interp(end) = psd_vals(end);

    df = mean(diff(f_list));
    A_list = sqrt(2 * psd_interp * df);

    phi_list = 2 * pi * rand(1, Ncomp);

    t0 = 0;
end

% Generar señal
t_vec = t_vec(:);  % asegurar columna
y = zeros(size(t_vec));
for i = 1:length(f_list)
    y = y + A_list(i) * sin(2*pi*f_list(i)*(t_vec - t0) + phi_list(i));
end
end
