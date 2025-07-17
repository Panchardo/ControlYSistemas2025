%% Parámetros del perfil PSD
freqs = [20, 130, 800, 2000];              % Hz
psd_vals = [0.01125, 0.05625, 0.05625, 0.015]; % g²/Hz

%% Interpolación del PSD
f_interp = linspace(freqs(1), freqs(end), 1000);
psd_interp = interp1(freqs, psd_vals, f_interp, 'pchip');

%% Generación de señal aleatoria con ese PSD
fs = 10000;     % Frecuencia de muestreo [Hz]
T = 120;         % Duración [s]
N = fs * T;
df = f_interp(2) - f_interp(1);
t = (0:N-1)/fs;

a = zeros(1, N);
rng('shuffle'); % Semilla aleatoria

for i = 1:length(f_interp)
    A_i = sqrt(2 * psd_interp(i) * df);
    phi = 2*pi*rand();
    a = a + A_i * sin(2*pi*f_interp(i)*t + phi);
end
a = a * (sqrt(2)/9.81 / rms(a));

%% Cálculo del RMS para usar como consigna
rms_objetivo = rms(a);

fprintf('RMS objetivo: %.3f g\n', rms_objetivo);

%% (Opcional) Graficar
figure;
subplot(2,1,1)
plot(t, a)
xlabel('Tiempo [s]')
ylabel('a(t) [g]')
title('Aceleración aleatoria generada')
grid on

subplot(2,1,2)
[pxx,f] = pwelch(a, hamming(2048), [], [], fs);
plot(f, pxx)
xlim([0 2500])
xlabel('Frecuencia [Hz]')
ylabel('PSD [g²/Hz]')
title('PSD estimada (Welch)')
grid on
