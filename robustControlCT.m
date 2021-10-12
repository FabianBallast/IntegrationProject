%% load model
load data/constPar/lin_model_ct

% A= A(1:2, 1:2);
% B = B(1:2);
% C= C(1, 1:2);
% D = D(1);

sys = ss(A,B,C,D);
sys.InputName='u';
sys.OutputName={'theta_1', 'theta_2'};
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
qcaric = connect(sys,Wref1,Wref2, Wcost, off1,off2,ICinputs,ICoutputs)

%%
[K,~,gamma] = hinfsyn(qcaric,2,1);
gamma

% [K,muPerf] = musyn(qcaric,1,1);
% muPerf
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
K_nom = tf(-5);
K_nom.InputName = {'off1'}; %, 'off2'};
K_nom.OutputName = 'u';

sys_cl = connect(qcaric, K_nom, 'r_theta1', {'z1', 'u', 'off1'});%, 'off2'});sys_cl = connect(qcaric, K, 'r_theta1', {'z1', 'u', 'off1'});%, 'off2'});

step(sys_cl);
