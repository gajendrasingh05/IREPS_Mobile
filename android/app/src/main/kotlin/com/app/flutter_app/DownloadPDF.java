package com.app.flutter_app;

import android.annotation.TargetApi;
import android.app.DownloadManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import static android.content.ContentValues.TAG;

@TargetApi(Build.VERSION_CODES.CUPCAKE)
public class DownloadPDF
{
   private static PasswordEncoder instance;
   static Context context;
   static ProgressDialog  progressDialog;
   static String downloadUrl,filename;
   static File outputFile;
    private final static int ITERATION_COUNT = 5;

    DownloadPDF()     {
    }

    public static String download(String input, Context context1)throws NoSuchAlgorithmException, IOException    {
       filename = input.split("#")[0];
       downloadUrl  = input.split("#")[1];
       context=context1;
       try {
            new DownloadingTask().execute();
        } catch (Exception e) {
            return "not successfull";
        }
        return outputFile.getAbsolutePath().toString();
    }

    private static class DownloadingTask extends AsyncTask<Void, Void, Void> {
        File apkStorage = null;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = new ProgressDialog(context);
        }

        @Override
        protected void onPostExecute(Void result) {
            try {
                if (outputFile != null) {
                    progressDialog.dismiss();
                    Log.e("Downloading","Downloading");
                    Toast.makeText(context, "Downloading...", Toast.LENGTH_SHORT).show();
                } else {
                    new Handler().postDelayed(new Runnable() {
                        @Override
                        public void run() {

                        }
                    }, 3000);
                    Log.e(TAG, "Download Failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                //Change button text if exception occurs
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {

                    }
                }, 3000);
                Log.e(TAG, "Download Failed with Exception - " + e.getLocalizedMessage());
            }
            super.onPostExecute(result);
        }

        @TargetApi(Build.VERSION_CODES.HONEYCOMB)
        @Override
        protected Void doInBackground(Void... arg0) {
            try {
                DownloadManager downloadManager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
                android.net.Uri uri = android.net.Uri.parse(downloadUrl);
                DownloadManager.Request request = new DownloadManager.Request(uri);
                request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
                //Creating folder in downloads
                request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS.toString() + "/AAPOORTI", filename);
                //Set the title of this download, to be displayed in notifications.
                filename = filename.replace("/", "");
                request.setTitle(filename);
                Long reference = downloadManager.enqueue(request);
                apkStorage = new File(Environment.DIRECTORY_DOWNLOADS.toString(), "IREPS");
                Log.e("bknkn",apkStorage+"storage");
                outputFile = new File(apkStorage, filename);
            } catch (Exception e) {
                //Read exception if something went wrong
                e.printStackTrace();
                outputFile = null;
                Log.e(TAG, "Download Error Exception " + e.getMessage());
            }
            return null;
        }
    }
}