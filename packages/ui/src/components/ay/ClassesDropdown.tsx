import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import ClassType from "@ed/types/src/class/Class";
import { FormControl, InputLabel, MenuItem, Select } from "@mui/material";
import { useTranslation } from "react-i18next";

export default function ClassesDropdown(props: {
  selected: string;
  classes: ClassType[];
  /* eslint-disable no-unused-vars */
  onSelect: (ayId: string) => void;
}) {
  const { selected, classes, onSelect } = props;
  const { t } = useTranslation();

  return (
    <FormControl sx={{ m: 1, minWidth: 120 }}>
      <InputLabel>{t(keys.year.year)}</InputLabel>
      <Select
        label={t(keys.year.year)}
        value={selected}
        onChange={(e) => onSelect(e.target.value as string)}
      >
        {classes.map((c) => (
          <MenuItem key={c.id} value={c.id}>
            {c.name}
          </MenuItem>
        ))}
      </Select>
    </FormControl>
  );
}
