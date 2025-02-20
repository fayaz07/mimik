import React from "react";

import keys from "@ed/core/src/lang/keys/Keys";
import { ChevronLeft, ChevronRight } from "@mui/icons-material";
import { IconButton, MenuItem, Select } from "@mui/material";
import { useTranslation } from "react-i18next";

import "./_.scss";

const paginationOptions = [10, 15, 20];

function TablePagination(props: {
  count: number;
  page: number;
  rowsPerPage: number;
  /* eslint-disable no-unused-vars */
  onPageChange: (newPage: number) => void;
  /* eslint-disable no-unused-vars */
  onRowsPerPageChange: (newSize: number) => void;
}) {
  const { count, page, rowsPerPage, onPageChange, onRowsPerPageChange } = props;
  const { t } = useTranslation();

  return (
    <div className="appPagination-table">
      <p>{t(keys.pagination.rowsPerPage)}</p>
      <Select
        className="appPagination-table-select"
        id="rowsPerPage-users-list"
        value={rowsPerPage}
        size="small"
        onChange={(e) =>
          onRowsPerPageChange(parseInt(e.target.value.toString(), 10))
        }
      >
        {paginationOptions.map((option) => (
          <MenuItem key={option} value={option}>
            {option}
          </MenuItem>
        ))}
      </Select>
      <IconButton
        className="ms-1"
        onClick={() => {
          onPageChange(page - 1);
        }}
      >
        <ChevronLeft />
      </IconButton>
      <p>
        {/* {(page - 1) * rowsPerPage + 1} - {page * rowsPerPage}{" "}
        <span className="ms-1 me-1">of</span> <b>{count}</b> */}
        {t(keys.pagination.xToYOfZ, {
          x: (page - 1) * rowsPerPage + 1,
          y: page * rowsPerPage,
          z: count,
        })}
      </p>
      <IconButton
        onClick={() => {
          onPageChange(page + 1);
        }}
      >
        <ChevronRight />
      </IconButton>
    </div>
  );
}

export default TablePagination;
