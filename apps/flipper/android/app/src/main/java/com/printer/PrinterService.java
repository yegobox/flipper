package com.printer;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.text.Layout;
import android.util.Log;

import androidx.annotation.Keep;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.Printer;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.print.PrnStrFormat;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

@Keep
public class PrinterService {
    private static final String TAG = "PrinterService";
    private static final boolean DEBUG = true;

    // Error codes
    private static final int ERROR_INVALID_INPUT = -1;
    private static final int ERROR_BITMAP_DECODE = -2;
    private static final int ERROR_GENERAL_EXCEPTION = -3;
    private static final int ERROR_DEVICE_CONNECTION = -1001;
    private static final int ERROR_PRINTER_POWER = -4;
    private static final int ERROR_PRINTER_WIDTH_UNKNOWN = -5;

    private static PrinterService instance;
    private Printer mPrinter;
    private boolean isInitialized = false;
    private int printerWidth = 384; // Default width for 58mm printer

    // Dithering constants
    private static final int FLOYD_STEINBERG_DITHERING = 0;
    private static final int ORDERED_DITHERING = 1;
    private static final int ATKINSON_DITHERING = 2;
    private static final int THRESHOLD_DITHERING = 3;
    private static final int QR_CODE_OPTIMIZED = 4;

    // Default dithering method - better for text and QR codes
    private int ditheringMethod = QR_CODE_OPTIMIZED;

    // Text enhancement settings
    private boolean enhanceTextReadability = true;
    private int textContrast = 30; // Default contrast enhancement percentage
    private int textSharpness = 20; // Default sharpness enhancement percentage

    private PrinterService() {}

    public static synchronized PrinterService getInstance() {
        if (instance == null) {
            instance = new PrinterService();
        }
        return instance;
    }

    public void setDitheringMethod(int method) {
        if (method >= FLOYD_STEINBERG_DITHERING && method <= QR_CODE_OPTIMIZED) {
            this.ditheringMethod = method;
        }
    }

    public void setTextEnhancement(boolean enhance, int contrast, int sharpness) {
        this.enhanceTextReadability = enhance;
        this.textContrast = Math.max(0, Math.min(100, contrast)); // Limit to 0-100%
        this.textSharpness = Math.max(0, Math.min(100, sharpness)); // Limit to 0-100%
    }

    public int initializePrinter() {
        try {
            DriverManager mDriverManager = DriverManager.getInstance();

            if (mDriverManager == null) {
                Log.e(TAG, "DriverManager instance is null");
                return ERROR_DEVICE_CONNECTION;
            }

            mPrinter = mDriverManager.getPrinter();
            if (mPrinter == null) {
                Log.e(TAG, "Printer instance is null");
                return ERROR_DEVICE_CONNECTION;
            }

            int status = mPrinter.getPrinterStatus();
            Log.i(TAG, "Printer status: " + status);

            try {
                // Set your printer width in dots/pixels here.
                // 384 dots is standard for 58mm printers (8 dots/mm × 48mm printable area)
                printerWidth = 384;
                Log.i(TAG, "Printer width set to: " + printerWidth);
            } catch (Exception e) {
                Log.e(TAG, "Failed to retrieve printer width, using default", e);
            }

            isInitialized = true;
            return SdkResult.SDK_OK;

        } catch (Exception e) {
            Log.e(TAG, "Error initializing printer", e);
            return ERROR_GENERAL_EXCEPTION;
        }
    }

    public int printNow(byte[] imageData) {
        if (imageData == null || imageData.length == 0) {
            Log.e(TAG, "Invalid image data");
            return ERROR_INVALID_INPUT;
        }

        if (!isInitialized) {
            int result = initializePrinter();
            Log.w(TAG, "Result when initializing printer: " + result);
            if (result != SdkResult.SDK_OK) return result;
            if (printerWidth <= 0) {
                Log.e(TAG, "Printer width is invalid or not initialized.");
                return ERROR_PRINTER_WIDTH_UNKNOWN;
            }
        }

        try (InputStream inputStream = new ByteArrayInputStream(imageData)) {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inScaled = false; // Disable scaling during decoding
            Bitmap bitmap = BitmapFactory.decodeStream(inputStream, null, options);

            if (bitmap == null) {
                Log.e(TAG, "Failed to decode image");
                return ERROR_BITMAP_DECODE;
            }

            // Process in correct order:
            // 1. Convert to grayscale first
            Bitmap grayscaleBitmap = toGrayscale(bitmap);
            bitmap.recycle(); // Recycle original

            // 2. Resize if needed
            Bitmap resizedBitmap = downscaleBitmap(grayscaleBitmap, printerWidth);
            if (resizedBitmap != grayscaleBitmap) {
                grayscaleBitmap.recycle();
            }

            // 3. Apply dithering to create 1-bit black and white image
            Bitmap ditheredBitmap;
            switch (ditheringMethod) {
                case ORDERED_DITHERING:
                    ditheredBitmap = applyOrderedDithering(resizedBitmap);
                    break;
                case ATKINSON_DITHERING:
                    ditheredBitmap = applyAtkinsonDithering(resizedBitmap);
                    break;
                case THRESHOLD_DITHERING:
                    ditheredBitmap = applyThresholdDithering(resizedBitmap);
                    break;
                case QR_CODE_OPTIMIZED:
                    ditheredBitmap = applyQRCodeOptimizedDithering(resizedBitmap);
                    break;
                case FLOYD_STEINBERG_DITHERING:
                default:
                    ditheredBitmap = applyFloydSteinbergDithering(resizedBitmap);
                    break;
            }
            resizedBitmap.recycle();

            if (mPrinter == null) {
                Log.e(TAG, "Printer not initialized properly");
                ditheredBitmap.recycle();
                return ERROR_DEVICE_CONNECTION;
            }

            int status = mPrinter.getPrinterStatus();
            if (status == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Out of paper before printing");
                ditheredBitmap.recycle();
                return status;
            }

            PrnStrFormat format = new PrnStrFormat();
            mPrinter.setPrintAppendBitmap(ditheredBitmap, Layout.Alignment.ALIGN_CENTER);
            // Add some space after the image
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            int printResult = mPrinter.setPrintStart();
            ditheredBitmap.recycle();

            if (printResult == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Paper out during print");
            } else if (printResult != SdkResult.SDK_PRN_STATUS_PRINTING) {
                Log.e(TAG, "Printing failed with status: " + printResult);
            } else {
                Log.i(TAG, "Printing started successfully");
            }

            return printResult;

        } catch (IOException e) {
            Log.e(TAG, "IO error during printing", e);
            return ERROR_GENERAL_EXCEPTION;
        } catch (Exception e) {
            Log.e(TAG, "Unexpected error during printing", e);
            return ERROR_GENERAL_EXCEPTION;
        }
    }

    private Bitmap downscaleBitmap(Bitmap bitmap, int printerWidth) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        if (width <= printerWidth) {
            return bitmap; // No need to downscale
        }

        float scaleFactor = (float) printerWidth / (float) width;
        int newHeight = (int) (height * scaleFactor);

        Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, printerWidth, newHeight, true);
        return scaledBitmap;
    }

    public static Bitmap toGrayscale(Bitmap bmpOriginal) {
        int width = bmpOriginal.getWidth();
        int height = bmpOriginal.getHeight();

        Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmpGrayscale);

        // Create custom color matrix for enhanced contrast grayscale
        // Uses the BT.709 luminance formula for better human perception
        // R: 0.2126, G: 0.7152, B: 0.0722
        ColorMatrix cm = new ColorMatrix(new float[] {
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0,       0,       0,       1, 0
        });

        // Add contrast boost for better printing
        ColorMatrix contrastMatrix = new ColorMatrix();
        float contrast = 1.4f; // Boost contrast by 40% (increased from 20%)
        float intercept = (-.5f * contrast + .5f) * 255f;

        contrastMatrix.set(new float[] {
                contrast, 0, 0, 0, intercept,
                0, contrast, 0, 0, intercept,
                0, 0, contrast, 0, intercept,
                0, 0, 0, 1, 0
        });

        // Apply both matrices
        cm.postConcat(contrastMatrix);

        Paint paint = new Paint();
        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        c.drawBitmap(bmpOriginal, 0, 0, paint);
        return bmpGrayscale;
    }

    /**
     * Floyd-Steinberg dithering algorithm - distributes error to neighboring pixels
     * Good for photographs and complex images
     */
    private Bitmap applyFloydSteinbergDithering(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Create a mutable copy of the bitmap
        Bitmap output = bitmap.copy(bitmap.getConfig(), true);

        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);

        // Apply Floyd-Steinberg dithering
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int index = y * width + x;
                int oldPixel = pixels[index];
                int oldR = Color.red(oldPixel);

                // For 1-bit output, we only care about the intensity
                int newR = (oldR < 128) ? 0 : 255;
                int newPixel = Color.rgb(newR, newR, newR);
                pixels[index] = newPixel;

                // Calculate error
                int error = oldR - newR;

                // Distribute error to neighboring pixels
                if (x + 1 < width) {
                    int rightIndex = index + 1;
                    int rightPixel = pixels[rightIndex];
                    int rightR = Color.red(rightPixel) + (error * 7) / 16;
                    rightR = Math.max(0, Math.min(255, rightR));
                    pixels[rightIndex] = Color.rgb(rightR, rightR, rightR);
                }

                if (y + 1 < height) {
                    // Bottom left
                    if (x > 0) {
                        int bottomLeftIndex = index + width - 1;
                        int bottomLeftPixel = pixels[bottomLeftIndex];
                        int bottomLeftR = Color.red(bottomLeftPixel) + (error * 3) / 16;
                        bottomLeftR = Math.max(0, Math.min(255, bottomLeftR));
                        pixels[bottomLeftIndex] = Color.rgb(bottomLeftR, bottomLeftR, bottomLeftR);
                    }

                    // Bottom
                    int bottomIndex = index + width;
                    int bottomPixel = pixels[bottomIndex];
                    int bottomR = Color.red(bottomPixel) + (error * 5) / 16;
                    bottomR = Math.max(0, Math.min(255, bottomR));
                    pixels[bottomIndex] = Color.rgb(bottomR, bottomR, bottomR);

                    // Bottom right
                    if (x + 1 < width) {
                        int bottomRightIndex = index + width + 1;
                        int bottomRightPixel = pixels[bottomRightIndex];
                        int bottomRightR = Color.red(bottomRightPixel) + (error * 1) / 16;
                        bottomRightR = Math.max(0, Math.min(255, bottomRightR));
                        pixels[bottomRightIndex] = Color.rgb(bottomRightR, bottomRightR, bottomRightR);
                    }
                }
            }
        }

        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    /**
     * Ordered dithering using a Bayer matrix
     * Good for text and line art
     */
    private Bitmap applyOrderedDithering(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // 4x4 Bayer matrix for ordered dithering
        int[][] bayerMatrix = {
                {0, 8, 2, 10},
                {12, 4, 14, 6},
                {3, 11, 1, 9},
                {15, 7, 13, 5}
        };

        // Create a mutable copy of the bitmap
        Bitmap output = bitmap.copy(bitmap.getConfig(), true);

        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);

        // Apply ordered dithering
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int index = y * width + x;
                int pixel = pixels[index];
                int gray = Color.red(pixel); // We only need one channel since it's grayscale

                // Apply threshold based on Bayer matrix
                int threshold = bayerMatrix[y % 4][x % 4] * 16;
                int newValue = (gray > threshold) ? 255 : 0;

                pixels[index] = Color.rgb(newValue, newValue, newValue);
            }
        }

        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    /**
     * Atkinson dithering - better for text and UI elements
     * Less error diffusion than Floyd-Steinberg
     */
    private Bitmap applyAtkinsonDithering(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Create a mutable copy of the bitmap
        Bitmap output = bitmap.copy(bitmap.getConfig(), true);

        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);

        // For each pixel
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int index = y * width + x;
                int oldPixel = pixels[index];
                int oldR = Color.red(oldPixel);

                // Threshold to get binary pixel value
                int newR = (oldR < 128) ? 0 : 255;
                pixels[index] = Color.rgb(newR, newR, newR);

                // Calculate error
                int error = (oldR - newR) / 8; // Divide by 8 for Atkinson

                // Distribute error to neighboring pixels (Atkinson pattern)
                // Right
                if (x + 1 < width)
                    updatePixel(pixels, index + 1, error, width);

                // Right+Right
                if (x + 2 < width)
                    updatePixel(pixels, index + 2, error, width);

                // Bottom-Left
                if (x - 1 >= 0 && y + 1 < height)
                    updatePixel(pixels, index + width - 1, error, width);

                // Bottom
                if (y + 1 < height)
                    updatePixel(pixels, index + width, error, width);

                // Bottom-Right
                if (x + 1 < width && y + 1 < height)
                    updatePixel(pixels, index + width + 1, error, width);

                // Bottom+Bottom
                if (y + 2 < height)
                    updatePixel(pixels, index + width + width, error, width);
            }
        }

        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    private void updatePixel(int[] pixels, int index, int error, int width) {
        int pixel = pixels[index];
        int r = Color.red(pixel) + error;
        r = Math.max(0, Math.min(255, r));
        pixels[index] = Color.rgb(r, r, r);
    }

    /**
     * Simple threshold dithering - creates sharper edges
     * Good for text and simple graphics
     */
    private Bitmap applyThresholdDithering(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Create a mutable copy of the bitmap
        Bitmap output = bitmap.copy(bitmap.getConfig(), true);

        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);

        // Apply simple threshold
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int index = y * width + x;
                int pixel = pixels[index];
                int gray = Color.red(pixel); // We only need one channel since it's grayscale

                // Apply fixed threshold
                int newValue = (gray > 127) ? 255 : 0;

                pixels[index] = Color.rgb(newValue, newValue, newValue);
            }
        }

        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    /**
     * Optimized dithering specifically for QR codes and text
     * Uses local contrast enhancement and adaptive thresholding
     */
    private Bitmap applyQRCodeOptimizedDithering(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Create a mutable copy of the bitmap
        Bitmap output = bitmap.copy(bitmap.getConfig(), true);

        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);

        // First pass: contrast enhancement
        enhanceContrast(pixels, width, height);

        // Apply text sharpening if enabled
        if (enhanceTextReadability) {
            sharpenText(pixels, width, height);
        }

        // Window size for adaptive thresholding - smaller window for sharper text
        int windowSize = 3; // Reduced from 5 for sharper text edges

        // Second pass: adaptive thresholding
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                int index = y * width + x;
                int centerPixel = Color.red(pixels[index]);

                // Calculate local average within window
                int sum = 0;
                int count = 0;

                for (int wy = Math.max(0, y - windowSize/2); wy < Math.min(height, y + windowSize/2 + 1); wy++) {
                    for (int wx = Math.max(0, x - windowSize/2); wx < Math.min(width, x + windowSize/2 + 1); wx++) {
                        sum += Color.red(pixels[wy * width + wx]);
                        count++;
                    }
                }

                int average = sum / count;

                // Apply threshold with a bias for better text preservation
                // Increased bias for better text preservation
                int threshold = average - 10; // Increased from -5 for better text clarity

                // Apply a more aggressive threshold for text-like patterns
                if (isLikelyText(pixels, x, y, width, height)) {
                    threshold -= 5; // Further reduce threshold for text
                }

                int newValue = (centerPixel > threshold) ? 255 : 0;
                pixels[index] = Color.rgb(newValue, newValue, newValue);
            }
        }

        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    /**
     * Heuristic to detect if a pixel is likely part of text
     * Looks for high local contrast which is typical of text
     */
    private boolean isLikelyText(int[] pixels, int x, int y, int width, int height) {
        // Skip edge pixels
        if (x < 2 || y < 2 || x >= width - 2 || y >= height - 2) {
            return false;
        }

        // Check local contrast in a small area
        int center = Color.red(pixels[y * width + x]);
        int count = 0;

        // Check 8 surrounding pixels
        for (int dy = -1; dy <= 1; dy++) {
            for (int dx = -1; dx <= 1; dx++) {
                if (dx == 0 && dy == 0) continue;

                int neighbor = Color.red(pixels[(y + dy) * width + (x + dx)]);
                if (Math.abs(center - neighbor) > 50) { // High local contrast
                    count++;
                }
            }
        }

        // If at least 3 surrounding pixels have high contrast, likely text
        return count >= 3;
    }

    /**
     * Applies a sharpening filter to improve text clarity
     */
    private void sharpenText(int[] pixels, int width, int height) {
        // Create a copy of the pixels array
        int[] original = pixels.clone();

        // Sharpening kernel
        // Center value is 1 + 4*amount, corners are -amount, edges are -amount
        float amount = textSharpness / 100.0f;

        // Skip the edges to avoid array bounds issues
        for (int y = 1; y < height - 1; y++) {
            for (int x = 1; x < width - 1; x++) {
                int index = y * width + x;

                // Apply sharpening kernel
                float sum = original[index] * (1 + 4 * amount)
                          - original[(y-1) * width + x] * amount
                          - original[(y+1) * width + x] * amount
                          - original[y * width + (x-1)] * amount
                          - original[y * width + (x+1)] * amount;

                // Clamp to valid range
                pixels[index] = Color.rgb(
                    Math.max(0, Math.min(255, (int)sum)),
                    Math.max(0, Math.min(255, (int)sum)),
                    Math.max(0, Math.min(255, (int)sum))
                );
            }
        }
    }

    /**
     * Enhances contrast to make dark pixels darker and light pixels lighter
     * This improves QR code and text readability
     */
    private void enhanceContrast(int[] pixels, int width, int height) {
        // Find min and max values
        int min = 255;
        int max = 0;

        for (int i = 0; i < pixels.length; i++) {
            int gray = Color.red(pixels[i]);
            if (gray < min) min = gray;
            if (gray > max) max = gray;
        }

        // Calculate contrast enhancement factor based on settings
        int contrastFactor = enhanceTextReadability ? textContrast : 20;

        // Apply contrast enhancement
        for (int i = 0; i < pixels.length; i++) {
            int gray = Color.red(pixels[i]);

            // Apply non-linear contrast enhancement
            // This formula emphasizes the difference between light and dark areas
            int newGray;
            if (gray < 128) {
                newGray = gray - (gray * contrastFactor / 100);  // Make dark pixels darker
            } else {
                newGray = gray + ((255 - gray) * contrastFactor / 100);  // Make light pixels lighter
            }

            newGray = Math.max(0, Math.min(255, newGray));
            pixels[i] = Color.rgb(newGray, newGray, newGray);
        }
    }
}