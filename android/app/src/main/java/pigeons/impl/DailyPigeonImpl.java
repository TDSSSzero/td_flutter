package pigeons.impl;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.MediaRecorder;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;
import java.io.IOException;

import pigeons.DailyPigeon;
import tdsss.flutter.td_flutter.MainActivity;
import tdsss.flutter.td_flutter.common.Constants;

public class DailyPigeonImpl implements DailyPigeon.DailyPigeonApi {

    String TAG = "flutter";

    private MainActivity activity;
    private final String[] permissions = {Manifest.permission.RECORD_AUDIO};

    private PerCallback callback;

    private MediaRecorder mediaRecorder;
    private boolean isStartRecord = false;

    public DailyPigeonImpl(MainActivity activity){
        this.activity = activity;
    }

    @NonNull
    @Override
    public Boolean requestRecordPermission() {
        boolean isGranted = false;
        isGranted = PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(activity,permissions[0]);
        if (isGranted){
            return true;
        }else{
            ActivityCompat.requestPermissions(activity,permissions, Constants.requestRecordCode);
            if(callback != null){
                int res = callback.getPermissionResult();
                return res == PackageManager.PERMISSION_GRANTED;
            }else{
                return false;
            }
        }

    }

    @NonNull
    @Override
    public Boolean startRecord(@NonNull String savePath) {
        if(mediaRecorder == null && PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(activity,permissions[0])){
            mediaRecorder = new MediaRecorder();
        }
        try {
            /* ②setAudioSource/setVedioSource */
            mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);// 设置麦克风
            /*
             * ②设置输出文件的格式：THREE_GPP/MPEG-4/RAW_AMR/Default THREE_GPP(3gp格式
             * ，H263视频/ARM音频编码)、MPEG-4、RAW_AMR(只支持音频且音频编码要求为AMR_NB)
             */
            mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.AAC_ADTS);
            /* ②设置音频文件的编码：AAC/AMR_NB/AMR_MB/Default 声音的（波形）的采样 */
            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
            File file = new File(savePath);
            /* ③准备 */
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                mediaRecorder.setOutputFile(file);
            }
            mediaRecorder.prepare();
            /* ④开始 */
            mediaRecorder.start();
            isStartRecord = true;
        }catch (IOException | IllegalStateException e){
            Log.e("flutter", "error: "+e );
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @NonNull
    @Override
    public Boolean stopRecord() {
        if (mediaRecorder != null){
            if (isStartRecord){
                mediaRecorder.stop();
            }
            mediaRecorder.reset();
            mediaRecorder.release();
            mediaRecorder = null;
        }
        return true;
    }

    @NonNull
    @Override
    public Boolean takePhoto(@NonNull String photoPath) {
        activity.takePhoto(photoPath);
        return true;
    }

    public void release(){
        activity = null;
    }

    public void registerCallback(PerCallback callback){
        this.callback = callback;
    }

    public void unregisterCallback(PerCallback callback){
        if(callback != null){
            this.callback = null;
        }
    }

    public interface PerCallback{
        int getPermissionResult();
    }

}
