String filterNewsBasedOnWeather(double temperature) {
  if (temperature <= 0) {
    return 'depressing';
  } else if (temperature > 30) {
    return 'fear';
  } else {
    return 'happiness';
  }
}
