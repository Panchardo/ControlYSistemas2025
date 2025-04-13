
%Tono de 300 Hz, más tono de 600 Hz, más tono de 50 Hz (frecuencia de línea eléctrica). 
% Parámetros de la señal
f300 = 300; f600 = 600; f50 = 50;               % Frecuencia de la señal (Hz)
fs = 6000;                                      % Frecuencia de muestreo (Hz)
tiempo_inicio = 0;                              % Tiempo inicial (s)
tiempo_final = 1;                               % Tiempo final (s)

periodo_muestreo = 1/fs;  % Periodo de muestreo
t = tiempo_inicio:periodo_muestreo:tiempo_final; % Vector de tiempo

signal = sin(2*pi*f300*t); % Generación de la señal senoidal