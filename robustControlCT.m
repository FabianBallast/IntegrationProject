%% load model
load data/constPar/lin_model_ct

% A= A(1:2, 1:2);
% B = B(1:2);
% C= C(1, 1:2);
% D = D(1);

sys_nom = ss(A,B,C,D);
sys_nom.InputName='u';
sys_nom.OutputName={'theta_1', 'theta_2'};

Wunc = makeweight(0.1,60,10);
unc = ultidyn('unc',[1 1],'SampleStateDim',5);
sys_rob = sys_nom*(1 + Wunc*unc);
sys_rob.InputName='u';
sys_rob.OutputName={'theta_1', 'theta_2'};
%%
ReferenceTarget1 = 1.5*tf([1 0.001], [1 0.5]);
ReferenceTarget2 = 1.2*tf([1 0.01], [1 10]);
ReferenceCost = 0.005*tf([1 100000], [1,100]);

Wref1 = 1/ReferenceTarget1;
Wref1.u = 'off1';
Wref1.y = 'z1';

Wref2 = 1/ReferenceTarget2;
Wref2.u = 'off2';
Wref2.y = 'z2';

Wcost = 1/ReferenceCost;
Wcost.u= 'u';
Wcost.y= 'z3';

bodemag(ReferenceTarget1, ReferenceTarget2, ReferenceCost);
legend('S1', 'S2', 'KS');
%%
off1  = sumblk('off1 = r_theta1 - theta_1');
off2  = sumblk('off2 = -r_theta1 - theta_2');
ICinputs = {'r_theta1';'u'};
ICoutputs = {'z1';'z2';'z3';'off1'; 'off2'};
qpend_nom = connect(sys_nom,Wref1,Wref2, Wcost, off1,off2,ICinputs,ICoutputs);
qpend_rob = connect(sys_rob,Wref1,Wref2, Wcost, off1,off2,ICinputs,ICoutputs);
%%
[K,~,gamma] = hinfsyn(qpend_nom,2,1);
gamma

K.InputName = {'off1', 'off2'};
K.OutputName = 'u';

sys_cl = connect(qcaric, K, 'r_theta1', {'z1', 'z2', 'z3', 'u', 'off1', 'off2'});

%%
save data/controller/hinf_controller K sys_cl

%%
opt = stepDataOptions('StepAmplitude',1);
step(sys_cl, 1, opt)

%%
bodemag(sys_cl)
%% 
[K,muPerf] = musyn(qpend_rob,2,1);
muPerf
%%
K.u = {'off1', 'off2'};
K.y = 'u';
ICinputs = {'r_theta1'};
ICoutputs = {'off1'; 'off2'};
sys_cl = connect(qpend_nom,K,ICinputs,ICoutputs);
step(sys_cl, 1, opt)

%%
save data/controller/musyn_controller K sys_cl