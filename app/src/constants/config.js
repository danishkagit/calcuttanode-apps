import { Platform } from 'react-native';

const DEV_API = Platform.select({
  android: 'http://10.0.2.2:5000/api',
  ios: 'http://localhost:5000/api',
  default: 'http://localhost:5000/api',
});

const PROD_API = 'https://calcuttanode-api.onrender.com/api';

export const API_BASE_URL = __DEV__ ? DEV_API : PROD_API;
export const APP_NAME = 'Calcutta Node.';
export const COMPANY_INFO = {
  name: 'Calcutta Node.',
  email: 'calcuttanode@gmail.com',
  phone: '8584885450',
  address: 'Kolkata, India',
};
