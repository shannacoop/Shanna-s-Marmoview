function [A,P] = wpImgNext(S,P,A),
% WPIMGNEXT initialise the next trial of MarmoView's wallpaper image task.
%
% Returns structures A and P with fields:
%
%   A.imageId - the image/texture id

% 26-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!

% FIXME: most of this should be done in the xxxInit() function... but xxxInit()
%        doesn't get passed the S and P structures.. wtf?

% set gaze indicator color
A.hGaze.size = (2*P.gazeRadius)*S.pixPerDeg;
% A.hGaze.colour = uint8(repmat(A.bgColour,1,3) + P.gazeIntensity*S.gazeColorStep);
A.hGaze.colour = repmat(S.bgColour,1,3) + P.gazeIntensity*S.gazeColorStep;

% wallpaper image...
A.imageId = A.hImg.texIds{randi(A.hImg.numTex)}; % random
% A.imageId = A.hImg.texIds{randi(3)};

% note: we use the alpha blending to smoothly "fade" the image (texture)
%       from one trial into the next... here we setup hImg.id to hold
%       the texture id's for both the previous trial and the next trial,
%       and then manipulate their respective alpha values

A.hImg.id = circshift(A.hImg.id',-1)';
A.hImg.id{2} = A.imageId; % [prev, next]
A.hImg.alpha = [1.0, 0.0]; % [prev, next]

if A.j == 1, % first trial... fade from gray
    A.hImg.alpha = [0.0, 0.0];
end
