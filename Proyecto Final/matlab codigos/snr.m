clear
clc
close all

% === CARGA ===
archivo = 'sweep_10-36hz-0,15g.mat'; % ← Cambia si es necesario
data = load(archivo);
out = data.out;

% Asumiendo que las señales están en estructuras Simulink con campos .time y .signals.values
y = out.filtrado.signals.values;           % Señal filtrada
x    = out.cuantizado.signals.values;      % Señal muestreada y cuantizada
%tiempo_real = out.;

% Asegurate de que tengan la misma longitud
NN = min(length(y), length(x));
y = y(1:NN);
x    = x(1:NN);

% Potencia de la señal
P_signal = sum(x.^2);

% Potencia del error (ruido de muestreo)
P_noise = sum((x - y).^2);

% Cálculo del SNR
SNR_dB = 10 * log10(P_signal / P_noise);

% Mostrar resultado
fprintf('SNR = %.2f dB\n', SNR_dB);
