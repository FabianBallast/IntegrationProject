%% Clear any variables in workspace
clear all;
sympref('MatrixWithSquareBrackets',true);
%% Set up system of equations 
syms theta1 dtheta1 ddtheta1 theta2 dtheta2 ddtheta2 real;
syms m1 m2 J1 J2 l1 g c1 c2 real positive;

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

dTddq = jacobian(T, dq)';
dTdq = jacobian(T, q)';
dVdq = jacobian(V, q)';
ddTddqdt = jacobian(dTddq, dq) * ddq + jacobian(dTddq, q) * dq;

EoM = ddTddqdt - dTdq + dVdq == 0;
[M,F] = equationsToMatrix(EoM, ddq);
M = simplify(M, 5);
F = simplify(F, 5);
qSol = M\F;

%% Create LaTex version with derivatives
rawStr = latex(qSol);
latStr = strrep(rawStr, 'dtheta','\dot{\theta}');
