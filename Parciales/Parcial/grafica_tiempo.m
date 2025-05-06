function grafica_tiempo(t, x, titulo)
% grafica_tiempo - Grafica una señal en función del tiempo con estilo
%
% Parámetros:
%   t      - Vector de tiempo
%   x      - Vector de la señal
%   titulo - Título del gráfico (string)

    figure;
    plot(t, x, 'LineWidth', 1.5);
    xlabel('Tiempo [s]');
    ylabel('Amplitud');
    title(titulo);
    grid on;

    % Ajuste automático de límites
    xlim([min(t), max(t)]);
    ylim([min(x), max(x)]);
end
