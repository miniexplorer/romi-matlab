clear all; close all;
global Rob ME
% Define parametros do Robot
Rob.nome='Romi';
Rob.R_wheel=7.0;
Rob.baseline=14.04;

% Set Pose Inicial do Robot 
Rob.pose.X=0;
Rob.pose.Y=0;
Rob.pose.Theta=0;

%Set velocidades Iniciais do Robot
Rob.V=0;
Rob.W=0;

% Controlo de update de velocidades
Rob.update=true;


% COM para comunicação
COM='COM14';

Quit=false;

begin_communication(COM);
move_fig();

Init_Robot()

while 1
    if Rob.update
     str=sprintf('V=%d , W=%d',Rob.V,Rob.W)
     send_to_robot(str);
     Rob.update=false;
    end
    
    Data=ME.odometry_dataset.dataset(ME.odometry_dataset.index-1,:);
    Rob.pose.X=Data(5);
    Rob.pose.Y=Data(6);
    Rob.pose.Theta=Data(7);
    sprintf('X=%f, Y=%f, Theta=%f \n',Rob.pose.X,Rob.pose.Y,Rob.pose.Theta);
    
    if Quit
        end_communication;
        break;
    end
    
    pause(0.05);
end


function []=Init_Rob()
global Rob; 
str=sprintf('R=%f D=%f - X=%f Y=%f Teta=%f \n',Rob.R_wheel,Rob.baseline,Rob.pose.X,Rob.pose.Y,Rob.pose.Theta);
send_to_robot(str);
end

function [S] = move_fig()
% move figure with arrow keys.
S.fh = figure('units','pixels',...
              'position',[500 500 200 260],...
              'menubar','none',...
              'name','move_fig',...
              'numbertitle','off',...
              'resize','off',...
              'keypressfcn',@fh_kpfcn,...
              'CloseRequestFcn',@f_closecq);
S.tx = uicontrol('style','text',...
                 'units','pixels',...
                 'position',[60 120 80 20],...
                 'fontweight','bold'); 
guidata(S.fh,S); 
end

function [] = fh_kpfcn(H,E)  
global Rob
% Figure keypressfcn
S = guidata(H);
set(S.tx,'string',E.Key)
switch E.Key
    case 'rightarrow'
        Rob.W=Rob.W+1;
    case 'leftarrow'
        Rob.W=Rob.W-1;
    case 'uparrow'
        Rob.V=Rob.V+1;
    case 'downarrow'
        Rob.V=Rob.V-1;
    otherwise  
end
Rob.update=true;
end

function f_closecq(src,callbackdata)
selection = questdlg('Close This Figure?','Close Request Function','Yes','No','Yes'); 
switch selection
          case 'Yes'
             S.fh.WindowSyle='normal'
             assignin('base','Quit',1);
             delete(gcf)
          case 'No'
          return 
end
end

