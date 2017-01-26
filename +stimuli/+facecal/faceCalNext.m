function [A,P] = faceCalNext(S,P,A)

% function [A,P] = FaceCalNext(S,P,A)

% Grab the face configuration to use on this trial
A.faceConfig = S.faceConfigs{P.faceConfig};

% Get how many faces in this configuration
N = size(A.faceConfig,1);

% Get texture list
F = A.faceConfig(:,3); % face indices
A.texList = A.tex(F); % corresponding textures

% Rectangles of the source textures
A.texRects = zeros(4,N);
for i = 1:N
    A.texRects(3:4,i) = zeros(2,1) + A.texDim(F(i));
end

% Rectangles of the window placement
A.winRects = zeros(4,N);
fr = round(P.faceRadius*S.pixPerDeg);
cp = S.centerPix;
X = A.faceConfig(:,1); % X coordinate in degrees
Y = A.faceConfig(:,2); % Y coordinate in degrees
for i = 1:N
    cX = round(cp(1)+X(i)*S.pixPerDeg);
    cY = round(cp(2)-Y(i)*S.pixPerDeg); % INVERT FOR SCREEN DRAWS
    A.winRects(:,i) = [cX-fr cY-fr cX+fr cY+fr];
end

% Color for gaze indicator color
A.eyeColor = uint8(repmat(P.bkgd,[1 3]) + P.eyeIntensity*S.eyeColorStep);