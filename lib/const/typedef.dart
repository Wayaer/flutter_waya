/// ******** Callback Zero ******** ///
/// Callback Zero
typedef Callback = void Function();

/// Callback Zero
typedef CallbackT<T> = T Function();

/// Future Callback Zero
typedef CallbackFuture = Future<void> Function();

/// Future Callback Zero
typedef CallbackFutureT<T> = Future<T> Function();

/// ******** Callback One ******** ///
/// Callback One
typedef ValueCallbackT<T> = T Function(T value);

/// Callback One
typedef ValueCallback<V> = void Function(V value);

/// Callback One
typedef ValueCallbackTV<T, V> = T Function(V value);

/// Future Callback One
typedef ValueCallbackFuture<V> = Future<void> Function(V value);

/// Future Callback One
typedef ValueCallbackFutureT<T> = Future<T> Function(T value);

/// Future Callback One
typedef ValueCallbackFutureTV<T, V> = Future<T> Function(V value);

/// ******** Callback Two ******** ///
/// Callback Two
typedef ValueTwoCallback<V1, V2> = void Function(V1 value1, V2 value2);

/// Future Callback Two
typedef ValueTwoCallbackT<T, V1, V2> = T Function(V1 value1, V2 value2);

/// Callback Two T
typedef ValueTwoCallbackFuture<V1, V2> = Future<void> Function(
    V1 value1, V2 value2);

/// Future Callback Two T
typedef ValueTwoCallbackFutureT<T, V1, V2> = Future<T> Function(
    V1 value1, V2 value2);

/// ******** Callback Three ******** ///
/// Callback Three
typedef ValueThreeCallback<V1, V2, V3> = void Function(
    V1 value1, V2 value2, V3 value3);

/// Callback Three T
typedef ValueThreeCallbackT<T, V1, V2, V3> = T Function(
    V1 value1, V2 value2, V3 value3);

/// Future Callback Three
typedef ValueThreeCallbackFuture<V1, V2, V3> = Future<void> Function(
    V1 value1, V2 value2, V3 value3);

/// Future Callback Three T
typedef ValueThreeCallbackFutureT<T, V1, V2, V3> = Future<T> Function(
    V1 value1, V2 value2, V3 value3);

/// ******** Callback Four ******** ///
/// Callback Four
typedef ValueFourCallback<V1, V2, V3, V4> = void Function(
    V1 value1, V2 value2, V3 value3, V4 value4);

/// Callback Four T
typedef ValueFourCallbackT<T, V1, V2, V3, V4> = T Function(
    V1 value1, V2 value2, V3 value3, V4 value4);

/// Future Callback Four
typedef ValueFourCallbackFuture<V1, V2, V3, V4> = Future<void> Function(
    V1 value1, V2 value2, V3 value3, V4 value4);

/// Future Callback Four T
typedef ValueFourCallbackFutureT<T, V1, V2, V3, V4> = Future<T> Function(
    V1 value1, V2 value2, V3 value3, V4 value4);
