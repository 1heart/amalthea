%--------------------------------------------------------------------------
% Function:    getDatasets
% Description: Loads the coefficient datasets from saved .mat files.
% 
% Outputs
% 
% datasets    - A array of structs with fields
%                 'name'        :   name of the dataset
%                 'path'        : relative path from prefix to the dataset
%                 'dimensions'  : dimensions of the data
%                                   specified as [numCategories, numShapes/category]
%                 'labels'      : dimensions of the data
%                 'wName'       : the name of the wavelet
%                 'sampleSupp'  : the sample support of the wavelet
%                 'startLevel'  : the start level of the wavelet
%
% Usage: Used in hierarchical retrieval on the unit hypersphere.
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laboratory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function [datasets] = getDatasets(names, prefix)

if (nargin < 2) prefix = '~/amalthea/data/'; end;
if (nargin < 1)
  names = {
    'brown_123', 'brown_125', ...
    'mpeg7_123', 'mpeg7_125', ...
    'shrec11_123', 'shrec11_125', ...
    'brown_wde', ...
    'mpeg_7_haar_singleres', 'mpeg_7_haar_multires',...
    'mpeg_7_sym4_singleres', 'mpeg_7_sym4_multires'...
  };
end
if ischar(names) names = {names}; end;

% Dimensions are specified as [numCategories, numShapes/category]
all_datasets = {
  struct( ...
    'path', ...
      'Coefficients/Brown/db4r3/range_1_123/Brown_EV_PQA_1_2_3_3D_2r1__WT_db4_RL_3_p1.mat', ...
    'name', 'brown_123', ...
    'dimensions', [9 11]), ...
  struct( ...
    'path', ...
      'Coefficients/Brown/db4r3/range_1_125/Brown_PQA_1_2_5_r1_3D_WT_db4_RL_3_p1.mat', ...
    'name', 'brown_125', ...
    'dimensions', [9 11]), ...
  struct( ...
    'path', ...
      'Coefficients/MPEG7/db4r3/range_1_123/mpeg7Al_PQA_1_2_3_3D_2r1__WT_db4_RL_3.mat', ...
    'name', 'mpeg7_123', ...
    'dimensions', [70 20]), ...
  struct( ...
    'path', ...
      'Coefficients/MPEG7/db4r3/range_1_125/mpeg7Al_PQA_1_2_5_3D_2r1__WT_db4_RL_3.mat', ...
    'name', 'mpeg7_125', ...
    'dimensions', [70 20]), ...
  struct( ...
    'path', ...
      'Coefficients/SH11/db4r3/range_1_125/SHREC11_Or_PN_SSPts_GL_PQA_1_2_5_3D_2r1__WT_db4_RL_3.mat', ...
    'name', 'shrec11_123', ...
    'dimensions', [30 20]), ...
  struct( ...
    'path', ...
      'Coefficients/SH11/db4r3/range_1_125/SHREC11_Or_PN_SSPts_GL_PQA_1_2_5_3D_2r1__WT_db4_RL_3.mat', ...
    'name', 'shrec11_125', ...
    'dimensions', [30 20]), ...
  struct( ...
    'path', ...
      'BrownBrown_2D_ns99_Coeffs_r6_sym4_res_3_p2.mat', ...
    'name', 'brown_wde', ...
    'dimensions', [9 11]), ...
struct( ...
    'path', ...
      'mpeg7Aligned_Coeffs_r6_db1_res_2.mat', ...
    'name', 'mpeg_7_haar_multires', ...
    'dimensions', [70 20]), ...
struct( ...
    'path', ...
      'mpeg7Aligned_Coeffs_r6_db1_res_4.mat', ...
    'name', 'mpeg_7_haar_singleres', ...
    'dimensions', [70 20]), ...
struct( ...
    'path', ...
      'mpeg7Aligned_Coeffs_r6_db1_res_5.mat', ...
    'name', 'mpeg_7_haar_singleres_hd', ...
    'dimensions', [70 20]), ...
struct( ...
    'path', ...
      'mpeg7Aligned_Coeffs_r6_sym4_res_2.mat', ...
    'name', 'mpeg_7_sym4_multires', ...
    'dimensions', [70 20]), ...
struct( ...
    'path', ...
      'mpeg7Aligned_Coeffs_r6_sym4_res_3.mat', ...
    'name', 'mpeg_7_sym4_singleres', ...
    'dimensions', [70 20]), ...
struct( ...
    'path', ...
      'MPEG7APCoeffs.mat', ...
    'name', 'adrian_mpeg7', ...
    'dimensions', [70 20]), ...
};

datasets = {};

for i = 1:length(all_datasets)
  curr = all_datasets{i};
  isInNames = strcmp(names, curr.name);
  if any(isInNames(:)) % if curr.name in names
    clear wdeCell; clear currWdeCell;
    load([prefix all_datasets{i}.path]);
    if exist('currWdeCell') wdeCell = currWdeCell; end;
    n = size(wdeCell,1); d = size(wdeCell{1,1}, 1); D = nan(n,d);
    for j = 1:n; D(j,:) = wdeCell{j,1}'; end;

    curr = setfield(curr, 'data', D);

    dimensions = curr.dimensions;
    numCategories = dimensions(1); numShapesPerCategory = dimensions(2);
    labels = kron(1:numCategories, ones(1,numShapesPerCategory))';
    curr = setfield(curr, 'labels', labels);
    curr = setfield(curr, 'wdeSet', wdeCell{1,3});

    curr = setfield(curr, 'sampleSupp', curr.wdeSet.sampleSupp);
    curr = setfield(curr, 'wName', curr.wdeSet.wName);
    curr = setfield(curr, 'startLevel', curr.wdeSet.startLevel);
    datasets = [datasets curr];
  end
end

if length(datasets) ~= length(names)
  error('One of the names typed was not in the database!');
end

end
