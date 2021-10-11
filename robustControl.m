%% load model
load data/constPar/lin_model_dt

%% Set up uncertainty
systf_nom = tf(sysd);

Wunc = makeweight(0.05,100,12, 0.01);
unc = ultidyn('unc',[1 1],'SampleStateDim',5);
systf = uss(systf_nom)*(1 + Wunc*unc);
systf.InputName = 'u';
systf.OutputName = {'theta_1', 'theta_2'};

rng('default')
bodemag(systf,'b',systf.NominalValue,'r+',logspace(-1,3,120))
%%
% ReferenceTarget1 = 0.004*tf([1], [1 -1.6 0.64], 0.01);
% ReferenceTarget2 = 0.001*tf([1], [1 -1.8 0.81], 0.01);
ReferenceTarget1 = 1*tf([1.1 -1.101], [1 -0.8187], 0.01);
ReferenceTarget2 = 0.01*tf([1 0.01], [1 -0.9], 0.01);
Wref1 = 1/ReferenceTarget1;
Wref2 = 1/ReferenceTarget2;
% Wref1 = tf(1/0.01);
% Wref2 = tf(0/10);
Wref1.u = 'off1';  Wref1.y = 'e1';
Wref2.u = 'off2';  Wref2.y = 'e2';


bodemag(ReferenceTarget1, ReferenceTarget2);
%%
sysd.InputName='u';
sysd.OutputName={'theta_1', 'theta_2'};
%%
th1meas  = sumblk('y1 = theta_1');
th2meas = sumblk('y2 = theta_2');
off1meas  = sumblk('off1 = r_theta1 - theta_1');
off2meas = sumblk('off2 = -r_theta1 - theta_2');
ICinputs = {'r_theta1';'u'};
ICoutputs = {'e1'; 'off1'}; %; 'off2'};
qcaric = connect(sysd,Wref1, off1meas, off2meas,...
                 th1meas,th2meas,ICinputs,ICoutputs)
             
%%
% [C,muPerf] = musyn(qcaric,2,1);
[K,~,gamma] = hinfsyn(ss(qcaric,'explicit'),1,1);
gamma
K.InputName = {'off1'}; %, 'off2'};
K.OutputName = 'u';

sys_cl = connect(qcaric, K, 'r_theta1', {'e1', 'u', 'off1'});%, 'off2'});

%%
opt = stepDataOptions('StepAmplitude',0.1);
step(sys_cl, opt)
%%
bodemag(sys_cl)