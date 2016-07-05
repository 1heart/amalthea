function [linearInd,bigLatticeOfTranslates,T1]= smallLatticePositionFromBigLattice(transCel,eachLatticeElt)

tr1 = transCel{1,1};
tr2 = transCel{2,1};
tr3 = transCel{3,1};

[T1, T2, T3] = ndgrid(tr1,tr2,tr3);

bigLatticeOfTranslates = [T1(:),T2(:),T3(:)];


linearInd = find(bigLatticeOfTranslates(:,1)==eachLatticeElt(1) & bigLatticeOfTranslates(:,2)==eachLatticeElt(2) & bigLatticeOfTranslates(:,3)==eachLatticeElt(3)) ;
% the linear index is the index of the translate (in the small lattice ) in the
% big lattice translates

if isempty(linearInd)
    linearInd =[]
end
    