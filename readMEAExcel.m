function varargout = readMEAExcel(varargin)
% READMEAEXCEL MATLAB code for readMEAExcel.fig
%      READMEAEXCEL, by itself, creates a new READMEAEXCEL or raises the existing
%      singleton*.
%
%      H = READMEAEXCEL returns the handle to a new READMEAEXCEL or the handle to
%      the existing singleton*.
%
%      READMEAEXCEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in READMEAEXCEL.M with the given input arguments.
%
%      READMEAEXCEL('Property','Value',...) creates a new READMEAEXCEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before readMEAExcel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to readMEAExcel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help readMEAExcel

% Last Modified by GUIDE v2.5 02-Feb-2018 09:06:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @readMEAExcel_OpeningFcn, ...
                   'gui_OutputFcn',  @readMEAExcel_OutputFcn, ...
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


% --- Executes just before readMEAExcel is made visible.
function readMEAExcel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to readMEAExcel (see VARARGIN)

% Choose default command line output for readMEAExcel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes readMEAExcel wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% import excel data
xlsFilePath = varargin{1};
[~,txt,raw] = xlsread(xlsFilePath,'MEAdata_code');
handles.figure1.UserData.xlsData.txt = txt;
handles.figure1.UserData.xlsData.raw = raw;
[filePath,fileName] = fileparts(xlsFilePath);
handles.figure1.UserData.xlsData.filePath = filePath;
handles.figure1.UserData.xlsData.fileName = fileName;

% initialize the litter info
litters = unique(txt(2:end,1));
set(handles.listbox1,'string',litters)

% initialize the litter info
litters = unique(txt(2:end,1));
set(handles.listbox1,'string',litters)

% label handles
set(handles.text2,'string','Litter/Culture');
set(handles.text3,'string','Condition');
set(handles.pushbutton1,'string','Push to import data');



% --- Outputs from this function are returned to the command line.
function varargout = readMEAExcel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
% keyboard
Litter_i = get(hObject,'value');
Litter_selected = handles.listbox1.String{Litter_i};
txt = handles.figure1.UserData.xlsData.txt;

[len,~] = size(txt);
j = 1;
for i = 1:len
    txt_temp = txt{i,1};
    cond_tf(i,1) = strcmpi(txt_temp,Litter_selected);
    if cond_tf(i,1)
        cond_c{j} = txt{i,3};
        fileName_c{j} = txt{i,2};
        j = j+1;
    end
end

set(handles.listbox2,'string',cond_c);
handles.listbox2.UserData = fileName_c;
handles.figure1.UserData.curr_litter = Litter_selected;




% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

cond = get(hObject,'value');
cond_selected = handles.listbox2.String{cond};
fileName_selected = handles.listbox2.UserData{cond};
handles.figure1.UserData.curr_cond = cond_selected;
handles.figure1.UserData.curr_fileName = fileName_selected;


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filePath = handles.figure1.UserData.xlsData.filePath;
curr_litter = handles.figure1.UserData.curr_litter;
curr_fileName = handles.figure1.UserData.curr_fileName;

burstFilePath = fullfile(filePath,curr_litter,curr_fileName,'BurstStruct.mat');
load(burstFilePath);
assignin('base','burstStruct',burstStruct);
