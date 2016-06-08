%--------------------------------------------------------------------------
% Function:    metricsTest
% Description: Runs tests for metrics1 (deprecated).
% 
% Usage: Used in hierarchical clustering on the unit hypersphere.
%       Usage: runtests('metricsTest.m');
%
% Authors(s):
%   Mark Moyou - markmmoyou@gmail.com
% Yixin Lin - yixin1996@gmail.com
%   Glizela Taino - glizelataino@gmail.com
%
% Date: Monday 6th June, 2016 (2:34pm)
%
% Affiliation: Florida Institute of Technology. Information
%              Characterization and Exploitation Laborartory.
%              http://research2.fit.edu/ice/
% -------------------------------------------------------------------------

function tests = metricsTest
tests = functiontests(localfunctions);
end

function test2x2(testCase) % Tests for 2 category, 2 shapes/category
  distMatrix = [ ...
    0 3 5 6 ; ...
    3 0 4 3 ; ...
    5 4 0 5 ; ...
    6 3 5 0 ; ...
    ];
  trueLabels = [ ...
    1 ;
    1 ;
    2 ;
    2 ;
  ];

  metricMap = metrics1(distMatrix, trueLabels);

  expectedPrecision = [ ...
    1 1 2/3 1/2 ; ...
    1 1 2/3 1/2 ; ...
    1 1/2 1/3 1/2 ; ...
    1 1/2 2/3 1/2 ; ...
  ];

  expectedRecall = [ ...
    1/2 1 1 1 ; ...
    1/2 1 1 1 ; ...
    1/2 1/2 1/2 1 ; ...
    1/2 1/2 1 1 ; ...
  ];

  expectedAvgPrecision = [ 0.7917; 0.7917; 0.5833; 0.6667; ];
  expectedMeanAvgPrecision = 0.7084;

  expectedEMeasure32 = nan(4,1);

  verifyEqual(testCase, metricMap('precision'), expectedPrecision);
  verifyEqual(testCase, metricMap('recall'), expectedRecall);
  verifyEqual(testCase, ...
    metricMap('mean_avg_precision'), ...
    expectedMeanAvgPrecision, ...
    'RelTol', 0.01);
  verifyEqual(testCase, metricMap('e_measure_32'), expectedEMeasure32);
  verifyEqual(testCase, metricMap('avg_e_measure_32'), nan);
end

