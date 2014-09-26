%% hitogramas_anuales.m
% Genera las gr�ficas de histogramas anuales y realiza la prueba de
% hip�tesis para afirmar o rechazar si la distribuci�n de los datos de las
% primeras dos repeticiones provienen de la misma distribuci�n.
%
% Se asume que el campo ya se encuentra simulado

% Julio Waissman, Luis D�az y Camilo Arancibia, 2014

clear all
close all
clc

%% Informaci�n sobre el archivo a abrir

% campo = 0 es el campo chico, y campo = 1 es el campo mediano
campo = 0;
if campo == 0
    archivos_datos = '../data_gen/campo_chico/heliostato';    
    archivos_imagen = '../figuras/campo_chico/histograma_anual';
elseif campo == 1
    archivos_datos = '../data_gen/campo_grande/heliostato';    
    archivos_imagen = '../figuras/campo_grande/histograma_anual';
end
heliostatos = load(archivo_posiciones, '-ascii');    % Campo chico

% desviaciones (solo un vector) asumiendo que se simul� previamente el
% campo utilizando la funci�n simulacion_anual.m
desviaciones = [3e-3, 3e-3, 3e-3, 3e-3];
des_str = sprintf('_%1.0f', desviaciones_nominales * 1e3);
        

%% Ahora vamos a obtener los errores de todos los heli�statos 

E = [];
for h = 1:size(heliostatos, 1)
    load([archivos_datos, int2str(h), des_str]);
    temp = TNE(:,3:end);
    E = [E; temp]; %Todos en un solo histograma
    clear TNE TNX TNY
end

%% Graficacion de histogramas
% Teniendo E, se realiza un histograma por columna

for r = 1:size(E, 2)
    figure();
    hist(E(:,r), d);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');

    title(['\fontsize{22}', ' Temporada: ',casos{caso},'\newline Desviaciones: ',texto{desviaciones}]);

    ylabel('Frequency', 'FontSize', 22, 'FontName', 'Times New Roman');
    xlabel('\theta (rad)', 'FontSize', 22, 'FontName', 'Times New Roman')

    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.fig']);
    saveas(gcf, [archivos_imagen, int2str(r), des_str,'.png']);
end

%% Prueba de hip�tesis
% Prueba que 2 muestras provienen de la misma distribuci�n
[h,p,stats] = ansaribradley(E(:,1), E(:,2))

    
