%% Clear any variables in workspace
clear all;
sympref('MatrixWithSquareBrackets',true);
%% Set up system of equations 
syms theta1 dtheta1 ddtheta1 theta2 dtheta2 ddtheta2 real;
syms m1 m2 J1 J2 l1 g c1 c2 b1 b2 real positive;

q = [theta1; theta2];
dq = [dtheta1; dtheta2];
ddq = [ddtheta1; ddtheta2];

pos =[c1 * sin(theta1);
      c1 * cos(theta1);
      theta1;
      l1 * sin(theta1) + c2 * sin(theta1 + theta2);
      l1 * cos(theta1) + c2 * cos(theta1 + theta2);
      theta1 + theta2];

vel = jacobian(pos, q) * dq;
acc = jacobian(vel, dq) * ddq + jacobian(vel, q) * dq;

mass = diag([m1 m1 J1 m2 m2 J2]);

T = 1/2 * vel' * mass * vel;
V = m1 * g * pos(2) + m2 * g * pos(5);
D = 1/2 * b1 * dtheta1^2 + 1/2 * b2 * dtheta2^2;

dTddq = jacobian(T, dq)';
dTdq = jacobian(T, q)';
dVdq = jacobian(V, q)';
ddTddqdt = jacobian(dTddq, dq) * ddq + jacobian(dTddq, q) * dq;
dDddq = jacobian(D, dq)';

EoM = ddTddqdt - dTdq + dVdq == -dDddq;
[M,F] = equationsToMatrix(EoM, ddq);
M = simplify(M, 5);
F = simplify(F, 5);
qSol = M\F;

%% Test
step_size = 0.001;
t_sim = 0:step_size:10;
theta1_0 = pi/2;
dtheta1_0  = 0;
theta2_0 = 0;
dtheta2_0  = 0;

sol_sim = zeros(4, length(t_sim));
sol_sim(:, 1) = [theta1_0; dtheta1_0; theta2_0; dtheta2_0];

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

acc_sol = subs(qSol, [b1 l1 c1 m1 J1 b2 c2 g m2 J2],...
    [b1_sim l1_sim c1_sim m1_sim J1_sim b2_sim c2_sim g_sim m2_sim J2_sim]);
acc = matlabFunction(acc_sol,'Vars',[theta1; dtheta1; theta2; dtheta2]);

for i = 2:length(t_sim)
    a = acc(sol_sim(1, i-1), sol_sim(2, i-1), sol_sim(3, i-1), sol_sim(4, i-1));
    sol_sim(:, i) = sol_sim(:, i-1) + step_size * [sol_sim(2, i-1); a(1); sol_sim(4, i-1); a(2)];
end

figure(2)
plot(t_sim, sol_sim(1, :));
hold on
plot(t_sim, sol_sim(3, :));
hold off

%% Simulation
dimensions;

par.l_link1 = l_link1;
par.l_link2 = l_link2;

visualize_pendulum(t_sim, sol_sim(1,:)', sol_sim(3,:)', par);


%% Create LaTex version with derivatives
rawStr = latex(qSol);
latStr = strrep(rawStr, 'dtheta','\dot{\theta}');
