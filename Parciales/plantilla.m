%% Plantilla base para graficar señales en el dominio del tiempo y frecuencia

clc; clear; close all;

%% Parámetros
fs = 1000;            % Frecuencia de muestreo (Hz)
T = 1/fs;               % Periodo de muestreo
tmax = 1;
t = 0:T:tmax*(1024-1);            % Vector de tiempo (1 segundo)

%% Señal (ejemplo: combinación de senoidales)
f1 = 10;              % Frecuencia 1 (Hz)
f2 = 200;              % Frecuencia 2 (Hz)
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t);  % Señal ejemplo

%% Dominio del tiempo
figure;
plot(t, x, 'LineWidth', 1.5);
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal en el dominio del tiempo');
grid on;
xlim([0, tmax]);  % Muestra solo los primeros 0.2 segundos (opcional)

%% Dominio de la frecuencia (espectro)

[f_signal, dft_mag_signal, dft_phase_signal] = my_dft(x, fs);

figure;
plot(f_signal, dft_mag_signal, 'LineWidth', 1.5);
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
title('Espectro de magnitud (FFT)');
grid on;
xlim([0, fs/2]);  % Limita al rango de Nyquist

%% (Opcional) Espectro en dB
figure;
plot(f_signal, 20*log10(dft_mag_signal+eps), 'LineWidth', 1.5);  % +eps para evitar log(0)
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
title('Espectro de magnitud en dB');
grid on;
xlim([0, fs/2]);

