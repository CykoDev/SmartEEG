#include <jni.h>

extern "C"
JNIEXPORT jstring JNICALL Java_com_example_app_MainActivity_getNativeString(
        JNIEnv *env, jobject obj) {
    return env->NewStringUTF("Hello World! From native code!");
}