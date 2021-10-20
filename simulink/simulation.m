%% Clear old values
clear; clc;

%% Set constant model parameters
load ../data/constPar/model_parameters
load ../data/constPar/motorPar
model_par.c2 = c2_val;
model_par.b = b2_val;
model_par.g = g_val;
model_par.m2 = m2_val;
model_par.J2 = J2_val;

model_par.a11 = a11;
model_par.a12 = a12;
model_par.a22 = c2_val*g_val*m2_val/(m2_val*c2_val^2+J2_val);

%% Initial parameters
% Theta1_0 = pi;
% Theta2_0 = -pi/2;
% Thetad1_0 = 0;
% Thetad2_0 = 0;

Theta1_0 = Y_ID1(1);
Theta2_0 = Y_ID2(1);
Thetad1_0 = 0;
Thetad2_0 = 0;