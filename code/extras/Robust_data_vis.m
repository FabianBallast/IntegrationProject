%% Compare target sets
load ../../data/results/Robust_set0

t = angles_raw.Time();
theta_2_sin(:, 1) = angles_raw.Data(:, 2);

load ../../data/results/Robust_set1

theta_2_sin(:, 2) = angles_raw.Data(:, 2);

load ../../data/results/Robust_setfinal_sin

theta_2_sin(:, 3) = angles_raw.Data(:, 2);

%% Load square data

load ../../data/results/Robust_setfinal_square
theta_2_square(:, 3) = angles_raw.Data(:, 2);

%% Load disturbance data

load ../../data/results/Robust_setfinal_dist
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
plot(t, theta_2_sin(:, :)); hold on;
plot(t, u_sine, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Sine reference on real setup');
legend('Set1','Set2', 'Set3', 'Reference');
exportgraphics(gcf,'../../figures/Robust_sine1.eps')

figure(2); clf;
set(gcf,'units','centimeters','position',[10,10,30,10])
plot(t, theta_2_square(:, [3])); hold on;
plot(t, u_step, 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Square wave reference on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/Robust_square_fin.eps')

figure(3); clf;
set(gcf,'units','centimeters','position',[10,10,30,10])
plot(t, theta_2_dist(:, [3])); hold on;
plot([t(1) t(end)], [0 0], 'k--');
ylim([-1 1]);
xlabel('Time (s)');
ylabel('\theta_2 (rad)');
title('Disturbance rejection on real setup');
legend('Final controller', 'Reference');
exportgraphics(gcf,'../../figures/Robust_dist_fin.eps')

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