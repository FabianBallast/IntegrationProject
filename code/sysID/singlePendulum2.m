%%
load ../../data/sysID/sweepv4;

% t_ID = t(500:1001);
% Y_ID = theta_1(1:502);
% U_ID = inputDig(2:503);

t_ID = t(500:901);
Y_ID = theta_1(1:402);
U_ID = inputDig(2:403);

[Y_ID2, th2] = preprocessing(Y_ID, theta_2(1:402), t_ID);
Y_ID2 = Y_ID2;

f = figure(1);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID2, 'LineWidth',1.5)
% plot(t_ID, Y_ID)
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 9])
saveas(f,'sysID_sweepv4_theta1','epsc')

f = figure(2);
f.Position(3:4) = [540 300];
plot(t_ID, th2, 'LineWidth',1.5);
% plot(t_ID, theta_2(1:402), 'LineWidth',1.5);
ylabel('\theta_2 (radians)')
xlabel('Time (seconds)')
xlim([5 9])
saveas(f,'sysID_sweepv4_theta2','epsc')
% saveas(f,'sysID_unwrap_after','epsc')

f = figure(3);
f.Position(3:4) = [540 300];
plot(t_ID, U_ID, 'LineWidth',1.5);
ylabel('Input (-)')
xlabel('Time (seconds)')
xlim([5 9])
title('Frequency sweep input signal')
saveas(f,'sysID_sweepv4_input','epsc')


data1 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Sweep');

%%
p = polyfit(t_ID,Y_ID2,23);
y1 = polyval(p,t_ID);
% y1=smooth(Y_ID2, 7);
f = figure(1);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID2, 'LineWidth',1.5)
hold on
plot(t_ID,y1, 'LineWidth',1.5)
hold off
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 9])
title('Fitting of the polynomial')
legend('Measured','Polynomial')
saveas(f,'sysID_sweepv4_polyfit','epsc')

%%
f = figure(2);
f.Position(3:4) = [540 300];
a=diff(y1, 2) / 0.01^2;
b = polyder(polyder(p));
a = [a(1); a; a(end)];
plot(t_ID, a); hold on;
plot(t_ID, polyval(b, t_ID), 'LineWidth',1.5); hold off;
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 9])
legend('Measured','Polynomial')
%title('Second derivatives of the signals')
saveas(f,'sysID_sweepv4_polyfit_acc','epsc')

%% NLID
ddtheta1 = polyval(b, t_ID);
dtheta1 = polyval(polyder(p), t_ID);
theta1 = Y_ID2;
u_th2 = [theta1, dtheta1, ddtheta1];

z = iddata(th2,u_th2,0.01,'Name','Single Pendulum');

fileName = 'singlePend3';
order = [1 3 2];
% Parameters = {b_sim*2; c2_sim; m2_sim*2; J2_sim*2; g_sim};
Parameters = { 0.1, 0.06};
% Parameters = { 15000, 1000};
InitialStates = [th2(1);0];
Ts = 0;
nlgr = idnlgrey(fileName,order,Parameters,InitialStates,Ts, ...
    'Name','Single Pendulum');

nlgr.Parameters(1).Minimum = 0;
nlgr.Parameters(2).Minimum = 0;

% nlgr.Parameters(1).Maximum = 0.4;
% nlgr.Parameters(2).Maximum = 0.1;

opt = nlgreyestOptions('Display', 'On');
nlgr = nlgreyest(z,nlgr,opt);
%%
f = figure();
f.Position(3:4) = [540 300];
compare(z,nlgr,Inf)
ylabel('\theta_2 (radians)')
title('Validation of the model of the second link')
saveas(f,'sysID_validation_link2','epsc')
%%
sys = pem(z, nlgr);
figure()
compare(z,nlgr,Inf)

%% Saving parameters
load ../../data/constPar/th2_temp_par
par = getpvec(nlgr);

m2_val = par(1);
c2_val = par(2);

g_val = 9.81;
J2_val = c2_val*m2_val*g_val/a22 - m2_val*c2_val^2;
b2_val = a21 * c2_val*m2_val*g_val / a22;
l1_val = 0.097;

save ../../data/constPar/model_parameters m2_val g_val c2_val J2_val b2_val l1_val

