%% Setup
clear; clc;

%% Load sin data
load ../../data/results/K1_sine

t = angles_raw.Time();
theta_2_sin(:, 1) = angles_raw.Data(:, 2);

load ../../data/results/K2_sine
theta_2_sin(:, 2) = angles_raw.Data(:, 2);

load ../../data/results/K3_sine
theta_2_sin(:, 3) = angles_raw.Data(:, 2);

load ../../data/results/K4_sin
theta_2_sin(:, 4) = angles_raw.Data(:, 2);

load ../../data/results/K5_sin
theta_2_sin(:, 5) = angles_raw.Data(:, 2);

load ../../data/results/K6_sin
theta_2_sin(:, 6) = angles_raw.Data(:, 2);

load ../../data/results/K7_sin
theta_2_sin(:, 7) = angles_raw.Data(:, 2);

load ../../data/results/K8_sine
theta_2_sin(:, 8) = angles_raw.Data(:, 2);

%% Load square data

load ../../data/results/K4_square
theta_2_square(:, 4) = angles_raw.Data(:, 2);

load ../../data/results/K5_square
theta_2_square(:, 5) = angles_raw.Data(:, 2);

load ../../data/results/K6_square
theta_2_square(:, 6) = angles_raw.Data(:, 2);

load ../../data/results/K7_square
theta_2_square(:, 7) = angles_raw.Data(:, 2);

load ../../data/results/K8_square
theta_2_square(:, 8) = angles_raw.Data(:, 2);

%% Load disturbance data

load ../../data/results/K4_dist
theta_2_dist(:, 4) = angles_raw.Data(:, 2);

load ../../data/results/K5_dist
theta_2_dist(:, 5) = angles_raw.Data(:, 2);

load ../../data/results/K6_dist
theta_2_dist(:, 6) = angles_raw.Data(:, 2);

load ../../data/results/K7_dist
theta_2_dist(:, 7) = angles_raw.Data(:, 2);

load ../../data/results/K8_dist
theta_2_dist(:, 8) = angles_raw.Data(:, 2);

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
plot(t, theta_2_sin(:, 1:3)); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('K_3','K_4', 'K_5', 'Reference');
exportgraphics(gcf,'../../figures/LQR_sine1.eps')

figure(2); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, [4 6 7])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('K_6','K_7', 'K_8', 'Reference');
exportgraphics(gcf,'../../figures/LQR_sine2.eps')

figure(3); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_sin(:, [8])); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/LQR_sine_fin.eps')

% figure(4); clf;
% set(gcf,'units','centimeters','position',[10,10,30,10])
% plot(t, theta_2_square(:, [4 6 7])); hold on;
% plot(t, u_step, 'k--');
% ylim([-1 1]);
% xlabel('Time (s)');
% ylabel('\theta_2 (rad)');
% title('Square wave reference on real setup');
% legend('K4','K5', 'K6', 'Reference');
% exportgraphics(gcf,'../../figures/LQR_square1.eps')

figure(5); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_square(:, [8])); hold on;
plot(t, u_step, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Square wave on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/LQR_square_fin.eps')

% figure(6); clf;
% set(gcf,'units','centimeters','position',[10,10,30,10])
% plot(t, theta_2_dist(:, [4 6 7])); hold on;
% plot([t(1) t(end)], [0,0], 'k--');
% ylim([-1 1]);
% xlabel('Time (s)');
% ylabel('\theta_2 (rad)');
% title('Disturbance rejection on real setup');
% legend('K4','K5', 'K6', 'Reference');
% exportgraphics(gcf,'../../figures/LQR_dist1.eps')

figure(7); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_dist(:, [8])); hold on;
plot([t(1) t(end)], [0,0], 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Disturbance rejection on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/LQR_dist_fin.eps')