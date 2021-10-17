load ../../data/sysID/velMap1
input1 = inputDig(2:end);
theta1 = theta_1;
t1 = t;

theta1 = preprocessing(theta1, theta1, t1);

load ../../data/sysID/velMap2
input2 = inputDig(2:end);
theta_1(1790)= theta_1(1789);
theta_1(3817)= theta_1(3816);
theta2 = theta_1;
t2 = t;

theta2 = preprocessing(theta2, theta2, t2);

figure(1);
plot(t1, theta1); hold on;
plot(t2, theta2); hold off;
legend('CCW rotations', 'CW rotations');
xlabel("Input value (-)");
ylabel("Angle (rad)");
title("Rotations before input mapping");
%%
y_s1 = smooth(theta1(1:5:end));
y_s2 = smooth(theta2(1:5:end));

v1 = smooth(diff(y_s1)/0.05, 7);
v2 = smooth(diff(y_s2)/0.05, 7);

figure(2);
plot(input1(2:5:end), v1, 'o', 'Markersize', 1); hold on;
plot(input2(2:5:end), v2, 'o', 'Markersize', 1); hold off;
xlabel("Input value (-)");
ylabel("Angular velocity (rad/s)");
legend('CCW rotations', 'CW rotations');
title("Angular velocity before input mapping");
%%
load ../../data/sysID/velMap1Imp
input1 = inputDig(11:end);
theta_1(755) = theta_1(756);
theta_1(3410) = theta_1(3409);
theta1 = theta_1;
t1 = t;
thettem = theta_1;
theta1 = preprocessing(theta1, theta1, t1);

load ../../data/sysID/velMap2Imp
input2 = inputDig(11:end);
theta_1(2046) = theta_1(2045);
theta_1(2382) = theta_1(2381);
theta2 = theta_1;
t2 = t;

theta2 = preprocessing(theta2, theta2, t2);

figure(3);
plot(t1, theta1); hold on;
plot(t2, theta2); hold off;
title("Rotations after input mapping");
legend('CCW rotations', 'CW rotations');
xlabel("Input value (-)");
ylabel("Angle (rad)");
%%
y_s1 = smooth(theta1(1:5:end));
y_s2 = smooth(theta2(1:5:end));

v1 = smooth(diff(y_s1)/0.05, 7);
v2 = smooth(diff(y_s2)/0.05, 7);

figure(4);
plot(input1(2:5:end), v1, 'o', 'Markersize', 1); hold on;
plot(input2(2:5:end), v2, 'o', 'Markersize', 1); hold off;
xlabel("Input value (-)");
ylabel("Angular velocity (rad/s)");
title("Angular velocity after input mapping");
legend('CCW rotations', 'CW rotations');
