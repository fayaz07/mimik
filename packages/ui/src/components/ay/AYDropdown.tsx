import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import AcademicYear, {
  getAYName,
} from "@ed/types/src/academicyear/AcademicYear";
import { FormControl, InputLabel, MenuItem, Select } from "@mui/material";
import { useTranslation } from "react-i18next";

export default function AcademicYearDropdown(props: {
  selectedAY: string;
  academicYears: AcademicYear[];
  /* eslint-disable no-unused-vars */
  onSelectAY: (ayId: string) => void;
}) {
  const { selectedAY, academicYears, onSelectAY } = props;
  const { t } = useTranslation();
  return (
    <FormControl sx={{ m: 1, minWidth: 120 }}>
      <InputLabel>{t(keys.academicYear.academicYear)}</InputLabel>
      <Select
        label={t(keys.academicYear.academicYear)}
        value={selectedAY}
        onChange={(e) => onSelectAY(e.target.value as string)}
      >
        {academicYears.map((ay) => (
          <MenuItem key={ay.id} value={ay.id}>
            {getAYName(ay)}
          </MenuItem>
        ))}
      </Select>
    </FormControl>
  );
}
