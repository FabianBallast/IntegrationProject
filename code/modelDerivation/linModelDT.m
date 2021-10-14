%% Load linear model
load data/constPar/lin_model_ct

%%
sysc = ss(A, B, C, D);
h = 0.01;
sysd = c2d(sysc, h);

save data/constPar/lin_model_dt sysd