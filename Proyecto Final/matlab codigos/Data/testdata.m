clear
clc
close all
data  = load('sweep_10-50Hz.mat');

ac = reshape(data.out.corriente.signals.values,[],1);
t = data.out.corriente.time;

% Graficar en unidades físicas
figure('Position', [100, 100, 800, 600]);

plot(t, ac)
xlabel('Tiempo (s)')
ylabel('$\ddot x_2(t) (m/s^2)$', 'Interpreter', 'latex')
title('Aceleración de los elementos móviles')
grid on
