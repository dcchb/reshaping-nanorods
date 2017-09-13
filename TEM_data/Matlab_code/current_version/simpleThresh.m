function [level, imgBw] = simpleThresh(img, varargin)
%SIMPLETHRESH Global image threshold using a simple method.
% [level, imgBw] = SIMPLETHRESH(img, varargin) computes a threshold
% that can be used to convert an intensity image to a binary image.
%
% inputs:
% img - a non-sparse matrix of any class
% stdFactor1 - optional, default 3, scaling factor for the cutoff used to determine background distribution
% stdFactor2 - optional, default 3, scaling factor for the standard deviation of background distribution
% logTransform - optional, default true, specifies whether to take log of image before thresholding
% average - optional, default @mode, function handle to calculate average
%
% outputs:
% level - threshold, of class double, in the same units as img
% imgBw - binary image
%
%Downloaded on 20/03/2014
%Downloaded by David Harris-Birtill
%Downloaded from: http://www.mathworks.co.uk/matlabcentral/fileexchange/44291-simple-image-thresholding
%File ID: #44291
%by Jake Hughey 12 Nov 2013 (Updated 20 Nov 2013)

p = inputParser;
p.addRequired('img', @ismatrix);
p.addOptional('stdFactor1', 3, @isscalar);
p.addOptional('stdFactor2', 3, @isscalar);
p.addOptional('logTransform', true, @islogical);
p.addOptional('average', @mode, @(x) isa(x, 'function_handle'));
p.parse(img, varargin{:});
a = p.Results;

if a.logTransform
	a.img = log(double(a.img));
else
	a.img = double(a.img);
	1;end

imgFlat = a.img(:);
idx = abs(imgFlat - a.average(imgFlat)) < a.stdFactor1 * std(imgFlat);
level = a.average(imgFlat(idx)) + a.stdFactor2 * std(imgFlat(idx));
imgBw = a.img > level;

if a.logTransform
	level = exp(level);
	1;end
