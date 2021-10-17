function [theta1,theta2] = preprocessing(th1,th2,t)
%PREPROSCESSING Summary of this function goes here
%   Detailed explanation goes here
    flat_th1 = th1 > 4.4 | th1 < -1.35;
    t_temp = t;
    t_temp(flat_th1) = [];
    thet1 = th1;
    thet1(flat_th1) = [];
    thet1 = unwrap(thet1);
    
    theta1 = interp1(t_temp, thet1, t, 'linear');
    
    theta2 = unwrap(th2);
end

