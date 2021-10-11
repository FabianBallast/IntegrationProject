%% load model
load data/constPar/lin_model_dt

%% Set up uncertainty
systf_nom = tf(sysd);

Wunc = makeweight(0.05,100,12);
unc = ultidyn('unc',[1 1],'SampleStateDim',5);
systf = systf_nom*(1 + Wunc*unc);
systf.InputName = 'u';
systf.OutputName = {'theta_1', 'theta_2'};

rng('default')
bode(systf,'b',systf.NominalValue,'r+',logspace(-1,3,120))