clear
clc
close all
f_res = 21000;
w0 = 2*pi*f_res;
f_target = 11000;
w_target = 2*pi*f_target;

target_gain = 10^(3/20);  % 3 dB → ganancia ≈ 1.412

zeta_range = linspace(0.01, 0.2, 1000);
gain_vals = zeros(size(zeta_range));

for i = 1:length(zeta_range)
    z = zeta_range(i);
    H = tf([w0^2], [1, 2*z*w0, w0^2]);
    [mag, ~] = bode(H, w_target);
    gain_vals(i) = mag;
end

% Encontrar el zeta que más se aproxima a la ganancia deseada
[~, idx] = min(abs(gain_vals - target_gain));
zeta_ajustado = zeta_range(idx);

fprintf('Zeta estimado para 3 dB a 11 kHz: %.4f\n', zeta_ajustado);

Hs = tf([w0^2], [1, 2*zeta_ajustado*12*w0, w0^2]);

fs = 100000; % Frecuencia de muestreo
N = fs * 2;  % 2 segundos

nsd = 30e-6; % [g/√Hz]
noise_rms = nsd * sqrt(fs/2);  % Ruido blanco escalado en RMS
ruido = noise_rms * randn(1, N); % Señal de ruido blanco

t = (0:N-1)/fs;
sensor_out = lsim(Hs, ruido, t);

% Graficar
plot(t, sensor_out), xlabel('t [s]'), ylabel('Señal [g]')
title('Salida del acelerómetro con ruido interno')
