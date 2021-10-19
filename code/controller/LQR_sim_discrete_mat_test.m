%% Setup
clear; clc;

%% Load linear model
load ../../data/constPar/lin_model_dt

%% Make ready for simulation
load ../../data/constPar/model_parameters
load ../../data/constPar/motorPar2

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
Theta2_0 = 0;
Thetad2_0 = 0;

h = 0.01;
%% Kalman filter

load ../../data/sysID/noise

Q = 0.0000018;
R = cov(theta_1, theta_2);
[kalmf,Ld,~,Mx,Z] = kalman(sysd, Q, R);


%% Create cost matrices
% Order of states: th1 thd1 th2 thd2

% Set 1
% Q1 = diag([1,1,1,1]); R1 = 1;
% Q2 = diag([10, 1, 10, 1]); R2 = 1;
% Q3 = diag([1, 10, 1, 10]); R3 = 1;

% Set 2
Q1 = diag([10, 1, 10, 1]); R1 = 1;
Q2 = diag([100,1,100,1]); R2 = 1;
Q3 = diag([100, 0.1, 100, 0.1]); R3 = 1;

K1 = dlqr(sysd.A, sysd.B, Q1, R1);
K2 = dlqr(sysd.A, sysd.B, Q2, R2);
K3 = dlqr(sysd.A, sysd.B, Q3, R3);

K = [K1; K2; K3];

%% Reference
t = 0:0.01:56;

% Step (trapezoidal) wave
u = smooth(square(t*2*pi / 20), 100);

% Sin wave
% u = sin(t*2*pi / 10).';

t = 0:0.01:60;
u = [zeros(400, 1); u];
plot(t, u);

ref.time = t.';
ref.signals.values = smooth(u.', 200);
%% Run simulations

for i = 1:length(K(:, 1))
    Kd = K(i, :);
    sim('../../simulink/LQR_sim_discrete');
    t_arr(:,i) = theta_2.Time();
    th2_arr(:,i) = theta_2.Data();
end

%%
figure(1); clf;
hold all;
for i =1:length(K(:, 1))
   plot(t_arr(:, i), th2_arr(:, i)); 
end

plot(Reference.Time(), Reference.Data(:, 3), 'k--');
hold off;
ylim([-1, 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)')
legend('K_3', 'K_4', 'K_5', 'Reference');
title('Square wave reference with different cost matrices');

%%

