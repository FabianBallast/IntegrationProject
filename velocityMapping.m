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