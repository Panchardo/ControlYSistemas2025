clc; clear; close all;

%% Parámetros
fs = 1000;            % Frecuencia de muestreo (Hz)
T = 1/fs;             % Periodo de muestreo
tmax = 0.013;
t = 0:T:tmax;         % Vector de tiempo

%% Señal (ejemplo: combinación de senoidales)
f1 = 10;              % Frecuencia 1 (Hz)
f2 = 50;              % Frecuencia 2 (Hz)
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);  % Señal ejemplo

% Graficar en el dominio del tiempo
grafica_tiempo(t, x, 'Senoidal combinada (10 Hz y 50 Hz)');

%% Otra forma: usando my_dft
[f1, dft_mag, ~, ~] = my_dft(x, fs);

grafica_frecuencia(f1, dft_mag, 'Espectro DFT', false);
grafica_frecuencia(f1, dft_mag, 'Espectro DFT', true);
