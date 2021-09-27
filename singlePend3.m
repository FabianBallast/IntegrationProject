function [dx, y] = singlePend3(t, x, u, m2, c2, varargin)
%SINGLEPEND Summary of this function goes here
%   Detailed explanation goes here
g = 9.81;
a21 = 0.074571658157541;
a22 = 117.7025981348793;
l1 = 0.097;

J2 = c2*m2*g/a22 - m2*c2^2;
b2 = a21 * c2*m2*g / a22;

F = -c2*l1*m2*sin(x(1))*u(2)^2 - b2*x(2) + c2*g*m2*sin(u(1) + x(1));
M21 = m2*c2^2 + l1*m2*cos(x(1))*c2 + J2;
M22 = m2*c2^2 + J2;

dx = [x(2); 
      F/M22 - M21/M22 * u(3)];

y = x(1);

end

