%% Load linear model
load data/constPar/lin_model

%% Create cost matrices
% Order of states: th1 thd1 th2 thd2
Q = diag([1 1 5 5]);
R = 1;

K = lqr(A, B, Q, R);

save data/constPar/LQR_gain