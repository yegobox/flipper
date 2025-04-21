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
    private static final int ERROR_DEVICE_CONNECTION = -1001; // Device connection error
    private static final int ERROR_PRINTER_POWER = -4; // Printer power issue

    // Singleton instance
    private static PrinterService instance;
    private Printer mPrinter;
    private boolean isInitialized = false;

    // Private constructor for singleton
    private PrinterService() {
        // Prevent instantiation
    }

    // Get singleton instance
    public static synchronized PrinterService getInstance() {
        if (instance == null) {
            instance = new PrinterService();
        }
        return instance;
    }

    /**
     * Initialize the printer. Call this method once when your app starts.
     * @return status code: 0 for success, or an error code
     */
    public int initializePrinter() {
        try {
            DriverManager mDriverManager = DriverManager.getInstance();
            if (mDriverManager == null) {
                Log.e(TAG, "Failed to get DriverManager instance");
                isInitialized = false;
                return ERROR_DEVICE_CONNECTION;
            }

            mPrinter = mDriverManager.getPrinter();
            if (mPrinter == null) {
                Log.e(TAG, "Failed to get Printer instance");
                isInitialized = false;
                return ERROR_DEVICE_CONNECTION;
            }

            // Wake up the printer
            int wakePrinter = mPrinter.getPrinterStatus();
            Log.i(TAG, "Wake printer result: " + wakePrinter);

            // Initialize the printer
            int initResult = mPrinter.getPrinterStatus();
            if (initResult != SdkResult.SDK_OK) {
                    Log.e(TAG, "Failed to initialize printer: " + initResult);
                isInitialized = false;
                return initResult;
            }

            // Check printer status after initialization
            int printerStatus = mPrinter.getPrinterStatus();
            if (printerStatus != SdkResult.SDK_OK) {
                Log.w(TAG, "Printer initialized but status is not OK: " + printerStatus);
            }

            isInitialized = true;
            Log.i(TAG, "Printer successfully initialized");
            return SdkResult.SDK_OK;
        } catch (Exception e) {
            Log.e(TAG, "Exception during printer initialization", e);
            isInitialized = false;
            return ERROR_GENERAL_EXCEPTION;
        }
    }

    /**
     * Prints an image from byte array data
     *
     * @param imageData The byte array containing image data
     * @return Status code: 0 for success, or an error code
     */
    public int printNow(byte[] imageData) {
        if (imageData == null || imageData.length == 0) {
            Log.e(TAG, "imageData is null or empty");
            return ERROR_INVALID_INPUT;
        }

        // Check if printer is initialized
        if (!isInitialized) {
            Log.w(TAG, "Printer not initialized. Attempting to initialize now.");
            int initResult = initializePrinter();
            if (initResult != SdkResult.SDK_OK) {
                return initResult;
            }
        }

        if (DEBUG) Log.i(TAG, "Printing from byte array (length: " + imageData.length + ")");

        // Check printer status before proceeding
        int printerStatus = mPrinter.getPrinterStatus();
        if (printerStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            Log.w(TAG, "Printer is out of paper.");
            return printerStatus;
        }

        InputStream inputStream = null;
        Bitmap mBitmapDef = null;
        try {
            inputStream = new ByteArrayInputStream(imageData);

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inScaled = false;

            mBitmapDef = BitmapFactory.decodeStream(inputStream, null, options);

            if (mBitmapDef == null) {
                Log.e(TAG, "Could not decode Bitmap from byte array. Invalid image format or corrupted data.");
                return ERROR_BITMAP_DECODE;
            }

            if (DEBUG) {
                Log.i(TAG, "Bitmap width: " + mBitmapDef.getWidth() + ", height: " + mBitmapDef.getHeight());
                Log.i(TAG, "Bitmap config: " + mBitmapDef.getConfig());
            }

            // Convert to monochrome (grayscale)
            mBitmapDef = toGrayscale(mBitmapDef);
            if (DEBUG) Log.i(TAG, "Bitmap converted to grayscale");

            // Configure print format
            PrnStrFormat format = new PrnStrFormat();

            // Append the bitmap to the print buffer
            mPrinter.setPrintAppendBitmap(mBitmapDef, Layout.Alignment.ALIGN_CENTER);
            if (DEBUG) Log.i(TAG, "setPrintAppendBitmap called");

            // Add empty lines for paper feed - IMPORTANT: This is what the working Kotlin code does
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            // Check printer status after append operation
            printerStatus = mPrinter.getPrinterStatus();
            if (printerStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Printer is out of paper before printing.");
                return printerStatus;
            }

            // Check paper status again before printing
            int statusBeforePrint = mPrinter.getPrinterStatus();
            if (statusBeforePrint == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Printer is out of paper before printing.");
                return statusBeforePrint;
            }

            // Start the print job
            int printStatus = mPrinter.setPrintStart();
            if (DEBUG) Log.i(TAG, "setPrintStart status: " + printStatus);

            // Check for successful printing - using the exact same success condition as Kotlin code
            if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Paper out during printing.");
            } else if (printStatus != SdkResult.SDK_PRN_STATUS_PRINTING) {
                // This is how the Kotlin code checks for success
                Log.e(TAG, "Printing failed with status: " + printStatus);
            } else {
                Log.i(TAG, "Printing started successfully");
            }

            return printStatus;

        } catch (Exception e) {
            Log.e(TAG, "Exception while printing from byte array", e);
            return ERROR_GENERAL_EXCEPTION;
        } finally {
            // Clean up resources
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    Log.w(TAG, "Error closing input stream", e);
                }
            }
            if (mBitmapDef != null && !mBitmapDef.isRecycled()) {
                mBitmapDef.recycle();
            }
        }
    }

    /**
     * Converts a bitmap to grayscale
     *
     * @param bmpOriginal The original bitmap
     * @return A new grayscale bitmap
     */
    public static Bitmap toGrayscale(Bitmap bmpOriginal) {
        int width = bmpOriginal.getWidth();
        int height = bmpOriginal.getHeight();

        Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmpGrayscale);
        Paint paint = new Paint();
        ColorMatrix cm = new ColorMatrix();
        cm.setSaturation(0);
        ColorMatrixColorFilter f = new ColorMatrixColorFilter(cm);
        paint.setColorFilter(f);
        c.drawBitmap(bmpOriginal, 0, 0, paint);
        return bmpGrayscale;
    }
}