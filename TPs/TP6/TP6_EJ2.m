clear
clc
close all

load('Tchaikovsky.mat')

signal_elegida = signal(:,2);
SNR = 60; % dB
signal_noise = awgn(signal_elegida, SNR);

% c) Diseñe un filtro leaking integrator (LI) con λ igual a 0.7.

lambda = 0.90;
b = 1-lambda;
a = [1 -lambda];

% d) Grafique la respuesta en frecuencia y fase del filtro LI. Use la función freqz(). Determine la frecuencia de corte fco con: fco = - ln (λ) . fs / π

[H, f] = freqz(b, a, 1024, Fs); 
fco = -log(lambda)*Fs / (pi)

% e) Determine el cero y el polo del filtro con la función zplane(). ¿Es el filtro estable?.

zplane(b,a); % es estable porque el polo está dentro de la circunferencia unitaria.

% f) Aplique el filtro LI a la señal con ruido. Utilice la función filter().

signal_filtered = filter(b,a,signal_noise);


% Graficar magnitud y fase
figure;

subplot(2,1,1);
plot(f, 20*log10(abs(H)));
grid on;
title(['Respuesta en Frecuencia del Filtro Leaky Integrator \lambda = ', num2str(lambda), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
ylim([-60 5]);

subplot(2,1,2);
plot(f, angle(H));
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (rad)');

%g) Grafique la respuesta en el tiempo de las señales original y filtrada y compare.
figure

plot(signal_elegida, 'b', 'LineWidth', 1.2); 
hold on;
plot(signal_noise, 'r', 'LineWidth', 0.8);
plot(signal_filtered,'color', [0 0.5 0], 'LineWidth', 1.2);

legend('Señal Original', 'Señal con Ruido', 'Señal Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Comparación de Señales en el Dominio del Tiempo');
grid on;

% h) Grafique la respuesta en frecuencia de las señales original y filtrada y compare. Utilice la función provista my_dft().
[f_signal, dft_mag_signal, dft_phase_signal] = my_dft(signal_elegida, Fs);
[f_noise, dft_mag_noise, dft_phase_noise] = my_dft(signal_noise, Fs);
[f_filtered, dft_mag_filtered, dft_phase_filtered] = my_dft(signal_filtered, Fs);

%Comparacion entre señales original y filtrada
figure;
subplot(3,1,1);
plot(f_signal, 20*log10(abs(dft_mag_signal)));
grid on;
title(['Transformada de Fourier de la señal original (\lambda = ', num2str(lambda), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 Fs/2]);

% subplot(3,2,2);
% plot(f_signal, angle(dft_phase_signal));
% grid on;
% xlabel('Frecuencia (Hz)');
% ylabel('Fase(rad)');

subplot(3,1,2);
plot(f_noise, 20*log10(abs(dft_mag_noise)));
grid on;
title(['Transformada de Fourier de la señal ruidosa (\lambda = ', num2str(lambda), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 Fs/2]);

% subplot(3,2,4);
% plot(f_noise, angle(dft_phase_noise));
% grid on;
% xlabel('Frecuencia (Hz)');
% ylabel('Fase(rad)');


subplot(3,1,3);
plot(f_filtered, 20*log10(abs(dft_mag_filtered)));
grid on;
title(['Respuesta en Frecuencia de la señal filtrada (\lambda = ', num2str(lambda), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 Fs/2]);

% subplot(3,2,6);
% plot(f_filtered, angle(dft_phase_filtered));
% grid on;
% xlabel('Frecuencia (Hz)');
% ylabel('Fase(rad)');

%sound(signal, Fs);
%sound(signal_noise, Fs);
sound(signal_filtered, Fs);
