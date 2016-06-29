function [coefficients,indexofRelevantTrans,linearIndOfRelevantTrans,sampleLattice,remeBerBigTrans]=accessLatticePointsOnline(dim,dims,indices,transCel,sample,...
                                            startLevel,...
                                            waveletFlag,coefficients,supp,phi)
                                        
                                        
                                        
                                        
%       [coefficients,indexofRelevantTrans,linearIndOfRelevantTrans,sampleLattice,remeBerBigTrans]=accessLatticePointsOnline(dim,dims,indices,transCel,sample,...
%                                             startLevel,...
%                                             waveletFlag,coefficients,supp,phi)   PREVIOUS before modified on september 06,2013   to the one at the top ( we remove sme composnents                            
%                                         
                                       
 for i = 1:dim
    eval(['tr',num2str(i),'= transCel{i,1};']);
 end

% create strings for indexing the sublattice below ( in the loop m)
[str1] = createSrings(dim,'idx') ;

% build the relevant lattice
[ sampleLattice ] = ComputeEachSampleLattice(sample,supp,startLevel,coefficients,transCel);
%[sampleLattice] = eachSampleLattice1(vect,supp,startLevel,coefficients,transCel)

% take it to iterate over the whole lattice to check get the index
remeBerBigTrans = [];

% Access each elt of the small sample lattice and compare it to each elt of
% the big lattice
for j = 1:length(sampleLattice)
    eachLatticeElt = sampleLattice(j,:);
        % From linear index to access in the lattice (translate, sampledensity)
        % % the linear index linearInd is the index of the translate (in the small lattice ) into the
       % big lattice translates: USE NDGRID TO BUILD THE SMALL LATTICE if U WANT TO USE IN2SUB LATER
        [linearInd,bigLatticeOfTranslates,T1] = smallLatticePositionFromBigLattice(transCel,eachLatticeElt);
        
%         x1=size(T1,1);
%         x2=size(T1,2);
%         x3=size(T1,3);
        % give the linear index of the small lattice in the biglattice and
        % provide the 3D index or ND ( position of the small lattice in the big lattice)
        eval(['[',str1,'] = ind2sub(dims,linearInd);']);
        eval(['eachIndex = [' str1 '];'])
        % eachIndex is the position (3D) of each elt of the small translate
        % lattice in the big translate lattice
        smallLatticePosition = eachIndex;
 %--------------------------------------------------------------------------       
%         for m = 1:length(indices) 
%             
%             eval(['[',str1,'] = ind2sub(dims,m);']);
%             eval(['eachIndex = [' str1 '];'])
%             % a row vector of index to be used for accessing translates vectors
%             L = length(eachIndex); 
%             
%                 % # of translates or number of feature vectors
%                 for f = 1 : L  
%                     % accessing each elt in the index vector
%                     ff = eachIndex(f); 
%                     % accesing the the translate or sample
%                     eval(['b',num2str(f),' = tr', num2str(f),'(ff);']);  
%                 end 
%             [str] = createSrings(dim,'b');
%             
%             % real value of the translate or sample
%             eval(['valForIndx = [' str '];']) 
%                            if(isequal(eachLatticeElt,valForIndx))
%                               indxTrans = eachIndex;
%                               linearInd = m;                           
%                              remeBerBigTrans = [remeBerBigTrans;valForIndx]; 
%                               break
%                                 
%                             end         
%         end
%         
%     % Access these values in the big lattice of translates by saving the
%     % indexes
%     indexofRelevantTrans{j,1} = indxTrans;
%     linearIndOfRelevantTrans(j) = linearInd;               
%----------------------------------------------------
    indexofRelevantTrans{j,1} = eachIndex;
    linearIndOfRelevantTrans(j) = linearInd;
    remeBerBigTrans =[remeBerBigTrans;eachLatticeElt];
end
v=1;