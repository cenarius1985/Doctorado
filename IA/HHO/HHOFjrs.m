clear all; close all; clc
load('Pesos_Productos.mat')

N = 50; % Número de agentes de búsqueda
T = 10; % Máximo número de iteraciones
lb = 0; % límite inferior para cada elemento de la solución
ub = 150; % límite superior para cada elemento de la solución
dim = numel(weight); % dimensión de la solución
iterations = 1:T; % Vector de números de iteración
bin_capacity = 150; % Define la capacidad de los bins

[Rabbit_Energy, Rabbit_Location, CNVG] = HHO(N, T, lb, ub, dim, @(x) obj_func(x, weight, bin_capacity));

disp('El mejor resultado encontrado:');
disp(['Energía del conejo: ', num2str(Rabbit_Energy)]);
disp(['Ubicación del conejo: ', num2str(Rabbit_Location)]);

figure;
subplot(2,1,1)
plot(iterations, CNVG, 'b-', 'LineWidth', 2);
xlabel('Iteración');
ylabel('Energía del conejo');
title('Convergencia de HHO');

subplot(2,1,2)
load('contenedores.mat');
plot(contenedores, 'b-', 'LineWidth', 2);
xlabel('Numero de Contenedores');
ylabel('Numero de Contenedores');
title('Convergencia de HHO');
grid on;


%%

function [Rabbit_Energy, Rabbit_Location, CNVG] = HHO(N, T, lb, ub, dim, fobj)
    disp('HHO is now tackling your problem');
    tic

    % Inicializar la ubicación y energía del conejo
    Rabbit_Location = zeros(1, dim);
    Rabbit_Energy = inf;

    % Inicializar las ubicaciones de los halcones de Harris
    X = initialization(N, dim, ub, lb);

    CNVG = zeros(1, T);
    t = 0; % Contador de iteraciones

    while t < T
        for i = 1:size(X, 1)
            % Comprobar límites
            FU = X(i, :) > ub;
            FL = X(i, :) < lb;
            X(i, :) = (X(i, :) .* (~(FU + FL))) + ub .* FU + lb .* FL;

            % Evaluar aptitud de las ubicaciones
            fitness = fobj(X(i, :));

            % Actualizar la ubicación del conejo
            if fitness < Rabbit_Energy
                Rabbit_Energy = fitness;
                Rabbit_Location = X(i, :);
            end
        end

        E1 = 2 * (1 - (t / T)); % Factor que muestra la energía decreciente del conejo

        % Actualizar la ubicación de los halcones de Harris
        for i = 1:size(X, 1)
            E0 = 2 * rand() - 1; % -1 < E0 < 1
            Escaping_Energy = E1 * E0; % Energía de escape del conejo

            if abs(Escaping_Energy) >= 1
                % Exploración
                q = rand();
                rand_Hawk_index = floor(N * rand() + 1);
                X_rand = X(rand_Hawk_index, :);

                if q < 0.5
                    % Perchar basado en otros miembros de la familia
                    X(i, :) = X_rand - rand() * abs(X_rand - 2 * rand() * X(i, :));
                elseif q >= 0.5
                    % Perchar en un árbol alto aleatorio (sitio aleatorio dentro del rango del hogar del grupo)
                    X(i, :) = (Rabbit_Location(1, :) - mean(X)) - rand() * ((ub - lb) * rand + lb);
                end
            elseif abs(Escaping_Energy) < 1
                % Explotación
                r = rand(); % Probabilidad de cada evento

                if r >= 0.5 && abs(Escaping_Energy) < 0.5
                    % Asedio fuerte
                    X(i, :) = (Rabbit_Location) - Escaping_Energy * abs(Rabbit_Location - X(i, :));
                end

                if r >= 0.5 && abs(Escaping_Energy) >= 0.5
                    % Asedio suave
                    Jump_strength = 2 * (1 - rand()); % Fuerza de salto aleatoria del conejo
                    X(i, :) = (Rabbit_Location - X(i, :)) - Escaping_Energy * abs(Jump_strength * Rabbit_Location - X(i, :));
                end

                if r < 0.5 && abs(Escaping_Energy) >= 0.5
                    % Asedio suave con buceos rápidos progresivos
                    Jump_strength = 2 * (1 - rand());
                    X1 = Rabbit_Location - Escaping_Energy * abs(Jump_strength * Rabbit_Location - X(i, :));

                    if fobj(X1) < fobj(X(i, :)) % ¿Mejora el movimiento?
                        X(i, :) = X1;
                    else
                        % Buceos rápidos basados en Levy alrededor del conejo
                        X2 = Rabbit_Location - Escaping_Energy * abs(Jump_strength * Rabbit_Location - X(i, :)) + rand(1, dim) .* Levy(dim);
                        if fobj(X2) < fobj(X(i, :)) % ¿Mejora el movimiento?
                            X(i, :) = X2;
                        end
                    end
                end

                if r < 0.5 && abs(Escaping_Energy) < 0.5
                    % Asedio fuerte con buceos rápidos progresivos
                    Jump_strength = 2 * (1 - rand());
                    X1 = Rabbit_Location - Escaping_Energy * abs(Jump_strength * Rabbit_Location - mean(X));

                    if fobj(X1) < fobj(X(i, :)) % ¿Mejora el movimiento?
                        X(i, :) = X1;
                    else
                        % Buceos rápidos basados en Levy alrededor del conejo
                        X2 = Rabbit_Location - Escaping_Energy * abs(Jump_strength * Rabbit_Location - mean(X)) + rand(1, dim) .* Levy(dim);
                        if fobj(X2) < fobj(X(i, :)) % ¿Mejora el movimiento?
                            X(i, :) = X2;
                        end
                    end
                end
            end
        end

        t = t + 1;
        CNVG(t) = Rabbit_Energy;

        % Imprimir el progreso cada 100 iteraciones
%         if mod(t, 100) == 0
%             disp(['En la iteración ', num2str(t), ', la mejor aptitud es ', num2str(Rabbit_Energy)]);
%         end
    end
    toc
end

%%
function X = initialization(N, dim, ub, lb)
    if size(ub, 1) == 1
        X = randi([lb, ub], N, dim);
    end
    if size(ub, 1) > 1
        X = zeros(N, dim);
        for i = 1:dim
            high = ub(i);
            low = lb(i);
            X(:, i) = randi([low, high], N, 1);
        end
    end
end

function [fitness] = obj_func(x, weight, bin_capacity)
    num_bins = 0;
    contenedores=[];
    remaining_capacity = zeros(size(x));

    for i = 1:numel(x)
        item_weight = weight(i);
        assigned = false;

        for j = 1:num_bins
            if remaining_capacity(j) >= item_weight
                remaining_capacity(j) = remaining_capacity(j) - item_weight;
                assigned = true;
                break;
            end
        end

        if ~assigned
            num_bins = num_bins + 1
            contenedores(j)= num_bins;
            remaining_capacity(num_bins) = bin_capacity - item_weight;
        end
    end
    
    fitness = num_bins;
    save('contenedores.mat', 'contenedores');
end
%%
function o=Levy(d)
    beta=1.5;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
    o=step;
end


