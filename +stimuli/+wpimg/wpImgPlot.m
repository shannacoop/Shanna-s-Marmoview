function wpImgPlot(handles,eyeData,P),
% WPIMGPLOT plot eye position from a trial of MarmoView's wallpaper image task.

% 26-06-2016 - Shaun L. Cloherty <s.cloherty@ieee.org>

% FIXME: marmoview needs (at minimum) a class system for tasks and stimuli!

% states are as follows:
%
% 0 - the whooe trial

ah = handles.EyeTrace;

dx = handles.A.dx;
dy = handles.A.dy;
c = handles.A.c;

eyeRad = get(ah,'UserData'); % so the user can zoom the eye position axes...

% convert eye position from "gaze space" to deg. of visual
% angle... relative to the centre of the screen
xDeg = (eyeData(:,2) - c(1))./dx;
yDeg = (eyeData(:,3) - c(2))./dy;
yDeg = -1*yDeg;

axes(ah); cla(ah); hold on;

h = plot(xDeg,yDeg,'bo','MarkerSize',2);

axis(ah,[-eyeRad eyeRad -eyeRad eyeRad]);
 
plot(ah,eyeRad*[-1,1],[0,0],'--','Color',0.5*ones([1,3]));
plot(ah,[0 0],eyeRad*[-1,1],'--','Color',0.5*ones([1,3]));

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THESE FINAL LINES SHOULD BE INCLUDED IN EVERY PROTOCOL PLOT FUNCTION TO
% MAINTAIN THE BUTTONDOWN FUNCTION TO ZOOM ON LEFT CLICK, OUT ON RIGHT
% This ensures the ButtonDownFcn is not erased with the new plots
%
% SC: are you kidding me?!
set(ah,'ButtonDownFcn',@(hObject,eventdata)MarmoView('EyeTrace_ButtonDownFcn',hObject,eventdata,handles));
% Same for the eye radius
set(ah,'UserData',eyeRad);
