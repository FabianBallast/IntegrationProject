%% Load linear model
load ../../data/constPar/lin_model_dt

%% Create cost matrices
% Order of states: th1 thd1 th2 thd2
% Qd = 1*diag([40 3 100 3]);
% Qd = 1*diag([120 10 150 10]); Rd = 50;
% Qd = 1*diag([100 0.0001 150 0.0001]); Rd = 25;
% Qd = 1*diag([100 0.0001 150 0.01]);
% Qd = 1*diag([100 0.0001 150 0.0001]); Rd = 200;

Qd = 1*diag([150 0.0001 150 0.0001]); Rd = 100; % 75 for better tracking, 100 for smooth movement

% Rd = 1;

Kd = dlqr(sysd.A, sysd.B, Qd, Rd)

save ../../data/constPar/LQR_gain_d Kd sysd Qd Rd

h = 0.01;

%% Kalman filter

load ../../data/sysID/noise

Q = 0.0000018;
R = cov(theta_1, theta_2);
[kalmf,Ld,~,Mx,Z] = kalman(sysd, Q, R);




