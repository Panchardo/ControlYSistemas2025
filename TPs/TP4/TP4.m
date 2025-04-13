
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
signal = sin(2*pi*frecuencia*t)+5;

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
signal_awgn = awgn(signal, SNR, 'measured'); % awgn(X,snr) adds white Gaussian noise to the vector signal X. This syntax assumes that the power of X is 0 dBW.
var_senal_ruidosa = var(signal_awgn)
% Graficar comparación
figure(2);
subplot(3,1,1); plot(t, signal); title('Señal original');
subplot(3,1,2); plot(t, signal_ruidosa); title('Señal con my\_awgn');
subplot(3,1,3); plot(t, signal_awgn); title('Señal con awgn de MATLAB');



%% EJ 4

X = 2.5;
sigma = 2.5/sqrt(2);

% Rango de bits
vectorB = 2:32;

% Inicializar vectores
SNR_ADC = zeros(size(vectorB));
SNR_teorico = zeros(size(vectorB));

% Cálculo de SNR
for i = 1:length(vectorB)
    B = vectorB(i);
    SNR_ADC(i) = 6.02*(B - 1) - 20*log10(X/sigma) + 10.8;
 %   SNR_teorico(i) = 6.02 * B + 1.76;
end

% Graficar
figure;
plot(vectorB, SNR_ADC, 'ro-', 'LineWidth', 2, 'DisplayName', 'SNR ADC (modificada)');
hold on;
%plot(vectorB, SNR_teorico, 'b--', 'LineWidth', 2, 'DisplayName', 'SNR Teórica');
grid on;
xlabel('Bits del ADC');
ylabel('SNR (dB)');
title('SNR del ADC');
legend('Location', 'southeast');

%% EJ 5

nivel_cuant = 10/2^12
SNR_ej5 = 6.02 * 11 - 20*log(5 / 3.5 * sqrt(2)) + 10.8 % La señal no utiliza el rango entero del ADC, es decir, no es de excursión completa

%% EJ 6

% a ) Error por offset -- Se soluciona con un sumador
% b ) Error de linealización -- Se soluciona con un amplificador o
% atenuador.
% c ) Error por factor de escala no lineal (ajustar el factor de escala,
% como el que puse en Simulink a la salida del ADC dependiendo de donde
% caiga la lectura). Se soluciona haciendo una tabla de correspondencias.
% d ) Pérdida de códigos palabras. Puede pasar cuando el los valores de la
% señal no se actualizan porque el micro se quedo haciendo un calculo que
% excedio el tiempo de muestreo.
%% Funciones


function senal_ruidosa = my_awgn(signal, snr)
    var_senal = var(signal);
    var_ruido = var_senal/10^(snr/10) %% SE ASUME QUE LA SEÑAL TIENE MEDIA 0, LA VARIANZA SOLO CAPTURA LA POTENCIA DE LA PARTE VARIABLE

    ruido = sqrt(var_ruido) * randn(1,length(signal));
    senal_ruidosa = signal + ruido;
end

% Señal continua -- espectro aperiodico y viceversa
% Señal discreta -- espectro periodico y viceversa
% Señal real -- espectro par y viceversa

