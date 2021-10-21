%% Load linear model
load ../../data/constPar/lin_model_dt

%% Create cost matrices
% Order of states: th1 thd1 th2 thd2
% Qd = 1*diag([40 3 100 3]);
% Qd = 1*diag([120 10 150 10]); Rd = 50;
% Qd = 1*diag([100 0.0001 150 0.0001]); Rd = 25;
% Qd = 1*diag([100 0.0001 150 0.01]);
% Qd = 1*diag([100 0.0001 150 0.0001]); Rd = 200;
% Qd = diag([100, 0.1, 100, 0.1]); R1 = 1;

Qd = diag([100, 0.1, 100, 0.1]); Rd = 25; %25 for better tracking, 50 for smoother movement

% Qd = diag([200, 0.01, 200, 0.01]); Rd = 1;
% Qd = 1*diag([150 0.01 150 0.01]); Rd = 75; % 75 for better tracking, 100 for smooth movement

% Rd = 1;

Kd = dlqr(sysd.A, sysd.B, Qd, Rd);
disp(Kd)

h = 0.01;
%% Save gain

save ../../data/constPar/LQR_gain_d Kd sysd Qd Rd
%% Kalman filter

load ../data/sysID/noise

Q = 0.0000018;
R = cov(theta_1, theta_2);
[kalmf,Ld,~,Mx,Z] = kalman(sysd, Q, R);


%%
save ../data/results/LQR_square_fin angles_raw Qd Rd Input InputDigital observer


%% Reference
load ../data/inputs/square2

