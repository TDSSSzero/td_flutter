package tdsss.flutter.td_flutter;

import android.Manifest;
import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.PersistableBundle;
import android.provider.MediaStore;
import android.util.Log;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import com.google.common.util.concurrent.ListenableFuture;
import com.tencent.mmkv.MMKV;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.FileSystem;
import java.util.Random;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import pigeons.DailyPigeon;
import pigeons.impl.DailyPigeonImpl;

public class MainActivity extends FlutterFragmentActivity {

    private DailyPigeonImpl dailyPigeon;
    MyObserver lifecycleObserver = new MyObserver();

    String TAG = "flutter";
    String CHANNEL_LOCATION_ID = "flutter";

    DailyPigeon.DailyCallback callback;

    String tempPath;
    public static final String NOTIFY_PERMISSION = Manifest.permission.POST_NOTIFICATIONS;


    ActivityResultLauncher<String> notifyLauncher = registerForActivityResult(new ActivityResultContracts.RequestPermission(),
            isGranted ->{

            });

    private final ActivityResultLauncher<Intent> photoResultLauncher = registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), result -> {
        if (result.getResultCode() == Activity.RESULT_OK){
            //Log.w(TAG, "onActivityResult: ");
            Intent intent = result.getData();
            if (intent != null){
                Uri uri = intent.getData();
                Log.e(TAG, "uri:"+uri.toString() );
                InputStream inputStream = null;
                FileOutputStream outputStream = null;
                try {
                    inputStream = getContentResolver().openInputStream(uri);
//                    File file = new File(new URI(uri.toString()));
                    String type = uri.toString().substring(uri.toString().lastIndexOf("."));
                    File tempFile = null;
                    String filename = "";
                    if (tempPath!=null){
                        filename = tempPath+type;
                        tempFile = new File(filename);
                        Log.w(TAG, "filename: "+filename );
                    }
//                    inputStream = new FileInputStream(file);
                    outputStream = new FileOutputStream(tempFile);
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    String path = getPath(this,uri);
                    if (callback != null && path != null){
                        callback.onChoicePhoto(filename, reply -> {
                            Log.i(TAG, "photo path: "+path);
                        });
                    }

                } catch (Exception e) {
                    Log.e(TAG, "copy file: "+e );
                } finally {
                    if (inputStream != null){
                        try {
                            inputStream.close();
                        } catch (IOException e) {
                            Log.e(TAG, "inputStream "+e );
                        }
                    }
                    if (outputStream != null){
                        try {
                            outputStream.close();
                        } catch (IOException e) {
                            Log.e(TAG, "outputStream "+e );
                        }
                    }
                }
            }
        }
    });

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        if (intent.getIntExtra("test",-1) == 1){
            callback.onTouchNotification(reply -> {
                Log.w(TAG, "onNewIntent: " );
            });
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        dailyPigeon = new DailyPigeonImpl(this);
        DailyPigeon.DailyPigeonApi.setup(flutterEngine.getDartExecutor().getBinaryMessenger(),dailyPigeon);
        callback = new DailyPigeon.DailyCallback(flutterEngine.getDartExecutor().getBinaryMessenger());
        boolean notifyPer = (ContextCompat.checkSelfPermission(this,NOTIFY_PERMISSION) == PackageManager.PERMISSION_GRANTED);
        if (!notifyPer){
            notifyLauncher.launch(NOTIFY_PERMISSION);
        }
//        new Handler(Looper.getMainLooper()).postDelayed(this::sendNotify,5000);

        if (getIntent().getIntExtra("test",-1) == 1){
            callback.onTouchNotification(reply -> {
                Log.w(TAG, "oncreate callback" );
            });
        }

        String rootPath = MMKV.initialize(this);
        MMKV mmkv = MMKV.mmkvWithID("mindset_mmkv",MMKV.MULTI_PROCESS_MODE,null,getFilesDir()+"/flutter_mmkv/mindset_mmkv");
        Log.e(TAG, "getFilesDir: "+getFilesDir() );


//        new Handler(Looper.getMainLooper()).postDelayed(()->{
//            Log.e(TAG, "mmkv vvvvvvvvvvvvvvvvvvvvvvvv: "+mmkv.decodeInt("init",0) );
//        },5000);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 3){
            if(dailyPigeon != null){
                dailyPigeon.registerCallback(() -> grantResults[0]);
            }
        }
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getLifecycle().addObserver(lifecycleObserver);

    }

    @Override
    protected void onDestroy() {
        dailyPigeon.release();
        getLifecycle().removeObserver(lifecycleObserver);
        super.onDestroy();
    }

    public void takePhoto(String filePath){
        tempPath = filePath;
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        photoResultLauncher.launch(intent);
    }
    private String getPath(Context context, Uri uri) {
        String path = null;
        Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
        if (cursor == null) {
            return null;
        }
        if (cursor.moveToFirst()) {
            try {
                path = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA));
            } catch (Exception e) {
                Log.e(TAG, "getPath: "+e );
            }
        }
        cursor.close();
        return path;
    }
    private void sendNotify(){
        Log.w(TAG, "sendNotify: " );
        int count = new Random().nextInt(100);
        NotificationManager notificationManager = ContextCompat.getSystemService(this, NotificationManager.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_LOCATION_ID, CHANNEL_LOCATION_ID, importance);
            channel.setDescription("test");
            notificationManager.createNotificationChannel(channel);
        }
        //通知的普通点按操作
        Intent intentN = new Intent(this, MainActivity.class);
//        intentN.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);

        intentN.putExtra("test",1);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 202, intentN, PendingIntent.FLAG_IMMUTABLE);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this,CHANNEL_LOCATION_ID)
                .setSmallIcon(R.drawable.launch_background)//发送通知必须指定一个smallIcon，背景需透明
                .setContentTitle("My notification")
                .setContentText("Hello World!"+ count)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setContentIntent(pendingIntent);
        //发送通知，检查权限
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        NotificationManagerCompat.from(this).notify(count, builder.build());
    }
}
