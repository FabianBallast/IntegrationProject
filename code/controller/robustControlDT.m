% load data/controller/hinf_controller
load data/controller/musyn_controller

hinf_dt = c2d(K, h);

%% For the simulation with the model

model_par.c2 = c2_val;
model_par.b2 = b2_val;
model_par.J2 = J2_val;
model_par.g = g_val;
model_par.l1 = l1_val;
model_par.m2 = m2_val;

model_par.a11 = a11;
model_par.a12 = a12;
model_par.a22 = c2_val*g_val*m2_val/(m2_val*c2_val^2+J2_val);

Theta1_0 = 0;
Thetad1_0 = 0;
Theta2_0 = 0.015;
Thetad2_0 = 0;



