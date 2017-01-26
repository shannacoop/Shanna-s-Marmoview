function [D,P,A] = wpImgEnd(D,A,P,S),
% WPIMGEND Tidy up after a trial of MarmoView's wallpaper image task.
%
% Returns D, P and A structures with fields:
%
%   D.imgId - the state of the random number generator on this trial
%   D.direction - motion direction on this trial
%   D.error - the outcome of this trial (0 = complete)
%   D.eyeData - gaze position data (gaze space) 
%   D.C - eye calibration parameters

% 14-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!

% grrr! copy data to be saved to the D structure...
D.imageId{A.j} = A.imageId;

D.eyeData{A.j} = A.eyeData;

% NOTE THAT THS RECORDS FINAL CALIBRATION VALUES OF THE TRIAL, WHICH CAN
% BE CHANGED MID-TRIAL. THEREFORE, ADJUST CALIBRATION MID-TRIAL SPARINGLY.
% BETTER TO PAUSE, ADJUST BASED ON THE EYE TRACE PLOT AND CONTINUE.
D.C(A.j).c = A.c;
D.C(A.j).dx = A.dx;
D.C(A.j).dy = A.dy;

%
% plot stuff...
%

axes(A.DataPlot1);

axes(A.DataPlot2);
hist(diff(A.eyeData(:,1)),0:0.001:0.060);

axes(A.DataPlot3);
