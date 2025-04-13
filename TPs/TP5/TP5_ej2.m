clear
clc
close all

load('Tchaikovsky.mat')

signal_elegida = signal(:,2);
SNR = 50; % dB
signal_noise = awgn(signal_elegida, SNR);

f_corte = 11025;
N_max = floor(Fs / (2*f_corte));


windowSize = N_max; %Cambiar a /2 y *10
b = (1/windowSize)*ones(1,windowSize);
a = 1;

signal_filtered = filter(b,a,signal_noise);

%Respuesta en frecuencia de la señal
[f_signal, dft_mag_signal, dft_phase_signal] = my_dft(signal_elegida, Fs);
[f_noise, dft_mag_noise, dft_phase_noise] = my_dft(signal_noise, Fs);
[f_filtered, dft_mag_filtered, dft_phase_filtered] = my_dft(signal_filtered, Fs);

%Comparacion entre señales original y filtrada
figure;
subplot(3,1,1);
plot(f_signal, 20*log10(abs(dft_mag_signal)));
grid on;
title(['Respuesta en Frecuencia de la señal original']);
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
title(['Respuesta en Frecuencia de la señal ruidosa']);
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
title(['Respuesta en Frecuencia de la señal filtrada (N = ', num2str(N_max), ')']);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
xlim([0 Fs/2]);

% subplot(3,2,6);
% plot(f_filtered, angle(dft_phase_filtered));
% grid on;
% xlabel('Frecuencia (Hz)');
% ylabel('Fase(rad)');

%Reproducir las señales con ruido, sin ruido y filtrada

%sound(signal, Fs);
%sound(signal_noise, Fs);
sound(signal_filtered, Fs);

