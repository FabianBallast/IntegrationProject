%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DSCS FPGA interface board: init and I/O conversions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ../data/constPar/calibration

% gains and offsets
daoutoffs = -[-0.0025];                   % output offset
daoutgain = 1*[-6];                   % output gain

% Sensor calibration:
adinoffs = -[offset_1 offset_2];
adingain = [gain_1 gain_2];

adinoffs = [adinoffs 0 0 0 0 0];    % input offset
adingain = [adingain 1 1 1 1 1];     % input gain (to radians)

