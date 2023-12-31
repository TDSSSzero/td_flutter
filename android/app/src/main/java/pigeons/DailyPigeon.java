// Autogenerated from Pigeon (v10.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package pigeons;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class DailyPigeon {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) 
    {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  protected static ArrayList<Object> wrapError(@NonNull Throwable exception) {
    ArrayList<Object> errorList = new ArrayList<Object>(3);
    if (exception instanceof FlutterError) {
      FlutterError error = (FlutterError) exception;
      errorList.add(error.code);
      errorList.add(error.getMessage());
      errorList.add(error.details);
    } else {
      errorList.add(exception.toString());
      errorList.add(exception.getClass().getSimpleName());
      errorList.add(
        "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    }
    return errorList;
  }
  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface DailyPigeonApi {

    @NonNull 
    Boolean requestRecordPermission();

    @NonNull 
    Boolean startRecord(@NonNull String savePath);

    @NonNull 
    Boolean stopRecord();

    @NonNull 
    Boolean takePhoto(@NonNull String photoPath);

    /** The codec used by DailyPigeonApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**Sets up an instance of `DailyPigeonApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable DailyPigeonApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyPigeonApi.requestRecordPermission", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.requestRecordPermission();
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyPigeonApi.startRecord", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String savePathArg = (String) args.get(0);
                try {
                  Boolean output = api.startRecord(savePathArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyPigeonApi.stopRecord", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Boolean output = api.stopRecord();
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyPigeonApi.takePhoto", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String photoPathArg = (String) args.get(0);
                try {
                  Boolean output = api.takePhoto(photoPathArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class DailyCallback {
    private final @NonNull BinaryMessenger binaryMessenger;

    public DailyCallback(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */ 
    @SuppressWarnings("UnknownNullness")
    public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by DailyCallback. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    public void onChoicePhoto(@NonNull String savePathArg, @NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyCallback.onChoicePhoto", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(savePathArg)),
          channelReply -> callback.reply(null));
    }
    public void onTouchNotification(@NonNull Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.td_flutter.DailyCallback.onTouchNotification", getCodec());
      channel.send(
          null,
          channelReply -> callback.reply(null));
    }
  }
}
