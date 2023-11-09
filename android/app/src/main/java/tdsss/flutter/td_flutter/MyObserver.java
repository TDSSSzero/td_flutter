package tdsss.flutter.td_flutter;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;

public class MyObserver implements DefaultLifecycleObserver {

    String TAG = "lifecycle";

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        DefaultLifecycleObserver.super.onCreate(owner);
        Log.e(TAG, "onCreate: " );
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        Log.w(TAG, "onStart: " );
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        Log.i(TAG, "onResume: ");
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        Log.i(TAG, "onPause: ");
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        Log.w(TAG, "onStop: " );
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        Log.e(TAG, "onDestroy: " );
    }

}
