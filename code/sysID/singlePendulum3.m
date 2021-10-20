%%
load ../../data/sysID/sweepv4;

t_ID = t(500:1001);
Y_ID = theta_1(1:502);
U_ID = input(2:503);

[Y_ID2, th2] = preprocessing(Y_ID, theta_2(1:502), t_ID);
Y_ID2 = Y_ID2;

figure(1);
plot(t_ID, Y_ID2)
% plot(t_ID, Y_ID)
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 10])
saveas(gcf,'sysID_sweepv4_theta1','epsc')

figure(2);
plot(t_ID, th2);
% plot(t_ID, theta_2(1:502));
ylabel('\theta_2 (radians)')
xlabel('Time (seconds)')
xlim([5 10])
saveas(gcf,'sysID_sweepv4_theta2','epsc')

data1 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Sweep');

%%
load ../../data/sysID/theta2swing

t = t(554:end);
theta_1 = theta_1(55:end);
theta_2 = theta_2(55:end)-theta_1(1);

data2 = iddata(theta_2, zeros(length(theta_2),3), 0.01, 'Name', 'Sweep');

%%
p = polyfit(t_ID,Y_ID2,23);
y1 = polyval(p,t_ID);
% y1=smooth(Y_ID2, 7);
figure(1)
plot(t_ID, Y_ID2)
hold on
plot(t_ID,y1)
hold off
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 10])
title('Fitting of the polynomial')
legend('Measured','Polynomial')
saveas(gcf,'sysID_sweepv4_polyfit','epsc')

%%
figure(2)
a=diff(y1, 2) / 0.01^2;
b = polyder(polyder(p));
a = [a(1); a; a(end)];
plot(t_ID, a); hold on;
plot(t_ID, polyval(b, t_ID), 'LineWidth',1.5); hold off;
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
xlim([5 10])
legend('Measured','Polynomial')
%title('Second derivatives of the signals')
saveas(gcf,'sysID_sweepv4_polyfit_acc','epsc')

%% NLID
ddtheta1 = polyval(b, t_ID);
dtheta1 = polyval(polyder(p), t_ID);
theta1 = Y_ID2;
u_th2 = [theta1, dtheta1, ddtheta1];

z = iddata(th2,u_th2,0.01,'Name','Single Pendulum');
z2 = merge(z,data2);

fileName = 'singlePend4';
order = [1 3 2];
% Parameters = {b_sim*2; c2_sim; m2_sim*2; J2_sim*2; g_sim};

a21 = 0.074571658157541;
a22 = 117.7025981348793;
g = 9.81;
m2_sim = 0.1;
c2_sim = 0.06;
J2_sim = c2_sim*m2_sim*g/a22 - m2_sim*c2_sim^2;
b2_sim = a21 * c2_sim*m2_sim*g / a22;

Parameters = { m2_sim, c2_sim, J2_sim, b2_sim};
% Parameters = { 15000, 1000};
% InitialStates = [th2(1);0];
% InitialStates = {[th2(1), theta_2(1)]; [0,0]};
InitialStates = [th2(1), theta_2(1); 0,0];
Ts = 0;
% nlgr = idnlgrey(fileName,order,Parameters,InitialStates,Ts, ...
%     'Name','Single Pendulum');
nlgr = idnlgrey(fileName,order,Parameters,{},Ts, ...
    'Name','Single Pendulum');

nlgr.Parameters(1).Minimum = 0;
nlgr.Parameters(2).Minimum = 0;
nlgr.Parameters(3).Minimum = 0;
nlgr.Parameters(4).Minimum = 0;

% nlgr.Parameters(1).Maximum = 0.4;
% nlgr.Parameters(2).Maximum = 0.1;

opt = nlgreyestOptions('Display', 'On','InitialState','estimate');
nlgr = nlgreyest(z2,nlgr,opt);

%%
par = getpvec(nlgr);
m2_val = par(1);
c2_val = par(2);
J2_val = par(3);
b2_val = par(4);

a21_new = b2_val/(m2_val*c2_val^2+J2_val);
a22_new = c2_val*g*m2_val/(m2_val*c2_val^2+J2_val);

%%
figure()
compare(data2,nlgr,Inf)
%%
sys = pem(z, nlgr);
figure()
compare(z,nlgr,Inf)

%% Saving parameters
% load ../../data/constPar/th2_temp_par
% par = getpvec(nlgr);
% 
% m2_val = par(1);
% c2_val = par(2);
% 
% g_val = 9.81;
% J2_val = c2_val*m2_val*g_val/a22 - m2_val*c2_val^2;
% b2_val = a21 * c2_val*m2_val*g_val / a22;
% l1_val = 0.097;
% 
% save ../../data/constPar/model_parameters m2_val g_val c2_val J2_val b2_val l1_val

