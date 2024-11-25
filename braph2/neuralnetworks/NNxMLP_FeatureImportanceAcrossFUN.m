classdef NNxMLP_FeatureImportanceAcrossFUN < NNxMLP_FeatureImportance
	%NNxMLP_FeatureImportanceAcrossFUN provides feature importance analysis for multi-layer perceptron (MLP) across all functional time series.
	% It is a subclass of <a href="matlab:help NNxMLP_FeatureImportance">NNxMLP_FeatureImportance</a>.
	%
	% Neural Network Feature Importance Across Functional Data (NNxMLP_FeatureImportanceAcrossFUN) 
	%  assesses the importance of brain regions by measuring the increase in model error 
	%  when its corresponding functional time series values are randomly shuffled.
	%
	% The list of NNxMLP_FeatureImportanceAcrossFUN properties is:
	%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
	%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
	%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the neural networks dataset for feature importance analysis.
	%  <strong>10</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network multi-layer perceptron classifier or regressor.
	%  <strong>11</strong> <strong>P</strong> 	P (parameter, scalar) is the permutation number that determines the statistical significance of the specific feature. 
	%  <strong>12</strong> <strong>PERM_SEEDS</strong> 	PERM_SEEDS (result, rvector) is the list of seeds for the random permutations.
	%  <strong>13</strong> <strong>APPLY_CONFIDENCE_INTERVALS</strong> 	APPLY_CONFIDENCE_INTERVALS (parameter, logical) determines whether to apply user-defined percent confidence interval.
	%  <strong>14</strong> <strong>SIG_LEVEL</strong> 	SIG_LEVEL (parameter, scalar) determines the significant level.
	%  <strong>15</strong> <strong>APPLY_BONFERRONI</strong> 	APPLY_BONFERRONI (parameter, logical) determines whether to apply Bonferroni correction.
	%  <strong>16</strong> <strong>BASELINE_INPUTS</strong> 	BASELINE_INPUTS (result, cell) retrieves the input data to be shuffled.
	%  <strong>17</strong> <strong>COMP_FEATURE_INDICES</strong> 	COMP_FEATURE_INDICES (result, cell) provides the indices of brain regions, represented as a cell array containing sets of feature indices, such as {[1], [2], [3], ...}.
	%  <strong>18</strong> <strong>D_SHUFFLED</strong> 	D_SHUFFLED (query, item) generates a shuffled version of the dataset where the time series of one brain region is replaced with random values drawn from a distribution with the same mean and standard deviation as the orginal ones.
	%  <strong>19</strong> <strong>BASELINE_LOSS</strong> 	BASELINE_LOSS (result, scalar) is the loss value obtained from original dataset, acting as a baseline loss value for evaluating the feature importance.
	%  <strong>20</strong> <strong>SHUFFLED_LOSS</strong> 	SHUFFLED_LOSS (query, rvector) is the loss value obtained from shuffled datasets.
	%  <strong>21</strong> <strong>PERM_SHUFFLED_LOSS</strong> 	PERM_SHUFFLED_LOSS (result, cell) is the permutation test for obtaining shuffled loss for a number of times in order to establish confidence interval.
	%  <strong>22</strong> <strong>CONFIDENCE_INTERVALS</strong> 	CONFIDENCE_INTERVALS (query, rvector) derives the 95 percent of confidence interval for the permuation of shuffled loss values.
	%  <strong>23</strong> <strong>STAT_SIG_MASK</strong> 	STAT_SIG_MASK (result, rvector) provides the statistical significance mask for composite features indicating which composite features has significant contribution.
	%  <strong>24</strong> <strong>FEATURE_IMPORTANCE</strong> 	FEATURE_IMPORTANCE (result, cell) is determined by applying Bonferroni correction for the permutation and obtaining the value by the average of the permutation number times of shuffled loss, which then in trun are divided by base loss for normalizaiton.
	%  <strong>25</strong> <strong>RESHAPED_FEATURE_IMPORTANCE</strong> 	RESHAPED_FEATURE_IMPORTANCE (query, empty) reshapes the cell of feature importances with the input data.
	%  <strong>26</strong> <strong>MAP_TO_CELL</strong> 	MAP_TO_CELL (query, empty) maps a single vector back to the original cell array structure.
	%  <strong>27</strong> <strong>COUNT_ELEMENTS</strong> 	COUNT_ELEMENTS (query, empty) counts the total number of elements within a nested cell array.
	%  <strong>28</strong> <strong>FLATTEN_CELL</strong> 	FLATTEN_CELL (query, empty) flattens a cell array into to a single vector.
	%  <strong>29</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display permutation progress information.
	%  <strong>30</strong> <strong>WAITBAR</strong> 	WAITBAR (gui, logical) determines whether to show the waitbar.
	%  <strong>31</strong> <strong>INTERRUPTIBLE</strong> 	INTERRUPTIBLE (gui, scalar) sets whether the permutation computation is interruptible for multitasking.
	%  <strong>32</strong> <strong>GR_FUN_LIST</strong> 	GR_FUN_LIST (data, item) is the list of FUN group, which also defines the subject class SubjectFUN.
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (constructor):
	%  NNxMLP_FeatureImportanceAcrossFUN - constructor
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods:
	%  set - sets values of a property
	%  check - checks the values of all properties
	%  getr - returns the raw value of a property
	%  get - returns the value of a property
	%  memorize - returns the value of a property and memorizes it
	%             (for RESULT, QUERY, and EVANESCENT properties)
	%  getPropSeed - returns the seed of a property
	%  isLocked - returns whether a property is locked
	%  lock - locks unreversibly a property
	%  isChecked - returns whether a property is checked
	%  checked - sets a property to checked
	%  unchecked - sets a property to NOT checked
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (display):
	%  tostring - string with information about the neural network feature importace for multi-layer perceptron
	%  disp - displays information about the neural network feature importace for multi-layer perceptron
	%  tree - displays the tree of the neural network feature importace for multi-layer perceptron
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (miscellanea):
	%  getNoValue - returns a pointer to a persistent instance of NoValue
	%               Use it as Element.getNoValue()
	%  getCallback - returns the callback to a property
	%  isequal - determines whether two neural network feature importace for multi-layer perceptron are equal (values, locked)
	%  getElementList - returns a list with all subelements
	%  copy - copies the neural network feature importace for multi-layer perceptron
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (save/load, Static):
	%  save - saves BRAPH2 neural network feature importace for multi-layer perceptron as b2 file
	%  load - loads a BRAPH2 neural network feature importace for multi-layer perceptron from a b2 file
	%
	% NNxMLP_FeatureImportanceAcrossFUN method (JSON encode):
	%  encodeJSON - returns a JSON string encoding the neural network feature importace for multi-layer perceptron
	%
	% NNxMLP_FeatureImportanceAcrossFUN method (JSON decode, Static):
	%   decodeJSON - returns a JSON string encoding the neural network feature importace for multi-layer perceptron
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (inspection, Static):
	%  getClass - returns the class of the neural network feature importace for multi-layer perceptron
	%  getSubclasses - returns all subclasses of NNxMLP_FeatureImportanceAcrossFUN
	%  getProps - returns the property list of the neural network feature importace for multi-layer perceptron
	%  getPropNumber - returns the property number of the neural network feature importace for multi-layer perceptron
	%  existsProp - checks whether property exists/error
	%  existsTag - checks whether tag exists/error
	%  getPropProp - returns the property number of a property
	%  getPropTag - returns the tag of a property
	%  getPropCategory - returns the category of a property
	%  getPropFormat - returns the format of a property
	%  getPropDescription - returns the description of a property
	%  getPropSettings - returns the settings of a property
	%  getPropDefault - returns the default value of a property
	%  getPropDefaultConditioned - returns the conditioned default value of a property
	%  checkProp - checks whether a value has the correct format/error
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (GUI):
	%  getPanelProp - returns a prop panel
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (GUI, Static):
	%  getGUIMenuImport - returns the importer menu
	%  getGUIMenuExport - returns the exporter menu
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (category, Static):
	%  getCategories - returns the list of categories
	%  getCategoryNumber - returns the number of categories
	%  existsCategory - returns whether a category exists/error
	%  getCategoryTag - returns the tag of a category
	%  getCategoryName - returns the name of a category
	%  getCategoryDescription - returns the description of a category
	%
	% NNxMLP_FeatureImportanceAcrossFUN methods (format, Static):
	%  getFormats - returns the list of formats
	%  getFormatNumber - returns the number of formats
	%  existsFormat - returns whether a format exists/error
	%  getFormatTag - returns the tag of a format
	%  getFormatName - returns the name of a format
	%  getFormatDescription - returns the description of a format
	%  getFormatSettings - returns the settings for a format
	%  getFormatDefault - returns the default value for a format
	%  checkFormat - returns whether a value format is correct/error
	%
	% To print full list of constants, click here <a href="matlab:metaclass = ?NNxMLP_FeatureImportanceAcrossFUN; properties = metaclass.PropertyList;for i = 1:1:length(properties), if properties(i).Constant, disp([properties(i).Name newline() tostring(properties(i).DefaultValue) newline()]), end, end">NNxMLP_FeatureImportanceAcrossFUN constants</a>.
	%
	%
	% See also NNDataPoint_FUN_CLA, NNDataPoint_FUN_REG, NNxMLP_FeatureImportanceAcrossMeasures.
	%
	% BUILD BRAPH2 6 class_name 1
	
	properties (Constant) % properties
		GR_FUN_LIST = 32; %CET: Computational Efficiency Trick
		GR_FUN_LIST_TAG = 'GR_FUN_LIST';
		GR_FUN_LIST_CATEGORY = 4;
		GR_FUN_LIST_FORMAT = 8;
	end
	methods % constructor
		function nnfiam = NNxMLP_FeatureImportanceAcrossFUN(varargin)
			%NNxMLP_FeatureImportanceAcrossFUN() creates a neural network feature importace for multi-layer perceptron.
			%
			% NNxMLP_FeatureImportanceAcrossFUN(PROP, VALUE, ...) with property PROP initialized to VALUE.
			%
			% NNxMLP_FeatureImportanceAcrossFUN(TAG, VALUE, ...) with property TAG set to VALUE.
			%
			% Multiple properties can be initialized at once identifying
			%  them with either property numbers (PROP) or tags (TAG).
			%
			% The list of NNxMLP_FeatureImportanceAcrossFUN properties is:
			%  <strong>1</strong> <strong>ELCLASS</strong> 	ELCLASS (constant, string) is the class of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>2</strong> <strong>NAME</strong> 	NAME (constant, string) is the name of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>3</strong> <strong>DESCRIPTION</strong> 	DESCRIPTION (constant, string) is the description of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>4</strong> <strong>TEMPLATE</strong> 	TEMPLATE (parameter, item) is the template of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>5</strong> <strong>ID</strong> 	ID (data, string) is a few-letter code of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>6</strong> <strong>LABEL</strong> 	LABEL (metadata, string) is an extended label of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>7</strong> <strong>NOTES</strong> 	NOTES (metadata, string) are some specific notes about the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.
			%  <strong>8</strong> <strong>TOSTRING</strong> 	TOSTRING (query, string) returns a string that represents the concrete element.
			%  <strong>9</strong> <strong>D</strong> 	D (data, item) is the neural networks dataset for feature importance analysis.
			%  <strong>10</strong> <strong>NN</strong> 	NN (data, item) contains a trained neural network multi-layer perceptron classifier or regressor.
			%  <strong>11</strong> <strong>P</strong> 	P (parameter, scalar) is the permutation number that determines the statistical significance of the specific feature. 
			%  <strong>12</strong> <strong>PERM_SEEDS</strong> 	PERM_SEEDS (result, rvector) is the list of seeds for the random permutations.
			%  <strong>13</strong> <strong>APPLY_CONFIDENCE_INTERVALS</strong> 	APPLY_CONFIDENCE_INTERVALS (parameter, logical) determines whether to apply user-defined percent confidence interval.
			%  <strong>14</strong> <strong>SIG_LEVEL</strong> 	SIG_LEVEL (parameter, scalar) determines the significant level.
			%  <strong>15</strong> <strong>APPLY_BONFERRONI</strong> 	APPLY_BONFERRONI (parameter, logical) determines whether to apply Bonferroni correction.
			%  <strong>16</strong> <strong>BASELINE_INPUTS</strong> 	BASELINE_INPUTS (result, cell) retrieves the input data to be shuffled.
			%  <strong>17</strong> <strong>COMP_FEATURE_INDICES</strong> 	COMP_FEATURE_INDICES (result, cell) provides the indices of brain regions, represented as a cell array containing sets of feature indices, such as {[1], [2], [3], ...}.
			%  <strong>18</strong> <strong>D_SHUFFLED</strong> 	D_SHUFFLED (query, item) generates a shuffled version of the dataset where the time series of one brain region is replaced with random values drawn from a distribution with the same mean and standard deviation as the orginal ones.
			%  <strong>19</strong> <strong>BASELINE_LOSS</strong> 	BASELINE_LOSS (result, scalar) is the loss value obtained from original dataset, acting as a baseline loss value for evaluating the feature importance.
			%  <strong>20</strong> <strong>SHUFFLED_LOSS</strong> 	SHUFFLED_LOSS (query, rvector) is the loss value obtained from shuffled datasets.
			%  <strong>21</strong> <strong>PERM_SHUFFLED_LOSS</strong> 	PERM_SHUFFLED_LOSS (result, cell) is the permutation test for obtaining shuffled loss for a number of times in order to establish confidence interval.
			%  <strong>22</strong> <strong>CONFIDENCE_INTERVALS</strong> 	CONFIDENCE_INTERVALS (query, rvector) derives the 95 percent of confidence interval for the permuation of shuffled loss values.
			%  <strong>23</strong> <strong>STAT_SIG_MASK</strong> 	STAT_SIG_MASK (result, rvector) provides the statistical significance mask for composite features indicating which composite features has significant contribution.
			%  <strong>24</strong> <strong>FEATURE_IMPORTANCE</strong> 	FEATURE_IMPORTANCE (result, cell) is determined by applying Bonferroni correction for the permutation and obtaining the value by the average of the permutation number times of shuffled loss, which then in trun are divided by base loss for normalizaiton.
			%  <strong>25</strong> <strong>RESHAPED_FEATURE_IMPORTANCE</strong> 	RESHAPED_FEATURE_IMPORTANCE (query, empty) reshapes the cell of feature importances with the input data.
			%  <strong>26</strong> <strong>MAP_TO_CELL</strong> 	MAP_TO_CELL (query, empty) maps a single vector back to the original cell array structure.
			%  <strong>27</strong> <strong>COUNT_ELEMENTS</strong> 	COUNT_ELEMENTS (query, empty) counts the total number of elements within a nested cell array.
			%  <strong>28</strong> <strong>FLATTEN_CELL</strong> 	FLATTEN_CELL (query, empty) flattens a cell array into to a single vector.
			%  <strong>29</strong> <strong>VERBOSE</strong> 	VERBOSE (gui, logical) is an indicator to display permutation progress information.
			%  <strong>30</strong> <strong>WAITBAR</strong> 	WAITBAR (gui, logical) determines whether to show the waitbar.
			%  <strong>31</strong> <strong>INTERRUPTIBLE</strong> 	INTERRUPTIBLE (gui, scalar) sets whether the permutation computation is interruptible for multitasking.
			%  <strong>32</strong> <strong>GR_FUN_LIST</strong> 	GR_FUN_LIST (data, item) is the list of FUN group, which also defines the subject class SubjectFUN.
			%
			% See also Category, Format.
			
			nnfiam = nnfiam@NNxMLP_FeatureImportance(varargin{:});
		end
	end
	methods (Static) % inspection
		function build = getBuild()
			%GETBUILD returns the build of the neural network feature importace for multi-layer perceptron.
			%
			% BUILD = NNxMLP_FeatureImportanceAcrossFUN.GETBUILD() returns the build of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Alternative forms to call this method are:
			%  BUILD = NNFIAM.GETBUILD() returns the build of the neural network feature importace for multi-layer perceptron NNFIAM.
			%  BUILD = Element.GETBUILD(NNFIAM) returns the build of 'NNFIAM'.
			%  BUILD = Element.GETBUILD('NNxMLP_FeatureImportanceAcrossFUN') returns the build of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Note that the Element.GETBUILD(NNFIAM) and Element.GETBUILD('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			
			build = 1;
		end
		function nnfiam_class = getClass()
			%GETCLASS returns the class of the neural network feature importace for multi-layer perceptron.
			%
			% CLASS = NNxMLP_FeatureImportanceAcrossFUN.GETCLASS() returns the class 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Alternative forms to call this method are:
			%  CLASS = NNFIAM.GETCLASS() returns the class of the neural network feature importace for multi-layer perceptron NNFIAM.
			%  CLASS = Element.GETCLASS(NNFIAM) returns the class of 'NNFIAM'.
			%  CLASS = Element.GETCLASS('NNxMLP_FeatureImportanceAcrossFUN') returns 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Note that the Element.GETCLASS(NNFIAM) and Element.GETCLASS('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			
			nnfiam_class = 'NNxMLP_FeatureImportanceAcrossFUN';
		end
		function subclass_list = getSubclasses()
			%GETSUBCLASSES returns all subclasses of the neural network feature importace for multi-layer perceptron.
			%
			% LIST = NNxMLP_FeatureImportanceAcrossFUN.GETSUBCLASSES() returns all subclasses of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Alternative forms to call this method are:
			%  LIST = NNFIAM.GETSUBCLASSES() returns all subclasses of the neural network feature importace for multi-layer perceptron NNFIAM.
			%  LIST = Element.GETSUBCLASSES(NNFIAM) returns all subclasses of 'NNFIAM'.
			%  LIST = Element.GETSUBCLASSES('NNxMLP_FeatureImportanceAcrossFUN') returns all subclasses of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Note that the Element.GETSUBCLASSES(NNFIAM) and Element.GETSUBCLASSES('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also subclasses.
			
			subclass_list = { 'NNxMLP_FeatureImportanceAcrossFUN' }; %CET: Computational Efficiency Trick
		end
		function prop_list = getProps(category)
			%GETPROPS returns the property list of neural network feature importace for multi-layer perceptron.
			%
			% PROPS = NNxMLP_FeatureImportanceAcrossFUN.GETPROPS() returns the property list of neural network feature importace for multi-layer perceptron
			%  as a row vector.
			%
			% PROPS = NNxMLP_FeatureImportanceAcrossFUN.GETPROPS(CATEGORY) returns the property list 
			%  of category CATEGORY.
			%
			% Alternative forms to call this method are:
			%  PROPS = NNFIAM.GETPROPS([CATEGORY]) returns the property list of the neural network feature importace for multi-layer perceptron NNFIAM.
			%  PROPS = Element.GETPROPS(NNFIAM[, CATEGORY]) returns the property list of 'NNFIAM'.
			%  PROPS = Element.GETPROPS('NNxMLP_FeatureImportanceAcrossFUN'[, CATEGORY]) returns the property list of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Note that the Element.GETPROPS(NNFIAM) and Element.GETPROPS('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropNumber, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_list = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32];
				return
			end
			
			switch category
				case 1 % Category.CONSTANT
					prop_list = [1 2 3];
				case 2 % Category.METADATA
					prop_list = [6 7];
				case 3 % Category.PARAMETER
					prop_list = [4 11 13 14 15];
				case 4 % Category.DATA
					prop_list = [5 9 10 32];
				case 5 % Category.RESULT
					prop_list = [12 16 17 19 21 23 24];
				case 6 % Category.QUERY
					prop_list = [8 18 20 22 25 26 27 28];
				case 9 % Category.GUI
					prop_list = [29 30 31];
				otherwise
					prop_list = [];
			end
		end
		function prop_number = getPropNumber(varargin)
			%GETPROPNUMBER returns the property number of neural network feature importace for multi-layer perceptron.
			%
			% N = NNxMLP_FeatureImportanceAcrossFUN.GETPROPNUMBER() returns the property number of neural network feature importace for multi-layer perceptron.
			%
			% N = NNxMLP_FeatureImportanceAcrossFUN.GETPROPNUMBER(CATEGORY) returns the property number of neural network feature importace for multi-layer perceptron
			%  of category CATEGORY
			%
			% Alternative forms to call this method are:
			%  N = NNFIAM.GETPROPNUMBER([CATEGORY]) returns the property number of the neural network feature importace for multi-layer perceptron NNFIAM.
			%  N = Element.GETPROPNUMBER(NNFIAM) returns the property number of 'NNFIAM'.
			%  N = Element.GETPROPNUMBER('NNxMLP_FeatureImportanceAcrossFUN') returns the property number of 'NNxMLP_FeatureImportanceAcrossFUN'.
			%
			% Note that the Element.GETPROPNUMBER(NNFIAM) and Element.GETPROPNUMBER('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getProps, Category.
			
			%CET: Computational Efficiency Trick
			
			if nargin == 0
				prop_number = 32;
				return
			end
			
			switch varargin{1} % category = varargin{1}
				case 1 % Category.CONSTANT
					prop_number = 3;
				case 2 % Category.METADATA
					prop_number = 2;
				case 3 % Category.PARAMETER
					prop_number = 5;
				case 4 % Category.DATA
					prop_number = 4;
				case 5 % Category.RESULT
					prop_number = 7;
				case 6 % Category.QUERY
					prop_number = 8;
				case 9 % Category.GUI
					prop_number = 3;
				otherwise
					prop_number = 0;
			end
		end
		function check_out = existsProp(prop)
			%EXISTSPROP checks whether property exists in neural network feature importace for multi-layer perceptron/error.
			%
			% CHECK = NNxMLP_FeatureImportanceAcrossFUN.EXISTSPROP(PROP) checks whether the property PROP exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNFIAM.EXISTSPROP(PROP) checks whether PROP exists for NNFIAM.
			%  CHECK = Element.EXISTSPROP(NNFIAM, PROP) checks whether PROP exists for NNFIAM.
			%  CHECK = Element.EXISTSPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP) checks whether PROP exists for NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Element.EXISTSPROP(PROP) throws an error if the PROP does NOT exist.
			%  Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNFIAM.EXISTSPROP(PROP) throws error if PROP does NOT exist for NNFIAM.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%  Element.EXISTSPROP(NNFIAM, PROP) throws error if PROP does NOT exist for NNFIAM.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%  Element.EXISTSPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP) throws error if PROP does NOT exist for NNxMLP_FeatureImportanceAcrossFUN.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%
			% Note that the Element.EXISTSPROP(NNFIAM) and Element.EXISTSPROP('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = prop >= 1 && prop <= 32 && round(prop) == prop; %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput'], ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput' '\n' ...
					'The value ' tostring(prop, 100, ' ...') ' is not a valid prop for NNxMLP_FeatureImportanceAcrossFUN.'] ...
					)
			end
		end
		function check_out = existsTag(tag)
			%EXISTSTAG checks whether tag exists in neural network feature importace for multi-layer perceptron/error.
			%
			% CHECK = NNxMLP_FeatureImportanceAcrossFUN.EXISTSTAG(TAG) checks whether a property with tag TAG exists.
			%
			% Alternative forms to call this method are:
			%  CHECK = NNFIAM.EXISTSTAG(TAG) checks whether TAG exists for NNFIAM.
			%  CHECK = Element.EXISTSTAG(NNFIAM, TAG) checks whether TAG exists for NNFIAM.
			%  CHECK = Element.EXISTSTAG(NNxMLP_FeatureImportanceAcrossFUN, TAG) checks whether TAG exists for NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Element.EXISTSTAG(TAG) throws an error if the TAG does NOT exist.
			%  Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%
			% Alternative forms to call this method are:
			%  NNFIAM.EXISTSTAG(TAG) throws error if TAG does NOT exist for NNFIAM.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%  Element.EXISTSTAG(NNFIAM, TAG) throws error if TAG does NOT exist for NNFIAM.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%  Element.EXISTSTAG(NNxMLP_FeatureImportanceAcrossFUN, TAG) throws error if TAG does NOT exist for NNxMLP_FeatureImportanceAcrossFUN.
			%   Error id: [BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			%
			% Note that the Element.EXISTSTAG(NNFIAM) and Element.EXISTSTAG('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getProps, existsTag.
			
			check = any(strcmp(tag, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NN'  'P'  'PERM_SEEDS'  'APPLY_CONFIDENCE_INTERVALS'  'SIG_LEVEL'  'APPLY_BONFERRONI'  'BASELINE_INPUTS'  'COMP_FEATURE_INDICES'  'D_SHUFFLED'  'BASELINE_LOSS'  'SHUFFLED_LOSS'  'PERM_SHUFFLED_LOSS'  'CONFIDENCE_INTERVALS'  'STAT_SIG_MASK'  'FEATURE_IMPORTANCE'  'RESHAPED_FEATURE_IMPORTANCE'  'MAP_TO_CELL'  'COUNT_ELEMENTS'  'FLATTEN_CELL'  'VERBOSE'  'WAITBAR'  'INTERRUPTIBLE'  'GR_FUN_LIST' })); %CET: Computational Efficiency Trick
			
			if nargout == 1
				check_out = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput'], ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput' '\n' ...
					'The value ' tag ' is not a valid tag for NNxMLP_FeatureImportanceAcrossFUN.'] ...
					)
			end
		end
		function prop = getPropProp(pointer)
			%GETPROPPROP returns the property number of a property.
			%
			% PROP = Element.GETPROPPROP(PROP) returns PROP, i.e., the 
			%  property number of the property PROP.
			%
			% PROP = Element.GETPROPPROP(TAG) returns the property number 
			%  of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  PROPERTY = NNFIAM.GETPROPPROP(POINTER) returns property number of POINTER of NNFIAM.
			%  PROPERTY = Element.GETPROPPROP(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns property number of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  PROPERTY = NNFIAM.GETPROPPROP(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns property number of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPPROP(NNFIAM) and Element.GETPROPPROP('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropFormat, getPropTag, getPropCategory, getPropDescription,
			%  getPropSettings, getPropDefault, checkProp.
			
			if ischar(pointer)
				prop = find(strcmp(pointer, { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NN'  'P'  'PERM_SEEDS'  'APPLY_CONFIDENCE_INTERVALS'  'SIG_LEVEL'  'APPLY_BONFERRONI'  'BASELINE_INPUTS'  'COMP_FEATURE_INDICES'  'D_SHUFFLED'  'BASELINE_LOSS'  'SHUFFLED_LOSS'  'PERM_SHUFFLED_LOSS'  'CONFIDENCE_INTERVALS'  'STAT_SIG_MASK'  'FEATURE_IMPORTANCE'  'RESHAPED_FEATURE_IMPORTANCE'  'MAP_TO_CELL'  'COUNT_ELEMENTS'  'FLATTEN_CELL'  'VERBOSE'  'WAITBAR'  'INTERRUPTIBLE'  'GR_FUN_LIST' })); % tag = pointer %CET: Computational Efficiency Trick
			else % numeric
				prop = pointer;
			end
		end
		function tag = getPropTag(pointer)
			%GETPROPTAG returns the tag of a property.
			%
			% TAG = Element.GETPROPTAG(PROP) returns the tag TAG of the 
			%  property PROP.
			%
			% TAG = Element.GETPROPTAG(TAG) returns TAG, i.e. the tag of 
			%  the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  TAG = NNFIAM.GETPROPTAG(POINTER) returns tag of POINTER of NNFIAM.
			%  TAG = Element.GETPROPTAG(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns tag of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  TAG = NNFIAM.GETPROPTAG(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns tag of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPTAG(NNFIAM) and Element.GETPROPTAG('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropSettings, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			if ischar(pointer)
				tag = pointer;
			else % numeric
				%CET: Computational Efficiency Trick
				nnxmlp_featureimportanceacrossfun_tag_list = { 'ELCLASS'  'NAME'  'DESCRIPTION'  'TEMPLATE'  'ID'  'LABEL'  'NOTES'  'TOSTRING'  'D'  'NN'  'P'  'PERM_SEEDS'  'APPLY_CONFIDENCE_INTERVALS'  'SIG_LEVEL'  'APPLY_BONFERRONI'  'BASELINE_INPUTS'  'COMP_FEATURE_INDICES'  'D_SHUFFLED'  'BASELINE_LOSS'  'SHUFFLED_LOSS'  'PERM_SHUFFLED_LOSS'  'CONFIDENCE_INTERVALS'  'STAT_SIG_MASK'  'FEATURE_IMPORTANCE'  'RESHAPED_FEATURE_IMPORTANCE'  'MAP_TO_CELL'  'COUNT_ELEMENTS'  'FLATTEN_CELL'  'VERBOSE'  'WAITBAR'  'INTERRUPTIBLE'  'GR_FUN_LIST' };
				tag = nnxmlp_featureimportanceacrossfun_tag_list{pointer}; % prop = pointer
			end
		end
		function prop_category = getPropCategory(pointer)
			%GETPROPCATEGORY returns the category of a property.
			%
			% CATEGORY = Element.GETPROPCATEGORY(PROP) returns the category of the
			%  property PROP.
			%
			% CATEGORY = Element.GETPROPCATEGORY(TAG) returns the category of the
			%  property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CATEGORY = NNFIAM.GETPROPCATEGORY(POINTER) returns category of POINTER of NNFIAM.
			%  CATEGORY = Element.GETPROPCATEGORY(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns category of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  CATEGORY = NNFIAM.GETPROPCATEGORY(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns category of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPCATEGORY(NNFIAM) and Element.GETPROPCATEGORY('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also Category, getPropProp, getPropTag, getPropSettings,
			%  getPropFormat, getPropDescription, getPropDefault, checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnxmlp_featureimportanceacrossfun_category_list = { 1  1  1  3  4  2  2  6  4  4  3  5  3  3  3  5  5  6  5  6  5  6  5  5  6  6  6  6  9  9  9  4 };
			prop_category = nnxmlp_featureimportanceacrossfun_category_list{prop};
		end
		function prop_format = getPropFormat(pointer)
			%GETPROPFORMAT returns the format of a property.
			%
			% FORMAT = Element.GETPROPFORMAT(PROP) returns the
			%  format of the property PROP.
			%
			% FORMAT = Element.GETPROPFORMAT(TAG) returns the
			%  format of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  FORMAT = NNFIAM.GETPROPFORMAT(POINTER) returns format of POINTER of NNFIAM.
			%  FORMAT = Element.GETPROPFORMAT(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns format of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  FORMAT = NNFIAM.GETPROPFORMAT(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns format of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPFORMAT(NNFIAM) and Element.GETPROPFORMAT('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			%  getPropDescription, getPropSettings, getPropDefault, checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnxmlp_featureimportanceacrossfun_format_list = { 2  2  2  8  2  2  2  2  8  8  11  12  4  11  4  16  16  8  11  12  16  12  12  16  1  1  1  1  4  4  11  8 };
			prop_format = nnxmlp_featureimportanceacrossfun_format_list{prop};
		end
		function prop_description = getPropDescription(pointer)
			%GETPROPDESCRIPTION returns the description of a property.
			%
			% DESCRIPTION = Element.GETPROPDESCRIPTION(PROP) returns the
			%  description of the property PROP.
			%
			% DESCRIPTION = Element.GETPROPDESCRIPTION(TAG) returns the
			%  description of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DESCRIPTION = NNFIAM.GETPROPDESCRIPTION(POINTER) returns description of POINTER of NNFIAM.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns description of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  DESCRIPTION = NNFIAM.GETPROPDESCRIPTION(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns description of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPDESCRIPTION(NNFIAM) and Element.GETPROPDESCRIPTION('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory,
			%  getPropFormat, getPropSettings, getPropDefault, checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			%CET: Computational Efficiency Trick
			nnxmlp_featureimportanceacrossfun_description_list = { 'ELCLASS (constant, string) is the class of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'NAME (constant, string) is the name of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'DESCRIPTION (constant, string) is the description of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'TEMPLATE (parameter, item) is the template of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'ID (data, string) is a few-letter code of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'LABEL (metadata, string) is an extended label of the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'NOTES (metadata, string) are some specific notes about the feature importance analysis for multi-layer perceptron (MLP) across all included graph measures.'  'TOSTRING (query, string) returns a string that represents the concrete element.'  'D (data, item) is the neural networks dataset for feature importance analysis.'  'NN (data, item) contains a trained neural network multi-layer perceptron classifier or regressor.'  'P (parameter, scalar) is the permutation number that determines the statistical significance of the specific feature. '  'PERM_SEEDS (result, rvector) is the list of seeds for the random permutations.'  'APPLY_CONFIDENCE_INTERVALS (parameter, logical) determines whether to apply user-defined percent confidence interval.'  'SIG_LEVEL (parameter, scalar) determines the significant level.'  'APPLY_BONFERRONI (parameter, logical) determines whether to apply Bonferroni correction.'  'BASELINE_INPUTS (result, cell) retrieves the input data to be shuffled.'  'COMP_FEATURE_INDICES (result, cell) provides the indices of brain regions, represented as a cell array containing sets of feature indices, such as {[1], [2], [3], ...}.'  'D_SHUFFLED (query, item) generates a shuffled version of the dataset where the time series of one brain region is replaced with random values drawn from a distribution with the same mean and standard deviation as the orginal ones.'  'BASELINE_LOSS (result, scalar) is the loss value obtained from original dataset, acting as a baseline loss value for evaluating the feature importance.'  'SHUFFLED_LOSS (query, rvector) is the loss value obtained from shuffled datasets.'  'PERM_SHUFFLED_LOSS (result, cell) is the permutation test for obtaining shuffled loss for a number of times in order to establish confidence interval.'  'CONFIDENCE_INTERVALS (query, rvector) derives the 95 percent of confidence interval for the permuation of shuffled loss values.'  'STAT_SIG_MASK (result, rvector) provides the statistical significance mask for composite features indicating which composite features has significant contribution.'  'FEATURE_IMPORTANCE (result, cell) is determined by applying Bonferroni correction for the permutation and obtaining the value by the average of the permutation number times of shuffled loss, which then in trun are divided by base loss for normalizaiton.'  'RESHAPED_FEATURE_IMPORTANCE (query, empty) reshapes the cell of feature importances with the input data.'  'MAP_TO_CELL (query, empty) maps a single vector back to the original cell array structure.'  'COUNT_ELEMENTS (query, empty) counts the total number of elements within a nested cell array.'  'FLATTEN_CELL (query, empty) flattens a cell array into to a single vector.'  'VERBOSE (gui, logical) is an indicator to display permutation progress information.'  'WAITBAR (gui, logical) determines whether to show the waitbar.'  'INTERRUPTIBLE (gui, scalar) sets whether the permutation computation is interruptible for multitasking.'  'GR_FUN_LIST (data, item) is the list of FUN group, which also defines the subject class SubjectFUN.' };
			prop_description = nnxmlp_featureimportanceacrossfun_description_list{prop};
		end
		function prop_settings = getPropSettings(pointer)
			%GETPROPSETTINGS returns the settings of a property.
			%
			% SETTINGS = Element.GETPROPSETTINGS(PROP) returns the
			%  settings of the property PROP.
			%
			% SETTINGS = Element.GETPROPSETTINGS(TAG) returns the
			%  settings of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  SETTINGS = NNFIAM.GETPROPSETTINGS(POINTER) returns settings of POINTER of NNFIAM.
			%  SETTINGS = Element.GETPROPSETTINGS(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns settings of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  SETTINGS = NNFIAM.GETPROPSETTINGS(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns settings of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPSETTINGS(NNFIAM) and Element.GETPROPSETTINGS('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropProp, getPropTag, getPropCategory, getPropFormat,
			%  getPropDescription, getPropDefault, checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 32 % NNxMLP_FeatureImportanceAcrossFUN.GR_FUN_LIST
					prop_settings = Format.getFormatSettings(8);
				case 4 % NNxMLP_FeatureImportanceAcrossFUN.TEMPLATE
					prop_settings = 'NNxMLP_FeatureImportanceAcrossFUN';
				case 18 % NNxMLP_FeatureImportanceAcrossFUN.D_SHUFFLED
					prop_settings = 'NNDataset';
				otherwise
					prop_settings = getPropSettings@NNxMLP_FeatureImportance(prop);
			end
		end
		function prop_default = getPropDefault(pointer)
			%GETPROPDEFAULT returns the default value of a property.
			%
			% DEFAULT = NNxMLP_FeatureImportanceAcrossFUN.GETPROPDEFAULT(PROP) returns the default 
			%  value of the property PROP.
			%
			% DEFAULT = NNxMLP_FeatureImportanceAcrossFUN.GETPROPDEFAULT(TAG) returns the default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNFIAM.GETPROPDEFAULT(POINTER) returns the default value of POINTER of NNFIAM.
			%  DEFAULT = Element.GETPROPDEFAULT(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns the default value of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  DEFAULT = NNFIAM.GETPROPDEFAULT(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns the default value of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPDEFAULT(NNFIAM) and Element.GETPROPDEFAULT('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also getPropDefaultConditioned, getPropProp, getPropTag, getPropSettings, 
			%  getPropCategory, getPropFormat, getPropDescription, checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			switch prop %CET: Computational Efficiency Trick
				case 32 % NNxMLP_FeatureImportanceAcrossFUN.GR_FUN_LIST
					prop_default = Group('SUB_CLASS', 'SubjectFUN');
				case 1 % NNxMLP_FeatureImportanceAcrossFUN.ELCLASS
					prop_default = 'NNxMLP_FeatureImportanceAcrossFUN';
				case 2 % NNxMLP_FeatureImportanceAcrossFUN.NAME
					prop_default = 'Feature Importace for Multi-layer Perceptron Across Functional Time Series';
				case 3 % NNxMLP_FeatureImportanceAcrossFUN.DESCRIPTION
					prop_default = 'Neural Network Feature Importance Across Functional Data (NNxMLP_FeatureImportanceAcrossFUN) assesses the importance of brain regions by measuring the increase in model error when its corresponding functional time series values are randomly shuffled.';
				case 4 % NNxMLP_FeatureImportanceAcrossFUN.TEMPLATE
					prop_default = Format.getFormatDefault(8, NNxMLP_FeatureImportanceAcrossFUN.getPropSettings(prop));
				case 5 % NNxMLP_FeatureImportanceAcrossFUN.ID
					prop_default = 'NNxMLP_FeatureImportanceAcrossFUN ID';
				case 6 % NNxMLP_FeatureImportanceAcrossFUN.LABEL
					prop_default = 'NNxMLP_FeatureImportanceAcrossFUN label';
				case 7 % NNxMLP_FeatureImportanceAcrossFUN.NOTES
					prop_default = 'NNxMLP_FeatureImportanceAcrossFUN notes';
				case 18 % NNxMLP_FeatureImportanceAcrossFUN.D_SHUFFLED
					prop_default = Format.getFormatDefault(8, NNxMLP_FeatureImportanceAcrossFUN.getPropSettings(prop));
				otherwise
					prop_default = getPropDefault@NNxMLP_FeatureImportance(prop);
			end
		end
		function prop_default = getPropDefaultConditioned(pointer)
			%GETPROPDEFAULTCONDITIONED returns the conditioned default value of a property.
			%
			% DEFAULT = NNxMLP_FeatureImportanceAcrossFUN.GETPROPDEFAULTCONDITIONED(PROP) returns the conditioned default 
			%  value of the property PROP.
			%
			% DEFAULT = NNxMLP_FeatureImportanceAcrossFUN.GETPROPDEFAULTCONDITIONED(TAG) returns the conditioned default 
			%  value of the property with tag TAG.
			%
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  DEFAULT = NNFIAM.GETPROPDEFAULTCONDITIONED(POINTER) returns the conditioned default value of POINTER of NNFIAM.
			%  DEFAULT = Element.GETPROPDEFAULTCONDITIONED(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns the conditioned default value of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%  DEFAULT = NNFIAM.GETPROPDEFAULTCONDITIONED(NNxMLP_FeatureImportanceAcrossFUN, POINTER) returns the conditioned default value of POINTER of NNxMLP_FeatureImportanceAcrossFUN.
			%
			% Note that the Element.GETPROPDEFAULTCONDITIONED(NNFIAM) and Element.GETPROPDEFAULTCONDITIONED('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also conditioning, getPropDefault, getPropProp, getPropTag, 
			%  getPropSettings, getPropCategory, getPropFormat, getPropDescription, 
			%  checkProp.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			prop_default = NNxMLP_FeatureImportanceAcrossFUN.conditioning(prop, NNxMLP_FeatureImportanceAcrossFUN.getPropDefault(prop));
		end
	end
	methods (Static) % checkProp
		function prop_check = checkProp(pointer, value)
			%CHECKPROP checks whether a value has the correct format/error.
			%
			% CHECK = NNFIAM.CHECKPROP(POINTER, VALUE) checks whether
			%  VALUE is an acceptable value for the format of the property
			%  POINTER (POINTER = PROP or TAG).
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  CHECK = NNFIAM.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of NNFIAM.
			%  CHECK = Element.CHECKPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP, VALUE) checks VALUE format for PROP of NNxMLP_FeatureImportanceAcrossFUN.
			%  CHECK = NNFIAM.CHECKPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP, VALUE) checks VALUE format for PROP of NNxMLP_FeatureImportanceAcrossFUN.
			% 
			% NNFIAM.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
			%  NOT an acceptable value for the format of the property POINTER.
			%  Error id: BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput
			% 
			% Alternative forms to call this method are (POINTER = PROP or TAG):
			%  NNFIAM.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of NNFIAM.
			%   Error id: BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput
			%  Element.CHECKPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNxMLP_FeatureImportanceAcrossFUN.
			%   Error id: BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput
			%  NNFIAM.CHECKPROP(NNxMLP_FeatureImportanceAcrossFUN, PROP, VALUE) throws error if VALUE has not a valid format for PROP of NNxMLP_FeatureImportanceAcrossFUN.
			%   Error id: BRAPH2:NNxMLP_FeatureImportanceAcrossFUN:WrongInput]
			% 
			% Note that the Element.CHECKPROP(NNFIAM) and Element.CHECKPROP('NNxMLP_FeatureImportanceAcrossFUN')
			%  are less computationally efficient.
			%
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription, getPropDefault.
			
			prop = NNxMLP_FeatureImportanceAcrossFUN.getPropProp(pointer);
			
			switch prop
				case 32 % NNxMLP_FeatureImportanceAcrossFUN.GR_FUN_LIST
					check = Format.checkFormat(8, value, NNxMLP_FeatureImportanceAcrossFUN.getPropSettings(prop));
				case 4 % NNxMLP_FeatureImportanceAcrossFUN.TEMPLATE
					check = Format.checkFormat(8, value, NNxMLP_FeatureImportanceAcrossFUN.getPropSettings(prop));
				case 18 % NNxMLP_FeatureImportanceAcrossFUN.D_SHUFFLED
					check = Format.checkFormat(8, value, NNxMLP_FeatureImportanceAcrossFUN.getPropSettings(prop));
				otherwise
					if prop <= 31
						check = checkProp@NNxMLP_FeatureImportance(prop, value);
					end
			end
			
			if nargout == 1
				prop_check = check;
			elseif ~check
				error( ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput'], ...
					['BRAPH2' ':NNxMLP_FeatureImportanceAcrossFUN:' 'WrongInput' '\n' ...
					'The value ' tostring(value, 100, ' ...') ' is not a valid property ' NNxMLP_FeatureImportanceAcrossFUN.getPropTag(prop) ' (' NNxMLP_FeatureImportanceAcrossFUN.getFormatTag(NNxMLP_FeatureImportanceAcrossFUN.getPropFormat(prop)) ').'] ...
					)
			end
		end
	end
	methods (Access=protected) % calculate value
		function value = calculateValue(nnfiam, prop, varargin)
			%CALCULATEVALUE calculates the value of a property.
			%
			% VALUE = CALCULATEVALUE(EL, PROP) calculates the value of the property
			%  PROP. It works only with properties with 5,
			%  6, and 7. By default this function
			%  returns the default value for the prop and should be implemented in the
			%  subclasses of Element when needed.
			%
			% VALUE = CALCULATEVALUE(EL, PROP, VARARGIN) works with properties with
			%  6.
			%
			% See also getPropDefaultConditioned, conditioning, preset, checkProp,
			%  postset, postprocessing, checkValue.
			
			switch prop
				case 17 % NNxMLP_FeatureImportanceAcrossFUN.COMP_FEATURE_INDICES
					rng_settings_ = rng(); rng(nnfiam.getPropSeed(17), 'twister')
					
					% yuxin 
					% Instruction: the value of this one should be the brain node index, such as {[1], [2],
					% [3], ...} for the momemnt.
					comp_feature_indices = [];
					value = comp_feature_indices;
					
					rng(rng_settings_)
					
				case 18 % NNxMLP_FeatureImportanceAcrossFUN.D_SHUFFLED
					% yuxin
					% Instruction: D_SHUFFLED will consist of NNDataPointMLP_Shuffled 
					% with inputs being adjacency matrices derived from correlations 
					% between the time series of nodes, with one of the node time series shuffled.
					if isempty(varargin)
					    value = NNDataset();
					    return
					end
					comp_feature_combination = varargin{1}; % the composite indexes 
					
					d = nnfi.get('D');
					dp_it_list = d.get('DP_DICT').get('IT_LIST');
					P = nnfi.get('P');
					
					inputs = cell2mat(nnfi.memorize('BASELINE_INPUTS'));
					shuffled_inputs = inputs;
					for i = 1:length(comp_feature_combination)
					    feature_idx = comp_feature_combination(i);
					    permuted_value = squeeze(normrnd(mean(inputs(:, feature_idx)), std(inputs(:, feature_idx)), squeeze(size(inputs(:, feature_idx)))));
					    shuffled_inputs(:, feature_idx) = permuted_value;
					end
					
					for i = 1:length(dp_it_list)
					    dp = dp_it_list{i};
					    shuffled_input = {shuffled_inputs(i, :)};
					    shuffled_dp_list{i} = NNDataPointMLP_Shuffled('SHUFFLED_INPUT', shuffled_input);
					end
					
					shuffled_dp_dict = IndexedDictionary(...
					        'IT_CLASS', 'NNDataPointMLP_Shuffled', ...
					        'IT_LIST', shuffled_dp_list ...
					        );
					
					value = NNDataset( ...
					    'DP_CLASS', 'NNDataPointMLP_Shuffled', ...
					    'DP_DICT', shuffled_dp_dict ...
					    );
					
					% yuxin do it until here
					
				otherwise
					if prop <= 31
						value = calculateValue@NNxMLP_FeatureImportance(nnfiam, prop, varargin{:});
					else
						value = calculateValue@Element(nnfiam, prop, varargin{:});
					end
			end
			
		end
	end
end
