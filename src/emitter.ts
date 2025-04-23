import { NativeModules, NativeEventEmitter } from 'react-native';
import { useInternalStore } from './useInternalStore';
import { logDebug } from './utils';

const AudioPro = NativeModules.AudioPro;
export const emitter = new NativeEventEmitter(AudioPro);

emitter.addListener('AudioProEvent', (event) => {
	logDebug('AudioProEvent', JSON.stringify(event));
	useInternalStore.getState().updateFromEvent(event);
});
