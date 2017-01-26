function varargout = monitorCenter(varargin)
% MONITORCENTER M-file for monitorCenter.fig
%      MONITORCENTER, by itself, creates a new MONITORCENTER or raises the existing
%      singleton*.
%
%      H = MONITORCENTER returns the handle to a new MONITORCENTER or the handle to
%      the existing singleton*.
%
%      MONITORCENTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONITORCENTER.M with the given input arguments.
%
%      MONITORCENTER('Property','Value',...) creates a new MONITORCENTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before monitorCenter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to monitorCenter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help monitorCenter

% Last Modified by GUIDE v2.5 06-Nov-2014 17:28:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @monitorCenter_OpeningFcn, ...
                   'gui_OutputFcn',  @monitorCenter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before monitorCenter is made visible.
function monitorCenter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to monitorCenter (see VARARGIN)

% Choose default command line output for monitorCenter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes monitorCenter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = monitorCenter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function X0_Callback(hObject, eventdata, handles)
% hObject    handle to X0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X0 as text
%        str2double(get(hObject,'String')) returns contents of X0 as a double


% --- Executes during object creation, after setting all properties.
function X0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X1_CreateFcn(hObject, eventdata, handles)
function X1_Callback(hObject, eventdata, handles)

function Y0_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y1_Callback(hObject, eventdata, handles)
% hObject    handle to Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y1 as text
%        str2double(get(hObject,'String')) returns contents of Y1 as a double


% --- Executes during object creation, after setting all properties.
function Y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Flip.
function Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x0 = str2double(get(handles.X0,'String'));
x1 = str2double(get(handles.X1,'String'));
y0 = str2double(get(handles.Y0,'String'));
y1 = str2double(get(handles.Y1,'String'));
Screen('DrawLine',handles.win,0,x0,y0,x1,y1);
Screen('Flip',handles.win);

% --- Executes on button press in Pursuit.
function Pursuit_Callback(hObject, eventdata, handles)
% hObject    handle to Pursuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenWin.
function OpenWin_Callback(hObject, eventdata, handles)
% hObject    handle to OpenWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.win = Screen('OpenWindow',2,128);
guidata(hObject, handles);

% --- Executes on button press in CloseWin.
function CloseWin_Callback(hObject, eventdata, handles)
% hObject    handle to CloseWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sca;
