% Source codes demo version 1.0.6 Updated 12. 5. 2021
% ------------------------------------------------------------------------------------------------------------
% Main paper (Please refer to the main paper):
% Slime Mould Algorithm: A New Method for Stochastic Optimization
% Shimin Li, Huiling Chen, Mingjing Wang, Ali Asghar Heidari, Seyedali Mirjalili
% Future Generation Computer Systems,2020
% DOI: https://doi.org/10.1016/j.future.2020.03.055
% https://www.sciencedirect.com/science/article/pii/S0167739X19320941
% ------------------------------------------------------------------------------------------------------------
% Website of SMA: http://www.aliasgharheidari.com/SMA.html
% You can find and run the SMA code online at http://www.aliasgharheidari.com/SMA.html

% You can find the SMA paper at https://doi.org/10.1016/j.future.2020.03.055
% Please follow the paper for related updates in researchgate: https://www.researchgate.net/publication/340431861_Slime_mould_algorithm_A_new_method_for_stochastic_optimization
% ------------------------------------------------------------------------------------------------------------
%  Main idea: Shimin Li
%  Author and programmer: Shimin Li,Ali Asghar Heidari,Huiling Chen
%  e-Mail: simonlishimin@foxmail.com
% ------------------------------------------------------------------------------------------------------------
%  Co-author:
%             Huiling Chen(chenhuiling.jlu@gmail.com)
%             Mingjing Wang(wangmingjing.style@gmail.com)
%             Ali Asghar Heidari(aliasghar68@gmail.com, as_heidari@ut.ac.ir)
%             
%             Researchgate: Ali Asghar Heidari https://www.researchgate.net/profile/Ali_Asghar_Heidari
%           
%             Researchgate: Huiling Chen https://www.researchgate.net/profile/Huiling_Chen
% ------------------------------------------------------------------------------------------------------------
% _____________________________________________________
 
% You can also use and compare with our other new optimization methods: (HHO)-2019- http://www.aliasgharheidari.com/HHO.html
%                                                                       (SMA)-2020- http://www.aliasgharheidari.com/SMA.html
%                                                                       (HGS)-2021- http://www.aliasgharheidari.com/HGS.html
%                                                                       (RUN)-2021- http://www.aliasgharheidari.com/RUN.html
% _____________________________________________________
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all 
close all
clc

N=30; % Number of search agents

Function_name='F1'; % Name of the test function, range from F1-F13

T=500; % Maximum number of iterations

dimSize = 30;   %dimension size

% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_SMA(Function_name,dimSize);

[Destination_fitness,bestPositions,Convergence_curve]=SMA(N,T,lb,ub,dim,fobj);


%Draw objective space
figure,
hold on
semilogy(Convergence_curve,'Color','b','LineWidth',4);
title('Convergence curve')
xlabel('Iteration');
ylabel('Best fitness obtained so far');
axis tight
grid off
box on
legend('SMA')

display(['The best location of SMA is: ', num2str(bestPositions)]);
display(['The best fitness of SMA is: ', num2str(Destination_fitness)]);

        



