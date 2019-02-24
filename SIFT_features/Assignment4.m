clear all
close all

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Setup VLFeat
% To run the code, you have to install VLFeat first, 
% and change the path below to your path to vl_setup
% The source code is supposed to be in a different folder from the datasets
% but under the same parent directory so you have to change the image path
% accordingly.
% The stiching algorithm is implemented as a function called sift_panorama
% which need two images as parameters.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
run('/Users/xzq_klaus/vlfeat-0.9.20/toolbox/vl_setup');

I1 = imread('../Dataset1/1.jpg') ;
I1 = imrotate(I1,-90) ;
I2 = imread('../Dataset1/2.jpg') ;
I2 = imrotate(I2,-90) ;
% I3 = imread('../Dataset1/4.jpg') ;
% I3 = imrotate(I3,-90) ;
% I4 = imread('../Dataset2/4.jpg') ;
% I4 = imrotate(I4,-90) ;
% I5 = imread('../Dataset2/5.jpg') ;
% I5 = imrotate(I5,-90) ;

panorama = sift_panorama(I1,I2) ;
% panorama2 = sift_panorama(panorama,I3) ;
imwrite(panorama, 'panorama.jpg')
% panorama3 = sift_panorama(I5,I4) ;
% 
% panorama4 = sift_panorama(panorama3,panorama2) ;

imagesc(panorama) ;
