% --- Parámetros ---
fs = 10000;           % Frecuencia de muestreo [Hz]
T  = 10;              % Duración [s]
N  = fs * T;

% --- Cargar señal desde Simulink ---
% Asegurate de que 'ruido_out' esté en el workspace
if ~exist('out', 'var')
    error('No se encontró la variable ruido_out. Verificá el To Workspace.');
end

% Vector de tiempo asociado (opcional)
t = (0:N-1)/fs;

% --- Gráfico de la señal en el tiempo ---
figure;
subplot(2,1,1);
plot(out.tout, out.ruido_out * 1e6);
xlabel('Tiempo [s]');
ylabel('Señal [\mug]');
title('Ruido generado (ruido blanco + 1/f)');
grid on;

% --- Estimación PSD con pwelch ---
subplot(2,1,2);
[pxx, f] = pwelch(out.ruido_out, hamming(2048), [], [], fs);
loglog(f, sqrt(pxx));  % Raíz del PSD en g/√Hz
xlabel('Frecuencia [Hz]');
ylabel('√PSD [g/√Hz]');
title('Raíz del PSD estimada con Welch');
grid on;
xlim([0.01 5000]);
