%% Load all parameters

load data/constPar/model_parameters
load data/constPar/motorPar

%% Make dynamical model again
syms theta1 dtheta1 ddtheta1 theta2 dtheta2 ddtheta2 c_mot dc_mot ddc_mot real;
syms m1 m2 k_gear J1 J2 l1 g c1 c2 b1 b2 R_mot L_mot k_mot V_in real positive;

a22 = c2*g*m2/(m2*c2^2+J2);
F = -c2*l1*m2*sin(theta2)*dtheta1^2 - b2*dtheta2 + c2*g*m2*sin(theta1 + theta2);
M21 = m2*c2^2 + l1*m2*cos(theta2)*c2 + J2;
M22 = m2*c2^2 + J2;
ddtheta2 = F/M22 - M21/M22 * (-a11*dtheta1 - a12*V_in);

ddtheta2 = subs(ddtheta2, [g m2 l1 c2 b2 J2], [g_val m2_val l1_val c2_val b2_val J2_val]);

f_nonlin_ct = [ dtheta1;
                -a11*dtheta1-a12*V_in;
                dtheta2;
                ddtheta2];
            
h_nonlin_ct = [theta1; theta2];

f_nonlin_dt = f_nonlin_ct*h + [theta1; dtheta1; theta2; dtheta2];

h_nonlin_dt = h_nonlin_ct;

