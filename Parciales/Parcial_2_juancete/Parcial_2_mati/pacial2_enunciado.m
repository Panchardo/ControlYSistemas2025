%% Ejercicio 1. 
% Construya un modelo en simulink usando simscape (mec�nica 
% traslacional) de la suspensi�n de un cuarto de veh�culo (un colectivo).
% Los par�metros se dan abajo.
% Las perturbaciones del terreno aparecen a los 50 segundos y se modelan 
% como un ruido de 1 m/s^2 RMS (el bloque Band-Limited White Noise ya est� configurado)
% SI EL MODELO ES CORRECTO, generan compresiones de la suspensi�n 
% de 3 a 4 cm pico.
% (2 puntos)

%Se conectan el resorte que, une el chasis con la rueda, en paralelo con el almotriguador.Todo este
%conjunto se conecta en seie con el resorte de la rueda,luego se colocan
%las mazas sobre cada nodo. Una conectada encima del resorte y amortiguador
%y otra entre los elementos series. Luego se coloca el sensor de posicion
%entre las dos puntos en los que se conectan las masas. Y finalmente se
%colocan las fuerzas y velocidad entrantes
%% Ejercicio 2. 
% Considerando un sensor ideal de distancia para medir la compresi�n de
% la suspensi�n:
% Implemente un PID para que el colectivo descienda y permita el ingreso 
% de pasajeros. 
% Este controlador, cuando el chofer da un escal�n a la referencia
% de -10 cm a los 10 s, debe hacer que la suspensi�n se comprima 10 cm, 
% sin error en estado estacionario, sin sobre-impulso y con un tiempo de 
% establecimiento de menos de 1.0 s.
% Por otra parte, cuando sube el pasajero, modelado como perturbaci�n
% tipo escal�n de 700 N a los 20 s, el controlador debe rechazar la 
% perturbaci�n con un tiempo de establecimiento de menos de 1.0 s.
% Un pasajero baja a los 25 s, lo cual tambi�n se modela con un escal�n.
% Para esto puede usar el comando 
% pidTuner(H, 'PID');
% y obtener las ganancias por tanteo observando la tabla mostrada al pulsar 
% el bot�n Show Parameters.
% (2 puntos)


%% Ejercicio 3
% Modifique el controlador de manera que la acci�n de control nunca 
% supere los 20000 N en valor absoluto. Se permite degradaci�n del
% desempe�o ante el escal�n en la referencia, pero ante el escal�n de la
% perturbaci�n debe mantener la din�mica.
% (2 puntos)


%% Ejercicio 4
% Agregue al modelo de simulink los componentes necesarios para modelar los
% siguientes detalles:
% La compresi�n de la suspensi�n se mide con tres sensores de distancia que
% tienen los siguientes ruidos (no correlacionados):
% Sensor A: 10 mm RMS (el bloque Band-Limited White Noise ya est� configurado)
% Sensor B: 5 mm RMS (el bloque Band-Limited White Noise ya est� configurado)
% Sensor C: 5 mm RMS (el bloque Band-Limited White Noise ya est� configurado)
% (1 punto)


%% Ejercicio 5
% Dise�e e implemente un observador de estado (posiblemente como filtro de 
% Kalman) de manera de tener una estimaci�n de la altura del chasis con un
% ruido RMS menor a 5 mm.
% (2 puntos) Si lo dise�a por ubicaci�n de polos (usando place o aker)
% (3 puntos) Si lo dise�a como filtro de Kalman-Bucy de tiempo continuo 
% (usando lqr), puede llegar a un ruido de 3.5 mm RMS en la primer intento
% correcto


%% Parameters (golden car)
clc
clear
close all

m_s = 3000;  % Sprung mass (masa del chasis por rueda) (kg)
k_s = 63.3*m_s;  % Spring stiffness (rigidez del resorte) (N/m)
c_s = 6*m_s;  % Damping coefficient (coeficiente de amortiguamiento del amortiguador) (Ns/m)
k_t = 653*m_s;  % Tire stiffness (rigidez del neum�tico) (N/m)
c_t = 0;  % Tire damping (Ns/m)
m_u = 0.15*m_s;  % (masa de la rueda) Unsprung mass (kg)

% 
%% Dise�o del PID
% x = [pos_u
%      pos_s
%      vel_u
%      vel_s]

M = [m_u 0
     0   m_s];
K = [k_s+k_t -k_s
     -k_s     k_s];
C = [c_s+c_t -c_s
     -c_s     c_s];
A_ss = [ 0 0 1 0 
         0 0 0 1
        -M\K -M\C]; 

B_ss = [ 0
         0
         (M^-1) * [ -1
                    1 ]];

C_ss = [ 1 -1 0 0];
D_ss = [ 0 ];
     
H = tf(ss(A_ss, B_ss, C_ss, D_ss))
stepinfo(H)
pidTuner(H, 'PID');


% % dise�o del filtro de Kalman
C_obs = [ 1 -1 0 0
          1 -1 0 0 
          1 -1 0 0 ];
B_ss_terreno = [ 0
                 0
                 k_t
                 0 ];
Q_proceso = B_ss_terreno * [1^2] * B_ss_terreno';
R_sensores = [ 10^2 0       0 
               0       5^2 0
               0       0       5^2 ];

L = (lqr(A_ss', C_obs', Q_proceso, R_sensores))';

