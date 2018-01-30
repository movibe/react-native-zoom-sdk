import { NativeModules, Platform } from 'react-native'

const { RNReactNativeZoomSdk } = NativeModules

const ZoomAuth = {}

ZoomAuth.getVersion = () =>
    RNReactNativeZoomSdk.getVersion()

ZoomAuth.initialize = (appToken, secret, userId, encrypt) =>
    Platform.OS === RNReactNativeZoomSdk.initialize(appToken, secret, userId, encrypt)

ZoomAuth.onEnroll = () =>
    RNReactNativeZoomSdk.onEnroll()

ZoomAuth.onAuth = () =>
    RNReactNativeZoomSdk.onAuth()

export default ZoomAuth