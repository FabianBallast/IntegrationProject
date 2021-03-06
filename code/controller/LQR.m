%% Load linear model
load ../../data/constPar/lin_model_ct

%% Create cost matrices
% Order of states: th1 thd1 th2 thd2
Q = 0.001*diag([1 1 100 100]);
R = 1;

K = lqr(A, B, Q, R);

save ../../data/constPar/LQR_gain

%% Make ready for simulation
load ../../data/constPar/model_parameters
load ../../data/constPar/motorPar

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
Theta2_0 = 0.03;
Thetad2_0 = 0;

poles = [-10.8860  -44.1060   -2.0000   -0.5000];
K = place(A, B, poles);
obs_poles = [-80 -20 -5 -4];
L = place(A',C',obs_poles)';