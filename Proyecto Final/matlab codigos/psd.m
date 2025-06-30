% Parámetros
fs = 10000; % Frecuencia de muestreo (debe ser al menos 2x la máxima frecuencia de interés)
T = 10; % Duración de la señal (segundos)
t = 0:1/fs:T-1/fs; % Vector de tiempo

% 1. Generar ruido blanco
noise = randn(size(t)); % Ruido gaussiano blanco

% 2. Diseñar filtro que moldee el PSD
% Usaremos un filtro FIR basado en tu perfil PSD
frequencies = [20, 130, 800, 2000]; % Puntos de frecuencia
amplitudes = [sqrt(0.01125), sqrt(0.05625), sqrt(0.05625), sqrt(0.015)]; % Amplitudes (raíz cuadrada del PSD)

% Crear respuesta en frecuencia deseada
f = linspace(0, fs/2, 1000);
H_desired = interp1(frequencies, amplitudes, f, 'linear', 'extrap');
H_desired = H_desired ./ max(H_desired); % Normalizar

% Diseñar filtro FIR
order = 500; % Orden del filtro
filt = fir2(order, f/(fs/2), H_desired);

% 3. Filtrar el ruido
filtered_noise = filter(filt, 1, noise);

% 4. Ajustar RMS a tu valor deseado
current_rms = rms(filtered_noise);
desired_rms = 7.545; % El RMS que calculamos antes
filtered_noise = filtered_noise * (desired_rms/current_rms);

% 5. Verificar PSD resultante
[pxx, f] = pwelch(filtered_noise, 1024, [], [], fs);
figure;
loglog(f, pxx);
hold on;
stairs(frequencies, amplitudes.^2, 'r--', 'LineWidth', 2);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('PSD [g^2/Hz]');
legend('Señal generada', 'Perfil objetivo');