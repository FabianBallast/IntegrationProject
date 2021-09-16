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
t_sim = 0:step_size:5;
theta1_0 = pi/2;
dtheta1_0  = 0;
theta2_0 = 0;
dtheta2_0  = 0;
c_mot_0 = 0;
i_mot_0 = 0;

% sol_sim = zeros(6, length(t_sim));
x0 = [theta1_0; dtheta1_0; theta2_0; dtheta2_0; c_mot_0; i_mot_0];

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
V_in_sim = 0;

acc_sol = subs(qSol, [b1 l1 c1 m1 J1 b2 c2 g m2 J2 k_gear k_mot R_mot L_mot V_in],...
    [b1_sim l1_sim c1_sim m1_sim J1_sim b2_sim c2_sim g_sim m2_sim J2_sim ...
    k_gear_sim k_mot_sim R_mot_sim L_mot_sim V_in_sim]);
acc_sol = [dtheta1; acc_sol(1); dtheta2; acc_sol(2); dc_mot; acc_sol(3)];
acc = matlabFunction(acc_sol,'Vars',[theta1; dtheta1; theta2; dtheta2; c_mot; dc_mot]);

% acc2 = @(th1, dth1, th2, dth2) acc()
ODE = @(x) acc(x(1), x(2), x(3), x(4), x(5), x(6));
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

%% Create LaTex version with derivatives
rawStr = latex(qSol);
latStr = strrep(rawStr, 'dtheta','\dot{\theta}');