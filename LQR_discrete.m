%% Load linear model
load data/constPar/lin_model_dt

%% Create cost matrices
% Order of states: th1 thd1 th2 thd2
% Qd = 1*diag([40 3 100 3]);
Qd = 1*diag([120 10 150 10]);
Rd = 0.5;

Kd = dlqr(sysd.A, sysd.B, Qd, Rd);

save data/constPar/LQR_gain_d

%% Make ready for simulation
load data/constPar/model_parameters
load data/constPar/motorPar

model_par.c2 = c2_val;
model_par.b2 = b2_val;
model_par.J2 = J2_val;
model_par.g = g_val;
model_par.l1 = l1_val;
model_par.m2 = m2_val;

model_par.a11 = a11;
model_par.a12 = a12;
model_par.a22 = c2_val*g_val*m2_val/(m2_val*c2_val^2+J2_val);

Theta1_0 = 0;
Thetad1_0 = 0;
Theta2_0 = 0.04;
Thetad2_0 = 0;

h = 0.01;

obs_poles_d = exp([-80 -20 -5 -4]*h);
% obs_poles_d = [0.55 0.85 0.95 0.96];
poles_d = exp([-10.8860 -44.1060 -2.0000 -0.5000]*h);
% Kd = place(sysd.A, sysd.B, poles_d);
Ld = place(sysd.A',sysd.C',obs_poles_d).';

%% Kalman filter

load data/sysID/noise

Q = 0.000001;
R = cov(theta_1, theta_2);

[kalmf,Ld,~,Mx,Z] = kalman(sysd, Q, R);



