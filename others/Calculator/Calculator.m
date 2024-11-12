function varargout = Calculator(varargin)
% CALCULATOR MATLAB code for Calculator.fig
%      CALCULATOR, by itself, creates a new CALCULATOR or raises the existing
%      singleton*.
%
%      H = CALCULATOR returns the handle to a new CALCULATOR or the handle to
%      the existing singleton*.
%
%      CALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATOR.M with the given input arguments.
%
%      CALCULATOR('Property','Value',...) creates a new CALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Calculator
% Last Modified by GUIDE v2.5 04-Nov-2024 14:58:36

%  Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @Calculator_OutputFcn, ...
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

% --- Executes just before Calculator is made visible.
function Calculator_OpeningFcn(hObject, ~, handles, varargin)
    handles.output = hObject; % Choose default command line output for Calculator
    guidata(hObject, handles); % Update handles structure
    set(handles.resultDisplayEdit, 'String', '0'); % Initialize resultDisplayEdit to 0
    % UIWAIT makes Calculator wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Calculator_OutputFcn(~, ~, handles) 
    varargout{1} = handles.output; % Get default command line output from handles structure

% --- Executes during object creation, after setting all properties.
function equationInputEdit_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function resultDisplayEdit_CreateFcn(hObject, ~, ~)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function equationInputEdit_Callback(~, ~, ~)

% --- callback's callback functions
function appendToEquationInput(handles, char)
    currentString = get(handles.equationInputEdit, 'String');
    if strcmp(char, 'pi')
        if isempty(currentString)
            set(handles.equationInputEdit, 'String', 'pi');
        else
            set(handles.equationInputEdit, 'String', [currentString '*(pi)']);
        end
    else
        set(handles.equationInputEdit, 'String', [currentString char]);
    end

function includesToEquationInput(handles, symbol)
    currentString = get(handles.equationInputEdit, 'String');
    if isempty(currentString)
        currentString = get(handles.resultDisplayEdit, 'String');
    end
    set(handles.equationInputEdit, 'String', [symbol '(' currentString ')']);

function calculateResult(handles)
    try
        equation = get(handles.equationInputEdit, 'String');
        result = eval(equation);
        if abs(result) < 1e14 && abs(result) >= 1
            resultStr = num2str(result, '%.15g');
        elseif abs(result) < 1 && abs(result) > 1e-14
            resultStr = num2str(result, '%.15f');
        elseif isnan(result) || abs(result) < 1e-14
            resultStr = '0';
        else
            resultStr = '99999999999999';

        end
        set(handles.resultDisplayEdit, 'String', resultStr);
    catch ME
        if strcmp(ME.identifier, 'MATLAB:divideByZero')
            set(handles.resultDisplayEdit, 'String', 'Error: Division by zero');
        elseif strcmp(ME.identifier, 'MATLAB:minrhs')
            set(handles.resultDisplayEdit, 'String', 'Error: Invalid input');
        else
            errorMessage = ME.message;
            set(handles.resultDisplayEdit, 'String', errorMessage);
        end
    end

% --- Executes on button press in num0-9But and dotBut.
function num0But_Callback(~, ~, handles)
    appendToEquationInput(handles, '0');
function num1But_Callback(~, ~, handles)
    appendToEquationInput(handles, '1');
function num2But_Callback(~, ~, handles)
    appendToEquationInput(handles, '2');
function num3But_Callback(~, ~, handles)
    appendToEquationInput(handles, '3');
function num4But_Callback(~, ~, handles)
    appendToEquationInput(handles, '4');
function num5But_Callback(~, ~, handles)
    appendToEquationInput(handles, '5');
function num6But_Callback(~, ~, handles)
    appendToEquationInput(handles, '6');
function num7But_Callback(~, ~, handles)
    appendToEquationInput(handles, '7');
function num8But_Callback(~, ~, handles)
    appendToEquationInput(handles, '8');
function num9But_Callback(~, ~, handles)
    appendToEquationInput(handles, '9');
function dotBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '.');

% --- Executes on button press in +-*/() Buts.
function plusBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '+');
function minusBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '-');
function multiplyBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '*');
function divisionBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '/');
function leftParenthesisBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '(');
function rightParenthesisBut_Callback(~, ~, handles)
    appendToEquationInput(handles, ')');


% --- Executes on button press in squareBut/cubicBut/exponentBut.
function squareBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '^2');
function cubicBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '^3');
function exponentBut_Callback(~, ~, handles)
    appendToEquationInput(handles, '^');

% --- Executes on button press in exp10But/log10But/lnBut.
function exp10But_Callback(~, ~, handles)
    includesToEquationInput(handles, '10^');
function log10But_Callback(~, ~, handles)
    includesToEquationInput(handles, 'log10');
function lnBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'log');

% --- Executes on button press in piBut.
function piBut_Callback(~, ~, handles)
    appendToEquationInput(handles, 'pi');

% --- Executes on button press in sineBut/cosineBut/tangentBut.
function sineBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'sin');
function cosineBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'cos');
function tangentBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'tan');

% --- Executes on button press in factorialBut/absBut/reciprocalBut_Callback.
function factorialBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'factorial');
function absBut_Callback(~, ~, handles)
    includesToEquationInput(handles, 'abs');
function reciprocalBut_Callback(~, ~, handles)
    includesToEquationInput(handles, '1/');

% --- Executes on button press in equalBut.
function equalBut_Callback(~, ~, handles)
    equation = get(handles.equationInputEdit, 'String');
    if isempty(equation)
        set(handles.resultDisplayEdit, 'String', 'Empty Input');
    else
        calculateResult(handles);
    end

% --- Executes on button press in allClearBut/clearBut/backspaceBut.
function allClearBut_Callback(~, ~, handles)
    set(handles.equationInputEdit, 'String', '');
    set(handles.resultDisplayEdit, 'String', '0');
function clearBut_Callback(~, ~, handles)
    set(handles.equationInputEdit, 'String', '');
function backspaceBut_Callback(~, ~, handles)
    currentString = get(handles.equationInputEdit, 'String');
    if ~isempty(currentString)
        set(handles.equationInputEdit, 'String', currentString(1:end-1));
    end
