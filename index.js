import { NativeModules } from 'react-native'

const { RNReactNativeZoomSdk } = NativeModules

const ZoomAuth = {}

ZoomAuth.getVersion = () =>
    RNReactNativeZoomSdk.getVersion()

ZoomAuth.initialize = (appToken, secret, userId, encrypt) =>
    RNReactNativeZoomSdk.initialize(appToken, secret, userId, encrypt)

ZoomAuth.onEnroll = () =>
    RNReactNativeZoomSdk.onEnroll()

ZoomAuth.onAuth = () =>
    RNReactNativeZoomSdk.onAuth()

export default ZoomAuth