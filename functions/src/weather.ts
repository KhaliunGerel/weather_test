const functions = require('firebase-functions');
const admin = require('firebase-admin');
import * as _ from 'lodash';
import axios from 'axios';
const { DateTime } = require('luxon');

import { WeatherData } from './types';
import { cityCoordinates } from './constants';
import { WEATHER_API_KEY } from './keys';

const db = admin.firestore();

let weather_48hour_api =
  'https://api.weather.com/v3/wx/forecast/hourly/2day?geocode={}&format=json&units=e&language=MN&apiKey=' + WEATHER_API_KEY;
let weather_weekly_api =
  'https://api.weather.com/v3/wx/forecast/daily/7day?geocode={}&format=json&units=e&language=MN&apiKey=' + WEATHER_API_KEY;

export const getWeatherData = functions.https.onRequest(async (req: any, res: any) => {
  const { cityCode } = req.query;
  let todayDate = DateTime.local().setZone('Asia/Ulaanbaatar').toISODate();

  let latLng = cityCoordinates[cityCode.toUpperCase()];

  let weatherDbLoc = `weatherData/${todayDate}-${cityCode}`;
  const weatherDb = await db.doc(weatherDbLoc).get();
  let result: WeatherData;
  if (!weatherDb.exists) {
    const hourlyPromise = axios({
      method: 'get',
      url: weather_48hour_api.replace('{}', latLng),
    });
    const weeklyPromise = axios({
      method: 'get',
      url: weather_weekly_api.replace('{}', latLng),
    });
    const api_result = await Promise.all([hourlyPromise, weeklyPromise]);
    const response = api_result[0];
    const responseWeek = api_result[1];

    result = {
      '48': {
        iconCode: response.data.iconCode,
        relativeHumidity: response.data.relativeHumidity,
        temperature: response.data.temperature,
        windSpeed: response.data.windSpeed,
        validTimeLocal: response.data.validTimeLocal,
        wxPhraseLong: response.data.wxPhraseLong,
      },
      week: responseWeek.data,
    };
    await db.doc(weatherDbLoc).set(result);
  } else result = weatherDb.data();

  let hourly = result['48'];

  let mnTime = DateTime.local()
    .setZone('Asia/Ulaanbaatar')
    .plus({ minutes: 60 })
    .startOf('hour')
    .toLocaleString(DateTime.TIME_24_SIMPLE);

  let timeIndex = hourly['validTimeLocal'].indexOf(`${todayDate}T${mnTime}:00+0800`);
  if (cityCode == 'UVS' || cityCode == 'KHO' || cityCode == 'BU' || cityCode == 'GA' || cityCode == 'ZAV')
    timeIndex = hourly['validTimeLocal'].indexOf(`${todayDate}T${mnTime}:00+0700`);

  let hour24 = {
    iconCode: hourly.iconCode.splice(timeIndex, 24),
    relativeHumidity: hourly.relativeHumidity.splice(timeIndex, 24),
    temperature: hourly.temperature.splice(timeIndex, 24),
    windSpeed: hourly.windSpeed.splice(timeIndex, 24),
    validTimeLocal: hourly.validTimeLocal.splice(timeIndex, 24),
    wxPhraseLong: hourly.wxPhraseLong.splice(timeIndex, 24),
  };
  result['48'] = hour24;
  res.send(result);
  return;
});
