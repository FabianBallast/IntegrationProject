%% Load all parameters

load data/constPar/model_parameters
load data/constPar/motorPar2

%% Make dynamical model again
syms theta1 dtheta1 ddtheta1 theta2 dtheta2 ddtheta2 c_mot dc_mot ddc_mot real;
syms m1 m2 k_gear J1 J2 l1 g c1 c2 b1 b2 R_mot L_mot k_mot V_in real positive;

a22 = c2*g*m2/(m2*c2^2+J2);
F = -c2*l1*m2*sin(theta2)*dtheta1^2 - b2*dtheta2 + c2*g*m2*sin(theta1 + theta2);
M21 = m2*c2^2 + l1*m2*cos(theta2)*c2 + J2;
M22 = m2*c2^2 + J2;
ddtheta2 = F/M22 - M21/M22 * (-a11*dtheta1 - a12*V_in);

%% Linearize
linState = [0;0;0;0];

jac_q = jacobian(ddtheta2, [theta1, dtheta1, theta2, dtheta2, V_in]);
jac_q_val = subs(jac_q, [c2 m2 g J2 b2 l1 theta1 dtheta1 theta2 dtheta2 V_in], ...
                        [c2_val m2_val, g_val, J2_val, b2_val, l1_val, linState.', 0]);
                    

jac_q_val = double(jac_q_val);
%% Find continuous time matrices

% x = [th1; dth1; th2; dth2];

A = [ 0,  1, 0, 0;
      0, -a11, 0, 0;
      0,    0, 0, 1;
      jac_q_val(1:4)];

B = [0;-a12;0;jac_q_val(end)];

C = [1,0,0,0;
     0,0,1,0];
 
D = [0;0];

%% Save matrices
save data/constPar/lin_model_ct A B C D
