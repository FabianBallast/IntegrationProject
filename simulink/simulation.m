%% Clear old values
clear; clc;

%% Set constant model parameters
load ../data/constPar/model_parameters
model_par.c2 = c2_val;
model_par.b = b2_val;
model_par.g = g_val;
model_par.m2 = m2_val;
model_par.J2 = J2_val;

%% Initial parameters
Theta1_0 = pi;
Theta2_0 = -pi/2;
Thetad1_0 = 0;
Thetad2_0 = 0;