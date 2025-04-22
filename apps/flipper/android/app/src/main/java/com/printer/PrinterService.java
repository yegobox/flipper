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

    private static PrinterService instance;
    private Printer mPrinter;
    private boolean isInitialized = false;

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
        }

        try (InputStream inputStream = new ByteArrayInputStream(imageData)) {

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inScaled = false;
            Bitmap bitmap = BitmapFactory.decodeStream(inputStream, null, options);

            if (bitmap == null) {
                Log.e(TAG, "Failed to decode image");
                return ERROR_BITMAP_DECODE;
            }

            bitmap = toGrayscale(bitmap);

            if (mPrinter == null) {
                Log.e(TAG, "Printer not initialized properly");
                return ERROR_DEVICE_CONNECTION;
            }

            int status = mPrinter.getPrinterStatus();
            if (status == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                Log.w(TAG, "Out of paper before printing");
                return status;
            }

            PrnStrFormat format = new PrnStrFormat();
            mPrinter.setPrintAppendBitmap(bitmap, Layout.Alignment.ALIGN_CENTER);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);
            mPrinter.setPrintAppendString(" ", format);

            int printResult = mPrinter.setPrintStart();

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
