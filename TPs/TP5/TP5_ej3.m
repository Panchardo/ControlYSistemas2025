clear
clc
close all

load('Tchaikovsky.mat')

signal_elegida = signal(:,2);
SNR = 50; % dB

%signal_noise = awgn(signal_elegida, SNR);


Hd = fir_kaiser_300_3400;
b = Hd.Numerator;
a = 1;
fir_output = filter(b, a, signal_elegida);

[f_signal, dft_mag_signal, dft_phase_signal] = my_dft(signal_elegida, Fs);
%[f_noise, dft_mag_noise, dft_phase_noise] = my_dft(signal_noise, Fs);
[f_filtered, dft_mag_filtered, dft_phase_filtered] = my_dft(fir_output, Fs);

% Configuración del gráfico
figure;
hold on; % Activa la superposición de gráficos

% Graficar señal original (en azul)
plot(f_signal, 20*log10(abs(dft_mag_signal)), 'b', 'LineWidth', 1.5, 'DisplayName', 'Señal original');

% Graficar señal filtrada (en rojo, línea discontinua)
plot(f_filtered, 20*log10(abs(dft_mag_filtered)), 'r', 'LineWidth', 1.5, 'DisplayName', 'Señal filtrada');
grid on;
title('Comparación de Respuestas en Frecuencia');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 Fs/2]);
legend('show', 'Location', 'best'); % Muestra la leyenda
hold off;
%sound(signal(:,1), Fs);
%sound(signal_noise, Fs);
%sound(fir_output, Fs);

