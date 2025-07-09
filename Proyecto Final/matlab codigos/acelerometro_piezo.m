clear; clc;

% -----------------------------
% Parámetros del acelerómetro
% -----------------------------
f_hp   = 0.7;         % Frecuencia de corte pasa alto [Hz]
f_lp   = 30000;       % (opcional) Frecuencia de corte pasa bajo [Hz]
f_res  = 18000;       % Frecuencia de resonancia [Hz]
Q      = 10;          % Factor de calidad (estimado)
f_ref  = 100;         % Frecuencia de referencia para sensibilidad
a_dB   = 0;           % Pendiente (en dB por década, normalmente 0 si es plano)

% Transformación a rad/s
w_hp   = 2*pi*f_hp;
w_lp   = 2*pi*f_lp;
w_res  = 2*pi*f_res;
w_ref  = 2*pi*f_ref;

a = a_dB / (20);  % a/ln(10) ≈ a/20 si a está en dB/década

% -----------------------------
% Función de transferencia
% -----------------------------
s = tf('s');

% Pasa alto (1er orden)
H_hp = (s/w_hp) / (1 + s/w_hp);

% Pasa bajo (1er orden)
H_lp = 1 / (1 + s/w_lp);

% Resonancia (2do orden)
H_res = 1 / (1 + (s/w_res)^2 + s/(Q*w_res));

% Ganancia de pendiente (si a ≠ 0)
H_gain = (s/(2*pi*f_ref))^a;

% Función de transferencia total
H_total = H_hp * H_lp * H_res * H_gain;

% -----------------------------
% Diagrama de Bode
% -----------------------------
figure;
bode(H_total, {2*pi*1, 2*pi*30000});
grid on;
title('Bode - Acelerómetro Piezoeléctrico');
