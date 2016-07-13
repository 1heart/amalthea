function [assignments] = lapjv_old(costMatrix)

PREFIX = '~/amalthea/code/linassgn/linassgn_old/';

inputFileName = 'temp_input';
outputFileName = 'temp_output';

writeMatrixToBinaryFile(costMatrix,inputFileName);

[status shellText] = unix([PREFIX 'original_cpp_code/lap_binInFile/' 'linAssignBinFile ' inputFileName ' ./' outputFileName]);
if status ~= 0
  error(shellText);
end

load(['./' outputFileName]);
eval(['assignments = ' outputFileName ';']);
delete(inputFileName);
delete(outputFileName);

assignments = assignments + 1;
assignments = assignments';

