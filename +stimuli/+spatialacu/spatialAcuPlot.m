function spatialAcuPlot(handles,eyeData,P)

% function spatialAcuPlot(handles,eyeData,P)
%
% This function plots the eye trace from a trial in the EyeTracker
% window of MarmoView.

h = handles.EyeTrace;
dx = handles.A.dx;
dy = handles.A.dy;
c = handles.A.c;
ppd = handles.S.pixPerDeg;
stimX = P.xDeg;
stimY = P.yDeg;
eyeRad = get(h,'UserData');
        
plot(h,0,0,'+k','LineWidth',2);
set(h,'NextPlot','Add');
axis(h,[-eyeRad eyeRad -eyeRad eyeRad]);
plot(h,[-eyeRad eyeRad],[0 0],'--','Color',[.5 .5 .5]);
plot(h,[0 0],[-eyeRad eyeRad],'--','Color',[.5 .5 .5]);

% Fixation window
r = P.fixWinRadius;
plot(h,r*cos(0:.01:1*2*pi),r*sin(0:.01:1*2*pi),'--k');

% Stimulus window
% r = P.stimWinRadius;
% plot(h,stimX+r*cos(0:.01:1*2*pi),stimY+r*sin(0:.01:1*2*pi),'--k');
minR = P.stimWinMinRad;
maxR = P.stimWinMaxRad;
errT = P.stimWinTheta;
stimT = atan2(stimY,stimX);

plot(h,[minR*cos(stimT+errT) maxR*cos(stimT+errT)],[minR*sin(stimT+errT) maxR*sin(stimT+errT)],'--k');
plot(h,[minR*cos(stimT-errT) maxR*cos(stimT-errT)],[minR*sin(stimT-errT) maxR*sin(stimT-errT)],'--k');
plot(h,minR*cos(stimT-errT:pi/100:stimT+errT),minR*sin(stimT-errT:pi/100:stimT+errT),'--k');
plot(h,maxR*cos(stimT-errT:pi/100:stimT+errT),maxR*sin(stimT-errT:pi/100:stimT+errT),'--k');
r = P.radius;
plot(h,stimX+r*cos(0:.01:1*2*pi),stimY+r*sin(0:.01:1*2*pi),'-k');


%
% Eye traces
%

% convert "gaze space" to deg. visual angle... relative to the
% centre of the screen
x = (eyeData(:,2)-c(1)) / dx;
y = (eyeData(:,3)-c(2)) / dy;
y = -1*y;

ind = ismember(eyeData(:,5),[1 2 3]); % States 1, 2, and 3 in fix window
if ~isempty(ind)
%     x = (eyeData(ind,2)-c(1)) / (dx*ppd);
%     y = (eyeData(ind,3)-c(2)) / (dy*ppd);

    H = plot(h,x(ind),y(ind),'bo');
    set(H,'Markersize',2);
end

ind = eyeData(:,5) == 4; % State 4, flight
if ~isempty(ind)
%     x = (eyeData(ind,2)-c(1)) / (dx*ppd);
%     y = (eyeData(ind,3)-c(2)) / (dy*ppd);
    
    H = plot(h,x(ind),y(ind),'go');
    set(H,'Markersize',2);
end

ind = eyeData(:,5) == 5; % State 5, holding stimulus
if ~isempty(ind)
%     x = (eyeData(ind,2)-c(1)) / (dx*ppd);
%     y = (eyeData(ind,3)-c(2)) / (dy*ppd);
    
    H = plot(h,x(ind),y(ind),'ro');
    set(H,'Markersize',2);
end

set(h,'NextPlot','Replace');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THESE FINAL LINES SHOULD BE INCLUDED IN EVERY PROTOCOL PLOT FUNCTION TO
% MAINTAIN THE BUTTONDOWN FUNCTION TO ZOOM ON LEFT CLICK, OUT ON RIGHT
% This ensures the ButtonDownFcn is not erased with the new plots
set(h,'ButtonDownFcn',@(hObject,eventdata)MarmoView('EyeTrace_ButtonDownFcn',hObject,eventdata,handles));
% Same for the eye radius
set(h,'UserData',eyeRad);