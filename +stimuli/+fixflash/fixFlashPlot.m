function fixFlashPlot(handles,eyeData,P)

% function fixFlashPlot(handles,eyeData,P)
%
% This function plots the eye trace from a trial in the EyeTracker
% window of MarmoView.
%
% handles is the MarmoView Gui handles structure
% i is the trial number to plot

h = handles.EyeTrace;
dx = handles.A.dx;
dy = handles.A.dy;
c = handles.A.c;
ppd = handles.S.pixPerDeg;
fixX = P.xDeg;
fixY = P.yDeg;
eyeRad = get(h,'UserData');
        
plot(h,0,0,'+k','LineWidth',2);
set(h,'NextPlot','Add');
axis(h,[-eyeRad eyeRad -eyeRad eyeRad]);
plot(h,[-30 30],[0 0],'--','Color',[.5 .5 .5]);
plot(h,[0 0],[-30 30],'--','Color',[.5 .5 .5]);

% Fixation window
r = P.fixWinRadius;
plot(h,fixX+r*cos(0:.01:1*2*pi),fixY+r*sin(0:.01:1*2*pi),'--k');

%
% Eye traces
%

% convert "gaze space" to deg. visual angle... relative to the
% centre of the screen
x = (eyeData(:,2)-c(1)) / dx;
y = (eyeData(:,3)-c(2)) / dy;
y = -1*y;

ind = eyeData(:,5) == 0; % State 0, prior to fixation
if ~isempty(ind)
%     x = (eyeData(ind,2)-c(1)) / (dx*ppd);
%     y = (eyeData(ind,3)-c(2)) / (dy*ppd);    
    
    H = plot(h,x(ind),y(ind),'ro');
    set(H,'Markersize',2);
end

ind = ismember(eyeData(:,5),[1 2]); % States 1 and 2 in fix window
if ~isempty(ind)
%     x = (eyeData(ind,2)-c(1)) / (dx*ppd);
%     y = (eyeData(ind,3)-c(2)) / (dy*ppd);
    
    H = plot(h,x(ind),y(ind),'bo');
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