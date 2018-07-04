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

% Last Modified by GUIDE v2.5 12-Apr-2017 09:58:17

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
set(handles.output, 'UserData', data);
max_ch = max(data.snips.eNe1.chan);
sortCodes = unique(data.snips.eNe1.sortcode);

% get sortcode details
scList{1,1} = 'None';
for i = 1:length(sortCodes)
    si = data.snips.eNe1.sortcode == sortCodes(i);
    scList{i+1,1} = ['Sort code ' num2str(sortCodes(i)) ' (' num2str(sum(si)) ' instances)'];
end

% set handle sizes
set(handles.figure1,'position',[18,14,150,40])
set(handles.listbox2,'position',[33 26 25 10])
set(handles.pushbutton1,'position',[33,12,25,4])
set(handles.text4,'position',[33 22 25 2])
set(handles.axes1,'position',[70,5,75,32])

% set listbox variables
set(handles.listbox1,'string',{'None'; num2str([1:max_ch]')});
set(handles.listbox1,'max',max_ch);
set(handles.listbox2,'string',scList);
set(handles.listbox2,'max',length(sortCodes));

% set textedit field default
set(handles.edit1,'String',1);
set(handles.edit2,'String','Dynamic');

% set static textbox strings
set(handles.text2,'string','Select Channels to remove');
set(handles.text3,'string','Select SortCodes to remove');
set(handles.text4,'string','Type in bin sinze (s)');
set(handles.pushbutton1,'string','Plot','fontsize',20)
set(handles.pushbutton2,'string','Save figure','fontsize',15)
set(handles.pushbutton3,'string','Save excel file','fontsize',15)
set(handles.checkbox1,'string','Manual Y Limit','fontsize',15)

% Update handles structure
guidata(hObject, handles);
% uiwait(handles.figure1);

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
% ch_selected = handles.output.UserData{1};
% sc_selected = handles.output.UserData{2};


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


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



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
ch_i_selected = get(handles.listbox1,'Value');
sc_i_selected = get(handles.listbox2,'Value');

% get sort code list
sortCodeList = get(handles.listbox2,'String');
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

% set(handles.output, 'UserData', {ch_selected, sc_selected});
% varargout{1,1} = ch_selected;
% varargout{2,1} = sc_selected;

%% Plotting function

% HARD CODE %
spikerate_min = 0;
spikerate_max = 1000;

data = handles.output.UserData;
max_ts = max(data.snips.eNe1.ts);
max_ch = max(data.snips.eNe1.chan);
binsize_s = str2num(get(handles.edit1,'String'));

% Sum the number of spikes for 1 sec bin per channel
nSpikes = zeros(max_ch,ceil(max_ts/binsize_s));
for ch_i = 1:max_ch
    
    % skip the channel if selected to be removed
    ch_skip = sum(ch_i == ch_selected);
    if ~ch_skip
        ind = find(data.snips.eNe1.chan == ch_i);
%         singleCh = data.snips.eNe1.ts(ind);
        
        % skip the sortCode if selected to be removed
        sortCodes = unique(data.snips.eNe1.sortcode);
        
        for j = 1:length(sc_selected)
            sortCodes(sortCodes == sc_selected(j)) = [];
        end
        sc_i = [];
        for sc = 1:length(sortCodes)
            sc_i_temp = find(data.snips.eNe1.sortcode == sortCodes(sc) & data.snips.eNe1.chan == ch_i);
            sc_i = [sc_i; sc_i_temp];
        end
        singleCh = data.snips.eNe1.ts(sc_i);
        
        roundSC = ceil(singleCh/binsize_s);
        % nSpikes(i,roundSC) = 1;

        for j = 1:length(roundSC)
            t_i = roundSC(j);
            nSpikes(ch_i,t_i) = nSpikes(ch_i,t_i)+1;
        end
    end
    
    clear singleCh sc_i
    
end
% sum the channel together to get total spike rate
nSpikes_all = sum(nSpikes);

% get rid of spike rate data outside of above defined values
Min = nSpikes_all < spikerate_min;
Max = nSpikes_all > spikerate_max;
nSpikes_all_range = nSpikes_all;
nSpikes_all_range(Min) = 0;
nSpikes_all_range(Max) = 0;

% plot
plot(nSpikes_all_range);

% check to set the ylim - dynamic/manual
if get(handles.checkbox1,'Value')
    UIylim_str = get(handles.edit2,'String');
    set(handles.axes1,'ylim',[0 str2num(UIylim_str)]);
end

set(handles.axes1,'xlim',[0 ceil(max_ts/binsize_s)]);
ylabel('Spike Rate')
xlabel(['Time (binSize = ' num2str(binsize_s) 's)'])
uiresume(handles.figure1);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton1_Callback(hObject, eventdata, handles)

fileName = inputdlg('Please enter file name','s');
if ~isempty(fileName)
    print(handles.figure1,fileName{1},'-dpng');
    savefig(handles.figure1,fileName{1});
else
    display('No figure was recorded')
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles)

% figH = handles.figure1;
% axesH = get(handle,'Children');
dataH = get(handles.axes1,'Children'); % 12th handle in axes children was the data file, other was UIcontrol.
xData = get(dataH,'Xdata');
yData = get(dataH,'Ydata');

fileName = inputdlg('Please enter file name','s');
if ~isempty(fileName)
    xlswrite(fileName{1},[xData' yData']);
else
    display('No figure was recorded')
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

if get(hObject,'Value')
    set(handles.edit2,'enable', 'on')
else
    set(handles.edit2,'enable', 'off')
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
