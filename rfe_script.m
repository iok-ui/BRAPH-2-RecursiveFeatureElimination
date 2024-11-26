%%
clc; clear
%%
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

%%
num_remaining_node = ba.get('BR_DICT').get('LENGTH');
condition_stop_rfe = 2;
num_elimination_node = 2;
reduced_ba = ba;
reduced_gr1 = gr1;
reduced_gr2 = gr2;
while num_remaining_node > condition_stop_rfe

    current_ba = reduced_ba;
    current_gr1 = reduced_gr1;
    current_gr2 = reduced_gr2;

    % Analysis FUN WU
    a_WU1 = AnalyzeEnsemble_FUN_WU( ...
        'GR', current_gr1 ...
        );

    a_WU2 = AnalyzeEnsemble_FUN_WU( ...
        'TEMPLATE', a_WU1, ...
        'GR', current_gr2 ...
        );

    a_WU1.memorize('G_DICT');
    a_WU2.memorize('G_DICT');

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
    nn = NNClassifierMLP('D', d_training, 'LAYERS', [20 20], 'EPOCHS', 100, 'VERBOSE', true);
    nn.get('TRAIN');

    % Evaluate the feature importance
    d_comb = NNDatasetCombine('D_LIST', {d1, d2}).get('D');
    fi = NNxMLP_FeatureImportanceAcrossFUN('BA', current_ba, 'AE_TEMPLATE', a_WU1, 'D', d_comb, 'NN', nn, 'GR_FUN_LIST', {current_gr1, current_gr2}, 'P', 1, 'APPLY_BONFERRONI', false, 'APPLY_CONFIDENCE_INTERVALS', false);
    fi_score = fi.get('FEATURE_IMPORTANCE');

    % Test GUI
    fi_br_pf = NNxMLP_FeatureImportanceBrainRegionPF('BA', current_ba, 'FI', fi_score);
    gui = GUIFig('PF', fi_br_pf, 'CLOSEREQ', false);
    gui.get('DRAW')
    gui.get('SHOW')
    fi_br_pf.get('ST_SURFACE').set('FACEALPHA', 0.05);
    fi_br_pf.set('SIZE_SCALE', 5);
    fi_br_pf.set('VIEW', BrainSurfacePF.VIEW_AD_AZEL)
    contenttype = 'auto'; resolution = 300; colorspace = 'rgb'; 
    braph2print(gui.get('PF').get('H'), ['node#' char(string(num_remaining_node)) '_FI.jpg'], 'ContentType', contenttype, 'Resolution', resolution, 'Colorspace', colorspace)

    gui.get('CLOSE')

    % remove node
    [~, node_rank] = sort(cell2mat(fi_score), 'descend');
    idx_node_removal = node_rank(end-num_elimination_node+1:end);
    
    reduced_br_list = current_ba.get('BR_DICT').get('IT_LIST');
    reduced_br_dict = IndexedDictionary('IT_CLASS', 'BrainRegion', 'IT_LIST', reduced_br_list);
    reduced_br_dict.get('REMOVE', idx_node_removal);
    reduced_ba = BrainAtlas('ID', current_ba.get('ID'), ...
        'BR_DICT', reduced_br_dict);

    num_remaining_node = reduced_ba.get('BR_DICT').get('LENGTH');lab

    current_gr1_list = current_gr1.get('SUB_DICT').get('IT_LIST');
    for i = 1:length(current_gr1_list)
        fun = current_gr1_list{i}.get('FUN'); % time_length x brain_regions
        fun(:, idx_node_removal) = [];
        reduced_gr1_list{i} = SubjectFUN('ID', current_gr1_list{i}.get('ID'), 'BA', reduced_ba, 'FUN', fun);
    end
    reduced_gr1_dict = IndexedDictionary('IT_CLASS', 'SubjectFUN', 'IT_LIST', reduced_gr1_list);
    reduced_gr1 = Group('ID', current_gr1.get('ID'), ...
        'SUB_DICT', reduced_gr1_dict);

    current_gr2_list = current_gr2.get('SUB_DICT').get('IT_LIST');
    for i = 1:length(current_gr2_list)
        fun = current_gr2_list{i}.get('FUN'); % time_length x brain_regions
        fun(:, idx_node_removal) = [];
        reduced_gr2_list{i} = SubjectFUN('ID', current_gr2_list{i}.get('ID'), 'BA', reduced_ba, 'FUN', fun);
    end
    reduced_gr2_dict = IndexedDictionary('IT_CLASS', 'SubjectFUN', 'IT_LIST', reduced_gr2_list);
    reduced_gr2 = Group('ID', current_gr2.get('ID'), ...
        'SUB_DICT', reduced_gr2_dict);

end