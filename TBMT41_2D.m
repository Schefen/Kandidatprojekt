% ----- DELSYSTEM 3 - GUI -----


function varargout = TBMT41_2D(varargin)
% TBMT41_2D MATLAB code for TBMT41_2D.fig
%      TBMT41_2D, by itself, creates a new TBMT41_2D or raises the existing
%      singleton*.
%
%      H = TBMT41_2D returns the handle to a new TBMT41_2D or the handle to
%      the existing singleton*.
%
%      TBMT41_2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TBMT41_2D.M with the given input arguments.
%
%      TBMT41_2D('Property','Value',...) creates a new TBMT41_2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TBMT41_2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TBMT41_2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TBMT41_2D

% Last Modified by GUIDE v2.5 25-Mar-2015 13:40:50

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TBMT41_2D_OpeningFcn, ...
    'gui_OutputFcn',  @TBMT41_2D_OutputFcn, ...
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

% --- Executes just before TBMT41_2D is made visible.
function TBMT41_2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TBMT41_2D (see VARARGIN)
% Choose default command line output for TBMT41_2D
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TBMT41_2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = TBMT41_2D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Knappen 'Ladda in bild'.
function laddaInBild_Callback(hObject, eventdata, handles)
global RescaledImage OriginalImage RegretImage EditImage;

[FileName, PathName] = uigetfile('*.dcm','browse');
cd(PathName);
info = dicominfo(FileName);

OriginalImage = dicomread(info);
RescaledImage = mat2gray(OriginalImage);
RegretImage = RescaledImage;
EditImage = RescaledImage;
imshow(EditImage, []);

% --- Knappen '�ndra kontrast'.
function andraKontrast_Callback(hObject, eventdata, handles)
imcontrast;

% --- Knappen 'J�mf�r med original'.
function jamforMedOriginal_Callback(hObject, eventdata, handles)
global RescaledImage EditImage

if (isempty(EditImage)|| isempty(RescaledImage))
warndlg('Ingen bild att j�mf�ra med.')

else   
set(figure, 'Position', [100, 100, 1049, 895]);
axes('Position',[0,0,0.5,1])
imshow(EditImage ,[] );
axes('Position',[0.5,0, 0.5, 1])
linkaxes();
imshow(RescaledImage, []);
end

% --- Knappen '�terg� till original'.
function atergaTillOriginal_Callback(hObject, eventdata, handles)
global RescaledImage RegretImage EditImage

if (isempty(RescaledImage))
    warndlg('Inget att �terg� till')
else
RegretImage = RescaledImage;
EditImage = RescaledImage;
imshow(RescaledImage, []);
end

% --- Knappen 'Utv�rdera'.
function utvardera_Callback(hObject, eventdata, handles)
global RescaledImage EditImage 

if (isequal(RescaledImage,EditImage) || isempty(EditImage))
   warndlg('Inget att utv�rdera');
else
    choice = menu('Utv�rdering','Peak Signal to Noise Ratio','Structural Similarity','Precision and Recall');
    if (choice == 1)
        PSNR = psnr(EditImage,RescaledImage);
        msgbox(['PSNR = ' num2str(PSNR)], 'Peak Signal to Noise Ratio')
    end

    if (choice == 2)
        SSIM = ssim(EditImage, RescaledImage);
        msgbox(['SSIM = ' num2str(SSIM)], 'Structural Similarity')
    end

    if (choice == 3)
        workmenu
        imshow(EditImage, []);
    end
end

% --- Knappen 'L�gg till brus'. 
function laggTillBrus_Callback(hObject, eventdata, handles)
global EditImage

EditImage = (Brushantering(EditImage, 'laggtillbrus'));
workmenu;
imshow (EditImage, []);

% --- Knappen 'Filtrera brus'. �ppnar val av filtrering och sedan filtrerar
% bilden.
function filtreraBrus_Callback(hObject, eventdata, handles)
global EditImage

EditImage = (Brushantering(EditImage, 'filtrerabrus'));
workmenu;
imshow(EditImage, []);


% --------------- F�rhandsgranskningsf�nster ---------------

function [] = workmenu()
f = figure('MenuBar','None');

% --- Knappen 'Acceptera'.
pp = uicontrol(f,'Style','Pushbutton','string',{'Acceptera'},...
    'pos',[0 250 100 20], ...
    'Callback', @acceptImage);

% --- Knappen 'Avbryt'.
pp2 = uicontrol(f,'Style','Pushbutton','string',{'Avbryt'},...
    'pos',[0 200 100 20], ...
    'Callback' , @denyImage);

% --- Funktion st�nger f�rhandsgranskningsf�nstret och beh�ller �ndringarna
% i f�rhandsgranskningen.
function acceptImage(src, callbackdata)
global EditImage RegretImage

RegretImage = EditImage;
delete(gcf);
imshow(EditImage, []);

% --- Funktion som st�nger f�rhandsgranskningsf�nstret och tar bort
% �ndringarna i f�rhandgranskningen.
function denyImage(src,callbackdata)
global EditImage RegretImage

selection = questdlg('�r du s�ker p� att du vill �ngra detta steg?',...
    'Close Request Function',...
    'Ja','Nej','Ja');
switch selection,
    case 'Ja',
        EditImage = RegretImage;
        delete(gcf);
    case 'Nej'
        return
end

% --- Knappen 'Spara'. Sparar bild till Matlabkatalogen.
function spara_Callback(hObject, eventdata, handles)
global EditImage RegretImage

if (isempty (EditImage))
    temp = RegretImage;
else
    temp = EditImage;
end

choice = menu('V�lj format som bilden ska sparas i', 'DICOM', 'JPEG');
if (choice == 1)
    FileName = uiputfile('*.dcm');
    dicomwrite(temp, FileName);
end
if (choice == 2)
    FileName = uiputfile('*.jpg');
    imwrite(temp, FileName);
end

% --- Knappen 'Granska'. �ppnar granskningsf�nster.
function granska_Callback(hObject, eventdata, handles)
global EditImage RescaledImage

if (isempty(RescaledImage))
    warndlg('Det finns ingen bild att granska') 
elseif (isempty(EditImage))
    figure('units','normalized','outerposition',[0 0 1 1])
    imshow(RescaledImage,'InitialMagnification','fit')
else
    figure('units','normalized','outerposition',[0 0 1 1])
    imshow(EditImage,'InitialMagnification','fit')
end

% --- Knappen 'Segmentera'. 
function segmentera_Callback(hObject, eventdata, handles)
global EditImage RegretImage

if (isempty(RegretImage))
     warndlg('Det finns ingen bild att segmentera')
else
choice = menu('V�lj segmenteringsmetod','Fuzzy Logic','Watershed');

%Fuzzy Logic
if (choice == 1)
    def = {'3'};
    stringAnswer = inputdlg('Ange antal kluster (vanligtvis mellan 2-5)', 'Parameterv�rde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    workmenu
    
    MF = SFCM2D(EditImage,answer);
    imgfcm=reshape(MF(1,:,:),size(EditImage,1),size(EditImage,2));
    sls = [];
    [EditImage, sls] = fuzzy2(EditImage,imgfcm,0.5);
    
    end
end

%Watershed
if (choice == 2)
    prompt = {'Ange parameter f�r strel:','Ta bort segment med f�rre pixlar �n:'};
    dlg_title = 'Ange parametrar f�r Watershed';
    num_lines = 1;
    def = {'4','10'};
    stringAnswer = inputdlg(prompt,dlg_title,num_lines,def);
    answer = str2double(stringAnswer);
    if(answer > 0)
    workmenu
    EditImages = WatershedJ(RegretImage,answer);
    end
    
    imshow(RegretImage, [])
    hold on
    himage = imshow(EditImages);
    himage.AlphaData = 0.2;
    title('Bilden segmenterad med Watershed')
    
    EditImage = imfuse(RegretImage,EditImages,'blend','Scaling','joint');
end
end


% --- Knappen 'Avsluta'. St�nger programmet.
function avsluta_Callback(hObject, eventdata, handles)

clearvars -global
close();

% --- Executes on button press in klippUtSegment.
%end

%EXEMPEL F�R ATT KUNNA CROPPA BILDER, L�T DET BA LIGGA H�R
%I = imcrop(EditImage);
%imshow(I, []);
