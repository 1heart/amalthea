%--------------------------------------------------------------------------
% Function:    sampSupport
% Description: Returns the support of the samples used in density
%              estmation.
%
% Inputs:
%  samps             - Nx2 matrix of 2D samples to use for density 
%                      estimation.  The first column is x and second y.
% Outputs:
%   support          - 2x2 matrix of the sample support.
%                      support(1,:) gives min x value and max x value
%                      support(2,:) gives min y value and max y value
% Usage:
%
% Authors(s):
%   Adrian M. Peter
%
% Reference:
% A. Peter and A. Rangarajan, “Maximum likelihood wavelet density estimation 
% with applications to image and shape matching,” IEEE Trans. Image Proc., 
% vol. 17, no. 4, pp. 458–468, April 2008.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Copyright (C) 2009 Adrian M. Peter (adrian.peter@gmail.com)
%
%     This file is part of the WDE package.
%
%     The source code is provided under the terms of the GNU General 
%     Public License as published by the Free Software Foundation version 2 
%     of the License.
%
%     WDE package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with WDE package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
%     USA
%--------------------------------------------------------------------------
function support = sampSupport(samps)

support = [floor(min(samps(:,1))) ceil(max(samps(:,1))); ...
           floor(min(samps(:,2))) ceil(max(samps(:,2)))];
