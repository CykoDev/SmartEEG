package com.example.eeglab;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

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
    private static final String BT_CHANNEL = "samples.flutter.dev/bluetooth";
    private static final String SENSOR_CHANNEL = "samples.flutter.dev/sensor";
    private static final int PERMISSION_CODE = 012;
    private static final int REQUEST_ENABLE_BT = 310;

    private MyBluetoothService bltService;
    private MySensorService sensorService;
    private EventChannel btStream;
    private EventChannel sensorStream;

    public static ArrayList<String> btDataStream;
    public static ArrayList<String> sensorDataStream;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        btDataStream = new ArrayList<>();
        sensorDataStream = new ArrayList<>();
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BT_CHANNEL)
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

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SENSOR_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("initSensors")) {
                        SensorManager mySensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
                        boolean sensors = MySensorService.initSensors(mySensorManager);
                        if (sensors) {
                            result.success("Sensors Functional");
                        } else {
                            result.error("UNAVAILABLE", "Couldn't connect to one or more sensors", null);
                        }
                    }
                });

        btStream = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "bluetoothDataStream");
        btStream.setStreamHandler(
                        new EventChannel.StreamHandler() {
                            @Override
                            public void onListen(Object listener, EventChannel.EventSink eventSink) {
                                startBtListening(listener, eventSink);
                            }

                            @Override
                            public void onCancel(Object listener) {
                                cancelBtListening(listener);
                            }
                        });

        sensorStream = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "sensorDataStream");
        sensorStream.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                startSensorListening(arguments, events);
            }

            @Override
            public void onCancel(Object arguments) {
                cancelSensorListening(arguments);
            }
        });
    }

    private Map<Object, Runnable> btListeners = new HashMap<>();

    void startBtListening(Object listener, EventChannel.EventSink emitter) {
        final Handler handler = new Handler();
        btListeners.put(listener, new Runnable() {
            @Override
            public void run() {
                if (btListeners.containsKey(listener)) {
                    // Send some value to callback
                    String dataString;
//                    Log.d("ANAS", dataStream.toString());
                    while(!btDataStream.isEmpty()) {
                        dataString = btDataStream.remove(0);
//                        Log.d("ANAS", dataString);
                        emitter.success(dataString);
                    }
                    handler.postDelayed((Runnable) this, 500);
                }
            }
        });
        // Run task
        handler.post(btListeners.get(listener));
    }

    void cancelBtListening(Object listener) {
        // Remove callback
        btListeners.remove(listener);
    }

    private Map<Object, Runnable> sensorListeners = new HashMap<>();

    void startSensorListening(Object listener, EventChannel.EventSink emitter) {
        final Handler handler = new Handler();
        sensorListeners.put(listener, new Runnable() {
            @Override
            public void run() {
                if (sensorListeners.containsKey(listener)) {
                    // Send some value to callback
                    String dataString;
//                    Log.d("ANAS", dataStream.toString());
                    while(!btDataStream.isEmpty()) {
                        dataString = btDataStream.remove(0);
//                        Log.d("ANAS", dataString);
                        emitter.success(dataString);
                    }
                    handler.postDelayed((Runnable) this, 500);
                }
            }
        });
        // Run task
        handler.post(sensorListeners.get(listener));
    }

    void cancelSensorListening(Object listener) {
        sensorListeners.remove(listener);
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
