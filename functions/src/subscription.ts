import * as functions from 'firebase-functions';
const { DateTime } = require('luxon');
import * as admin from 'firebase-admin';
import { weatherApi } from './weather';
import { cityNames } from './constants';
import { sendMail } from './email_service';

const db = admin.firestore();

export const subscriptionScheduler = functions.pubsub
  .schedule('0 9 * * *')
  .timeZone('Asia/Ulaanbaatar')
  .onRun(async () => {
    let todayDate = DateTime.local().setZone('Asia/Ulaanbaatar').toISODate();
    const emails = await db.collection('notifications').get();
    const emailsData = emails.docs.map((e) => e.data());

    for (var i = 0; i < emailsData.length; i++) {
      let code = emailsData[i].city;
      let cityName = cityNames[code];
      const weather = await weatherApi(todayDate, code);
      let weekData = weather['week'];
      let weatherData: any = {
        max_temp: Math.round((weekData.calendarDayTemperatureMax[0] - 32) / 1.8),
        min_temp: Math.round((weekData.calendarDayTemperatureMin[0] - 32) / 1.8),
        sunrise: weekData.sunriseTimeLocal.toString().slice(11, 16),
        sunset: weekData.sunsetTimeLocal.toString().slice(11, 16),
        narrative: weekData.narrative.toString().split('.')[0],
      };
      const title = 'Өнөөдрийн цаг агаарын мэдээ';
      const desc = `${cityName}: Өдөр ${weatherData.max_temp}° шөнө ${weatherData.min_temp}°. ${weatherData.narrative}. Өдрийн нар ${weatherData.sunrise} мандаж ${weatherData.sunset} жаргана.`;
      await sendMail({
        email: emailsData[i].email,
        subject: title,
        html: `<p>${desc}</p>`,
      });
    }
  });

export const updateEmail = functions.https.onRequest(async (req: functions.https.Request, res: any) => {
  const { email, newEmail, city } = req.body;
  console.log(req.params);
  console.log(req.body);
  console.log(req.query);
  if (newEmail !== email) {
    await db.doc(`notifications/${email}`).delete();
  }
  await db.collection('notifications').doc(newEmail).set({ email: newEmail, city }, { merge: true });
  res.send(true);
});
