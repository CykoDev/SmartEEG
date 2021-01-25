package com.example.eeglab;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/bluetooth";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
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
    }

    private List<String> getDeviceList() {
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (bluetoothAdapter == null) {
            // Device doesn't support Bluetooth
        }

        Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();

        List<String> deviceList = new ArrayList<String>();

        if (pairedDevices.size() > 0) {
            // There are paired devices. Get the name and address of each paired device.
            for (BluetoothDevice device : pairedDevices) {
                // if(device.getName().contains("SMARTING")) {
                    deviceList.add(device.getName());
                // }
            }
        }

        bluetoothAdapter.cancelDiscovery();
        return deviceList;
    }
}
