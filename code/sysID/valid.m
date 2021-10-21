t = 0:0.01:7;
in = 0.7*square(t*2*pi*0.5);
in = [zeros(1, 300),in];
t = 0:0.01:10;

inp.time = t.';
inp.signals.values = in.';

model_par.J2= J2_val;
model_par.m2=m2_val;
model_par.c2=c2_val;
model_par.l1=0.074;
model_par.b2 =b2_val;
model_par.a11 = a11;
model_par.a12 = a12;
model_par.a21 = a21;
model_par.a22 = a22;
model_par.g = 9.81;

Thetad1_0 = 0;
Theta1_0 = theta_1(1);
Thetad2_0 = 0;
Theta2_0 = theta_2(1);

%%

th1 = angles_raw.Data(:, 1);
th2 = angles_raw.Data(:, 2);
t_meas = angles_raw.Time();

figure(1);
plot(t_meas, th1); hold on;
plot(t, theta_1);


figure(2);
plot(t_meas, th2);hold on;
plot(t, theta_2);