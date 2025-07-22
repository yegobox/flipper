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
import java.util.Objects;

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

    private PrinterService() {}

    public static synchronized PrinterService getInstance() {
        if (instance == null) {
            instance = new PrinterService();
        }
        return instance;
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

            if (status != Printer.PRINTER_NORMAL) {
                Log.e(TAG, "Printer not in normal state");
                return ERROR_PRINTER_POWER;
            }

            try {
                printerWidth = 384; // Standard for 58mm printers
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
            if (result != SdkResult.SDK_OK) return result;
            if (printerWidth <= 0) {
                Log.e(TAG, "Printer width is invalid or not initialized.");
                return ERROR_PRINTER_WIDTH_UNKNOWN;
            }
        }

        try (InputStream inputStream = new ByteArrayInputStream(imageData)) {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inPreferredConfig = Bitmap.Config.ARGB_8888;
            options.inScaled = false;
            
            Bitmap bitmap = BitmapFactory.decodeStream(inputStream, null, options);
            if (bitmap == null) {
                Log.e(TAG, "Failed to decode image");
                return ERROR_BITMAP_DECODE;
            }

            // 1. Resize to printer width
            Bitmap resizedBitmap = resizeToPrinterWidth(bitmap, printerWidth);
            bitmap.recycle();

            // 2. Convert to optimized grayscale for thermal printing
            Bitmap grayscaleBitmap = toThermalOptimizedGrayscale(resizedBitmap);
            resizedBitmap.recycle();

            // 3. Apply optimized dithering for thermal printers
            Bitmap thresholded = applyThermalOptimizedThreshold(grayscaleBitmap);
            grayscaleBitmap.recycle();

            if (mPrinter == null) {
                thresholded.recycle();
                return ERROR_DEVICE_CONNECTION;
            }

            // Add slight delay to prevent freezing
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            PrnStrFormat format = new PrnStrFormat();
            int printResult = mPrinter.setPrintAppendBitmap(thresholded, Layout.Alignment.ALIGN_CENTER);
            
            if (printResult != SdkResult.SDK_OK) {
                Log.e(TAG, "Failed to append bitmap: " + printResult);
                thresholded.recycle();
                return printResult;
            }

            printResult = mPrinter.setPrintAppendString(" ", format);
            if (printResult != SdkResult.SDK_OK) {
                Log.e(TAG, "Failed to append space: " + printResult);
                thresholded.recycle();
                return printResult;
            }

            printResult = mPrinter.setPrintStart();
            thresholded.recycle();
            
            return printResult;
        } catch (IOException e) {
            Log.e(TAG, "IO error during printing", e);
            return ERROR_GENERAL_EXCEPTION;
        } catch (Exception e) {
            Log.e(TAG, "Unexpected error during printing", e);
            return ERROR_GENERAL_EXCEPTION;
        }
    }

    // Optimized grayscale conversion for thermal printers
    private Bitmap toThermalOptimizedGrayscale(Bitmap bmpOriginal) {
        int width = bmpOriginal.getWidth();
        int height = bmpOriginal.getHeight();
        Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmpGrayscale);
        
        // Custom color matrix for thermal printer optimization
        // Uses BT.709 luminance with slight contrast enhancement
        ColorMatrix cm = new ColorMatrix(new float[] {
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0.2126f, 0.7152f, 0.0722f, 0, 0,
                0,       0,       0,       1, 0
        });
        
        // Add slight contrast enhancement
        float contrast = 1.2f;
        float scale = contrast;
        float translate = (-0.5f * contrast + 0.5f) * 255f;
        cm.postConcat(new ColorMatrix(new float[] {
                scale, 0, 0, 0, translate,
                0, scale, 0, 0, translate,
                0, 0, scale, 0, translate,
                0, 0, 0, 1, 0
        }));

        Paint paint = new Paint();
        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        c.drawBitmap(bmpOriginal, 0, 0, paint);
        return bmpGrayscale;
    }

    // Resize to printer width if needed
    private Bitmap resizeToPrinterWidth(Bitmap bitmap, int printerWidth) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        if (width <= printerWidth) return bitmap;
        
        float scale = (float) printerWidth / width;
        int newHeight = (int) (height * scale);
        return Bitmap.createScaledBitmap(bitmap, printerWidth, newHeight, true);
    }

    // Optimized thresholding for thermal printers
    private Bitmap applyThermalOptimizedThreshold(Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        Bitmap output = bitmap.copy(Objects.requireNonNull(bitmap.getConfig()), true);
        
        int[] pixels = new int[width * height];
        output.getPixels(pixels, 0, width, 0, 0, width, height);
        
        // Calculate adaptive threshold
        int threshold = calculateAdaptiveThreshold(pixels, width, height);
        
        // Apply threshold with slight bias for better readability
        threshold = (int)(threshold * 0.9); // Makes it slightly more sensitive to dark pixels
        
        for (int i = 0; i < pixels.length; i++) {
            int gray = Color.red(pixels[i]);
            int bw = (gray > threshold) ? 255 : 0;
            pixels[i] = Color.rgb(bw, bw, bw);
        }
        
        output.setPixels(pixels, 0, width, 0, 0, width, height);
        return output;
    }

    // Calculate adaptive threshold using Otsu's method
    private int calculateAdaptiveThreshold(int[] pixels, int width, int height) {
        // Calculate histogram
        int[] histogram = new int[256];
        for (int pixel : pixels) {
            int gray = Color.red(pixel);
            histogram[gray]++;
        }

        // Otsu's threshold algorithm
        int total = width * height;
        float sum = 0;
        for (int i = 0; i < 256; i++) {
            sum += i * histogram[i];
        }

        float sumB = 0;
        int wB = 0;
        int wF = 0;
        float varMax = 0;
        int threshold = 0;

        for (int i = 0; i < 256; i++) {
            wB += histogram[i];
            if (wB == 0) continue;
            
            wF = total - wB;
            if (wF == 0) break;
            
            sumB += (float) (i * histogram[i]);
            
            float mB = sumB / wB;
            float mF = (sum - sumB) / wF;
            
            float varBetween = (float) wB * (float) wF * (mB - mF) * (mB - mF);
            
            if (varBetween > varMax) {
                varMax = varBetween;
                threshold = i;
            }
        }
        
        return threshold;
    }
}