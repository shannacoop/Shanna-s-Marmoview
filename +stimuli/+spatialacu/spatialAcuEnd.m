function [D,P,A] = spatialAcuEnd(D,A,P,S)

%%%% Record some data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D.eyeData{A.j} = A.eyeData;
D.error(A.j) = A.error;
D.x(A.j) = D.P(A.j).xDeg;
D.y(A.j) = D.P(A.j).yDeg;
D.cpd(A.j) = D.P(A.j).cpd;
D.contrastCue(A.j) = A.useContrastCue;
D.distVals{A.j} = A.distVals;
D.C(A.j).c = A.c;
D.C(A.j).dx = A.dx;
D.C(A.j).dy = A.dy;

%%%% Close textures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Close',A.tex);
Screen('Close',A.fixTex1);
Screen('Close',A.fixTex2);
for i = 1:(P.apertures-1)
    Screen('Close',A.distTex{i});
end

%%%% Trial control -- Update certain parameters depending on run type %%%%%
switch P.runType
    case 1  % Randomizing location using current parameter eccentricity,
            % but this only randomizes among the cardinal directions
        if logical(ceil(2*rand)-1)
            xsign = 2*ceil(2*rand)-3;
            ysign = 0;
        else
            xsign = 0;
            ysign = 2*ceil(2*rand)-3;
        end
        ecc = norm([P.xDeg P.yDeg]);
        P.xDeg = xsign*ecc;
        P.yDeg = ysign*ecc;
        P.phase = 180*floor(2*rand);
    case 2  % Only update if trial was initiated to the point of stimulus shown
        if A.error == 0 || A.error > 2
        % These parameters will be assigned again if the user tries to
        % deviate from the trials list without changing the P.runType to
        % random or manual.
            A.trialInd = A.trialInd+1;
            i = A.trialPerm(A.trialInd);
            P.xDeg = S.trialsList(i,1);
            P.yDeg = S.trialsList(i,2);
            P.cpd = S.trialsList(i,3);
            P.phase = S.trialsList(i,4);
            P.angle = S.trialsList(i,5);
            P.rewardNumber = S.trialsList(i,7);
        end
end

%%%% Plot results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dataplot 1, errors
errors = [0 1 2 3 4 5;
    sum(D.error==0) sum(D.error==1) sum(D.error==2) sum(D.error==3) sum(D.error==4) sum(D.error==5)];
bar(A.DataPlot1,errors(1,:),errors(2,:));
title(A.DataPlot1,'Errors');
ylabel(A.DataPlot1,'Count');
set(A.DataPlot1,'XLim',[-.75 5.75]);

% DataPlot2, fraction correct by spatial location
% Note that this plot will break down if multiple stimulus eccentricities 
% or a non horizontal hexagon are used. It will also only calculate
% fraction correct for locations assigned by the trials list.
locs = unique(S.trialsList(:,1:2),'rows');
nlocs = size(locs,1);
labels = cell(1,nlocs);
fcXxy = zeros(1,nlocs);
for i = 1:nlocs
    x = locs(i,1); y = locs(i,2);
    Ncorrect = sum(D.x == x & D.y == y & D.error == 0);
    Ntotal = sum(D.x == x & D.y == y & (D.error == 0 | D.error > 2.5));
    if  Ntotal > 0
        fcXxy(i) = Ncorrect/Ntotal;
    end
    % Constructs labels based on the six locations
    if x > 0 && abs(y) < .01;       labels{i} = 'R';    end
    if x < 0 && abs(y) < .01;       labels{i} = 'L';    end
    if y > .01 && x > 0;            labels{i} = 'UR';   end
    if y < -.01 && x > 0;           labels{i} = 'DR';   end
    if y > .01 && x < 0;            labels{i} = 'UL';   end
    if y < -.01 && x < 0;           labels{i} = 'DL';   end
end
bar(A.DataPlot2,1:nlocs,fcXxy);
title(A.DataPlot2,'By Location');
ylabel(A.DataPlot2,'Fraction Correct');
set(A.DataPlot2,'XTickLabel',labels);
axis(A.DataPlot2,[.25 nlocs+.75 0 1]);

% Dataplot3, fraction correct by cycles per degree
% This plot only calculates the fraction correct for trials list cpds.
cpds = unique(S.trialsList(:,3));
ncpds = size(cpds,1);
fcXcpd = zeros(1,ncpds);
labels = cell(1,ncpds);
for i = 1:ncpds
    cpd = cpds(i);
    Ncorrect = sum(D.cpd == cpd & D.error == 0);
    Ntotal = sum(D.cpd == cpd & (D.error == 0 | D.error > 2.5));
    if Ntotal > 0
        fcXcpd(i) = Ncorrect/Ntotal;
    end
    labels{i} = num2str(round(10*cpd)/10);
end
bar(A.DataPlot3,1:ncpds,fcXcpd);
title(A.DataPlot3,'By Cycles per Degree');
ylabel(A.DataPlot3,'Fraction Corret');
set(A.DataPlot3,'XTickLabel',labels);
axis(A.DataPlot3,[.25 ncpds+.75 0 1]);
