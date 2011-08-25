//
//  UIImage+Resize.m
//  NYXImagesUtilities
//
//  Created by Nyx0uf on 5/2/11.
//  Copyright 2011 Benjamin Godard. All rights reserved.
//


#import "UIImage+Resizing.h"


@implementation UIImage (NYX_Resizing)

-(UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode
{
	const CGSize size = self.size;
	CGFloat x, y;
	switch (cropMode)
	{
		case NYXCropModeTopLeft:
			x = y = 0.0f;
			break;
		case NYXCropModeTopCenter:
			x = (size.width - newSize.width) * 0.5f;
			y = 0.0f;
			break;
		case NYXCropModeTopRight:
			x = size.width - newSize.width;
			y = 0.0f;
			break;
		case NYXCropModeBottomLeft:
			x = 0.0f;
			y = size.height - newSize.height;
			break;
		case NYXCropModeBottomCenter:
			x = newSize.width * 0.5f;
			y = size.height - newSize.height;
			break;
		case NYXCropModeBottomRight:
			x = size.width - newSize.width;
			y = size.height - newSize.height;
			break;
		case NYXCropModeLeftCenter:
			x = 0.0f;
			y = (size.height - newSize.height) * 0.5f;
			break;
		case NYXCropModeRightCenter:
			x = size.width - newSize.width;
			y = (size.height - newSize.height) * 0.5f;
			break;
		case NYXCropModeCenter:
			x = (size.width - newSize.width) * 0.5f;
			y = (size.height - newSize.height) * 0.5f;
			break;
		default: // Default to top left
			x = y = 0.0f;
			break;
	}

	/// Create the cropped image
	CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, (CGRect){.origin.x = x, .origin.y = y, .size = newSize});
#ifdef kNYXReturnRetainedObjects 
	UIImage* cropped = [[UIImage alloc] initWithCGImage:croppedImageRef];
#else
	UIImage* cropped = [UIImage imageWithCGImage:croppedImageRef];
#endif

	/// Cleanup
	CGImageRelease(croppedImageRef);

	return cropped;
}

/* Convenience method to crop the image from the top left corner */
-(UIImage*)cropToSize:(CGSize)newSize
{
	return [self cropToSize:newSize usingMode:NYXCropModeTopLeft];
}

-(UIImage*)scaleByFactor:(CGFloat)scaleFactor
{
	CGImageRef cgImage = self.CGImage;
	const size_t originalWidth = CGImageGetWidth(cgImage) * scaleFactor;
	const size_t originalHeight = CGImageGetHeight(cgImage) * scaleFactor;
	/// Number of bytes per row, each pixel in the bitmap will be represented by 4 bytes (ARGB), 8 bits of alpha/red/green/blue
	const size_t bytesPerRow = originalWidth * 4;

	/// Create an ARGB bitmap context
	CGContextRef bmContext = NYXImageCreateARGBBitmapContext(originalWidth, originalHeight, bytesPerRow);
	if (!bmContext) 
		return nil;
	
	/// Handle orientation
	if (UIImageOrientationLeft == self.imageOrientation)
	{
		CGContextRotateCTM(bmContext, M_PI_2);
		CGContextTranslateCTM(bmContext, 0, -originalHeight);
	}
	else if (UIImageOrientationRight == self.imageOrientation)
	{
		CGContextRotateCTM(bmContext, -M_PI_2);
		CGContextTranslateCTM(bmContext, -originalWidth, 0);
	}
	else if (UIImageOrientationDown == self.imageOrientation)
	{
		CGContextTranslateCTM(bmContext, originalWidth, originalHeight);
		CGContextRotateCTM(bmContext, -M_PI);
	}

	/// Image quality
	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);

	/// Draw the image in the bitmap context
	CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = originalWidth, .size.height = originalHeight}, cgImage);

	/// Create an image object from the context
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
#ifdef kNYXReturnRetainedObjects 
	UIImage* scaled = [[UIImage alloc] initWithCGImage:scaledImageRef];
#else
	UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef];
#endif

	/// Cleanup
	CGImageRelease(scaledImageRef);
	CGContextRelease(bmContext);

	return scaled;
}

-(UIImage*)scaleToFitSize:(CGSize)newSize
{
	CGImageRef cgImage = self.CGImage;
	const size_t originalWidth = CGImageGetWidth(cgImage);
	const size_t originalHeight = CGImageGetHeight(cgImage);

	/// Keep aspect ratio
	size_t destWidth, destHeight;
	if (originalWidth > originalHeight)
	{
		destWidth = newSize.width;
		destHeight = originalHeight * newSize.width / originalWidth;
	}
	else
	{
		destHeight = newSize.height;
		destWidth = originalWidth * newSize.height / originalHeight;
	}
	if (destWidth > newSize.width)
	{ 
		destWidth = newSize.width; 
		destHeight = originalHeight * newSize.width / originalWidth; 
	} 
	if (destHeight > newSize.height)
	{ 
		destHeight = newSize.height; 
		destWidth = originalWidth * newSize.height / originalHeight; 
	}

	/// Create an ARGB bitmap context
	CGContextRef bmContext = NYXImageCreateARGBBitmapContext(destWidth, destHeight, 4 * destWidth);
	if (!bmContext)
		return nil;

	/// Handle orientation
	if (UIImageOrientationLeft == self.imageOrientation)
	{
		CGContextRotateCTM(bmContext, M_PI_2);
		CGContextTranslateCTM(bmContext, 0, -destHeight);
	}
	else if (UIImageOrientationRight == self.imageOrientation)
	{
		CGContextRotateCTM(bmContext, -M_PI_2);
		CGContextTranslateCTM(bmContext, -destWidth, 0);
	}
	else if (UIImageOrientationDown == self.imageOrientation)
	{
		CGContextTranslateCTM(bmContext, destWidth, destHeight);
		CGContextRotateCTM(bmContext, -M_PI);
	}

	/// Image quality
	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);

	/// Draw the image in the bitmap context
	CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = destWidth, .size.height = destHeight}, cgImage);

	/// Create an image object from the context
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
#ifdef kNYXReturnRetainedObjects 
	UIImage* scaled = [[UIImage alloc] initWithCGImage:scaledImageRef];
#else
	UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef];
#endif

	/// Cleanup
	CGImageRelease(scaledImageRef);
	CGContextRelease(bmContext);

	return scaled;	
}

@end
