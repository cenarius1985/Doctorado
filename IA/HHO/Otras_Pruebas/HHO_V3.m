clear all; close all; clc

global weights
weights = [42, 69, 67, 57, 93, 90, 38, 36, 45, 42, 33, 79, 27, 57, 44, 84, 86, 92, 46, 38, 85, 33, 82, 73, 49, ...
        97, 39, 80, 72, 55, 41, 60, 67, 53, 65, 95, 20, 66, 78, 98, 47, 100, 85, 53, 53, 67, 27, 22, 61, ...
        43, 52, 76, 64, 61, 29, 30, 46, 79, 66, 27, 79, 98, 90, 22, 75, 57, 67, 36, 70, 99, 48, 43, ...
        45, 71, 100, 88, 48, 27, 39, 38, 100, 60, 42, 20, 69, 24, 23, 92, 32];

T = 10000;
N = 50;
global dim
dim = 150;
lb = 1;
ub = 150;

bin_packing_objective_function = @(x) bin_packing_objective(x);

[Rabbit_Energy, Rabbit_Location, CNVG, Best_bins] = HHO(N, T, lb, ub, dim, bin_packing_objective_function);

disp('La mejor disposición de elementos es:');
disp(Best_bins);
disp(['Se utilizan ', num2str(length(unique(Best_bins))), ' contenedores.']);

figure
plot(CNVG)
xlabel('Iteración')
ylabel('Fitness del conejo')
title('Fitness del conejo vs Iteración')

function [fitness, bins] = bin_packing_objective(solution)
    global weights dim 
    num_bins = round(max(solution));
    bins = zeros(1, num_bins);
    for i = 1:length(solution)
        idx = round(max(1, solution(i)));
        if idx > length(bins)
            bins(idx) = 0;
        end
        bins(idx) = bins(idx) + weights(i);
    end
    fitness = sum(bins > dim) * 1e6 + num_bins;
end

function [Rabbit_Energy, Rabbit_Location, CNVG, Best_bins] = HHO(N, T, lb, ub, dim, fobj)
    disp('HHO is now tackling your problem')
    tic
    Rabbit_Location=zeros(1,dim);
    Rabbit_Energy=inf;
    Best_bins = [];

    X=initialization(N,dim,ub,lb);
    CNVG=zeros(1,T);

    t=0; 
    while t<T
        for i=1:size(X,1)
            FU=X(i,:)>ub;FL=X(i,:)<lb;X(i,:)=(X(i,:).*(~(FU+FL)))+ub.*FU+lb.*FL;
            [fitness, bins] = fobj(X(i,:));

            if fitness<Rabbit_Energy
                Rabbit_Energy=fitness;
                Rabbit_Location=X(i,:);
                Best_bins = bins;
            end
        end
        a=2-t*((2)/T);
        a2=-1+t*((-1)/T);

        for i=1:size(X,1)
            E0=2*a*rand-a;  E=2*rand-1;   
            X1=Rabbit_Location; 
            if abs(E)>=1
                EP=E0; 
                if EP>=0
                    X_rand=Rabbit_Location;
                else
                    X_rand=X(randi([1 size(X,1)],1,1),:);
                end
                X2=X_rand-E0*abs(X_rand-X1);
                X(i,:)=X2;
            else
                X2=X1+E*a2*(X1-X(i,:));
                X(i,:)=X2;
            end
        end
        t=t+1;
        CNVG(t)=Rabbit_Energy;
        disp(['At iteration ', num2str(t), ' the best fitness is ', num2str(Rabbit_Energy)]);
    end
    disp('The best solution is: ');
    disp(Rabbit_Location);
    disp('The best objective is: ');
    disp(Rabbit_Energy);

    timeElapsed = toc;
    disp(['The elapsed time is ', num2str(timeElapsed), ' seconds']);
end

function Positions=initialization(SearchAgents_no,dim,ub,lb)
    Boundary_no= size(ub,2); 
    if Boundary_no==1
        Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
    else
        for i = 1:size(lb,2)
            ub_i=ub(i);
            lb_i=lb(i);
            Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
        end
    end
end
