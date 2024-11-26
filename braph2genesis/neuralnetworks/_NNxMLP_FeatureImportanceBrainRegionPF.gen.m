%% ¡header!
NNxMLP_FeatureImportanceBrainRegionPF < BrainAtlasPF (pf, panel figure for feature importance brain) is a plot of a feature importance brain.

%%% ¡description!
A panel figure for the neural networks feature importance on brain surface (NNxMLP_FeatureImportanceBrainRegionPF) manages the plot
 of the feature importance ploted over the brain.  
NNxMLP_FeatureImportanceBrainRegionPF utilizes the surface created from BrainAtlasPF to integrate 
 the feature importance values into the brain regions.

%%% ¡seealso!
NNxMLP_FeatureImportanceBrainSurface

%%% ¡build!
1

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the panel figure for the neural networks feature importance on brain surface.
%%%% ¡default!
'NNxMLP_FeatureImportanceBrainRegionPF'

%%% ¡prop!
NAME (constant, string) is the name of the panel figure for the neural networks feature importance on brain surface.
%%%% ¡default!
'Panel Figure for Neural Networks Feature Impoortance on Brain Surface'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the panel figure for neural networks feature importance on brain surface.
%%%% ¡default!
'A panel figure for neural networks feature importance on brain surface (NNxMLP_FeatureImportanceBrainRegionPF) manages the plot of the feature importance ploted over the brain. NNxMLP_FeatureImportanceBrainRegionPF utilizes the surface created from BrainAtlasPF to integrate the feature importance values into the brain regions.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the panel figure for neural networks feature importance on brain surface.
%%%% ¡settings!
'NNxMLP_FeatureImportanceBrainRegionPF'

%%% ¡prop!
ID (data, string) is a few-letter code for the panel figure for neural networks feature importance on brain surface.
%%%% ¡default!
'NNxMLP_FeatureImportanceBrainRegionPF ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the panel figure for neural networks feature importance on brain surface.
%%%% ¡default!
'NNxMLP_FeatureImportanceBrainRegionPF label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the panel figure for neural networks feature importance on brain surface.
%%%% ¡default!
'NNxMLP_FeatureImportanceBrainRegionPF notes'

%%% ¡prop!
DRAW (query, logical) draws the figure brain atlas.
%%%% ¡calculate!
value = calculateValue@BrainAtlasPF(pf, NNxMLP_FeatureImportanceBrainRegionPF.DRAW, varargin{:}); % also warning
if value    
    % trigger setup
    pf.get('SETUP');
end

%%% ¡prop!
DELETE (query, logical) resets the handles when the panel figure brain surface is deleted.
%%%% ¡calculate!
value = calculateValue@BrainAtlasPF(pf, NNxMLP_FeatureImportanceBrainRegionPF.DELETE, varargin{:}); % also warning
if value
    % do nothing
end

%% ¡props!

%%% ¡prop!
FI (metadata, cell) is the feature importance value.

%%% ¡prop!
SETUP (query, empty) calculates the measure value and stores it to be implemented in the subelements.
%%%% ¡calculate!
% get brain region related list
sph_list = pf.get('SPH_DICT').get('IT_LIST');
sym_list = pf.get('SYM_DICT').get('IT_LIST');
id_list = pf.get('ID_DICT').get('IT_LIST');
lab_list = pf.get('LAB_DICT').get('IT_LIST');

fi = pf.get('FI');
fi = cell2mat(fi);
if isempty(fi)
    value = {};
    return
end

% apply mask to mask out those nodes with value of 0
mask = zeros(size(fi));
mask(fi ~= 0) = 1;
mask = logical(mask);
for i = 1:1:length(sph_list)
    set(sph_list{i}, 'VISIBLE', mask(i));
end
for i = 1:1:length(sym_list)
    set(sym_list{i}, 'VISIBLE', mask(i));
end
for i = 1:1:length(id_list)
    set(id_list{i}, 'VISIBLE', mask(i));
end
for i = 1:1:length(lab_list)
    set(lab_list{i}, 'VISIBLE', mask(i));
end

size_diff = pf.get('SIZE_DIFF');
switch size_diff
    case 'on'
        % transfrom diff value to appropriate size
        % value ranching from 0.01 to 1
        fi(isnan(fi)) = 0.1;
        fi(isinf(fi)) = 0.1;
        size_value = abs(fi);
        min_bound = 0.01;
        max_bound = 1.0;
        min_size_value = min(size_value);
        if min_size_value == 0 % change the min value to the second min as 0 indicates masked out
            min_size_value = min(size_value(size_value > 0));
            size_value(size_value == 0) = min_size_value;
        end
        max_size_value = max(size_value);
        if max_size_value == min_size_value
            normalized_size_value = ones(size(size_value)) * max_bound;
        else
            normalized_size_value = min_bound + (max_bound - min_bound) * (size_value - min_size_value) / (max_size_value - min_size_value);
        end
        size_scale = pf.get('SIZE_SCALE');
        scaled_size_value = normalized_size_value * size_scale;

        % set size to sphs
        for i = 1:1:length(sph_list)
            set(sph_list{i}, 'SPHERESIZE', scaled_size_value(i));
        end
    case 'off'
        if pf.get('SPHS')
            for i = 1:1:length(sph_list)
                set(sph_list{i}, 'SPHERESIZE', SettingsSphere.getPropDefault('SPHERESIZE'));
            end
        end
    case 'disable'
end

color_diff = pf.get('COLOR_DIFF');
switch color_diff
    case 'on'
        % transfrom m value to appropriate color
        % RGB code ranching from 0 to 1
        fi(isnan(fi)) = 0;
        size_value = abs(fi);
        min_bound = 0.0;
        max_bound = 1.0;
        min_size_value = min(size_value);
        if min_size_value == 0 % change the min value to the second min as 0 indicates masked out
            min_size_value = min(size_value(size_value > 0));
            size_value(size_value == 0) = min_size_value;
        end
        max_size_value = max(size_value);
        if max_size_value == min_size_value
            normalized_size_value = ones(size(size_value)) * max_bound;
        else
            normalized_size_value = min_bound + (max_bound - min_bound) * (size_value - min_size_value) / (max_size_value - min_size_value);
        end

        % Map the normalized values to colors in the Jet colormap
        cmap = jet(256);
        color_indices = ceil(normalized_size_value * (size(cmap, 1) - 1)) + 1;

        % Clip color_indices to valid range
        color_indices = max(1, min(color_indices, size(cmap, 1)));

        % Get the RGB colors for the indices
        rgb_colors = cmap(color_indices, :);

        % set color to sphs
        for i = 1:1:length(sph_list)
            set(sph_list{i}, 'FACECOLOR', rgb_colors(i, :));
        end
    case 'off'
        if pf.get('SPHS')
            for i = 1:1:length(sph_list)
                set(sph_list{i}, 'FACECOLOR', SettingsSphere.getPropDefault('FACECOLOR'));
            end
        end
    case 'disable'
end

value = {};

%%% ¡prop!
SIZE_DIFF (figure, option) determines whether the difference is shown with size effect.
%%%% ¡settings!
{'on' 'off' 'disable'}
%%%% ¡default!
'on'
%%%% ¡postset!
pf.get('SETUP');

%%% ¡prop!
SIZE_SCALE (figure, scalar) determines the scale of size effect.
%%%% ¡default!
10
%%%% ¡postset!
pf.get('SETUP');

%%% ¡prop!
COLOR_DIFF (figure, option) determines whether the difference is shown with color effect.
%%%% ¡settings!
{'on' 'off' 'disable'}
%%%% ¡default!
'on'
%%%% ¡postset!
pf.get('SETUP');

%% ¡tests!

%%% ¡excluded_props!
[NNxMLP_FeatureImportanceBrainRegionPF.PARENT NNxMLP_FeatureImportanceBrainRegionPF.H NNxMLP_FeatureImportanceBrainRegionPF.ST_POSITION NNxMLP_FeatureImportanceBrainRegionPF.ST_AXIS NNxMLP_FeatureImportanceBrainRegionPF.ST_SURFACE NNxMLP_FeatureImportanceBrainRegionPF.ST_AMBIENT NNxMLP_FeatureImportanceBrainRegionPF.FI NNxMLP_FeatureImportanceBrainRegionPF.D]

%%% ¡warning_off!
true

%%% ¡test!
%%%% ¡name!
Remove Figures
%%%% ¡code!
warning('off', [BRAPH2.STR ':NNxMLP_FeatureImportanceBrainRegionPF'])
assert(length(findall(0, 'type', 'figure')) == 5)
delete(findall(0, 'type', 'figure'))
warning('on', [BRAPH2.STR ':NNxMLP_FeatureImportanceBrainRegionPF'])
