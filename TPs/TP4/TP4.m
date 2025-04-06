
clear
clc
close all
%%EJ 1

% Parámetros de la señal
frecuencia = 100;         % Frecuencia de la señal (Hz)
frec_muestreo = 1000;     % Frecuencia de muestreo (Hz)
tiempo_inicio = 0;        % Tiempo inicial (s)
tiempo_final = 1;         % Tiempo final (s)

% Cálculo de parámetros derivados
periodo_muestreo = 1/frec_muestreo;  % Periodo de muestreo
t = tiempo_inicio:periodo_muestreo:tiempo_final; % Vector de tiempo

% Generación de la señal senoidal
signal = sin(2*pi*frecuencia*t);

% Graficación
figure;
plot(t, signal);
title('Señal Senoidal de 100 Hz muestreada a 1000 Hz');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on;


disp(['Frecuencia de la señal: ', num2str(frecuencia), ' Hz']);
disp(['Frecuencia de muestreo: ', num2str(frec_muestreo), ' Hz']);
disp(['Número de muestras: ', num2str(length(t))]);

% el muestreo no deja ver los picos


%% EJ 2

SNR = 10; % dB
%Función awgn propia
signal_ruidosa = my_awgn(signal, SNR);
%Función awgn de Matlab
signal_awgn = awgn(signal, SNR); % awgn(X,snr) adds white Gaussian noise to the vector signal X. This syntax assumes that the power of X is 0 dBW.

% Graficar comparación
figure(2);
subplot(3,1,1); plot(t, signal); title('Señal original');
subplot(3,1,2); plot(t, signal_ruidosa); title('Señal con my\_awgn');
subplot(3,1,3); plot(t, signal_awgn); title('Señal con awgn de MATLAB');



%% EJ 4

X = 2.5;
sigma = 2.5/sqrt(2);

for B = 1:32
    B
    SNR_ADC = 6.02*B - 20*log(X/sigma) + 10.8
end

%% EJ 5

nivel_cuant = 10/2^12
SNR_ej5 = 6.02 * 11 - 20*log(5 / 3.5 * sqrt(2)) + 10.8 % La señal no utiliza el rango entero del ADC, es decir, no es de excursión completa

%% EJ 6

% a ) Error por offset
% b ) Error de linealización
% c ) Error por factor de escala no lineal (ajustar el factor de escala,
% como el que puse en Simulink a la salida del ADC dependiendo de donde caiga la lectura)
% d ) Pérdida de códigos palabras
%% Funciones


function senal_ruidosa = my_awgn(signal, snr)
    var_senal = var(signal);
    var_ruido = var_senal/10^(snr/10) %% SE ASUME QUE LA SEÑAL TIENE MEDIA 0, LA VARIANZA SOLO CAPTURA LA POTENCIA DE LA PARTE VARIABLE

    ruido = sqrt(var_ruido) * randn(1,length(signal));
    senal_ruidosa = signal + ruido;
end
