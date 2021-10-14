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

L = T-V;

dLddq = jacobian(L, dq)';
dLdq = jacobian(L, q)';
%dVdq = jacobian(V, q)';
ddLddqdt = jacobian(dLddq, dq) * ddq + jacobian(dLddq, q) * dq;
dDddq = jacobian(D, dq)';

EoM = ddLddqdt - dLdq == -dDddq;
EoM = subs(EoM, [m2 J2 b2 c2 c1], [0 0 0 0 0]);
[M,F] = equationsToMatrix(EoM, [ddtheta1; ddc_mot]);
M = simplify(M, 5);
F = simplify(F, 5);
qSol = M\F;

%% x = [theta1; dtheta1; dc_mot];
A = [0 1 0;
     0 -b1/J1 k_gear*k_mot/J1;
     0 -k_gear*k_mot/L_mot -R_mot/L_mot];
 
B = [0;0;1/L_mot];

C = [1 0 0];

D = [0];

x = [theta1; dtheta1; dc_mot];