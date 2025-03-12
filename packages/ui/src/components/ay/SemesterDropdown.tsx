import React from "react";

import keys from "@mimik/core/src/lang/keys/Keys";
import Semester from "@mimik/types/src/semester/Semester";
import { FormControl, InputLabel, MenuItem, Select } from "@mui/material";
import { useTranslation } from "react-i18next";

export default function SemesterDropdown(props: {
  selected: string;
  semesters: Semester[];
  /* eslint-disable no-unused-vars */
  onSelect: (id: string) => void;
}) {
  const { t } = useTranslation();
  const { selected, semesters, onSelect } = props;
  return (
    <FormControl sx={{ m: 1, minWidth: 120 }}>
      <InputLabel>{t(keys.semester.semester)}</InputLabel>
      <Select
        label={t(keys.semester.semester)}
        value={selected}
        onChange={(e) => onSelect(e.target.value as string)}
      >
        {semesters.map((item) => (
          <MenuItem key={item.id} value={item.id}>
            {item.name}
          </MenuItem>
        ))}
      </Select>
    </FormControl>
  );
}
