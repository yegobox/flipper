package com.printer;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
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
    private static final int ERROR_PRINTER_WIDTH_UNKNOWN = -5; //Added error code

    private static PrinterService instance;
    private Printer mPrinter;
    private boolean isInitialized = false;
    private int printerWidth = 384; // Default width, adjust as needed. Set a safe default.

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

            // Attempt to get printer width, handle potential errors gracefully
            try {
                // Replace this with the actual method to get the printer width
                // This is a placeholder as the ZCS SDK's method might be different
                // printerWidth = mPrinter.getPrinterPaperWidth(); // Example - Adapt to your SDK!
                // Log.i(TAG, "Printer width: " + printerWidth);

                //IMPORTANT: Set the printer width in dp here. You might need to use a formula to convert from mm/inches.
                //Example: 58mm = 384dp on many ZCS printers.  Check your device's documentation.
                printerWidth = 384; // Set your printer width in dots/pixels here.
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
                return ERROR_PRINTER_WIDTH_UNKNOWN; //Handle cases where we cannot determine width
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

            // Downscale the bitmap to the printer's width
            bitmap = downscaleBitmap(bitmap, printerWidth);

            // Convert to grayscale *after* downscaling to reduce memory footprint
            Bitmap grayscaleBitmap = toGrayscale(bitmap);

            // Recycle the original bitmap as it's no longer needed
            bitmap.recycle();
            bitmap = null; // Help GC

            if (mPrinter == null) {
                Log.e(TAG, "Printer not initialized properly");
                return ERROR_DEVICE_CONNECTION;
            }

            int status = mPrinter.getPrinterStatus();
            if (status == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Out of paper before printing");
                grayscaleBitmap.recycle();
                grayscaleBitmap = null;
                return status;
            }

            PrnStrFormat format = new PrnStrFormat();
            mPrinter.setPrintAppendBitmap(grayscaleBitmap, Layout.Alignment.ALIGN_CENTER);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            int printResult = mPrinter.setPrintStart();

            // Recycle the grayscale bitmap *after* printing is initiated!  Crucial.
            grayscaleBitmap.recycle();
            grayscaleBitmap = null;

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
        } finally {
            // Ensure bitmaps are recycled even if exceptions occur.  Defensive coding.
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
        if (scaledBitmap != bitmap) {  //Only recycle if it is a new bitmap.  Important!
            bitmap.recycle(); // Recycle the original if a new bitmap was created
        }

        return scaledBitmap;
    }

    public static Bitmap toGrayscale(Bitmap bmpOriginal) {
        int width = bmpOriginal.getWidth();
        int height = bmpOriginal.getHeight();

        Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmpGrayscale);
        Paint paint = new Paint();
        ColorMatrix cm = new ColorMatrix();
        cm.setSaturation(0);
        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        c.drawBitmap(bmpOriginal, 0, 0, paint);
        return bmpGrayscale;
    }
}