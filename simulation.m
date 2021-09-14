%% Clear old values
clear; clc;

%% Set constant model parameters
load model_parameters
model_par.c2 = c2;
model_par.b = b;
model_par.g = g;
model_par.m2 = m2;
model_par.J2 = J2;

%% Initial parameters
Theta1_0 = pi;
Theta2_0 = -pi/2;
Thetad1_0 = 0;
Thetad2_0 = 0;