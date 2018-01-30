declare module 'react-native-proapps-2fa' {
	export const getVersion: () => Promise
    export const initialize: (appToken: string, secret: string, userId: string, encrypt: string) => Promise
    export const onEnroll: () => Promise
    export const onAuth: (): => Promise
}