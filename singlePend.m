function [dx, y] = singlePend(t, x, u, b, c2, m2, J2, g, varargin)
%SINGLEPEND Summary of this function goes here
%   Detailed explanation goes here

dx = [x(2); 
      -(b*x(2) + c2*g*m2*sin(x(1)))/(m2*c2^2 + J2)];

y = x(1);

end

