%% Setup
clear; clc;

%% Load sin data
load ../../data/results/MPC_sin1

t = angles_raw.Time();
theta_2_sin(:, 1) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin2
theta_2_sin(:, 2) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin3
theta_2_sin(:, 3) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin4
theta_2_sin(:, 4) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin6
theta_2_sin(:, 6) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin7
theta_2_sin(:, 7) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin_8
theta_2_sin(:, 8) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin_9
theta_2_sin(:, 9) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sin_10
theta_2_sin(:, 10) = angles_raw.Data(:, 2);

load ../../data/results/MPC_sine_11
theta_2_sin(:, 11) = angles_raw.Data(:, 2);

%% Load square data

load ../../data/results/MPC_square_10
theta_2_square(:, 10) = angles_raw.Data(:, 2);

%% Load disturbance data

load ../../data/results/MPC_dist_10
theta_2_dist(:, 10) = angles_raw.Data(:, 2);

%% Reference
t = 0:0.01:27;

% Step (trapezoidal) wave
u_step = -pi/6 * smooth(square(t(1:2601)*2*pi / 20), 100);

% Sin wave
u_sine = -pi/6 * sin(t*2*pi / 10).';

t = 0:0.01:30;
u_sine = [zeros(300, 1); u_sine];
u_step = [zeros(400, 1); u_step];
%% Plot
figure(1); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, 2:4)); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('MPC1','MPC2', 'MPC3', 'Reference');
exportgraphics(gcf,'../../figures/MPC_sine1.eps')

figure(2); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, [1 6 7])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('MPC4','MPC5', 'MPC6', 'Reference');
exportgraphics(gcf,'../../figures/MPC_sine2.eps')

figure(3); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, [7 8 9])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('MPC6','MPC7', 'MPC8', 'Reference');
exportgraphics(gcf,'../../figures/MPC_sine3.eps')

figure(4); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, [7  10 11])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('MPC6','MPC9', 'MPC10', 'Reference');
exportgraphics(gcf,'../../figures/MPC_sine4.eps')

figure(5); clf;
set(gcf,'units','centimeters','position',[10,10,30,10])
plot(t, theta_2_sin(:, [10])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/MPC_sine_fin.eps')

figure(6); clf;
set(gcf,'units','centimeters','position',[10,10,30,10])
plot(t, theta_2_square(:, [10])); hold on;
plot(t, u_step, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Square wave reference on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/MPC_square_fin.eps')

figure(7); clf;
set(gcf,'units','centimeters','position',[10,10,30,10])
plot(t, theta_2_dist(:, [10])); hold on;
plot([t(1) t(end)], [0 0], 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Disturbance rejection on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/MPC_dist_fin.eps')

% figure(5); clf;
% set(gcf,'units','centimeters','position',[10,10,30,10])
% plot(t, theta_2_square(:, [8])); hold on;
% plot(t, u_step, 'k--');
% ylim([-1 1]);
% xlabel('Time (s)');
% ylabel('\theta_2 (rad)');
% title('Square wave on real setup');
% legend('Final controller', 'Reference');
% exportgraphics(gcf,'../../figures/MPC_square_fin.eps')
%%
figure(8);clf;
set(gcf,'units','centimeters','position',[10,10,30,6])
plot(t, u_step, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Square wave reference');

% figure(7); clf;
% set(gcf,'units','centimeters','position',[10,10,30,10])
% plot(t, theta_2_dist(:, [8])); hold on;
% plot([t(1) t(end)], [0,0], 'k--');
% ylim([-1 1]);
% xlabel('Time (s)');
% ylabel('\theta_2 (rad)');
% title('Disturbance rejection on real setup');
% legend('Final controller', 'Reference');
% exportgraphics(gcf,'../../figures/MPC_dist_fin.eps')