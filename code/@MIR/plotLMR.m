function plotLMR( obj )

% plotLMR  Plot luminance image and illuminance and reflectance estimates
% 
% usage:  obj.plotLMR

subplot(1,3,1); imagesc( obj.imL, [ 0 max(obj.imL(:)) ] );      axis image; title luminance; colormap gray;
subplot(1,3,2); imagesc( obj.imMhat, [ 0 max(obj.imMhat(:)) ]); axis image; title 'estimated illuminance';
subplot(1,3,3); imagesc( obj.imRhat, [ 0 1 ]);                  axis image; title 'estimated reflectance';

end
