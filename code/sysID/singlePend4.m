function [dx, y] = singlePend3(t, x, u, l1, varargin)
%SINGLEPEND Summary of this function goes here
%   Detailed explanation goes here
g = 9.81;
a21 = 0.074571658157541;
a22 = 117.7025981348793;

th2dd = -a22*l1*sin(x(1))*u(2)^2/g-u(3)+a21*x(2)+a22*sin(u(1)+x(1))-a22*l1*u(3)*cos(x(1))/g;

dx = [x(2); 
      th2dd];

y = x(1);

end

