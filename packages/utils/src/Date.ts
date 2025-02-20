/* eslint-disable no-unused-vars */
import dayjs from "dayjs";

const shortMonths = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

const longMonths = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const formatDDMMYYYY = "DD/MM/YYYY";
const formatDMMMYYYYDDD = "D MMMM YYYY (dddd)";

export { formatDDMMYYYY, formatDMMMYYYYDDD };

export function getFormattedDate(
  value: string,
  orEmpty = false,
  defValue = ""
): string {
  if (!value) {
    return defValue;
  }
  const date = new Date(value);
  if (orEmpty && date.getUTCFullYear() < 1950) {
    return defValue;
  }
  return new Date(value).toLocaleString();
}

// Format as "23 Jan 2020"
export function getGeneralizedDate(
  value: string,
  orEmpty = false,
  defValue = ""
): string {
  if (!value) {
    return defValue;
  }
  const date = new Date(value);
  if (orEmpty && date.getUTCFullYear() < 1950) {
    return defValue;
  }
  // Get the day, month, and year
  const day = String(date.getDate()).padStart(2, "0");
  const month = shortMonths[date.getMonth()]; // Month is 0-based, so we map it manually
  const year = date.getFullYear();

  return `${day} ${month} ${year}`;
}

export function getYear(value: string): number {
  return new Date(value).getFullYear();
}

export function getOnlyDate(
  value: string,
  orEmpty = false,
  defValue = ""
): string {
  if (!value) {
    return defValue;
  }
  const date = new Date(value);
  if (orEmpty && date.getUTCFullYear() < 1950) {
    return defValue;
  }
  return date.toLocaleDateString();
}

export function getDefFormattedDateOrEmpty(value: string): string {
  const res = new Date(value);

  if (res.getUTCFullYear() < 1950) {
    return "";
  }
  return res.toLocaleString();
}

export function getFormattedDateOrWithEmptyValue(
  value: string,
  format: string,
  emptyValue: string
): string {
  const res = dayjs(value);

  if (res.year() < 1950) {
    return emptyValue;
  }

  // format the date as per the format
  return res.format(format);
}

export function getFormattedDateOrEmpty(value: string, format: string): string {
  return getFormattedDateOrWithEmptyValue(value, format, "");
}
