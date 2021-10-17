%% Load in angular data

t = angles_raw.Time;
Theta1 = angles_raw.Data(:,1);
Theta2 = angles_raw.Data(:,2);

%% Load in parameters (length of links)
dimensions;

%% Find positions of Elbow and Hand
E = l_link1 * [sin(Theta1), cos(Theta1)];
H = E + l_link2 * [sin(Theta1 + Theta2), cos(Theta1 + Theta2)];

%% Make animation
figure()
p = plot([0, E(1,1), H(1,1)], [0, E(1, 2), H(1, 2)],'-o');
xlim([-0.2, 0.2]);
ylim([-0.2, 0.2]);
pause(t(2));
for i = 2:length(t)
    p.XData = [0, E(i,1), H(i,1)];
    p.YData = [0, E(i,2), H(i,2)];
    pause(t(min(i+1,length(t)))-t(i));
end