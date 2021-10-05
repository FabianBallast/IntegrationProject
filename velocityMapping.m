load data/sysID/rot_inc_torqv1.mat

t = t(1:1002);
input = input(4:end);
%% Preprocess
th1 = preprocessing(theta_1, theta_2, t);

%% Velocity
p = polyfit(t, th1, 20);

figure(3)
plot(t, polyval(p, t)); hold on;
plot(t, th1); hold off;

y_s = smooth(th1(1:5:end));
figure(1)
plot(t(1:5:end), y_s); hold on;
plot(t, th1); hold off;

v = smooth(diff(y_s)/0.05, 7);
pv = polyder(p);


figure(2)
plot(t(5:5:end), v); hold on;
plot(t,polyval(pv, t)); hold off;

v1 = v; %polyval(pv, t);
%%

load data/sysID/rot_inc_torq_negv1.mat

t = t(1:1002);
input = input(4:end);
%% Preprocess
th1 = preprocessing(theta_1, theta_2, t);

%% Velocity
p = polyfit(t, th1, 20);

figure(3)
plot(t, polyval(p, t)); hold on;
plot(t, th1); hold off;

y_s = smooth(th1(1:5:end));
figure(1)
plot(t(1:5:end), y_s); hold on;
plot(t, th1); hold off;

v = smooth(diff(y_s)/0.05, 7);
pv = polyder(p);


figure(2)
plot(t(5:5:end), v); hold on;
plot(t,polyval(pv, t)); hold off;

v2 = v; %polyval(pv, t);
%%
figure(4)
plot(-input(3:5:end), v1); hold on;
plot(input(3:5:end), v2);hold off;

%% 
load data/sysID/velMap1
input1 = inputDig(2:end);
theta1 = theta_1;
t1 = t;

load data/sysID/velMap2
input2 = inputDig(2:end);
theta2 = theta_1;
t2 = t;

theta1 = preprocessing(theta1, theta1, t1);
theta2 = preprocessing(theta2, theta2, t2);

figure(1);
plot(t1, theta1); hold on;
plot(t2, theta2); hold off;

%%
y_s1 = smooth(theta1(1:5:end));
y_s2 = smooth(theta2(1:5:end));

v1 = smooth(diff(y_s1)/0.05, 7);
v2 = smooth(diff(y_s2)/0.05, 7);

figure(2);
plot(input1(2:5:end), v1, 'o', 'Markersize', 1); hold on;
plot(input2(2:5:end), v2, 'o', 'Markersize', 1); hold off;