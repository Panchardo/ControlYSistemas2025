%% EJ 1
%a) Genere una señal senoidal con frecuencia fundamental fn = 100 Hz. Elija una frecuencia de muestreo adecuada.

clear
clc
close all

% Parámetros de la señal
frecuencia_seno = 100;    % Frecuencia de la señal (Hz)
fs = 1000;                % Frecuencia de muestreo (Hz)
tiempo_inicio = 0;        % Tiempo inicial (s)
tiempo_final = 1;         % Tiempo final (s)

periodo_muestreo = 1/fs;  % Periodo de muestreo
t = tiempo_inicio:periodo_muestreo:tiempo_final; % Vector de tiempo

signal = sin(2*pi*frecuencia_seno*t); % Generación de la señal senoidal
SNR = 15; % dB
signal_noise = awgn(signal, SNR);

f_corte = 2 * frecuencia_seno;

N_max = floor(fs / (2*f_corte));


windowSize = N_max; %Cambiar a /2 y *10
b = (1/windowSize)*ones(1,windowSize);
a = 1;

signal_filtered = filter(b,a,signal_noise);

%Respuesta en frecuencia del filtro

[H, f] = freqz(b, a, 1000, fs);  % 1000 puntos, fs como frecuencia de muestreo. H es el vector de magnitudes y f el de frecuencias

%Respuesta en frecuencia de la señal
[f_signal, dft_mag_signal, dft_phase_signal] = my_dft(signal, fs);
[f_noise, dft_mag_noise, dft_phase_noise] = my_dft(signal_noise, fs);
[f_filtered, dft_mag_filtered, dft_phase_filtered] = my_dft(signal_filtered, fs);

figure(1)

plot(t, signal, 'b', 'LineWidth', 1.2); 
hold on;
plot(t, signal_noise, 'r', 'LineWidth', 0.8);
plot(t, signal_filtered,'color', [0 0.5 0], 'LineWidth', 1.2);

legend('Señal Original', 'Señal con Ruido', 'Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Comparación de Señales en el Dominio del Tiempo');
grid on;



% Graficar magnitud y fase
figure;

subplot(2,1,1);
plot(f/fs, 20*log10(abs(H)));
grid on;
title(['Respuesta en Frecuencia del Filtro MA (N = ', num2str(N_max), ')']);
xlabel('Frecuencia Normalizada');
ylabel('Magnitud (dB)');
ylim([-60 5]);

subplot(2,1,2);
plot(f/fs, angle(H));
grid on;
xlabel('Frecuencia Normalizada');
ylabel('Fase (rad)');

%Comparacion entre señales original y filtrada
figure;
subplot(3,2,1);
plot(f_signal, 20*log10(abs(dft_mag_signal)));
grid on;
title(['Respuesta en Frecuencia de la señal original (N = ', num2str(N_max), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 fs/2]);

subplot(3,2,2);
plot(f_signal, angle(dft_phase_signal));
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase(rad)');

subplot(3,2,3);
plot(f_noise, 20*log10(abs(dft_mag_noise)));
grid on;
title(['Respuesta en Frecuencia de la señal ruidosa (N = ', num2str(N_max), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
ylim([-60 5]);

subplot(3,2,4);
plot(f_noise, angle(dft_phase_noise));
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase(rad)');


subplot(3,2,5);
plot(f_filtered, 20*log10(abs(dft_mag_filtered)));
grid on;
title(['Respuesta en Frecuencia de la señal filtrada (N = ', num2str(N_max), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
ylim([-60 5]);

subplot(3,2,6);
plot(f_filtered, angle(dft_phase_filtered));
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase(rad)');




