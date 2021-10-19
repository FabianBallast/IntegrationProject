%% 
clear; clc;

%%
h = 0.01;

load ../data/controller/MPCDesignerSessionAgressive
mpc1 = MPCDesignerSession.AppData.Controllers.MPC;

%%
h = 0.01;

load ../data/controller/MPCDesignerSessionRelaxed.mat
mpc1 = MPCDesignerSession.AppData.Controllers.MPC;

%%
h = 0.01;

load ../data/controller/MPCDesignerSessionRelaxedLongHorizon.mat
mpc1 = MPCDesignerSession.AppData.Controllers.MPC;

%%
h = 0.01;

load ../data/controller/MPCDesignerSessionAgressive
mpc1 = MPCDesignerSession.AppData.Controllers.MPC;

%%
% RateWeight = 500; % 6
% RateWeight = 1000; % 4 / 3
% RateWeight = 750; % 2 / 1
RateWeight = 875; % 7 8 9
PredHor = 50;
ContHor = 10;
save ../data/results/MPC_dist_11 angles_raw RateWeight PredHor ContHor

%% Reference
load ../data/inputs/square2
