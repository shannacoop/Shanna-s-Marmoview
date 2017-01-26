function faceCalPlot(handles,eyeData,P)

% function FaceCalPlot(handles,eyeData,P)
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
faceConfig = handles.S.faceConfigs{P.faceConfig};
eyeRad = get(h,'UserData');

ind = eyeData(:,5) == 0;
% x = (eyeData(ind,2)-c(1)) / (dx*ppd);
% y = (eyeData(ind,3)-c(2)) / (dy*ppd);
% convert "gaze space" to deg. visual angle... relative to the
% centre of the screen
x = (eyeData(ind,2) - c(1))/dx;
y = (eyeData(ind,3) - c(2))/dy;
y = -1*y;

plot(h,0,0,'+k','LineWidth',2);
set(h,'NextPlot','Add');
axis(h,[-eyeRad eyeRad -eyeRad eyeRad]);
plot(h,[-eyeRad eyeRad],[0 0],'--','Color',[.5 .5 .5]);
plot(h,[0 0],[-eyeRad eyeRad],'--','Color',[.5 .5 .5]);
for i = 1:size(faceConfig,1)
    xF = faceConfig(i,1);
    yF = faceConfig(i,2);
    rF = handles.P.faceRadius;
    plot(h,[xF-rF xF+rF xF+rF xF-rF xF-rF],[yF-rF yF-rF yF+rF yF+rF yF-rF],'-k');
end
plot(h,x,y,'.b');

set(h,'NextPlot','Replace');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THESE FINAL LINES SHOULD BE INCLUDED IN EVERY PROTOCOL PLOT FUNCTION TO
% MAINTAIN THE BUTTONDOWN FUNCTION TO ZOOM ON LEFT CLICK, OUT ON RIGHT
% This ensures the ButtonDownFcn is not erased with the new plots
set(h,'ButtonDownFcn',@(hObject,eventdata)MarmoView('EyeTrace_ButtonDownFcn',hObject,eventdata,handles));
% Same for the eye radius
set(h,'UserData',eyeRad);