%% Clear any variables in workspace
clear all;
sympref('MatrixWithSquareBrackets',true);
%% Set up system of equations 
syms theta1 dtheta1 ddtheta1 theta2 dtheta2 ddtheta2 c_mot dc_mot ddc_mot real;
syms m1 m2 k_gear J1 J2 l1 g c1 c2 b1 b2 R_mot L_mot k_mot V_in real positive;

q = [theta1; theta2; c_mot];
dq = [dtheta1; dtheta2; dc_mot];
ddq = [ddtheta1; ddtheta2; ddc_mot];

pos =[c1 * sin(theta1);
      c1 * cos(theta1);
      theta1;
      l1 * sin(theta1) + c2 * sin(theta1 + theta2);
      l1 * cos(theta1) + c2 * cos(theta1 + theta2);
      theta1 + theta2];

vel = jacobian(pos, q) * dq;
acc = jacobian(vel, dq) * ddq + jacobian(vel, q) * dq;

mass = diag([m1 m1 J1 m2 m2 J2]);

T = 1/2 * vel' * mass * vel + 1/2 * L_mot * dc_mot^2;
V = m1 * g * pos(2) + m2 * g * pos(5) - (V_in - k_mot*k_gear*dtheta1)*c_mot;
D = 1/2 * b1 * dtheta1^2 + 1/2 * b2 * dtheta2^2 + 1/2 * R_mot * dc_mot^2;


% dTddq = jacobian(T, dq)';
% dTdq = jacobian(T, q)';
% dVdq = jacobian(V, q)';
% ddTddqdt = jacobian(dTddq, dq) * ddq + jacobian(dTddq, q) * dq;
% dDddq = jacobian(D, dq)';
% 
% EoM = ddTddqdt - dTdq + dVdq == -dDddq;
% [M,F] = equationsToMatrix(EoM, ddq);
% M = simplify(M, 5);
% F = simplify(F, 5);
% qSol = M\F;

L = T-V;

dLddq = jacobian(L, dq)';
dLdq = jacobian(L, q)';
%dVdq = jacobian(V, q)';
ddLddqdt = jacobian(dLddq, dq) * ddq + jacobian(dLddq, q) * dq;
dDddq = jacobian(D, dq)';

EoM = ddLddqdt - dLdq == -dDddq;
[M,F] = equationsToMatrix(EoM, ddq);
M = simplify(M, 5);
F = simplify(F, 5);
qSol = M\F;

%% Test
step_size = 0.0001;
t_sim = 0:step_size:10;
theta1_0 = pi;
dtheta1_0  = 0;
theta2_0 = 0;
dtheta2_0  = 0;
i_mot_0 = 0;

% sol_sim = zeros(6, length(t_sim));
x0 = [theta1_0; dtheta1_0; theta2_0; dtheta2_0; i_mot_0];

c1_sim = 0.040;
l1_sim = 0.100;
b1_sim = 0.0004;
m1_sim = 0.4;
J1_sim = 1/12*m1_sim*(l1_sim^2 + 0.015^2);
c2_sim = 0.070;
g_sim = 9.81;
b2_sim = 0.00004;
m2_sim = 0.1;
J2_sim = 1/12*0.1^2*0.048;

k_gear_sim = 33;
k_mot_sim = 0.0385;
R_mot_sim = 0.1;
L_mot_sim = 0.0000717;
V_in_sim = 3.5;

acc_sol = subs(qSol, [b1 l1 c1 m1 J1 b2 c2 g m2 J2 k_gear k_mot R_mot L_mot V_in],...
    [b1_sim l1_sim c1_sim m1_sim J1_sim b2_sim c2_sim g_sim m2_sim J2_sim ...
    k_gear_sim k_mot_sim R_mot_sim L_mot_sim V_in_sim]);
acc_sol = [dtheta1; acc_sol(1); dtheta2; acc_sol(2); acc_sol(3)];
acc = matlabFunction(acc_sol,'Vars',[theta1; dtheta1; theta2; dtheta2; dc_mot]);

% acc2 = @(th1, dth1, th2, dth2) acc()
ODE = @(x) acc(x(1), x(2), x(3), x(4), x(5));
sol_sim = RK4(t_sim, x0, ODE);

figure(2)
plot(t_sim, sol_sim(1, :));
%hold on
%plot(t_sim, sol_sim(3, :));
%hold off

%% Simulation
dimensions;

par.l_link1 = l_link1;
par.l_link2 = l_link2;

dt_vis = 0.05;
ind_step = dt_vis / step_size;
ind = 1:ind_step:length(t_sim); 

visualize_pendulum(t_sim(ind), sol_sim(1,ind)', sol_sim(3,ind)', par);

%% Create data
load data/sysID/fullRots

jump_thres = 0.03;

jumps1 = [0; theta_1(2:end)-theta_1(1:end-1)];
jumps1(abs(jumps1) < jump_thres) = 0;
acc_err1 = cumsum(jumps1);

jumps2 = [0; theta_2(2:end)-theta_2(1:end-1)];
jumps2(abs(jumps2) < jump_thres) = 0;
acc_err2 = cumsum(jumps2);

theta_1 = medfilt1(unwrap(theta_1 - 1*acc_err1), 3);
theta_2 = medfilt1(unwrap(theta_2 - 1*acc_err2), 3);

data1 = iddata([theta_1(1:10:800), theta_2(1:10:800)], input(1:10:800)*0.7*12, (t(5)-t(4))*10);

figure(1)
plot(t, theta_1, t, theta_2)

figure(2)
plot(t, medfilt1(unwrap(theta_1 + acc_err1), 3), t, medfilt1(unwrap(theta_2 + acc_err2), 3))



% load data/sysID/fullRots
% 
% theta_1 = medfilt1(unwrap(theta_1), 3);
% theta_2 = medfilt1(unwrap(theta_2), 3);
% 
% data2 = iddata([theta_1(1:10:400), theta_2(1:10:400)], input(1:10:400)*15, (t(5)-t(4))*10);
% 
% figure(2)
% plot(t, theta_1, t, theta_2)
%%
data_full = merge(data1, data2);

load data/constPar/model_parameters

c1_sim = 0.040;
l1_sim = 0.100;
b1_sim = 0.04;
m1_sim = 0.5; % from 0.4
J1_sim = 1/12*m1_sim*(l1_sim^2 + 0.015^2)*300;
% c2_sim = 0.070;
% g_sim = 9.81;
% b2_sim = 0.00004;
% m2_sim = 0.1;
% J2_sim = 1/12*0.1^2*0.048;
c2_sim = c2*1;
g_sim = g;
b2_sim = b2;
m2_sim = m2*1;
J2_sim = J2;


k_gear_sim = 33;
k_mot_sim = 0.0385;
R_mot_sim = 0.1;
L_mot_sim = 0.0000717;
V_in_sim = 3.5; % from 3.5

% matlabFunction(qSol,'Vars',[theta1; dtheta1; theta2; dtheta2; dc_mot; V_in; c1; l1; b1; m1; J1; c2; g; b2; m2; J2; k_gear; k_mot; R_mot; L_mot],'File', 'DoublePendMotor')
fileName = 'DoublePendMotor';
order = [2 1 5];
Parameters = {c1_sim, l1_sim, b1_sim, m1_sim, J1_sim, c2_sim, g_sim, b2_sim, m2_sim, J2_sim, k_gear_sim, k_mot_sim, R_mot_sim, L_mot_sim};
InitialStates = [data1.OutputData(1, 1);0;data1.OutputData(1, 2);0;0];
Ts = 0;
nlgr = idnlgrey(fileName,order,Parameters,InitialStates,Ts, ...
    'Name','Double Pendulum Motor');

nlgr.Parameters(1).Fixed = true;
nlgr.Parameters(2).Fixed = true;
nlgr.Parameters(3).Fixed = true;
nlgr.Parameters(4).Fixed = true;
nlgr.Parameters(5).Fixed = true;
nlgr.Parameters(7).Fixed = true;
nlgr.Parameters(1).Minimum = 0;
nlgr.Parameters(2).Minimum = 0.09;
nlgr.Parameters(3).Minimum = 0;
nlgr.Parameters(4).Minimum = 0;
nlgr.Parameters(5).Minimum = 0;
nlgr.Parameters(6).Minimum = 0;
nlgr.Parameters(8).Minimum = 0;
nlgr.Parameters(9).Minimum = 0;
nlgr.Parameters(10).Minimum = 0;
nlgr.Parameters(12).Minimum = 0;
nlgr.Parameters(13).Minimum = 0;
nlgr.Parameters(14).Minimum = 0;

nlgr.Parameters(1).Maximum = 0.1;
nlgr.Parameters(2).Maximum = 0.12;
nlgr.Parameters(3).Maximum = 0.1;
nlgr.Parameters(4).Maximum = 0.9;  % from 0.5
nlgr.Parameters(5).Maximum = 0.35;
nlgr.Parameters(6).Maximum = 0.1*1.4;
nlgr.Parameters(8).Maximum = 0.0004;
nlgr.Parameters(9).Maximum = 0.12;
nlgr.Parameters(10).Maximum = 0.01;
nlgr.Parameters(12).Maximum = 0.4;
nlgr.Parameters(13).Maximum = 1;
nlgr.Parameters(14).Maximum = 0.000717;

opt = nlgreyestOptions('Display', 'On');
nlgr = nlgreyest(data1,nlgr, opt);

figure(3)
compare(data1,nlgr,Inf)

%% Just texting variables

load data/constPar/model_parameters

c1_sim = 0.040;
l1_sim = 0.100;
b1_sim = 0.04;
m1_sim = 0.5; 
J1_sim = 1/12*m1_sim*(l1_sim^2 + 0.015^2)*300;
c2_sim = c2*1;
g_sim = g;
b2_sim = b2*1;
m2_sim = m2*1;
J2_sim = J2*1;

k_gear_sim = 33;
k_mot_sim = 0.05;
R_mot_sim = 0.2;
L_mot_sim = 0.0000917;
V_in_sim = -0.55*12; % from 3.5
%*sin(time * 2 * pi* 2.2)
% matlabFunction(qSol,'Vars',[theta1; dtheta1; theta2; dtheta2; dc_mot; V_in; c1; l1; b1; m1; J1; c2; g; b2; m2; J2; k_gear; k_mot; R_mot; L_mot],'File', 'DoublePendMotor')
% InitialStates = [data1.OutputData(1, 1);0;data1.OutputData(1, 2);0;0];
InitialStates = [data1.OutputData(1, 1);0;data1.OutputData(1, 2);0;0];

ODE = @(time,x) DoublePendMotor(0,x,V_in_sim,c1_sim,l1_sim,b1_sim,m1_sim,J1_sim,c2_sim,g_sim,b2_sim,m2_sim,J2_sim,k_gear_sim,k_mot_sim,R_mot_sim,L_mot_sim,0);
t_sim = 0:0.0001:5;
x = RK4(t_sim, InitialStates, ODE);

figure(3)
plot(t_sim, x(1, :), t(1:5000), theta_1(1:5000)); hold on;
plot(t_sim, x(3, :), t(1:5000), theta_2(1:5000)); hold off;
% 
% figure(4)
% plot(t_sim,6*sin(t_sim* (2*pi)*2.2), t(1:5000), input(1:5000)); 
%% Create LaTex version with derivatives
rawStr = latex(qSol);
latStr = strrep(rawStr, 'dtheta','\dot{\theta}');
