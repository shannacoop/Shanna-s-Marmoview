function [D,P,A] = faceCalEnd(D,A,P,S)

D.eyeData{A.j} = A.eyeData;
D.faceConfig{A.j} = A.faceConfig;
% NOTE THAT THS RECORDS FINAL CALIBRATION VALUES OF THE TRIAL, WHICH CAN
% BE CHANGES MID-TRIAL. THEREFORE, ADJUST CALIBRATION MID-TRIAL SPARINGLY.
% BETTER TO PAUSE, ADJUST BASED ON THE EYE TRACE PLOT AND CONTINUE.
D.C(A.j).c = A.c;
D.C(A.j).dx = A.dx;
D.C(A.j).dy = A.dy;

% UPDATE THE FACE CONFIGURATION
P.faceConfig = P.faceConfig+1;
if P.faceConfig > length(S.faceConfigs)
    P.faceConfig = 1;
end

%%%% Plot results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To calculate location fix counts abd face fix counts
% 15 degrees in each direction, assuming no halfs used
locFixCounts = zeros(31,31);
% 30 faces
faceFixCounts = zeros(length(A.tex),1);
for i = 1:A.j
    % Get x and y coordinates for trial
    ed = D.eyeData{i};
    ind = ed(:,5) == 0;
    x = ((ed(ind,2)-A.c(1))/A.dx)/S.pixPerDeg;
    y = ((ed(ind,3)-A.c(2))/A.dy)/S.pixPerDeg;
    
    % Get face config data
    fc = D.faceConfig{i};
    X = fc(:,1); Y = fc(:,2); F = fc(:,3);
    % Go through the face locations
    for j = 1:length(F)
        fixCount = sum(sqrt((x-X(j)).^2 + (y-Y(j)).^2) < P.faceRadius);
        % Record the number of frames within face radius of locations
        locFixCounts(16+Y(j),16+X(j)) = locFixCounts(16+Y(j),16+X(j)) + fixCount;
        % Record the number of frames within the face number, multiply by
        % number of faces on screen -- maybe should be chnaged based on
        % eccentricity, too
        faceFixCounts(F) = faceFixCounts(F) + fixCount*length(F);
    end
end

% DataPlot1 Counts of face fixation
bar(A.DataPlot1,1:length(A.tex),faceFixCounts/sum(faceFixCounts));
title(A.DataPlot1,'Relative Face Popularity');
axis(A.DataPlot1,[0 length(A.tex)+1 0 1]);

% DataPlot2 How much time has been spent looking at different locations,
% caps out at 4 seconds which should indicate enough data to work with
locMap = locFixCounts; locMap(locMap > 240) = 240;
pcolor(A.DataPlot2,-15:15,-15:15,locMap);
colormap(hot);
title(A.DataPlot2,'Time looking at face by location');
set(A.DataPlot2,'XTick',-15:5:15,'YTick',-15:5:15);


