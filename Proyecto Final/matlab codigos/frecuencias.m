% Rango de frecuencias a graficar
f_vals = 5:1:2000;

% Calcular wp para cada frecuencia
wp_vals = arrayfun(@wpfreq, f_vals);

% Graficar
figure('Position', [100, 100, 800, 600]);
plot(f_vals, wp_vals, 'b-', 'LineWidth', 2);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('\omega_p (rad/s)');
title('\omega_p vs Frecuencia');


function wp = wpfreq(f)
    % Tabla de frecuencia (Hz) y valores correspondientes de wp
    freq_table = [ ...
          5,  10,  20,  25,  30,  40,  50,  60,  70,  80, ...
         90, 100, 200, 300, 400, 500, 600,700,800, 900, 1000, 1100,1200, 1300, 1450, 1500,1800, 2000];

    wp_table = [ ...
         20,  10,  15,  15,  15,  15,  15,  18,  20,  20, ...
         30,  17,  25,  30,  35, 35,40,60, 80, 80,  100, 100,100, 100, 100,  120,90,  100];

    % Interpolación lineal
    wp = interp1(freq_table, wp_table, f, 'linear', 'extrap');
    wp = wp*0.8
end

