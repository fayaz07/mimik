import React from "react";

import { formatDMMMYYYYDDD } from "@ed/utils/src/Date";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import dayjs, { Dayjs } from "dayjs";
import { useTranslation } from "react-i18next";

const rawDate = new Date();
rawDate.setTime(0);
rawDate.setHours(0);
rawDate.setMinutes(0);
rawDate.setSeconds(0);
rawDate.setMilliseconds(0);

export interface AppDatePickerProps {
  label: string;
  value: string;
  className?: string;
  disablePast?: boolean;
  disableFuture?: boolean;
  minDate?: Dayjs;
  maxDate?: Dayjs;
  helperText?: string;
  error?: boolean;
  readonly?: boolean;

  // eslint-disable-next-line no-unused-vars
  onChange: (e: string) => void;
}

export default function AppDatePicker(props: AppDatePickerProps) {
  const { t } = useTranslation();
  const {
    label,
    value,
    className,
    disableFuture,
    disablePast,
    minDate,
    maxDate,
    helperText,
    error,
    readonly,
    onChange,
  } = props;

  return (
    <div className={className}>
      <LocalizationProvider dateAdapter={AdapterDayjs}>
        <DatePicker
          className="w-100 mt-3 mb-3"
          label={t(label)}
          value={dayjs(value)}
          format={formatDMMMYYYYDDD}
          disablePast={disablePast}
          disableFuture={disableFuture}
          defaultValue={dayjs("00-00-0000")}
          minDate={minDate}
          maxDate={maxDate}
          readOnly={readonly}
          onChange={(e) => {
            rawDate.setFullYear(e?.year() || 0);
            rawDate.setMonth(e?.month() || 0);
            rawDate.setDate(e?.date() || 0);

            onChange(rawDate.toISOString());
          }}
        />
      </LocalizationProvider>
      <small className={error ? "ms-3 text-danger" : "ms-3 text-muted"}>
        {helperText}
      </small>
    </div>
  );
}

AppDatePicker.defaultProps = {
  className: "w-100",
  disablePast: false,
  disableFuture: false,
  minDate: undefined,
  maxDate: undefined,
  helperText: "",
  error: false,
  readonly: false,
};
