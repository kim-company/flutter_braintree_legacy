package info.keepinmind.flutter_braintree;

import android.app.Activity;
import android.content.Intent;

import com.braintreepayments.api.dropin.DropInActivity;
import com.braintreepayments.api.dropin.DropInRequest;
import com.braintreepayments.api.dropin.DropInResult;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterBraintreePlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private final Activity mActivity;
  private final static int REQUEST_CODE = 11;
  private Result mResult;

  private FlutterBraintreePlugin(Registrar registrar) {
    this.mActivity = registrar.activity();
    registrar.addActivityResultListener(this);
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "info.keepinmind.flutter_braintree");
    channel.setMethodCallHandler(new FlutterBraintreePlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("showDropIn")) {
      String clientToken = call.argument("clientToken");

      DropInRequest dropInRequest = new DropInRequest().clientToken(clientToken);

      mResult = result;
      mActivity.startActivityForResult(dropInRequest.getIntent(mActivity), REQUEST_CODE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        DropInResult result = data.getParcelableExtra(DropInResult.EXTRA_DROP_IN_RESULT);
        mResult.success(result.getPaymentMethodNonce().getNonce());
      } else if (resultCode == Activity.RESULT_CANCELED) {
        mResult.error("CANCELLED", "Purchase process was cancelled.", null);
      } else {
        Exception error = (Exception) data.getSerializableExtra(DropInActivity.EXTRA_ERROR);
        mResult.error("ERROR", error.getMessage(), null);
      }

      mResult = null;

      return true;
    }

    return false;
  }
}
