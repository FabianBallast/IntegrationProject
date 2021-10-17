function [x] = RK4(t, x0, ODE)
%RK4 Runge-Kutta 4th-order method of integration
%   Input:
%     t   - Array of size (1 x n) with all time stamps. t(1) = 0.
%     x0  - Initial conditions of the state of size (m x 1).
%     ODE - Function that returns derivatives of system given a state and time.
%         - That is, x_dot = ODE(t, x)
%
%   Output:
%      x  - Array of size (m x n) with all positions over time. 

    dt = t(2);
    n = length(t);
    m = length(x0);
   
    x = zeros(m, n);
    x(:, 1) = x0;
    
    for i = 2:n
        k1 = ODE(t(i), x(:, i-1));
        k2 = ODE(t(i) + dt/2, x(:, i-1) + dt*k1/2);
        k3 = ODE(t(i) + dt/2, x(:, i-1) + dt*k2/2);
        k4 = ODE(t(i)+dt, x(:, i-1) + dt*k3);
        x(:, i) = x(:, i-1) + 1/6 * dt * (k1 + 2* k2 + 2*k3 + k4);
    end
end

