package com.printer;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.text.Layout; // Consider environmental compatibility

import androidx.annotation.Keep;

import com.zcs.sdk.DriverManager;
import com.zcs.sdk.SdkResult;
import com.zcs.sdk.print.PrnStrFormat;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;


@Keep
public class PrinterService {

    private static final Logger LOGGER = Logger.getLogger(PrinterService.class.getName());

    public int printNow(String path) {
        DriverManager mDriverManager = DriverManager.getInstance();
        com.zcs.sdk.Printer mPrinter = mDriverManager.getPrinter();
        LOGGER.info("Printing from path: " + path);

        int printStatus = mPrinter.getPrinterStatus();
        if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
            LOGGER.warning("Printer is out of paper.");
            return printStatus; // Or a specific error code
        }

        InputStream inputStream = null;
        try {
            inputStream = new FileInputStream(new File(path));
            Drawable drawable = Drawable.createFromStream(inputStream, null);
            if (drawable == null) {
                LOGGER.severe("Could not create Drawable from stream.  Invalid image or file not found: " + path);
                return -1; // Or a specific error code
            }

            Bitmap mBitmapDef = ((BitmapDrawable) drawable).getBitmap();
            if (mBitmapDef == null) {
                LOGGER.severe("Could not get Bitmap from Drawable.  Possibly invalid image format: " + path);
                return -1; // Or a specific error code
            }

            PrnStrFormat format = new PrnStrFormat();
            mPrinter.setPrintAppendBitmap(mBitmapDef, Layout.Alignment.ALIGN_CENTER); //Consider environment
            mPrinter.setPrintAppendString(" ", format); // Redundant?  Consider removing
            mPrinter.setPrintAppendString(" ", format); // Redundant?  Consider removing
            mPrinter.setPrintAppendString(" ", format); // Redundant?  Consider removing

            printStatus = mPrinter.setPrintStart();

            if (printStatus == SdkResult.SDK_PRN_STATUS_PAPEROUT) {
                LOGGER.warning("Paper out during printing.");
                // send pubnub message to paper channel (Implement this)
            }

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "IOException while printing from: " + path, e);
            printStatus = -1;  // Or a specific error code
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    LOGGER.log(Level.WARNING, "Error closing input stream for: " + path, e);
                }
            }
        }

        return printStatus;
    }
}