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
step_size = 0.001;
t_sim = 0:step_size:2;
theta1_0 = pi/2;
dtheta1_0  = 0;
theta2_0 = 0;
dtheta2_0  = 0;
c_mot_0 = 0;
i_mot_0 = 0;

sol_sim = zeros(6, length(t_sim));
sol_sim(:, 1) = [theta1_0; dtheta1_0; theta2_0; dtheta2_0; c_mot_0; i_mot_0];

c1_sim = 0.070;
l1_sim = 0.100;
b1_sim = 0.00004;
m1_sim = 0.1;
J1_sim = 1/12*0.1^2*0.048;
c2_sim = 0.070;
g_sim = 9.81;
b2_sim = 0.00004;
m2_sim = 0.1;
J2_sim = 1/12*0.1^2*0.048;

k_gear_sim = 33;
k_mot_sim = 0.001;
R_mot_sim = 2;
L_mot_sim = 0.001;
V_in_sim = 8*0;

acc_sol = subs(qSol, [b1 l1 c1 m1 J1 b2 c2 g m2 J2 k_gear k_mot R_mot L_mot V_in],...
    [b1_sim l1_sim c1_sim m1_sim J1_sim b2_sim c2_sim g_sim m2_sim J2_sim ...
    k_gear_sim k_mot_sim R_mot_sim L_mot_sim V_in_sim]);
acc = matlabFunction(acc_sol,'Vars',[theta1; dtheta1; theta2; dtheta2; c_mot; dc_mot]);

% acc2 = @(th1, dth1, th2, dth2) acc()

for i = 2:length(t_sim)
    a = acc(sol_sim(1, i-1), sol_sim(2, i-1), sol_sim(3, i-1), sol_sim(4, i-1), sol_sim(5, i-1), sol_sim(6, i-1));
    sol_sim(:, i) = sol_sim(:, i-1) + step_size * ...
        [sol_sim(2, i-1); a(1); sol_sim(4, i-1); a(2); sol_sim(6, i-1); a(3)];
end

figure(2)
plot(t_sim, sol_sim(1, :));
%hold on
%plot(t_sim, sol_sim(3, :));
%hold off

%% Simulation
dimensions;

par.l_link1 = l_link1;
par.l_link2 = l_link2;

visualize_pendulum(t_sim, sol_sim(1,:)', sol_sim(3,:)', par);

%% Create LaTex version with derivatives
rawStr = latex(qSol);
latStr = strrep(rawStr, 'dtheta','\dot{\theta}');
