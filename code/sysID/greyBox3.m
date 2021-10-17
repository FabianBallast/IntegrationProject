%% Read data from file. 
clear all;
close all;
%%
load ../../data/sysID/sawtooth1;

t_ID = t(1:952);
Y_ID = theta_1(1:952);
in = inputDig(inputDig < -0.00001 | inputDig > 0.0001 | inputDig == 0);
U_ID = in(2:953);
Y_ID2 = preprocessing(Y_ID, Y_ID, t_ID);
Y_ID2 = Y_ID2-Y_ID(1);

min_vals = [];
vals = [];
for i = 3:8
    [vals(i-2), ind] = min(Y_ID2(i*100:(i+1)*100));
     min_vals(i-2) = 100*i + ind;
end

min_vals(7) = 952;
vals(7) = Y_ID2(952);

t_interp = t_ID(min_vals(1):min_vals(end));
extra_val = interp1(t_ID(min_vals), vals, t_interp);

Y_ID2(min_vals(1):min_vals(end)) = Y_ID2(min_vals(1):min_vals(end)) - (extra_val - vals(1));

figure(1);
plot(t_ID, Y_ID2);

figure(2);
plot(t_ID, U_ID);

data1 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Sawtooth');

%%
load ../../data/sysID/chirp_deadzone;

t_ID = t(1:1001);
Y_ID = theta_1(1:1001);
in = inputDig(inputDig < -0.00001 | inputDig > 0.0001 | inputDig == 0);
U_ID = in(2:1002);

Y_ID2 = preprocessing(Y_ID, Y_ID, t_ID);
Y_ID2 = Y_ID2-Y_ID(1);
figure(1);
plot(t_ID, Y_ID2)
data4 = iddata(Y_ID2, U_ID, 0.01, 'Name', 'Chirp');

figure(2);
plot(t_ID, U_ID)
xlabel('Time (seconds)')
ylabel('Input value (-)')
title('Chirp input signal')
saveas(gcf,'sysID_chirp','epsc')


%%
% load data/constPar/motorPar
% k = 1100;
% zeta =0.3;
% omega = 2.3 * 2 * pi; 


% [A, B, C, D] = motorDyn(-a11,-a12,0);
% lsys = ss(A,B,C,D);
% y = lsim(lsys, U_ID, t_ID, [0;0]); 
% plot(t_ID, Y_ID2); hold on;
% plot(t_ID, y); hold off;

%%

data = merge(data4);
a11 = -44;
a12 = -342.5;
% data = iddata(y(:, 1), u, 0.1, 'Name', 'DC-motor');
data.InputName = 'Voltage';
data.InputUnit = 'V';
data.OutputName = 'Angular position';
data.OutputUnit = 'deg';
data.Tstart = 0;
data.TimeUnit = 's';


parameters = 0;
init_sys = idgrey('motorDyn',{'a11',a11; 'a12', a12},'c');
init_sys.Structure.Parameters(1).Maximum = 0;
init_sys.Structure.Parameters(2).Maximum = 0;

init_sys.Structure.Parameters(1).Minimum =-500;
init_sys.Structure.Parameters(2).Minimum = -4000;
opt = greyestOptions('InitialState', 'zero');
sys = greyest(data,init_sys, opt);
%%
opt = compareOptions('InitialCondition', 'zero');
figure(2);
compare(data1,sys, Inf, opt)
%%
% figure(3)
% compare(data2,sys,Inf,opt)
% figure(4)
% compare(data3,sys,Inf,opt)
figure(5)
compare(data4,sys,Inf,opt)
%%
par = getpvec(sys);
init_sys2 = idgrey('motorDyn',{'a11',par(1); 'a12', par(2)},'c');
sys_pem = pem(data,init_sys2);

%%
figure(2);
compare(data1,sys_pem,Inf,opt)

%%
% figure(3)
% compare(data2,sys_pem,Inf,opt)
% figure(4)
% compare(data3,sys_pem,Inf,opt)

%%
% opt = n4sidOptions('Focus','simulation');
% init_sys = n4sid(data,2);
% sys = pem(data,init_sys);
% figure(2)
% compare(data1,sys,init_sys);
%%
% figure(3)
% compare(data2,sys,init_sys);
% figure(4)
% compare(data3,sys,init_sys);