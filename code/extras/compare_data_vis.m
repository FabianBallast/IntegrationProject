%% Setup
clear; clc;

%% Load sin data
load ../../data/results/LQR_sin_fin

t = angles_raw.Time();
theta_2_sin(:, 1) = angles_raw.Data(:, 2);
input_sin(:, 1) = Input.Data();

load ../../data/results/Robust_setfinal_sin
theta_2_sin(:, 2) = angles_raw.Data(:, 2);
input_sin(:, 2) = Input.Data();

load ../../data/results/MPC_sin_fin
theta_2_sin(:, 3) = angles_raw.Data(:, 2);
input_sin(:, 3) = Input.Data();
%% Load square data
load ../../data/results/LQR_square_fin

theta_2_square(:, 1) = angles_raw.Data(:, 2);

load ../../data/results/Robust_setfinal_square
theta_2_square(:, 2) = angles_raw.Data(:, 2);

load ../../data/results/MPC_square_fin
theta_2_square(:, 3) = angles_raw.Data(:, 2);

%% Load dist data
load ../../data/results/LQR_dist_fin

theta_2_dist(:, 1) = angles_raw.Data(:, 2);

load ../../data/results/Robust_setfinal_dist
theta_2_dist(:, 2) = angles_raw.Data(:, 2);

load ../../data/results/MPC_dist_fin
theta_2_dist(:, 3) = angles_raw.Data(:, 2);

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
title('Different results for controllers when tracking sine wave');
legend('LQG','Robust Control', 'MPC', 'Reference');
exportgraphics(gcf,'../../figures/compSine.eps')

figure(2); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_square(:, 1:3)); hold on;
plot(t, u_step, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Different results for controllers when tracking square wave');
legend('LQG','Robust Control', 'MPC', 'Reference');
exportgraphics(gcf,'../../figures/compSquare.eps')

figure(3); clf;
set(gcf,'units','centimeters','position',[10,10,30,8])
plot(t, theta_2_dist(:, 1:3)); hold on;
plot([t(1) t(end)], [0 0], 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Different results for controllers with disturbance rejection');
legend('LQG','Robust Control', 'MPC', 'Reference');
exportgraphics(gcf,'../../figures/compDist.eps')