%% ¡header!
NNxMLP_FeatureImportanceAcrossFUN < NNxMLP_FeatureImportance (nnfiam, neural network feature importace for multi-layer perceptron) provides feature importance analysis for multi-layer perceptron (MLP) across all functional time series.

%%% ¡description!
Neural Network Feature Importance Across Functional Data (NNxMLP_FeatureImportanceAcrossFUN) 
 assesses the importance of brain regions by measuring the increase in model error 
 when its corresponding functional time series values are randomly shuffled.

%%% ¡seealso!
NNDataPoint_FUN_CLA, NNDataPoint_FUN_REG, NNxMLP_FeatureImportanceAcrossMeasures

%%% ¡build!
1

%% ¡layout!

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.ID
%%%% ¡title!
Feature Importance MLP ID

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.LABEL
%%%% ¡title!
Feature Importance MLP LABEL

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.VERBOSE
%%%% ¡title!
VERBOSE ON/OFF

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.D
%%%% ¡title!
Neural Networks Dataset

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.NN
%%%% ¡title!
Neural Networks

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.P
%%%% ¡title!
Permutation Number

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.APPLY_BONFERRONI
%%%% ¡title!
Bonferroni Correction ON/OFF

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.APPLY_CONFIDENCE_INTERVALS
%%%% ¡title!
Confidence Intervals ON/OFF

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.SIG_LEVEL
%%%% ¡title!
Significant level

%%% ¡prop!
%%%% ¡id!
NNxMLP_FeatureImportanceAcrossFUN.FEATURE_IMPORTANCE
%%%% ¡title!
Feature Importance Score

%% ¡props_update!

%%% ¡prop!
ELCLASS (constant, string) is the class of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'NNxMLP_FeatureImportanceAcrossFUN'

%%% ¡prop!
NAME (constant, string) is the name of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'Feature Importace for Multi-layer Perceptron Across Functional Time Series'

%%% ¡prop!
DESCRIPTION (constant, string) is the description of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'Neural Network Feature Importance Across Functional Data (NNxMLP_FeatureImportanceAcrossFUN) assesses the importance of brain regions by measuring the increase in model error when its corresponding functional time series values are randomly shuffled.'

%%% ¡prop!
TEMPLATE (parameter, item) is the template of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡settings!
'NNxMLP_FeatureImportanceAcrossFUN'

%%% ¡prop!
ID (data, string) is a few-letter code of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'NNxMLP_FeatureImportanceAcrossFUN ID'

%%% ¡prop!
LABEL (metadata, string) is an extended label of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'NNxMLP_FeatureImportanceAcrossFUN label'

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
%%%% ¡default!
'NNxMLP_FeatureImportanceAcrossFUN notes'

%%% ¡prop!
COMP_FEATURE_INDICES (result, cell) provides the indices of brain regions, represented as a cell array containing sets of feature indices, such as {[1], [2], [3], ...}.
%%%% ¡calculate!

% yuxin 
% Instruction: the value of this one should be the brain node index, such as {[1], [2],
% [3], ...} for the momemnt.
ba = nnfiam.get('BA');
num_brain_region = ba.get('BR_DICT').get('LENGTH');
value = num2cell(1:num_brain_region);

%%% ¡prop!
D_SHUFFLED (query, item) generates a shuffled version of the dataset where the time series of one brain region is replaced with random values drawn from a distribution with the same mean and standard deviation as the orginal ones.
%%%% ¡settings!
'NNDataset'
%%%% ¡calculate!

% yuxin
% Instruction: D_SHUFFLED will consist of NNDataPointMLP_Shuffled 
% with inputs being adjacency matrices derived from correlations
% between the time series of nodes, with one of the node time series shuffled.
if isempty(varargin)
    value = NNDataset();
    return
end
comp_feature_combination = varargin{1}; % the composite indexes

gr_fun_list = nnfiam.get('GR_FUN_LIST');

% combine all grs to single gr
comb_sub_list = {};
for i = 1:length(gr_fun_list)
    current_gr = gr_fun_list{i};
    sub_list = current_gr.get('SUB_DICT').get('IT_LIST');
    comb_sub_list = [comb_sub_list sub_list];
end

% shuffle the time series
for i = 1:length(comb_sub_list)
    current_subj = comb_sub_list{i};
    fun = current_subj.get('FUN'); % time_length x brain_regions
    for j = 1:length(comp_feature_combination)
        br_idx = comp_feature_combination(j);
        permuted_value = squeeze(normrnd(mean(fun(:, br_idx)), std(fun(:, br_idx)), squeeze(size(fun(:, br_idx)))));
        fun(:, br_idx) = permuted_value;
    end
    permuted_sub_list{i} = SubjectFUN('ID', current_subj.get('ID'), ...
        'BA', current_subj.get('BA'), ...
        'FUN', fun);
end

permuted_sub_dict = IndexedDictionary(...
    'IT_CLASS', 'SubjectFUN', ...
    'IT_LIST', permuted_sub_list ...
    );

permuted_gr = Group('SUB_DICT', permuted_sub_dict);

% get analyzeEnsemble
ae_template = nnfiam.get('AE_TEMPLATE');
ae = eval([ae_template.getClass() '(''TEMPLATE'', ae_template);']);
ae.set('GR', permuted_gr);
ae.memorize('G_DICT')

shuffled_dp_list = cellfun(@(x) NNDataPointMLP_Shuffled( ...
    'ID', x.get('ID'), ...
    'SHUFFLED_INPUT', {transpose(nnfiam.get('FLATTEN_CELL', x.get('A')))}), ...
    ae.get('G_DICT').get('IT_LIST'), ...
    'UniformOutput', false);

shuffled_dp_dict = IndexedDictionary(...
    'IT_CLASS', 'NNDataPointMLP_Shuffled', ...
    'IT_LIST', shuffled_dp_list ...
    );

value = NNDataset( ...
    'DP_CLASS', 'NNDataPointMLP_Shuffled', ...
    'DP_DICT', shuffled_dp_dict ...
    );

%% ¡props!

%%% ¡prop!
BA (parameter, item) is the brain atlas.
%%%% ¡settings!
'BrainAtlas'

%%% ¡prop!
GR_FUN_LIST (data, itemlist) is the list of FUN group, which also defines the subject class SubjectFUN.
%%%% ¡settings!
'Group'

%%% ¡prop!
AE_TEMPLATE (data, item) is the list of FUN group, which also defines the subject class SubjectFUN.
%%%% ¡settings!
'AnalyzeEnsemble'

%% ¡tests!

%%% ¡test!
%%%% ¡name!
GUI
%%%% ¡code!
gui = GUIElement('PE', fi, 'CLOSEREQ', false);
gui.get('DRAW')
gui.get('SHOW')

gui.get('CLOSE')

%%% ¡test!
%%%% ¡name!
Sanity check
%%%% ¡code!
create_data_NN_CLA_FUN_XLS() % only creates files if the example folder doesn't already exist

% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('NNDataPoint_FUN_CLA')) filesep 'Example data NN CLA FUN XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

% Load Groups of SubjectFUN
im_gr1 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('NNDataPoint_FUN_CLA')) filesep 'Example data NN CLA FUN XLS' filesep 'FUN_Group_1_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('NNDataPoint_FUN_CLA')) filesep 'Example data NN CLA FUN XLS' filesep 'FUN_Group_2_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2 = im_gr2.get('GR');

% Analysis FUN WU
a_WU1 = AnalyzeEnsemble_FUN_WU( ...
    'GR', gr1 ...
    );

a_WU2 = AnalyzeEnsemble_FUN_WU( ...
    'TEMPLATE', a_WU1, ...
    'GR', gr2 ...
    );

a_WU1.memorize('G_DICT');
a_WU2.memorize('G_DICT');

%% Create NNData composed of corresponding NNDataPoints
% create item lists of NNDataPoint_Graph_CLA
it_list1 = cellfun(@(x) NNDataPoint_Graph_CLA( ...
    'ID', x.get('ID'), ...
    'G', x, ...
    'TARGET_CLASS', {gr1.get('ID')}), ...
    a_WU1.get('G_DICT').get('IT_LIST'), ...
    'UniformOutput', false);

it_list2 = cellfun(@(x) NNDataPoint_Graph_CLA( ...
    'ID', x.get('ID'), ...
    'G', x, ...
    'TARGET_CLASS', {gr2.get('ID')}), ...
    a_WU2.get('G_DICT').get('IT_LIST'), ...
    'UniformOutput', false);

% create NNDataPoint_Graph_CLA DICT items
it_class = 'NNDataPoint_Graph_CLA';
dp_list1 = IndexedDictionary(...
        'IT_CLASS', it_class, ...
        'IT_LIST', it_list1 ...
        );

dp_list2 = IndexedDictionary(...
        'IT_CLASS', it_class, ...
        'IT_LIST', it_list2 ...
        );

% create a NNDataset containing the NNDataPoint_FUN_CLA DICT
d1 = NNDataset( ...
    'DP_CLASS', it_class, ...
    'DP_DICT', dp_list1 ...
    );

d2 = NNDataset( ...
    'DP_CLASS', it_class, ...
    'DP_DICT', dp_list2 ...
    );

% Split the NNData into training set and test set
d_split1 = NNDatasetSplit('D', d1, 'SPLIT', {0.7, 0.3});
d_split2 = NNDatasetSplit('D', d2, 'SPLIT', {0.7, 0.3});

d_training = NNDatasetCombine('D_LIST', {d_split1.get('D_LIST_IT', 1), d_split2.get('D_LIST_IT', 1)}).get('D');
d_test = NNDatasetCombine('D_LIST', {d_split1.get('D_LIST_IT', 2), d_split2.get('D_LIST_IT', 2)}).get('D');

% Train a NN
nn = NNClassifierMLP('D', d_training, 'LAYERS', [20 20]);
nn.get('TRAIN');

% Evaluate the feature importance
d_comb = NNDatasetCombine('D_LIST', {d1, d2}).get('D');
fi = NNxMLP_FeatureImportanceAcrossFUN('BA', ba, 'AE_TEMPLATE', a_WU1, 'D', d_comb, 'NN', nn, 'GR_FUN_LIST', {gr1, gr2}, 'P', 5, 'APPLY_BONFERRONI', true, 'APPLY_CONFIDENCE_INTERVALS', true);
fi_score = fi.get('FEATURE_IMPORTANCE');
num_br = ba.get('BR_DICT').get('LENGTH');

assert(isequal(length(cell2mat(fi_score)), num_br), ...
	        [BRAPH2.STR ':NNxMLP_FeatureImportanceAcrossFUN:' BRAPH2.FAIL_TEST], ...
	        'NNxMLP_FeatureImportanceAcrossFUN does not have the feature importance score array as intended.' ...
	        )

% Test GUI
gui = GUIElement('PE', fi, 'CLOSEREQ', false);
gui.get('DRAW')
gui.get('SHOW')

gui.get('CLOSE')