% Developed in MATLAB R2013b
% Source codes demo version 1.0.6. Updated 12.5.2021
% _____________________________________________________

%  Author, inventor and programmer: Ali Asghar Heidari,
%  PhD research intern, Department of Computer Science, School of Computing, National University of Singapore, Singapore
%  Exceptionally Talented Ph. DC funded by Iran's National Elites Foundation (INEF), University of Tehran
%  03-03-2019

%  Researchgate: https://www.researchgate.net/profile/Ali_Asghar_Heidari

%  e-Mail: as_heidari@ut.ac.ir, aliasghar68@gmail.com,
%  e-Mail (Singapore): aliasgha@comp.nus.edu.sg, t0917038@u.nus.edu

% _____________________________________________________
%  Co-authors: Hossam Faris, Ibrahim Aljarah, Majdi Mafarja, and Hui-Ling Chen



%       Homepage: http://www.evo-ml.com/2019/03/02/hho/
%                 https://aliasgharheidari.com/HHO.html
% _____________________________________________________

%  Please refer to the main paper:
% Ali Asghar Heidari, Seyedali Mirjalili, Hossam Faris, Ibrahim Aljarah, Majdi Mafarja, Huiling Chen
% Harris hawks optimization: Algorithm and applications
% Future Generation Computer Systems, DOI: https://doi.org/10.1016/j.future.2019.02.028
% _____________________________________________________

%  Researchgate: https://www.researchgate.net/profile/Ali_Asghar_Heidari
%  Website of HHO: http://www.aliasgharheidari.com/HHO.html

% You can also use and compare with our other new optimization methods: (HHO)-2019- http://www.aliasgharheidari.com/HHO.html
%                                                                       (SMA)-2020- http://www.aliasgharheidari.com/SMA.html
%                                                                       (HGS)-2021- http://www.aliasgharheidari.com/HGS.html
%                                                                       (RUN)-2021- http://www.aliasgharheidari.com/RUN.html

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc
weights = randi([1, 150], 1, 150);

N = 150; % Número de agentes de búsqueda
T = 50; % Máximo número de iteraciones
lb = 0; % límite inferior para cada elemento de la solución
ub = 150; % límite superior para cada elemento de la solución
dim = 150; % dimensión de la solución
iterations = 1:T; % Vector de números de iteración

% Inicializar las ubicaciones de los halcones de Harris
X = initialization(N, dim, ub, weights);

% Llamar al algoritmo HHO con la función objetivo personalizada
[Rabbit_Energy, Rabbit_Location, CNVG] = HHO(N, T, lb, ub, dim, @(sol)obj_func(sol, weights, N, dim));
figure;
plot(iterations, CNVG, 'b'); % Grafica las iteraciones en el eje x y el número de contenedores en el eje y
title('Número de contenedores en función del número de iteraciones');
xlabel('Número de iteraciones');
ylabel('Número de contenedores');
grid on;


function total_weight_diff = obj_func(solution, weights, N, dim)
    % Apply capacity constraint to solution
    for i=1:N
        container_weight = 0;
        for j=1:dim
            if container_weight + weights(j) <= 150
                container_weight = container_weight + weights(j);
            else
                solution(i,j) = 0;
            end
        end
    end
    % Calculate total weight of objects in each container
    container_weights = solution * weights'; % transpose weights here
    % Calculate difference between container capacity and total weight of objects
    weight_diff = 150 - container_weights;
    % Sum up all differences
    total_weight_diff = sum(weight_diff);

    % Count the number of containers used
    num_containers = sum(sum(solution > 0));

    % Add penalty to total_weight_diff if number of containers is out of range
    if num_containers < 80 || num_containers > 150
        total_weight_diff = total_weight_diff + 1e6; % Add a large penalty
    end
end



% Define the initialization function
function [X] = initialization(N, dim, up, down)
    X = zeros(N, dim);
    for i = 1:N
        container_weight = 0;
        for j = 1:dim
            if container_weight + down(j) <= up
                X(i,j) = 1;
                container_weight = container_weight + down(j);
            end
        end
    end
end


