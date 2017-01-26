function [D,P,A] = fixFlashEnd(D,A,P,S)

%%%% Record some data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D.eyeData{A.j} = A.eyeData;
D.error(A.j) = A.error;
D.x(A.j) = D.P(A.j).xDeg;
D.y(A.j) = D.P(A.j).yDeg;
D.fixDur(A.j) = A.fixDur;
D.C(A.j).c = A.c;
D.C(A.j).dx = A.dx;
D.C(A.j).dy = A.dy;

%%%% Close textures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Close',A.fixTex);

%%%% Trial control -- Update certain parameters depending on run type %%%%%
switch P.runType
    case 1  % Staircasing
        % If correct, small increment in fixation duration
        if ~A.error
            P.fixMin = P.fixMin + S.staircase.up(1);
            P.fixRan = P.fixRan + S.staircase.up(2);
            % cannot exceed limit
            P.fixMin = min([P.fixMin S.staircase.durLims(3)]);
            P.fixRan = min([P.fixRan S.staircase.durLims(4)]);
        % If entered fixationand failed to maintain it, large reduction in
        % fixation duration
        elseif A.error == 2
            P.fixMin = P.fixMin - S.staircase.down(1);
            P.fixRan = P.fixRan - S.staircase.down(2);
            % cannot exceed limit
            P.fixMin = max([P.fixMin S.staircase.durLims(1)]);
            P.fixRan = max([P.fixRan S.staircase.durLims(2)]);
        end
end

%%%% Plot results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dataplot 1, errors
errors = [0 1 2; sum(D.error==0) sum(D.error==1) sum(D.error==2)];
bar(A.DataPlot1,errors(1,:),errors(2,:));
title(A.DataPlot1,'Errors');
ylabel(A.DataPlot1,'Count');
set(A.DataPlot1,'XLim',[-.75 errors(1,end)+.75]);

%% show the number - 2016-05-05 - Shaun L. Cloherty <s.cloherty@ieee.org> 
x = errors(1,:);
y = 0.15*max(ylim);

h = [];
for ii = 1:size(errors,2),
  axes(A.DataPlot1);
  h(ii) = text(x(ii),y,sprintf('%i',errors(2,ii)),'HorizontalAlignment','Center');
  if errors(2,ii) > 2*y,
    set(h(ii),'Color','w');
  end
end
%%

% Dataplot 2, wait time histogram
if any(D.error==0)
    hist(A.DataPlot2,D.fixDur(D.error==0));
end
% title(A.DataPlot2,'Successful Trials');
% show the numbers - 2016-05-06 - Shaun L. Cloherty <s.cloherty@ieee.org> 
title(A.DataPlot2,sprintf('%.2fs %.2fs',median(D.fixDur(D.error==0)),max(D.fixDur(D.error==0))));
ylabel(A.DataPlot2,'Count');
xlabel(A.DataPlot2,'Time');
