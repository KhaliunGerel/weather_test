export type CityCoordinate = {
  [key: string]: string;
};

export type WeatherData = {
  48: {
    iconCode: { [key: string]: any };
    relativeHumidity: { [key: string]: any };
    temperature: { [key: string]: any };
    windSpeed: { [key: string]: any };
    validTimeLocal: { [key: string]: any };
    wxPhraseLong: { [key: string]: any };
  };
  week: any;
};
