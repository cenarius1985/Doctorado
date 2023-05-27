clear all; close all; clc
% Parámetros específicos del problema Bin Packing
global weights
weights = [ 42, 69, 67, 57, 93, 90, 38, 36, 45, 42, 33, 79, 27, 57, 44, 84, 86, 92, 46, 38, 85, 33, 82, 73, 49, ...
            70, 59, 23, 57, 72, 74, 69, 33, 42, 28, 46, 30, 64, 29, 74, 41, 49, 55, 98, 80, 32, 25, 38, ...
            82, 30, 35, 39, 57, 84, 62, 50, 55, 27, 30, 36, 20, 78, 47, 26, 45, 41, 58, 98, 91, 96, 73, ...
            84, 37, 93, 91, 43, 73, 85, 81, 79, 71, 80, 76, 83, 41, 78, 70, 23, 42, 87, 43, 84, 60, 55, ...
            49, 78, 73, 62, 36, 44, 94, 69, 32, 96, 70, 84, 58, 78, 25, 80, 58, 66, 83, 24, 98, 60, 42, ...
            43, 43, 39, 97, 57, 81, 62, 75, 81, 23, 43, 50, 38, 60, 58, 70, 88, 36, 90, 37, 45, 45, 39, ...
            44, 53, 70, 24, 82, 81, 47, 97, 35, 65, 74, 68, 49, 55, 52, 94, 95, 29, 99, 20, 22, 25, 49, ...
            46, 98, 59, 98, 60, 23, 72, 33, 98, 80, 95, 78, 57, 67, 53, 47, 53, 36, 38, 92, 30, 80, 32, ...
            97, 39, 80, 72, 55, 41, 60, 67, 53, 65, 95, 20, 66, 78, 98, 47, 100, 85, 53, 53, 67, 27, 22, 61, ...
            43, 52, 76, 64, 61, 29, 30, 46, 79, 66, 27, 79, 98, 90, 22, 75, 57, 67, 36, 70, 99, 48, 43, ...
            45, 71, 100, 88, 48, 27, 39, 38, 100, 60, 42, 20, 69, 24, 23, 92, 32];

T = 100;     % Número máximo de iteraciones
N = 50;      % Tamaño de la población
global dim
dim = 150;              % Dimensión del problema
lb = 1;                 % Límite inferior de búsqueda
ub = 150;               % Límite superior de búsqueda


bin_packing_objective_function = @(x) bin_packing_objective(x);

[Rabbit_Energy,Rabbit_Location,CNVG] = HHO(N, T, lb, ub, dim, bin_packing_objective_function);

% Define la función de optimización
function fitness = bin_packing_objective(solution)
    global weights dim  % Asegúrate de que weights sea accesible
    num_bins = round(max(solution));
    bins = zeros(1, num_bins);
    
    for i = 1:length(solution)
        idx = round(max(1, solution(i)));
        if idx > length(bins)
            bins(idx) = 0; % esto expandirá automáticamente el tamaño de 'bins'
        end
        bins(idx) = bins(idx) + weights(i);
    end
   
    for i = 1:length(solution)
        bins(round(max(1,solution(i)))) = bins(round(max(1,solution(i)))) + weights(i);
    end
    
    fitness = sum(bins > dim) * 1e6 + num_bins;  % Penalización por exceder la capacidad
end

% Define la función de HHO
function [Rabbit_Energy,Rabbit_Location,CNVG]=HHO(N,T,lb,ub,dim,fobj)
    disp('HHO is now tackling your problem')
    tic
    % initialize the location and Energy of the rabbit
    Rabbit_Location=zeros(1,dim);
    Rabbit_Energy=inf;

    %Initialize the locations of Harris' hawks
    X=initialization(N,dim,ub,lb);

    CNVG=zeros(1,T);

    t=0; % Loop counter

    while t<T
        for i=1:size(X,1)
            % Check boundries
            FU=X(i,:)>ub;FL=X(i,:)<lb;X(i,:)=(X(i,:).*(~(FU+FL)))+ub.*FU+lb.*FL;
            % fitness of locations
            fitness = fobj(X(i,:));
            % Update the location of Rabbit
            if fitness<Rabbit_Energy
                Rabbit_Energy=fitness;
                Rabbit_Location=X(i,:);
                % Guarda los bins correspondientes a la mejor solución
                [Rabbit_Energy, Rabbit_Bins] = fobj(X(i,:));
            end
            
            
            
            
            
            
            
            
            
            
        end
        E1=2*(1-(t/T)); % factor to show the decreaing energy of rabbit
    % Update the location of Harris' hawks
    for i=1:size(X,1)
        E0=2*rand()-1; %-1<E0<1
        Escaping_Energy=E1*(E0);  % escaping energy of rabbit
        
        if abs(Escaping_Energy)>=1
            %% Exploration:
            % Harris' hawks perch randomly based on 2 strategy:
            
            q=rand();
            rand_Hawk_index = floor(N*rand()+1);
            X_rand = X(rand_Hawk_index, :);
            if q<0.5
                % perch based on other family members
                X(i,:)=X_rand-rand()*abs(X_rand-2*rand()*X(i,:));
            elseif q>=0.5
                % perch on a random tall tree (random site inside group's home range)
                X(i,:)=(Rabbit_Location(1,:)-mean(X))-rand()*((ub-lb)*rand+lb);
            end
            
        elseif abs(Escaping_Energy)<1
            %% Exploitation:
            % Attacking the rabbit using 4 strategies regarding the behavior of the rabbit
            
            %% phase 1: surprise pounce (seven kills)
            % surprise pounce (seven kills): multiple, short rapid dives by different hawks
            
            r=rand(); % probablity of each event
            
            if r>=0.5 && abs(Escaping_Energy)<0.5 % Hard besiege
                X(i,:)=(Rabbit_Location)-Escaping_Energy*abs(Rabbit_Location-X(i,:));
            end
            
            if r>=0.5 && abs(Escaping_Energy)>=0.5  % Soft besiege
                Jump_strength=2*(1-rand()); % random jump strength of the rabbit
                X(i,:)=(Rabbit_Location-X(i,:))-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
            end
            
            %% phase 2: performing team rapid dives (leapfrog movements)
            if r<0.5 && abs(Escaping_Energy)>=0.5, % Soft besiege % rabbit try to escape by many zigzag deceptive motions
                
                Jump_strength=2*(1-rand());
                X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
                
                if fobj(X1)<fobj(X(i,:)) % improved move?
                    X(i,:)=X1;
                else % hawks perform levy-based short rapid dives around the rabbit
                    X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:))+rand(1,dim).*Levy(dim);
                    if (fobj(X2)<fobj(X(i,:))), % improved move?
                        X(i,:)=X2;
                    end
                end
            end
            
            if r<0.5 && abs(Escaping_Energy)<0.5, % Hard besiege % rabbit try to escape by many zigzag deceptive motions
                % hawks try to decrease their average location with the rabbit
                Jump_strength=2*(1-rand());
                X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X));
                
                if fobj(X1)<fobj(X(i,:)) % improved move?
                    X(i,:)=X1;
                else % Perform levy-based short rapid dives around the rabbit
                    X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X))+rand(1,dim).*Levy(dim);
                    if (fobj(X2)<fobj(X(i,:))), % improved move?
                        X(i,:)=X2;
                    end
                end
            end
            %%
        end
    end
    t=t+1;
    CNVG(t)=Rabbit_Energy;
%    Print the progress every 100 iterations
    if mod(t,100)==0
        display(['At iteration ', num2str(t), ' the best fitness is ', num2str(Rabbit_Energy)]);
    end 
    end
    toc
end


function X = initialization(N, dim, ub, lb)
    % Generate N vectors, each of dimension dim
    % Each element of the vector is a random number between lb and ub
    X = randi([lb, ub], N, dim);
end

function o=Levy(d)
    beta=1.5;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
    o=step;
end



