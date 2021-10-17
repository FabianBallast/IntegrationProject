%% Clear any variables in workspace
clear all;
sympref('MatrixWithSquareBrackets',true);
%% Set up system of equations 
syms theta2 dtheta2 ddtheta2 real;
syms m2 J2 g c2 b a1 a2 real positive;

q = [theta2];
dq = [dtheta2];
ddq = [ddtheta2];

pos =[-c2 * sin(theta2);
      -c2 * cos(theta2);
      theta2];

vel = jacobian(pos, q) * dq;
acc = jacobian(vel, dq) * ddq + jacobian(vel, q) * dq;

mass = diag([m2 m2 J2]);

T = 1/2 * vel' * mass * vel;
V = m2 * g * pos(2);
D = 1/2 * b * dtheta2^2;

dTddq = jacobian(T, dq)';
dTdq = jacobian(T, q)';
dVdq = jacobian(V, q)';
ddTddqdt = jacobian(dTddq, dq) * ddq + jacobian(dTddq, q) * dq;
dD = jacobian(D, dq);

EoM = ddTddqdt - dTdq + dVdq == -dD;
[M,F] = equationsToMatrix(EoM, ddq);
M = simplify(M, 5);
F = simplify(F, 5);
qSol = M\F;

%% Plot data
load ../../data/sysID/theta2swing

t = t(554:end);
theta_1 = theta_1(55:end);
theta_2 = theta_2(55:end)-theta_1(1);
plot(t, theta_2)
%% Test simple integration
t_sim = t(1):0.001:t(end);
theta2_0 = theta_2(1);
dtheta2_0  = 0;

sol_sim = zeros(2, length(t_sim));
sol_sim(:, 1) = [theta2_0; dtheta2_0];

c2_sim = 0.070;
g_sim = 9.81;
b_sim = 0.00004;
m2_sim = 0.1;
J2_sim = 1/12*0.1^2*0.048; 
%%
% c2_sim = 0.0309;
% g_sim = 9.81;
% b_sim = 0.0001;
% m2_sim = 0.0965;
% J2_sim = 1.6434e-04; 


acc_sol = subs(qSol, [b c2 g m2 J2], [b_sim c2_sim g_sim m2_sim J2_sim]);
acc = matlabFunction(acc_sol);

for i = 2:length(t_sim)
    a = acc(sol_sim(2, i-1), sol_sim(1, i-1));
    sol_sim(:, i) = sol_sim(:, i-1) + 0.0001 * [sol_sim(2, i-1); a];
end

figure(2)
plot(t_sim, sol_sim(1, :), t, theta_2 );

%% NLID
z = iddata(theta_2,[],0.01,'Name','Single Pendulum');

fileName = 'singlePend2';
order = [1 0 2];
% Parameters = {b_sim*2; c2_sim; m2_sim*2; J2_sim*2; g_sim};
Parameters = { b_sim/(m2_sim*c2_sim^2+J2_sim); c2_sim*g_sim*m2_sim/(m2_sim*c2_sim^2+J2_sim)};
InitialStates = [theta_2(1);0];
Ts = 0;
nlgr = idnlgrey(fileName,order,Parameters,InitialStates,Ts, ...
    'Name','Single Pendulum');

% nlgr.Parameters(5).Fixed = true;
% nlgr.Parameters(1).Minimum = 0;
% nlgr.Parameters(2).Minimum = 0;
% nlgr.Parameters(3).Minimum = 0;
% nlgr.Parameters(4).Minimum = 0;
% 
% nlgr.Parameters(1).Maximum = 0.0004;
% nlgr.Parameters(2).Maximum = 0.12;
% nlgr.Parameters(3).Maximum = 1;
% nlgr.Parameters(4).Maximum = 0.1;

nlgr.Parameters(1).Minimum = 0;
nlgr.Parameters(2).Minimum = 0;

% nlgr.Parameters(1).Maximum = 0.0004;
% nlgr.Parameters(2).Maximum = 0.12;

opt = nlgreyestOptions('Display', 'On');
nlgr = nlgreyest(z,nlgr,opt);

%%
figure()
compare(z,nlgr,Inf)
ylabel('Angle (rad)')
legend('Measured data', 'Identified model')
saveas(gcf,'sysID_theta2','epsc')

%%
figure()
sys = pem(z,nlgr);
compare(z,sys,Inf)
%%
par = getpvec(nlgr);
a21 = par(1);
a22 = par(2);

save ../../data/constPar/th2_temp_par a21 a22

% b2 = par(1);
% c2 = par(2);
% m2 = par(3);
% J2 = par(4);
% g = par(5);
% 
% save data/constPar/model_parameters b2 c2 g m2 J2