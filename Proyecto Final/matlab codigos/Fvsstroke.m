clear
clc
close all
% Datos corregidos a formato numérico
x_in = [ ...
    0.01098, 0.04430, 0.07761, 0.11093, 0.14424, 0.17756, 0.21087, 0.24418, ...
    0.27750, 0.31081, 0.34413, 0.37744, 0.41075, 0.44407, 0.47738, 0.51070, ...
    0.54401, 0.57732, 0.61064, 0.64395, 0.67727, 0.71058, 0.74389, 0.77721, ...
    0.81052, 0.84384, 0.87715, 0.91047, 0.94378, 0.97558, 0.99678 ];

F_lb = [ ...
    43.32553, 45.37782, 47.41985, 49.37980, 51.23712, 52.80713, 54.11034, ...
    55.18779, 56.03950, 56.64492, 57.11695, 57.40427, 57.60950, 57.73264, ...
    57.73264, 57.73264, 57.73264, 57.57872, 57.29140, 56.86041, 56.29603, ...
    55.56747, 54.59263, 53.41256, 51.91438, 50.24176, 48.41522, 46.28083, ...
    43.86938, 41.42202, 39.84175 ];

% Conversión de unidades
x_mm = x_in * 25.4;         % pulgadas → milímetros
F_N  = F_lb * 4.44822;      % libras → Newtons

% Corriente continua nominal
I_cont = 5;                 % amperios

% Constante de fuerza
k = F_N ./ I_cont;          % N/A

% === Plot 1: Fuerza vs Stroke ===
figure;
plot(x_mm, F_N, 'r-o', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Stroke [mm]');
ylabel('Fuerza continua [N]');
title('Fuerza continua vs. Posición');
xlim([0 25.4])
grid on;

% === Plot 2: k(x) vs Stroke ===
figure;
plot(x_mm, k, 'b-s', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('Stroke [mm]');
ylabel('k(x) [N/A]');
title('Constante de fuerza vs. Posición');
xlim([0 25.4])
grid on;
