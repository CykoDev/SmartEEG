package com.example.eeglab;

import android.Manifest;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/bluetooth";
    private static final int PERMISSION_CODE = 012;
    private static final int REQUEST_ENABLE_BT = 310;

    private MyBluetoothService bltService;
    private EventChannel stream;

    public static ArrayList<String> dataStream;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        dataStream = new ArrayList<>();
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getDeviceList")) {
                                List<String> deviceList = getDeviceList();

                                if (deviceList.size() > 0) {
                                    result.success(deviceList);
                                } else {
                                    result.error("UNAVAILABLE", "No devices available.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );

        stream = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "bluetoothDataStream");
        stream.setStreamHandler(
                        new EventChannel.StreamHandler() {
                            @Override
                            public void onListen(Object listener, EventChannel.EventSink eventSink) {
                                startListening(listener, eventSink);
                            }

                            @Override
                            public void onCancel(Object listener) {
                                cancelListening(listener);
                            }
                        });
    }

    private Map<Object, Runnable> listeners = new HashMap<>();

    void startListening(Object listener, EventChannel.EventSink emitter) {
        final Handler handler = new Handler();
        listeners.put(listener, new Runnable() {
            @Override
            public void run() {
                if (listeners.containsKey(listener)) {
                    // Send some value to callback
                    String dataString;
//                    Log.d("ANAS", dataStream.toString());
                    while(!dataStream.isEmpty()) {
                        dataString = dataStream.remove(0);
//                        Log.d("ANAS", dataString);
                        emitter.success(dataString);
                    }
                    handler.postDelayed((Runnable) this, 500);
                }
            }
        });
        // Run task
        handler.post(listeners.get(listener));
    }

    void cancelListening(Object listener) {
        // Remove callback
        listeners.remove(listener);
    }

    private List<String> getDeviceList() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            if (ContextCompat.checkSelfPermission(getContext(),
                    Manifest.permission.ACCESS_BACKGROUND_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(
                        this,
                        new String[]{Manifest.permission.ACCESS_BACKGROUND_LOCATION},
                        PERMISSION_CODE);
            }
        }

        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (bluetoothAdapter == null) {
            // Device doesn't support Bluetooth
        }

        if (!bluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }

        Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
        List<String> deviceList = new ArrayList<>();

        if (pairedDevices.size() > 0) {
            // There are paired devices. Get the name and address of each paired device.
            for (BluetoothDevice device : pairedDevices) {
                if (device.getName().equals("HC-05")) {
                    deviceList.add(device.getName());
                    bltService = new MyBluetoothService(device);
                }
            }
        }

        return deviceList;
    }

    @Override
    protected void onDestroy() {
        bltService.terminateConnection();
        super.onDestroy();
    }
}
