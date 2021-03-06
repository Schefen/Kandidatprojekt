% Hj�lpfunktion f�r egendefinierade menyfunktioner baserade p� MATLABs egna
% menyfunktioner.

function figure_size = getnicedialoglocation(figure_size, figure_units)
% adjust the specified figure position to fig nicely over GCBF
% or into the upper 3rd of the screen

%  Copyright 1999-2011 The MathWorks, Inc.

%%%%%% PLEASE NOTE %%%%%%%%%
%%%%%% This file has also been copied into:
%%%%%% matlab/toolbox/ident/idguis
%%%%%% If this functionality is changed, please
%%%%%% change it also in idguis.
%%%%%% PLEASE NOTE %%%%%%%%%

parentHandle = gcbf;
convertData.destinationUnits = figure_units;
convertData.reference = 0;
if ~isempty(parentHandle)
    % If there is a parent figure
    convertData.hFig = parentHandle;
    convertData.size = get(parentHandle,'Position');
    convertData.sourceUnits = get(parentHandle,'Units');  
    c = []; 
else
    % If there is no parent figure, use the root's data
    % and create a invisible figure as parent
    convertData.hFig = figure('visible','off');
    convertData.size = get(0,'ScreenSize');
    convertData.sourceUnits = get(0,'Units');
    c = onCleanup(@() close(convertData.hFig));
end

% Get the size of the dialog parent in the dialog units
container_size = hgconvertunits(convertData.hFig, convertData.size ,...
    convertData.sourceUnits, convertData.destinationUnits, convertData.reference);

delete(c);

figure_size(1) = container_size(1)  + 1/2*(container_size(3) - figure_size(3));
figure_size(2) = container_size(2)  + 2/3*(container_size(4) - figure_size(4));
end