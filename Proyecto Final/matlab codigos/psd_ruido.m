% clear
% clc
 close all

fs = 1/(3*fs); % o la frecuencia real de muestreo del bloque de ruido
ruido = out.ruido_simulado.signals.values; % suponiendo que se llama así

[pxx, f] = pwelch(ruido, hamming(1024), 512, 1024, fs);

% Graficar en unidades físicas
plot(f, pxx)
xlabel('Frecuencia [Hz]')
ylabel('PSD [(m/s^2)^2/Hz]')
title('Densidad espectral del ruido del acelerómetro')
grid on
