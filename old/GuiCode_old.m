function varargout = GuiCode(varargin)
% GUICODE MATLAB code for GuiCode.fig
%      GUICODE, by itself, creates a new GUICODE or raises the existing
%      singleton*.
%
%      H = GUICODE returns the handle to a new GUICODE or the handle to
%      the existing singleton*.
%
%      GUICODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUICODE.M with the given input arguments.
%
%      GUICODE('Property','Value',...) creates a new GUICODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiCode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiCode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiCode

% Last Modified by GUIDE v2.5 17-Feb-2017 14:08:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiCode_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiCode_OutputFcn, ...
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


% --- Executes just before GuiCode is made visible.
function GuiCode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiCode (see VARARGIN)

% Choose default command line output for GuiCode
handles.output = hObject;

data = varargin{1};
max_ch = max(data.snips.eNe1.chan);
sortCodes = unique(data.snips.eNe1.sortcode);

% get sortcode details
scList{1,1} = 'None';
for i = 1:length(sortCodes)
    si = data.snips.eNe1.sortcode == sortCodes(i);
    scList{i+1,1} = ['Sort code ' num2str(sortCodes(i)) ' (' num2str(sum(si)) ' instances)'];
end

% set handle sizes
set(handles.figure1,'position',[18,14,160,40])
set(handles.listbox3,'position',[33,15,25,21])
set(handles.pushbutton1,'position',[33,5,25,8])
set(handles.pushbutton1,'string','OK','fontsize',30)

% set listbox variables
set(handles.listbox2,'string',{'None'; num2str([1:max_ch]')});
set(handles.listbox2,'max',max_ch);
set(handles.listbox3,'string',scList);
set(handles.listbox3,'max',length(sortCodes));

% set static textbox strings
set(handles.text2,'string','Select Channels to remove');
set(handles.text3,'string','Select SortCodes to remove');


% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes GuiCode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function [ch_selected,sc_selected] = GuiCode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% varargout{1,1} = handles.output;
ch_selected = handles.output.UserData{1};
sc_selected = handles.output.UserData{2};


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


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
function hObject = pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get channel removal selection
ch_i_selected = get(handles.listbox2,'Value');
sc_i_selected = get(handles.listbox3,'Value');

% get sort code list
sortCodeList = get(handles.listbox3,'String');
for i = 2:length(sortCodeList)
    sortCode_sp = strsplit(sortCodeList{i,1},' ');
    sortCodes(i-1,1) = str2num(sortCode_sp{3});
end


% remove None selected
if ch_i_selected == 1 
    ch_selected = NaN;
else
    ch_selected = ch_i_selected - 1;
end

if sc_i_selected == 1 
    sc_selected = NaN;
else
    sc_selected = sortCodes(sc_i_selected-1)';
end

set(handles.output, 'UserData', {ch_selected, sc_selected});
varargout{1,1} = ch_selected;
varargout{2,1} = sc_selected;
uiresume(handles.figure1);
% close(handles.figure1);


