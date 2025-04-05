
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

SNR = 0.5; % dB
%Función awgn propia
signal_ruidosa = my_awgn(signal, SNR);
%Función awgn de Matlab
signal_awgn = awgn(signal, SNR); % awgn(X,snr) adds white Gaussian noise to the vector signal X. This syntax assumes that the power of X is 0 dBW.

% Graficar comparación
figure(2);
subplot(3,1,1); plot(t, signal); title('Señal original');
subplot(3,1,2); plot(t, signal_ruidosa); title('Señal con my\_awgn');
subplot(3,1,3); plot(t, signal_awgn); title('Señal con awgn de MATLAB');


function senal_ruidosa = my_awgn(signal, snr)
    var_senal = var(signal);
    var_ruido = var_senal/10^(snr/10); %% SE ASUME QUE LA SEÑAL TIENE MEDIA 0, LA VARIANZA SOLO CAPTURA LA POTENCIA DE LA PARTE VARIABLE

    ruido = sqrt(var_ruido) * randn(1,length(signal));

    senal_ruidosa = signal + ruido;
end
