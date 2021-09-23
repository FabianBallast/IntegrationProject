function [dx, y] = singlePend2(t, x, u, a1, a2, varargin)
%SINGLEPEND Summary of this function goes here
%   Detailed explanation goes here

dx = [x(2); 
      -(a1*x(2) + a2*sin(x(1)))];

y = x(1);

end

