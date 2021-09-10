h = 0.001;

% Positive input -> counter-clockwise rotation

% t = angles_raw.Time;
% theta_1 = angles_raw.Data(:, 1);
% theta_2 = angles_raw.Data(:, 2);
%%
% save data t theta_1 theta_2
%% Check the data in a plot

figure();
plot(t, theta_1, t, theta_2);
xlabel("Time [s]");
ylabel("Sensor output");
legend('\theta_1', '\theta_2')

%% 
% Part 1: 0 rad / pi rad -- [0-4] s
% Part 2: pi/2 rad / pi/2 rad -- [14-17] s
% Part 3: pi rad / 0 rad -- [24-27] s
% Part 4: -pi/2 rad / -pi/2 rad -- [32-37] s
% Part 5: 0 rad / pi rad -- [42-46] s

theta_1_p1 = theta_1(t < 4);
theta_2_p1 = theta_2(t < 4);

theta_1_p2 = theta_1((t > 14) & (t < 17));
theta_2_p2 = theta_2((t > 14) & (t < 17));

theta_1_p3 = theta_1((t > 24) & (t < 27));
theta_2_p3 = theta_2((t > 24) & (t < 27));

offset_1 = mean(theta_1_p1);
offset_2 = mean(theta_2_p3);

min_theta_1 = min(theta_1);
max_theta_1 = max(theta_1);

min_theta_2 = min(theta_2);
max_theta_2 = max(theta_2);

gain_1 = 2 * pi / (max_theta_1 - min_theta_1);
gain_2 = 2 * pi / (max_theta_2 - min_theta_2);

% save calibration offset_1 offset_2 gain_1 gain_2

%%
t = angles_raw.Time;
theta_1 = angles_raw.Data(:, 1);
theta_2 = angles_raw.Data(:, 2);

input = Input.Data;

save sin2p2HzFullPower t theta_1 theta_2 input