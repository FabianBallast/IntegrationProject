load ../../data/sysID/square0p5Hz0p7
% load ../../data/sysID/square2Hz0p7

t_ID = t(1:1001);
Y_ID1 = theta_1(1:1001);
Y_ID2 = theta_2(1:1001);
% in = inputDig(inputDig < -0.00001 | inputDig > 0.0001 | inputDig == 0);
% U_ID = in(1:1001);
[Y_ID1,Y_ID2] = preprocessing(Y_ID1, Y_ID2, t_ID);

t = 0:0.01:7;
in = 0.7*square(t*2*pi*0.5);
U_ID = [zeros(1, 300),in];

f = figure(1);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID1, 'LineWidth',1.5);
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
% saveas(f,'sysID_sawtooth_theta1','epsc')

f = figure(2);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID2, 'LineWidth',1.5);
ylabel('\theta_2 (radians)')
xlabel('Time (seconds)')
% saveas(f,'sysID_sawtooth_theta1','epsc')

f = figure(3);
plot(t_ID, U_ID, 'LineWidth',1.5);
ylabel('Input (-)')
xlabel('Time (seconds)')
title('Square input signal')
saveas(f,'sysID_validation_input','epsc')

%% Simulate the system with the input
% h = 0.01;
% 
% x0 = [Y_ID1(1); 0; Y_ID2(1); 0];
% 
% x_sim = zeros(4,1000);
% x_sim(:,1) = x0;
% y_sim = zeros(2,1000);
% 
% 
% for i=1:1:999
%     x_sim(:,i+1) = nonlin_state(x_sim(:,i),U_ID(i));
%     y_sim(:,i) = nonlin_meas(x_sim(:,i));
% end
% y_sim(:,i) = nonlin_meas(x_sim(:,i+1));
% 
% figure(4);
% plot(t_ID, y_sim(1,:));
% ylabel('\theta_1 (radians)')
% xlabel('Time (seconds)')
% %saveas(gcf,'sysID_sawtooth_theta1','epsc')
% 
% figure(5);
% plot(t_ID, y_sim(2,:));
% ylabel('\theta_2 (radians)')
% xlabel('Time (seconds)')

%%

load ../../data/constPar/model_parameters
load ../../data/constPar/motorPar2
load ../../data/constPar/th2_temp_par

model_par.c2 = c2_val;
model_par.b2 = b2_val;
model_par.J2 = J2_val;
model_par.g = g_val;
model_par.l1 = 0.097;
model_par.m2 = m2_val;

model_par.a11 = a11;
model_par.a12 = a12;
model_par.a22 = a22;
model_par.a21 = a21;

Theta1_0 = Y_ID1(1);
Thetad1_0 = 0;
Theta2_0 = Y_ID2(1);
Thetad2_0 = 0;

test_input = timeseries(U_ID,t_ID);

sim('../../simulink/simulate_with_data',10);

%% Calculate fit

V1 = Y_ID1;
V2 = angles_raw.Data(1:end,1);
fit_theta1 = 100*(1 - norm(V1-V2)/norm(V1-mean(V1)));

V1 = Y_ID2;
V2 = angles_raw.Data(1:end,2);
fit_theta2 = 100*(1 - norm(V1-V2)/norm(V1-mean(V1)));

%%
f = figure(4);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID1, 'LineWidth',1.5);
hold on
plot(angles_raw.Time, angles_raw.Data(:,1), 'LineWidth',1.5);
hold off
ylabel('\theta_1 (radians)')
xlabel('Time (seconds)')
title("Model fit of the first link: " + fit_theta1 + "%")
legend({'Measured','Model'})
saveas(f,'sysID_validation_theta1','epsc')

f = figure(5);
f.Position(3:4) = [540 300];
plot(t_ID, Y_ID2, 'LineWidth',1.5);
hold on
plot(angles_raw.Time, angles_raw.Data(:,2), 'LineWidth',1.5);
hold off
ylabel('\theta_2 (radians)')
xlabel('Time (seconds)')
title("Model fit of the second link: " + fit_theta2 + "%")
legend({'Measured','Model'},'Location','northwest')
saveas(f,'sysID_validation_theta2','epsc')
