close all
clear all
% setup VLfeat
run('/Users/xzq_klaus/vlfeat-0.9.20/toolbox/vl_setup');
peak_thresh = 7;
edge_thresh = 10;
match_thresh = 15;
% 1.jpg
% I1 = vl_impattern('roofs1') ;
I1 = imread('../Dataset1/3.jpg');
I1 = imrotate(I1,-90);
image(I1)
I1 = single(rgb2gray(I1));
[f1,d1] = vl_sift(I1, 'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);

% print matching points
perm = randperm(size(f1,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f1(:,:)) ;
h2 = vl_plotframe(f1(:,:)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

% 2.jpg
% I2 = imread('../Dataset2/4.jpg');
% % I2_original = imrotate(I2,-90);
% % image(I2)
% I2 = single(rgb2gray(I2));
% [f2,d2] = vl_sift(I2, 'PeakThresh', peak_thresh, 'edgethresh', edge_thresh);

% feature matching
% [matches, scores] = vl_ubcmatch(d1, d2, match_thresh);

% figure(2); 
% clf;
% imagesc(cat(2, I1_original, I2_original));
% 
% x1 = f1(1,matches(1,:));
% x2 = f2(1,matches(2,:)) + size(I1,2);
% y1 = f1(2,matches(1,:));
% y2 = f2(2,matches(2,:));
% 
% hold on;
% h = line([x1 ; x2], [y1 ; y2]);
% set(h,'linewidth', 1, 'color', 'b');
% 
% vl_plotframe(f1(:,matches(1,:)));
% f2(1,:) = f2(1,:) + size(I1,2);
% vl_plotframe(f2(:,matches(2,:)));
% axis image off;

% Q4

