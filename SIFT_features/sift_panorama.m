function panorama = sift_panorama(I1, I2)

% setup VLfeat
% run('/Users/xzq_klaus/vlfeat-0.9.20/toolbox/vl_setup');
match_thresh = 15 ;

% I1 = imread('../Dataset1/3.jpg') ;
% I1 = imrotate(I1,-90) ;
I1 = im2single(I1) ;
I1g = rgb2gray(I1) ;

% I2 = imread('../Dataset1/1&2.jpg') ;
% I2 = imrotate(I2,-90) ;
I2 = im2single(I2) ;
I2g = rgb2gray(I2) ;

% SIFT matches (Q3)

[f1,d1] = vl_sift(I1g) ;
[f2,d2] = vl_sift(I2g) ;

[matches, ~] = vl_ubcmatch(d1,d2,match_thresh) ;

numMatches = size(matches,2) ;

X1 = f1(1:2,matches(1,:)) ; 
X1(3,:) = 1 ;
X2 = f2(1:2,matches(2,:)) ; 
X2(3,:) = 1 ;

clear H
clear consensus_set
clear score

% RANSAC (Q4)
for i = 1:100
  % estimate homograpyh
  % Choose a small subset of keypoints
  subset = vl_colsubset(1:numMatches, 4) ;
  A = [] ;
  for j = subset
    A = cat(1, A, kron(X1(:,j)', vl_hat(X2(:,j)))) ;
  end
  [~,~,V] = svd(A) ;
  H{i} = reshape(V(:,9),3,3) ;

  % score homography
  X2_ = H{i} * X1 ;
  du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
  dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
  consensus_set{i} = (du.*du + dv.*dv) < 35 ;
  score(i) = sum(consensus_set{i}) ;
end

% best model with hightest score
[~, highest] = max(score) ;
H = H{highest} ;
consensus_set = consensus_set{highest} ;

% Re-estimate the homography with consensus set
function error = loss_function(H)
 u = H(1) * X1(1,consensus_set) + H(4) * X1(2,consensus_set) + H(7) ;
 v = H(2) * X1(1,consensus_set) + H(5) * X1(2,consensus_set) + H(8) ;
 d = H(3) * X1(1,consensus_set) + H(6) * X1(2,consensus_set) + 1 ;
 du = X2(1,consensus_set) - u ./ d ;
 dv = X2(2,consensus_set) - v ./ d ;
 error = sum(du.*du + dv.*dv) ;
end

H = H / H(3,3) ;
os = optimset('Display', 'none', 'TolFun', 1e-8, 'TolX', 1e-8) ;
H(1:8) = fminsearch(@loss_function, H(1:8)', os) ;

% Start Stiching

% map the 4 corners of image 2 to image 1 coordianate frame
boundary2 = [1  size(I2,2) size(I2,2)  1 ;
        1  1           size(I2,1)  size(I2,1) ;
        1  1           1            1 ] ;
boundary2_ = inv(H) * boundary2 ;
boundary2_(1,:) = boundary2_(1,:) ./ boundary2_(3,:) ;
boundary2_(2,:) = boundary2_(2,:) ./ boundary2_(3,:) ;
uu = min([1 boundary2_(1,:)]):max([size(I1,2) boundary2_(1,:)]) ;
vv = min([1 boundary2_(2,:)]):max([size(I1,1) boundary2_(2,:)]) ;

[u,v] = meshgrid(uu,vv) ;
I1_ = vl_imwbackward(im2double(I1),u,v) ;

% Apply homography on image 2
z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;
I2_ = vl_imwbackward(im2double(I2),u_,v_) ;

%Overlay is handled as following
m = ~isnan(I1_) + ~isnan(I2_) ;
I1_(isnan(I1_)) = 0 ;
I2_(isnan(I2_)) = 0 ;
panorama = (I1_ + I2_) ./ m ;

figure(2) ; 
clf ;
imagesc(panorama) ; 
axis image off ;
title('Panorama') ;

if nargout == 0
    clear panorama ; 
end

end