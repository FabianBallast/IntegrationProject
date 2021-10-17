function [A,B,C,D] = motorDyn(a11, a12,ts)
%MOTORDYNAMICS ODE file representing the dynamics of a motor.
%
%   [A,B,C,D,K,X0] = motorDynamics(Tau,Ts,G)
%   returns the State Space matrices of the DC-motor with
%   time-constant Tau (Tau = par) and known static gain G. The sample
%   time is Ts.
%
%   This file returns continuous-time representation if input argument Ts
%   is zero. If Ts>0, a discrete-time representation is returned. To make
%   the IDGREY model that uses this file aware of this flexibility, set the
%   value of Structure.FcnType property to 'cd'. This flexibility is useful
%   for conversion between continuous and discrete domains required for
%   estimation and simulation.
%
%   See also IDGREY, IDDEMO7.

%   L. Ljung
%   Copyright 1986-2015 The MathWorks, Inc.

% par
% aux
% t = par(1);
% G = par(2);

% A = [-a11, 0
%      1, 0 ];
%  B = [1;0];
%  C = [0,-a12];
%  D = [0];

A = [0, 1;
     0, a11 ];
B = [0; a12];
C = [1,0];
D = [0];


%  K = [0;0];
%  X0 = [0;0;-3.33/k];
% A = [0 1;0 -1/t];
% B = [0;G/t];
% C = [1 0];
% D = [0];
% K = [0;0];
% X0 = [0;0];
if ts>0 % Sample the model with sample time Ts
   s = expm([[A B]*ts; zeros(1,4)]);
   A = s(1:3,1:3);
   B = s(1:3,4);
end
