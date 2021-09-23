%% Read data from file. 
clear all;
close all;
%%
load data/sysID/sweepv4;

t_ID = t(500:1301);
Y_ID = theta_1(1:802);
U_ID = input(2:803);

Y_ID2 = preprocessing(Y_ID, Y_ID, t_ID);
Y_ID2 = Y_ID2-Y_ID(1);

figure(1);
plot(t_ID, Y_ID2)

data1 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Sweep');
%%
load data/sysID/sin1Hz0p5v1;

t_ID = t(700:1301);
Y_ID = theta_1(201:802);
U_ID = input(202:803);

Y_ID2 = preprocessing(Y_ID, Y_ID, t_ID);
Y_ID2 = Y_ID2-Y_ID(1);
figure(2);
plot(t_ID, Y_ID2)

data2 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Sine');
%%
load data/sysID/rot_inc_torqv1;

t_ID = t(700:1301);
Y_ID = theta_1(201:802);
U_ID = input(202:803);



Y_ID2 = preprocessing(Y_ID, Y_ID, t_ID);
Y_ID2 = Y_ID2-Y_ID(1);
figure(1);
plot(t_ID, Y_ID2)
data3 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Torque');

%%

% k = 1100;
% zeta =0.3;
% omega = 2.3 * 2 * pi; 
a11 = 45;
a12 = 311;


[A, B, C, D] = motorDyn(a11,a12,0);
lsys = ss(A,B,C,D);
y = lsim(lsys, U_ID, t_ID, [0;0]); 
plot(t_ID, Y_ID2); hold on;
plot(t_ID, y); hold off;

%%


data = merge(data1, data2, data3);
a11 = 1;
a12 = 1;
% data = iddata(y(:, 1), u, 0.1, 'Name', 'DC-motor');
data.InputName = 'Voltage';
data.InputUnit = 'V';
data.OutputName = 'Angular position';
data.OutputUnit = 'deg';
data.Tstart = 0;
data.TimeUnit = 's';




parameters = 0;
init_sys = idgrey('motorDyn',{'a11',a11; 'a12', a12},'c');
init_sys.Structure.Parameters(1).Maximum = 800;
init_sys.Structure.Parameters(2).Maximum = 500;

init_sys.Structure.Parameters(1).Minimum = 0;
init_sys.Structure.Parameters(2).Minimum = 0;
opt = greyestOptions('InitialState', 'auto');%, 'Focus', 'Simulation');
sys = greyest(data3,init_sys, opt);
%%
opt = compareOptions('InitialCondition', 'auto');
figure(2);
compare(data1,sys,Inf,opt)
figure(3)
compare(data2,sys,Inf,opt)
figure(4)
compare(data3,sys,Inf,opt)
%%
par = getpvec(sys);
init_sys = idgrey('motorDyn',{'a11',par(1); 'a12', par(2)},'c');
sys_pem = pem(data3,init_sys);

%%
figure(2);
compare(data1,sys_pem,Inf,opt)
figure(3)
compare(data2,sys_pem,Inf,opt)
figure(4)
compare(data3,sys_pem,Inf,opt)

%%
opt = n4sidOptions('Focus','simulation');
init_sys = n4sid(data,2,opt);
sys = pem(data,init_sys);
figure(2)
compare(data1,sys,init_sys);
figure(3)
compare(data2,sys,init_sys);
figure(4)
compare(data3,sys,init_sys);