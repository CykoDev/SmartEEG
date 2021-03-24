package com.example.eeglab;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

public class MySensorService {

    public static Handler handler;
//    public static SensorEventListener lightSensorListener;
//    public static SensorEventListener accSensorListener;
    private final static int MESSAGE_READ = 2;
    static Sensor lightSensor;
    static Sensor accSensor;

//    public MySensorService() {
//        handler = new Handler(Looper.getMainLooper()) {
//            @Override
//            public void handleMessage(Message msg) {
//                switch (msg.what) {
//                    case MESSAGE_READ:
//                        String sensorMsg = msg.obj.toString();
//                        MainActivity.sensorDataStream.add(sensorMsg);
//                        break;
//                }
//            }
//        };
//    }

    public static boolean initSensors(SensorManager sensorManager) {

        boolean sensors = true;

        lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        accSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);

        if (lightSensor != null) {
            sensorManager.registerListener(
                    lightSensorListener,
                    lightSensor,
                    SensorManager.SENSOR_DELAY_NORMAL);

        } else {
            sensors = false;
        }
        if (accSensor != null) {
            sensorManager.registerListener(
                    accSensorListener,
                    accSensor,
                    SensorManager.SENSOR_DELAY_NORMAL);
        } else {
            sensors = false;
        }

        return sensors;
    }

    public static boolean destroySensors(SensorManager sensorManager) {
        sensorManager.unregisterListener(lightSensorListener);
        sensorManager.unregisterListener(accSensorListener);
        return true;
    }

    private static final SensorEventListener lightSensorListener = new SensorEventListener() {

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onSensorChanged(SensorEvent event) {
            if(event.sensor.getType() == Sensor.TYPE_LIGHT) {
                MainActivity.lightDataStream.add(String.valueOf(event.values[0]));
//                textLight.setText("LIGHT: " + event.values[0]);
            }
        }
    };

    private static final SensorEventListener accSensorListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent sensorEvent) {
            if (sensorEvent.sensor.getType() == Sensor.TYPE_LINEAR_ACCELERATION) {
                String value = String.valueOf(sensorEvent.values[0]) + ',' + String.valueOf(sensorEvent.values[1]) + ',' + String.valueOf(sensorEvent.values[2]);
                MainActivity.accDataStream.add(value);
//                textAcc.setText("X:" + sensorEvent.values[0] + " Y:" + sensorEvent.values[1] + " Z:" + sensorEvent.values[2]);
            }
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int i) {

        }
    };
}