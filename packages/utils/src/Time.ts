// like - Morning, Afternoon, Evening
export function whatPartOfTimeIsIt() {
  const date = new Date();
  const hour = date.getHours();
  if (hour < 12) {
    return "Morning";
  }
  if (hour < 18) {
    return "Afternoon";
  }
  return "Evening";
}
